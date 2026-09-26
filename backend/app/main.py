from fastapi import FastAPI

from app.api.auth import router as auth_router

from app.db.init_db import init_db

from app.api.uploads import router as uploads_router

from app.api.projects import router as projects_router

from app.api import user

from fastapi.middleware.cors import CORSMiddleware

from prometheus_fastapi_instrumentator import Instrumentator

init_db()

app = FastAPI(
    title="ProjectHub API",
    version="1.0.0",
    root_path="/api"
)

Instrumentator().instrument(app).expose(
    app,
    endpoint="/metrics",
    include_in_schema=False
)

app.add_middleware(
    CORSMiddleware,

    allow_origins=[
        "http://localhost:5173"
    ],

    allow_credentials=True,

    allow_methods=["*"],

    allow_headers=["*"]
)

app.include_router(
    auth_router
)

app.include_router(
    uploads_router
)

app.include_router(
    projects_router
)

app.include_router(
    user.router
)

@app.get("/health")
def health_check():

    return {
        "status": "healthy"
    }
