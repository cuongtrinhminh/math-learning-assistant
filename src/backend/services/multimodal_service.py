
import os
from openai import AzureOpenAI 
from common import constant
from enum import Enum     # for enum34, or the stdlib version
from fastapi.responses import JSONResponse
import json

class PromptRole(Enum):
    SYSTEM = "system"
    USER = "user"
    ASSISTANT = "assistant"

class PromptType(Enum):
    TEXT = "text"
    IMAGE = "image_url"

class PromptKey(Enum):
    ROLE = "role"
    CONTENT = "content"
    TYPE = "type"
    URL = "url"
    
class MultimodalService: 
    
    def __init__(self, end_point: str, api_key: str, api_version: str, deployment: str = None):
        self.azure_openai_client = AzureOpenAI (
            azure_endpoint= end_point,
            api_key=api_key,
            api_version=api_version
        )
        if deployment is not None:
            self.deployment_name = deployment

    def get_answer(self, imageBase64Str: str):
        full_response = "" 
        messages = [
            {
                PromptKey.ROLE.value: PromptRole.SYSTEM.value,
                PromptKey.CONTENT.value: [
                    {
                        PromptKey.TYPE.value: PromptType.TEXT.value,
                        PromptType.TEXT.value: constant.system_prompt
                    }
                ]
            },
            {
                PromptKey.ROLE.value: PromptRole.USER.value,
                PromptKey.CONTENT.value:
                [
                    {
                        PromptKey.TYPE.value: PromptType.TEXT.value,
                        PromptType.TEXT.value: constant.user_predefined_promt
                    },
                    {
                        PromptKey.TYPE.value: PromptType.IMAGE.value,
                        PromptType.IMAGE.value: {
                           PromptKey.URL.value: f"data:image/jpeg;base64,{imageBase64Str}"
                        }
                     }
                ]
                
            }
        ]

        response = self.azure_openai_client.chat.completions.create(
            model = self.deployment_name if self.deployment_name is not None else "gpt-4.1-mini",
            messages=messages,
            max_tokens=1024,
            temperature=0.2,
            top_p=0.95,
            frequency_penalty=0,
            presence_penalty=0,
            stop=None,
            stream=False
        )
        
        content = response.choices[0].message.content

        try:
            data = json.loads(content)
            print(data)
        except json.JSONDecodeError:
            return JSONResponse(
                status_code=204,
                content={"error_message": "Invalid JSON from model"}
            )
        
        if isinstance(data, list) and len(data) > 0:
            if "error_message" in data[0]:
                return JSONResponse(status_code=400, content=data[0])

        return JSONResponse(status_code=200, content=data)
    
        
        