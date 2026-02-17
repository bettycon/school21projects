from sqlalchemy import Column, String, Integer
from sqlalchemy.orm import relationship
from .base import Base

class Address(Base):
    __tablename__ = "addresses"
    
    id = Column(Integer, primary_key=True, index=True)
    country = Column(String(100), nullable=False)
    city = Column(String(100), nullable=False)
    street = Column(String(200), nullable=False)
    
    
    clients = relationship("Client", back_populates="address")
