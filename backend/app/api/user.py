from fastapi import APIRouter
from fastapi import Depends

from sqlalchemy.orm import Session

from app.dependencies.auth import get_current_user
from app.dependencies.auth import get_db

from app.models.user import User

from app.services.s3_service import (
    generate_presigned_url
)

router = APIRouter(
    prefix="/users",
    tags=["Users"]
)


@router.get("/me")
def get_me(
    current_user: User = Depends(
        get_current_user
    )
):

    return {

        "id": current_user.id,

        "full_name": current_user.full_name,

        "email": current_user.email,

        "profile_picture":
            generate_presigned_url(
                current_user.profile_picture
            )
            if current_user.profile_picture
            else None,

        "resume_url":
            generate_presigned_url(
                current_user.resume
            )
            if current_user.resume
            else None,

        "bio":
            current_user.bio

    }

@router.put("/me/bio")
def update_bio(

    payload: dict,

    db: Session = Depends(
        get_db
    ),

    current_user: User = Depends(
        get_current_user
    )

):

    current_user.bio = payload["bio"]

    db.commit()

    db.refresh(current_user)

    return {

        "message": "Bio updated"

    }
