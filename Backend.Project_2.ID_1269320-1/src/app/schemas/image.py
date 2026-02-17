from pydantic import BaseModel
from uuid import UUID
from typing import Optional

class ImageBase(BaseModel):
    pass

class ImageCreate(BaseModel):
    image: str  # base64 строка
    product_id: int

class ImageUpdate(BaseModel):
    image: str  # base64 строка

class Image(ImageBase):
    id: UUID  # ИСПРАВЛЕНО: UUID вместо str
    product_id: int
    
    class Config:
        from_attributes = True