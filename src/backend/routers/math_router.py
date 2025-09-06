from fastapi import APIRouter
from services.multimodal_service import MultimodalService
from models.model_request import MathQuestionRequest
from dotenv import load_dotenv
from common import constant
import os 

load_dotenv()
router = APIRouter()

llm_service = MultimodalService(
    end_point=os.getenv("AZ_LL_ENDPOINT"),
    api_key=os.getenv("AZ_LLM_KEY"),
    api_version=os.getenv("AZ_LLM_API_VERSION"),
    deployment=os.getenv("AZ_LLM_DEPLOYMENT"),
)

@router.post("/math/solve")
def solve_questions(input: MathQuestionRequest):
    messages = llm_service.get_answer(input.imageBase64Str)
    return messages