from fastapi import FastAPI
from routers import routers as learning_assistant_routers

import os

app = FastAPI()

for r in learning_assistant_routers:
    app.include_router(r)

