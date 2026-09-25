from pydantic import BaseModel
from pydantic import EmailStr


class UserRegister(BaseModel):

    full_name: str

    email: EmailStr

    password: str


class UserLogin(BaseModel):

    email: EmailStr

    password: str


class UserResponse(BaseModel):

    id: int

    full_name: str

    email: EmailStr

    profile_picture: str | None = None

    resume_url: str | None = None

    bio: str | None = None

    class Config:

        from_attributes = True
