from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.product import Product
from app.schemas.product import ProductCreate, ProductUpdate
from .base import BaseRepository
from fastapi import HTTPException

class ProductRepository(BaseRepository[Product]):
    def __init__(self):
        super().__init__(Product)
    
    def decrease_stock(self, db: Session, product_id: int, decrease_by: int) -> Optional[Product]:
        product = self.get(db, product_id)
        if product:
            if product.available_stock >= decrease_by:
                product.available_stock -= decrease_by
                db.commit()
                db.refresh(product)
                return product
            else:
                raise HTTPException(
                    status_code=400, 
                    detail=f"Not enough stock. Available: {product.available_stock}, requested: {decrease_by}"
                )
        return None