from fastapi import APIRouter
from fastapi import Depends

from sqlalchemy.orm import Session

from app.db.session import SessionLocal

from app.models.projects import Project

from app.schemas.projects import (
    ProjectCreate,
    ProjectResponse
)

from app.services.s3_service import generate_presigned_url

from app.dependencies.auth import get_current_user

from app.models.user import User

from app.services.sns_service import publish_event

from app.services.s3_service import (
    generate_presigned_url
)

router = APIRouter(
    prefix="/projects",
    tags=["Projects"]
)


def get_db():

    db = SessionLocal()

    try:

        yield db

    finally:

        db.close()


@router.post(
    "/",
    response_model=ProjectResponse
)

def create_project(

    payload: ProjectCreate,

    db: Session = Depends(get_db),

    current_user: User = Depends(
        get_current_user
    )

):

    project = Project(

        title=payload.title,

        description=payload.description,

        tech_stack=payload.tech_stack,

        owner_id=current_user.id

    )

    db.add(project)

    db.commit()

    db.refresh(project)

    publish_event(

        event_type="project_created",

        payload={

            "user_email": current_user.email,

            "user_name": current_user.full_name,

            "project_title": project.title

        }

    )

    return project

@router.get(
    "/",
    response_model=list[dict]
)
def get_projects(

    db: Session = Depends(get_db),

    current_user: User = Depends(
        get_current_user
    )

):

    projects = db.query(
        Project
    ).filter(
        Project.owner_id == current_user.id
    ).all()

    return [
        {
            "id": project.id,
            "title": project.title,
            "description": project.description,
            "tech_stack": project.tech_stack,
            "project_image":
                generate_presigned_url(
                    project.project_image
                )
                if project.project_image
                else None
        }
        for project in projects
    ]
