"""
elder_routes.py

- 노인(피보호자) 생성
- 사용자 기준 노인 목록 조회
"""

from fastapi import APIRouter, Body, Query
from app.services.elder_service import (
    create_elder,
    get_elders_by_user,
)

router = APIRouter(
    prefix="/api/elders",
    tags=["Elders"]
)

# ---------------------------
# 1. 노인 생성
# ---------------------------
@router.post("")
def create_elder_api(
    user_id: str = Body(...),
    name: str = Body(...),
    birth: str | None = Body(None),
    gender: str | None = Body(None),
):
    elder_id = create_elder(
        user_id=user_id,
        name=name,
        birth=birth,
        gender=gender,
    )
    return {"elder_id": elder_id}


# ---------------------------
# 2. 사용자 기준 노인 목록 조회
# ---------------------------
@router.get("")
def list_elders_api(
    user_id: str = Query(...)
):
    return {
        "elders": get_elders_by_user(user_id)
    }
