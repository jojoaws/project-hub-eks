from sqlalchemy import Column
from sqlalchemy import DateTime
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String

from sqlalchemy.orm import relationship

from datetime import datetime

from app.db.base import Base


class Upload(Base):

    __tablename__ = "uploads"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    file_name = Column(
        String,
        nullable=False
    )

    file_type = Column(
        String,
        nullable=False
    )

    s3_key = Column(
        String,
        nullable=False
    )

    thumbnail_key = Column(
        String,
        nullable=True
    )

    project_id = Column(
        Integer,
        ForeignKey("projects.id")
    )

    created_at = Column(
        DateTime,
        default=datetime.utcnow
    )

    project = relationship(
        "Project",
        back_populates="uploads"
    )
