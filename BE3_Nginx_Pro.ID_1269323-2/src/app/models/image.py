from sqlalchemy import Column, LargeBinary, ForeignKey, Integer
from sqlalchemy.dialects.postgresql import UUID
import uuid
from .base import Base

class Image(Base):
    __tablename__ = "images"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)  # UUID
    image = Column(LargeBinary, nullable=False)
    product_id = Column(Integer, ForeignKey("products.id"))