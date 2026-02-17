from sqlalchemy.orm import Session
from typing import List, Optional
from uuid import UUID
from app.models.image import Image
from app.schemas.image import ImageCreate, ImageUpdate
from .base import BaseRepository
import base64

class ImageRepository(BaseRepository[Image]):
    def __init__(self):
        super().__init__(Image)
    
    def get_by_product_id(self, db: Session, product_id: int) -> Optional[Image]:
        return db.query(Image).filter(Image.product_id == product_id).first()
    
    def create(self, db: Session, obj_in: ImageCreate) -> Image:
        # Декодируем base64 в бинарные данные
        try:
            image_binary = base64.b64decode(obj_in.image)
        except Exception as e:
            raise ValueError(f"Invalid base64 image data: {e}")
        
        db_obj = Image(
            image=image_binary,
            product_id=obj_in.product_id
        )
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj
    
    def update(self, db: Session, image_id: UUID, obj_in: ImageUpdate) -> Optional[Image]:
        image = self.get(db, image_id)
        if image:
            # Декодируем base64 в бинарные данные
            try:
                image_binary = base64.b64decode(obj_in.image)
            except Exception as e:
                raise ValueError(f"Invalid base64 image data: {e}")
            
            image.image = image_binary
            db.commit()
            db.refresh(image)
            return image
        return None