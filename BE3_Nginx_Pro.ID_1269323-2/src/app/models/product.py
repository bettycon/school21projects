from sqlalchemy import Column, String, Float, Integer, DateTime, ForeignKeyConstraint
from sqlalchemy.dialects.postgresql import UUID
from .base import Base
import datetime

class Product(Base):
    __tablename__ = "products"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    category = Column(String(100), nullable=False)
    price = Column(Float, nullable=False)
    available_stock = Column(Integer, default=0)
    last_update_date = Column(DateTime, default=datetime.datetime.utcnow)
    supplier_id = Column(Integer)
    image_id = Column(UUID(as_uuid=True))
    
    __table_args__ = (
        ForeignKeyConstraint(['supplier_id'], ['suppliers.id']),
        ForeignKeyConstraint(['image_id'], ['images.id']),
    )