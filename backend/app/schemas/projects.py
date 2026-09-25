from pydantic import BaseModel


class ProjectCreate(BaseModel):

    title: str

    description: str

    tech_stack: str | None = None


class ProjectResponse(BaseModel):

    id: int

    title: str

    description: str

    tech_stack: str | None = None

    project_image: str | None = None

    class Config:

        from_attributes = True
