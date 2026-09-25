from fastapi import APIRouter
from fastapi import File
from fastapi import UploadFile
from fastapi import HTTPException
from fastapi import Depends

from sqlalchemy.orm import Session

from app.services.s3_service import upload_file
from app.dependencies.auth import get_current_user
from app.models.user import User
from app.models.projects import Project
from app.services.sns_service import publish_event

from app.api.projects import get_db

router = APIRouter(
    prefix="/uploads",
    tags=["Uploads"]
)

MAX_FILE_SIZE = 20 * 1024 * 1024


@router.post("/profile-picture")
def upload_profile_picture(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(
        get_current_user
    )
):

    if not file.content_type.startswith(
        "image/"
    ):
        raise HTTPException(
            status_code=400,
            detail="Image file required"
        )

    contents = file.file.read()

    if len(contents) > MAX_FILE_SIZE:
        raise HTTPException(
            status_code=400,
            detail="Maximum file size is 20 MB"
        )

    file.file.seek(0)

    key = upload_file(
        file,
        "profile-pictures"
    )

    user = db.query(User).filter(
    User.id == current_user.id
    ).first()

    user.profile_picture = key

    db.commit()

#    publish_event(
#        event_type="file_uploaded",
#        payload={
#            "file_type": "profile-picture",
#            "user_email": current_user.email,
#            "user_name": current_user.full_name,
#            "s3_key": key
#       }
#    )

    return {
        "message": "Profile picture uploaded",
        "s3_key": key
    }


@router.post("/project-image")
def upload_project_image(
    project_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(
        get_current_user
    )
):

    if not file.content_type.startswith(
        "image/"
    ):
        raise HTTPException(
            status_code=400,
            detail="Image file required"
        )

    contents = file.file.read()

    if len(contents) > MAX_FILE_SIZE:
        raise HTTPException(
            status_code=400,
            detail="Maximum file size is 20 MB"
        )

    file.file.seek(0)

    key = upload_file(
        file,
        "project-images"
    )

    project = db.query(
        Project
    ).filter(
        Project.id == project_id,
        Project.owner_id == current_user.id
    ).first()

    if not project:
        raise HTTPException(
            status_code=404,
            detail="Project not found"
        )

    project.project_image = key

    db.commit()

    db.refresh(project)

    publish_event(
        event_type="file_uploaded",
        payload={
            "file_type": "project-image",
            "user_email": current_user.email,
            "user_name": current_user.full_name,
            "s3_key": key
        }
    )

    return {
        "message": "Project image uploaded",
        "s3_key": key
    }


@router.post("/resume")
def upload_resume(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(
        get_current_user
    )
):

    if file.content_type != "application/pdf":
        raise HTTPException(
            status_code=400,
            detail="PDF file required"
        )

    contents = file.file.read()

    if len(contents) > MAX_FILE_SIZE:
        raise HTTPException(
            status_code=400,
            detail="Maximum file size is 20 MB"
        )

    file.file.seek(0)

    key = upload_file(
        file,
        "resumes"
    )

    user = db.query(User).filter(
    User.id == current_user.id
    ).first()

    user.resume = key

    db.commit()

    publish_event(
        event_type="file_uploaded",
        payload={
            "file_type": "resume",
            "user_email": current_user.email,
            "user_name": current_user.full_name,
            "s3_key": key
        }
    )

    return {
        "message": "Resume uploaded",
        "s3_key": key
    }
