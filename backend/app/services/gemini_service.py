import os
import json
from google import genai
from google.genai import types  

client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))
MODEL = "gemini-2.0-flash"

def analyze_prescription_image(image_bytes: bytes) -> dict:
    prompt = """
이 이미지는 '약 봉투 또는 처방전' 사진이다.
이미지를 보고 복약 정보를 구조화하라.

규칙:
- 반드시 JSON만 출력
- 설명 문장, 코드블록, 마크다운 절대 금지
- 누락된 정보는 빈 문자열로 둔다
- times_per_day, days 는 숫자 문자열

출력 형식:
{
  "drugs": [
    {
      "drug_name": "",
      "dose": "",
      "amount_per_dose": "",
      "times_per_day": "",
      "days": ""
    }
  ]
}
"""

    try:
        response = client.models.generate_content(
            model=MODEL,
            contents=[
                # 1. 텍스트 프롬프트
                prompt,
                # 2. 이미지 파트 (타입 객체를 사용하여 명시적으로 전달)
                types.Part.from_bytes(
                    data=image_bytes,
                    mime_type="image/jpeg"
                )
            ]
        )

        text = response.text.strip()
        
        # 마크다운 코드 블록(```json)이 포함될 경우 제거
        if "```" in text:
            text = text.replace("```json", "").replace("```", "").strip()

        return json.loads(text)

    except json.JSONDecodeError:
        # AI가 이상한 말을 했을 경우 빈 구조라도 반환하여 500 에러 방지
        print(f"Gemini JSON 파싱 실패 원본: {text}")
        return {"drugs": []}
    except Exception as e:
        print(f"Gemini API 호출 에러: {e}")
        return {"drugs": []}