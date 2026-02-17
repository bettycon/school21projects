from sqlalchemy import Column, String, Date, Integer, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from .base import Base
import datetime

class Client(Base):
    __tablename__ = "clients"
    
    id = Column(Integer, primary_key=True, index=True)
    client_name = Column(String(100), nullable=False)
    client_surname = Column(String(100), nullable=False)
    birthday = Column(Date, nullable=False)
    gender = Column(String(10), nullable=False)
    registration_date = Column(DateTime, default=datetime.datetime.utcnow)
    address_id = Column(Integer, ForeignKey("addresses.id"))
    
    # УБЕДИТЕСЬ, ЧТО ЕСТЬ ЭТА СТРОКА:
    address = relationship("Address", back_populates="clients")