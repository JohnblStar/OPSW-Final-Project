from fastapi import APIRouter, UploadFile, File, HTTPException
from app.services.ocr_service import extract_text_from_image
from app.services.ollama_service import analyze_ocr_text_with_llm

from app.services.firestore_store import (
    save_scan,
    save_medicines,
    save_prescription,
    save_schedules
)

router = APIRouter(prefix="/api/ocr", tags=["OCR"])


# ----------------------------------------------------
# 🔥 OCR + AI + Firestore 전체 파이프라인
# ----------------------------------------------------
@router.post("/upload/ai/save")
async def upload_image_ai_and_save(file: UploadFile = File(...)):
    try:
        user_id = "test_user_001"

        file_bytes = await file.read()

        # OCR
        raw_text = extract_text_from_image(file_bytes)

        # AI 분석
        ai_parsed = analyze_ocr_text_with_llm(raw_text)

        medications = ai_parsed.get("drugs", [])

        # 저장
        scan_id = save_scan(user_id, raw_text, ai_parsed)
        medicine_ids = save_medicines(user_id, scan_id, medications)
        prescription_id = save_prescription(user_id, scan_id, medicine_ids)

        # 🔥 raw_text 사용하여 날짜 자동 파싱 적용
        schedule_ids = save_schedules(user_id, medicine_ids, medications, raw_text)

        return {
            "success": True,
            "message": "OCR + AI 분석 + 저장 완료",
            "scan_id": scan_id,
            "prescription_id": prescription_id,
            "medicine_ids": medicine_ids,
            "schedule_ids": schedule_ids,
            "raw_text": raw_text,
            "ai_parsed": ai_parsed
        }

    except Exception as e:
        print("FULL PIPELINE ERROR:", e)
        raise HTTPException(status_code=500, detail=str(e))
