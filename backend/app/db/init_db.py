from app.db.base import Base

from app.db.session import engine

from app.models.user import User
from app.models.projects import Project
from app.models.uploads import Upload


def init_db():

    Base.metadata.create_all(
        bind=engine
    )
