from pydantic import BaseModel
from datetime import date, datetime
from typing import Optional

class ClientBase(BaseModel):
    client_name: str
    client_surname: str
    birthday: date
    gender: str

class ClientCreate(ClientBase):
    address_id: int

class ClientUpdate(BaseModel):
    client_name: Optional[str] = None
    client_surname: Optional[str] = None
    birthday: Optional[date] = None
    gender: Optional[str] = None
    address_id: Optional[int] = None

class Client(ClientBase):
    id: int
    registration_date: datetime
    address_id: int  # ПРОСТО ID, А НЕ ЦЕЛЫЙ ОБЪЕКТ
    
    class Config:
        from_attributes = True