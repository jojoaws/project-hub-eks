import os

from jose import JWTError
from jose import jwt

from fastapi import Depends
from fastapi import HTTPException

from fastapi.security import HTTPBearer
from fastapi.security import HTTPAuthorizationCredentials

from sqlalchemy.orm import Session

from app.db.session import SessionLocal

from app.models.user import User


security = HTTPBearer()

JWT_SECRET_KEY = os.getenv(
    "JWT_SECRET_KEY"
)

ALGORITHM = "HS256"


def get_db():

    db = SessionLocal()

    try:

        yield db

    finally:

        db.close()


def get_current_user(

    credentials: HTTPAuthorizationCredentials = Depends(
        security
    ),

    db: Session = Depends(
        get_db
    )

):

    token = credentials.credentials

    try:

        payload = jwt.decode(
            token,
            JWT_SECRET_KEY,
            algorithms=[ALGORITHM]
        )

    except JWTError:

        raise HTTPException(
            status_code=401,
            detail="Invalid token"
        )

    user_id = int(
        payload["sub"]
    )

    user = db.query(User).filter(
        User.id == user_id
    ).first()

    if not user:

        raise HTTPException(
            status_code=401,
            detail="User not found"
        )

    return user
