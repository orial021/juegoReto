#abrir el entorno virtual venv\Scripts\activate
#fastapi dev --reload

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from tortoise.contrib.fastapi import register_tortoise
from tortoise_conf import TORTOISE_ORM
from routers import routers
from utils.http_error_handler import HTTPErrorHandler

app = FastAPI()

origins = [
    "http://localhost",
    "http://localhost:8080",
]

app.add_middleware(HTTPErrorHandler)
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount("/static", StaticFiles(directory="../"), name="static")

register_tortoise(
    app,
    config = TORTOISE_ORM,
    generate_schemas = True,
    add_exception_handlers = True
)


for router, prefix in routers:
    app.include_router(router, prefix=prefix)