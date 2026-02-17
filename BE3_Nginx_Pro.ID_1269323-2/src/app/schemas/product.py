from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class ProductBase(BaseModel):
    name: str
    category: str
    price: float
    available_stock: int

class ProductCreate(ProductBase):
    supplier_id: int
    image_id: Optional[str] = None

class ProductUpdate(BaseModel):
    name: Optional[str] = None
    category: Optional[str] = None
    price: Optional[float] = None
    available_stock: Optional[int] = None
    supplier_id: Optional[int] = None
    image_id: Optional[str] = None

class Product(ProductBase):
    id: int
    last_update_date: datetime
    supplier_id: int  
    
    class Config:
        from_attributes = True
