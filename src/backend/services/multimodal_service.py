
import os
from openai import AzureOpenAI 
from common import constant

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
                "role": "system",
                "content": [
                    {
                        "type": "text",
                        "text": constant.system_prompt
                    }
                ]
            },
            {
                "role": "user",
                "content":
                [
                    {
                        "type": "text",
                        "text": "Please solve this math problem. If the image is not math, return the JSON error as instructed."
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{imageBase64Str}"
                        }
                     }
                ]
                
            }
        ]

        response = self.azure_openai_client.chat.completions.create(
            model = self.deployment_name if self.deployment_name is not None else "gpt-4.1-mini",
            messages=messages,
            max_tokens=1024,
            temperature=0.3,
            top_p=0.95,
            frequency_penalty=0,
            presence_penalty=0,
            stop=None,
            stream=False
        )
        
        print(response.to_json())

        return response.choices[0].message.content
        
        