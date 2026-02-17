from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from typing import List
import uuid

from app.database import get_db
from app.models.image import Image
from app.schemas.image import ImageCreate, ImageUpdate, Image as ImageSchema

router = APIRouter(prefix="/images", tags=["images"])

# CREATE
@router.post("/", response_model=ImageSchema, status_code=201)
async def create_image(
    product_id: int,
    image: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    contents = await image.read()
    db_image = Image(
        id=str(uuid.uuid4()),
        image=contents,
        product_id=product_id
    )
    db.add(db_image)
    db.commit()
    db.refresh(db_image)
    return db_image

# READ ALL
@router.get("/", response_model=List[ImageSchema])
def read_images(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    images = db.query(Image).offset(skip).limit(limit).all()
    return images

# READ ONE
@router.get("/{image_id}", response_model=ImageSchema)
def read_image(image_id: str, db: Session = Depends(get_db)):
    db_image = db.query(Image).filter(Image.id == image_id).first()
    if db_image is None:
        raise HTTPException(status_code=404, detail="Image not found")
    return db_image

# UPDATE
@router.put("/{image_id}", response_model=ImageSchema)
async def update_image(
    image_id: str,
    image: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    db_image = db.query(Image).filter(Image.id == image_id).first()
    if db_image is None:
        raise HTTPException(status_code=404, detail="Image not found")
    
    contents = await image.read()
    db_image.image = contents
    
    db.commit()
    db.refresh(db_image)
    return db_image

# DELETE
@router.delete("/{image_id}")
def delete_image(image_id: str, db: Session = Depends(get_db)):
    db_image = db.query(Image).filter(Image.id == image_id).first()
    if db_image is None:
        raise HTTPException(status_code=404, detail="Image not found")
    
    db.delete(db_image)
    db.commit()
    return {"message": "Image deleted successfully"}

# GET PRODUCT IMAGE
@router.get("/product/{product_id}")
def get_product_image(product_id: int, db: Session = Depends(get_db)):
    db_image = db.query(Image).filter(Image.product_id == product_id).first()
    if db_image is None:
        raise HTTPException(status_code=404, detail="Image not found for this product")
    return db_image
