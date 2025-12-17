from google.cloud import firestore
from datetime import datetime, timedelta, timezone
import os
import uuid
import re

db = firestore.Client.from_service_account_json(
    os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
)

# --------------------------------------------------------
# 🔹 숫자 정규화 (times_per_day, days)
# --------------------------------------------------------
def extract_number(value, default=1):
    if isinstance(value, int):
        return value
    if isinstance(value, str):
        nums = re.findall(r'\d+', value)
        if nums:
            return int(nums[0])
    return default


# --------------------------------------------------------
# 🔹 OCR 원본 저장
# --------------------------------------------------------
def save_scan(user_id: str, raw_text: str, ai_parsed: dict):
    scan_ref = db.collection("prescription_scans").document()
    scan_ref.set({
        "user_id": user_id,
        "raw_ocr_text": raw_text,
        "parsed": True,
        "ai_parsed": ai_parsed,
        "created_at": datetime.now(timezone.utc),
    })
    return scan_ref.id


# --------------------------------------------------------
# 🔹 약 리스트 저장 (간단 저장)
# --------------------------------------------------------
def save_medicines(user_id: str, scan_id: str, medications: list):

    medicine_ids = []

    for m in medications:
        med_id = str(uuid.uuid4())
        medicine_ids.append(med_id)

        # Firestore에 기본 정보 저장
        db.collection("medicines").document(med_id).set({
            "user_id": user_id,
            "scan_id": scan_id,
            "drug_name": m.get("drug_name", ""),
            "normalized_name": m.get("normalized_name", ""),
            "dose": m.get("dose", ""),
            "created_at": datetime.now(timezone.utc)
        })

    return medicine_ids


# --------------------------------------------------------
# 🔹 처방전 저장
# --------------------------------------------------------
def save_prescription(user_id: str, scan_id: str, medicines: list):
    prescription_id = str(uuid.uuid4())

    doc = {
        "user_id": user_id,
        "scan_id": scan_id,
        "created_at": datetime.utcnow(),
        "medicine_ids": medicines,
    }

    db.collection("prescriptions").document(prescription_id).set(doc)
    return prescription_id


# --------------------------------------------------------
# 🔹 조제일 자동 추출 (OCR → "2025-10-16")
# --------------------------------------------------------
def extract_prescription_date(raw_text: str):
    # yyyy-mm-dd 또는 yyyy.mm.dd 또는 yyyy/mm/dd 형태 자동 추출
    pattern = r"(20\d{2})[-./](\d{1,2})[-./](\d{1,2})"
    match = re.search(pattern, raw_text)
    if match:
        y, m, d = match.groups()
        return datetime(int(y), int(m), int(d), tzinfo=timezone.utc)

    # 실패 시 오늘 날짜
    return datetime.now(timezone.utc)


# --------------------------------------------------------
# 🔹 스케줄 생성
# --------------------------------------------------------
def save_schedules(user_id: str, medicine_ids: list, medications: list, raw_text: str):

    base_date = extract_prescription_date(raw_text)

    schedule_ids = []

    for idx, med in enumerate(medications):

        med_id = medicine_ids[idx]

        # 횟수 / 일수 정규화
        times_per_day = extract_number(med.get("times_per_day", 1))
        days = extract_number(med.get("days", 1))

        # 시간 자동 생성
        if times_per_day == 1:
            times = ["09:00"]
        elif times_per_day == 2:
            times = ["09:00", "18:00"]
        elif times_per_day == 3:
            times = ["09:00", "13:00", "18:00"]
        else:
            times = ["09:00"]

        schedule_id = str(uuid.uuid4())

        schedule_doc = {
            "user_id": user_id,
            "medicine_id": med_id,
            "drug_name": med.get("drug_name"),
            "dose": med.get("dose"),
            "times_per_day": times_per_day,
            "days": days,
            "times": times,
            "start_date": base_date,
            "end_date": base_date + timedelta(days=days),
            "created_at": datetime.now(timezone.utc)
        }

        db.collection("schedules").document(schedule_id).set(schedule_doc)
        schedule_ids.append(schedule_id)

    return schedule_ids
