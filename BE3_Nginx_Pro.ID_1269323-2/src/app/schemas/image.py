from pydantic import BaseModel
from uuid import UUID
from typing import Optional

class ImageBase(BaseModel):
    pass

class ImageCreate(BaseModel):
    image: str  
    product_id: int

class ImageUpdate(BaseModel):
    image: str  

class Image(ImageBase):
    id: UUID  
    product_id: int
    
    class Config:
        from_attributes = True
