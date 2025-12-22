import json
import traceback
from fastapi import APIRouter, UploadFile, File, HTTPException
from app.services.ocr_service import extract_text_from_image
from app.utils.parser import parse_ocr_text


from app.services.ollama_service import analyze_ocr_text_with_llm
from app.services.gemini_service import analyze_prescription_image

router = APIRouter(prefix="/api/ocr", tags=["OCR"])

from app.services.firestore_store import (
    save_scan,
    save_medicines,
    save_prescription,
    save_schedules,
    create_intake_logs_for_schedule
)

# -------------------------
# 1) OCR 업로드
# -------------------------
@router.post("/upload")
async def upload_image(file: UploadFile = File(...)):
    try:
        file_bytes = await file.read()

        raw_text = extract_text_from_image(file_bytes)

        parsed = parse_ocr_text(raw_text)

        return {
            "success": True,
            "data": {
                "raw_text": raw_text,
                "parsed": parsed
            }
        }

    except Exception as e:
        print("OCR ERROR:", e)
        raise HTTPException(status_code=500, detail=str(e))

'''
# ----------------------------------------------------
# 2) FULL OCR + 약 API 검색 
# ----------------------------------------------------
@router.post("/upload/full")
async def upload_image_with_drug_info(file: UploadFile = File(...)):
    try:
        file_bytes = await file.read()

        # OCR
        raw_text = extract_text_from_image(file_bytes)

        # 파싱 (약명, 용량, 횟수 등)
        parsed = parse_ocr_text(raw_text)

        # 약 검색 + 효능/주의/부작용 포함한 enrichment
        drug_details = enrich_ocr_drugs(parsed["drugs"])

        return {
            "success": True,
            "raw_text": raw_text,
            "parsed": parsed,
            "drug_details": drug_details
        }

    except Exception as e:
        print("OCR+Drug ERROR:", e)
        raise HTTPException(status_code=500, detail=str(e))
'''

# ----------------------------------------------------
# 3)  OCR + Ollama AI 분석
# ----------------------------------------------------
@router.post("/upload/ai")
async def upload_image_with_ai(file: UploadFile = File(...)):
    try:
        file_bytes = await file.read()

        # 1) OCR
        raw_text = extract_text_from_image(file_bytes)

        # 2) Ollama 분석 (약명 정규화 + 용량 추출 + JSON)
        ai_parsed = analyze_ocr_text_with_llm(raw_text)

        return {
            "success": True,
            "raw_text": raw_text,
            "ai_parsed": ai_parsed
        }

    except Exception as e:
        print("OCR+AI ERROR:", e)
        raise HTTPException(status_code=500, detail=str(e))

# ----------------------------------------------------
# 4) OCR + AI 분석 + Firestore 저장 (최종 파이프라인)
# ----------------------------------------------------

@router.post("/upload/ai/save")
async def upload_image_ai_and_save(
    file: UploadFile = File(...),
    elder_id: str = "elder_001" 
):
    try:
        # TODO: 인증 연동 시 토큰에서 추출
        user_id = "test_user_001"

        # 1) OCR
        file_bytes = await file.read()
        raw_text = extract_text_from_image(file_bytes)

        # 2) AI 분석
        ai_parsed = analyze_ocr_text_with_llm(raw_text)
        medications = ai_parsed.get("drugs", [])

        if not medications:
            raise HTTPException(status_code=400, detail="No drugs detected")

        # 3) Firestore 저장
        scan_id = save_scan(
            user_id=user_id,
            elder_id=elder_id,
            raw_text=raw_text,
            ai_parsed=ai_parsed
        )

        medicine_ids = save_medicines(
            user_id=user_id,
            scan_id=scan_id,
            medications=medications
        )

        prescription_id = save_prescription(
            user_id=user_id,
            elder_id=elder_id,
            scan_id=scan_id,
            medicines=medicine_ids
        )

        schedule_ids = save_schedules(
            user_id=user_id,
            elder_id=elder_id,
            medicine_ids=medicine_ids,
            medications=medications
        )

        return {
            "success": True,
            "message": "OCR + AI + 복약 스케줄 생성 완료",
            "elder_id": elder_id,
            "scan_id": scan_id,
            "prescription_id": prescription_id,
            "medicine_ids": medicine_ids,
            "schedule_ids": schedule_ids,
            "ai_parsed": ai_parsed
        }

    except HTTPException:
        raise
    except Exception as e:
        traceback.print_exc()   # 🔥 이 줄 추가
        raise HTTPException(status_code=500, detail=str(e))

# ----------------------------------------------------
# 5) Gemini Vision → Firestore 저장 (신규 파이프라인)
# ----------------------------------------------------
@router.post("/upload/gemini/save")
async def upload_image_gemini_and_save(
    file: UploadFile = File(...),
    elder_id: str = "elder_001"
):
    try:
        user_id = "test_user_001"
        image_bytes = await file.read()

        # 1. Gemini Vision 분석 (문자열 응답 수신)
        gemini_raw_output = analyze_prescription_image(image_bytes)

        # 2. 문자열을 딕셔너리로 변환 (매우 중요!)
        try:
            if isinstance(gemini_raw_output, str):
                ai_parsed = json.loads(gemini_raw_output)
            else:
                ai_parsed = gemini_raw_output
        except Exception as e:
            print(f"JSON Parsing Error: {e}, Output: {gemini_raw_output}")
            raise HTTPException(status_code=500, detail="AI 응답 형식이 올바르지 않습니다.")

        # 3. 데이터 보정 및 추출
        medications = ai_parsed.get("drugs", [])

        if not medications:
            raise HTTPException(status_code=400, detail="약 정보를 찾을 수 없습니다.")

        # 필수 필드가 비어있을 경우를 대비한 기본값 채우기 (400 에러 방지)
        for drug in medications:
            if not drug.get("drug_name"): drug["drug_name"] = "알 수 없는 약"
            if not drug.get("times_per_day"): drug["times_per_day"] = "1"
            if not drug.get("days"): drug["days"] = "1"

        # 4. Firestore 저장 파이프라인
        scan_id = save_scan(
            user_id=user_id,
            elder_id=elder_id,
            raw_text=gemini_raw_output, # 원본 텍스트 저장
            ai_parsed=ai_parsed
        )

        medicine_ids = save_medicines(
            user_id=user_id,
            scan_id=scan_id,
            medications=medications
        )

        prescription_id = save_prescription(
            user_id=user_id,
            elder_id=elder_id,
            scan_id=scan_id,
            medicines=medicine_ids
        )

        schedule_ids = save_schedules(
            user_id=user_id,
            elder_id=elder_id,
            medicine_ids=medicine_ids,
            medications=medications
        )

        return {
            "success": True,
            "pipeline": "gemini",
            "elder_id": elder_id,
            "scan_id": scan_id,
            "prescription_id": prescription_id,
            "medicine_ids": medicine_ids,
            "schedule_ids": schedule_ids,
            "ai_parsed": ai_parsed
        }

    except HTTPException:
        raise
    except Exception as e:
        traceback.print_exc()
        print("🔥 GEMINI SAVE ERROR:", e)
        raise HTTPException(status_code=500, detail=f"서버 내부 오류: {str(e)}")