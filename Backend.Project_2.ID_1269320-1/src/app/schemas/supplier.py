from pydantic import BaseModel
from typing import Optional

class SupplierBase(BaseModel):
    name: str
    phone_number: str

class SupplierCreate(SupplierBase):
    address_id: int

class SupplierUpdate(BaseModel):
    name: Optional[str] = None
    phone_number: Optional[str] = None
    address_id: Optional[int] = None

class Supplier(SupplierBase):
    id: int
    address_id: int  # ЗАМЕНИТЬ address на address_id
    
    class Config:
        from_attributes = True