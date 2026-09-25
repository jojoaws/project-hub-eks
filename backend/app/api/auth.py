from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException

from sqlalchemy.orm import Session

from app.db.session import SessionLocal

from app.models.user import User

from app.schemas.user import (
    UserLogin,
    UserRegister,
    UserResponse
)

from app.services.auth_service import (
    create_access_token,
    hash_password,
    verify_password
)

from app.services.sns_service import publish_event

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"]
)


def get_db():

    db = SessionLocal()

    try:

        yield db

    finally:

        db.close()


@router.post(
    "/register",
    response_model=UserResponse
)
def register(
    payload: UserRegister,
    db: Session = Depends(get_db)
):

    existing_user = db.query(User).filter(
        User.email == payload.email
    ).first()

    if existing_user:

        raise HTTPException(
            status_code=400,
            detail="Email already registered"
        )

    user = User(

        full_name=payload.full_name,

        email=payload.email,

        hashed_password=hash_password(
            payload.password
        )

    )

    db.add(user)

    db.commit()

    db.refresh(user)

    publish_event(

        event_type="user_registered",

        payload={

            "email": user.email,

            "full_name": user.full_name

        }

    )

    return user

@router.post("/login")
def login(
    payload: UserLogin,
    db: Session = Depends(get_db)
):

    user = db.query(User).filter(
        User.email == payload.email
    ).first()

    if not user:

        raise HTTPException(
            status_code=401,
            detail="Invalid credentials"
        )

    if not verify_password(
        payload.password,
        user.hashed_password
    ):

        raise HTTPException(
            status_code=401,
            detail="Invalid credentials"
        )

    token = create_access_token(
        user.id
    )

    return {

        "access_token": token,

        "token_type": "bearer"

    }
