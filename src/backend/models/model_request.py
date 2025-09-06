from pydantic import BaseModel

class MathQuestionRequest(BaseModel):
    imageBase64Str: str