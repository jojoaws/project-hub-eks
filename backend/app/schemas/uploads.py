from pydantic import BaseModel


class UploadResponse(BaseModel):

    id: int

    file_name: str

    file_type: str

    s3_key: str

    thumbnail_key: str | None = None

    class Config:

        from_attributes = True
