from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.schemas.product import Product, ProductCreate, ProductUpdate
from app.repositories.product import ProductRepository

router = APIRouter()
repo = ProductRepository()

@router.post("/", response_model=Product, status_code=status.HTTP_201_CREATED)
def create_product(product: ProductCreate, db: Session = Depends(get_db)):
    return repo.create(db, product)

@router.get("/{product_id}", response_model=Product)
def get_product(product_id: int, db: Session = Depends(get_db)):
    product = repo.get(db, product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

@router.get("/", response_model=List[Product])
def get_products(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    return repo.get_all(db, skip, limit)

@router.patch("/{product_id}/stock", response_model=Product)
def decrease_product_stock(
    product_id: int, 
    decrease_by: int,
    db: Session = Depends(get_db)
):
    try:
        product = repo.decrease_stock(db, product_id, decrease_by)
        if not product:
            raise HTTPException(status_code=404, detail="Product not found")
        return product
    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.delete("/{product_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_product(product_id: int, db: Session = Depends(get_db)):
    if not repo.delete(db, product_id):
        raise HTTPException(status_code=404, detail="Product not found")