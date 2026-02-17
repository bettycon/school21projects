from sqlalchemy import Column, String, Integer, ForeignKeyConstraint
from .base import Base

class Supplier(Base):
    __tablename__ = "suppliers"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    address_id = Column(Integer)
    phone_number = Column(String(20), nullable=False)
    
    __table_args__ = (
        ForeignKeyConstraint(['address_id'], ['addresses.id']),
    )