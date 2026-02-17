from fastapi import APIRouter, Depends, HTTPException, status, Response
from sqlalchemy.orm import Session
from typing import Optional
from uuid import UUID
from app.database import get_db
from app.schemas.image import Image, ImageCreate, ImageUpdate
from app.repositories.image import ImageRepository

router = APIRouter()
repo = ImageRepository()

@router.post("/", response_model=Image, status_code=status.HTTP_201_CREATED)
def create_image(image: ImageCreate, db: Session = Depends(get_db)):
    try:
        return repo.create(db, image)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/{image_id}", response_class=Response)
def get_image(image_id: UUID, db: Session = Depends(get_db)):
    image = repo.get(db, image_id)
    if not image:
        raise HTTPException(status_code=404, detail="Image not found")
    
    return Response(
        content=image.image,
        media_type="image/png",  
        headers={"Content-Disposition": f"attachment; filename={image_id}.png"}  # Изменили на .png
    )

@router.get("/product/{product_id}", response_class=Response)
def get_product_image(product_id: int, db: Session = Depends(get_db)):
    image = repo.get_by_product_id(db, product_id)
    if not image:
        raise HTTPException(status_code=404, detail="Image not found")
    
    return Response(
        content=image.image,
        media_type="image/png",  
        headers={"Content-Disposition": f"attachment; filename=product_{product_id}.png"}  # Изменили на .png
    )

@router.put("/{image_id}", response_model=Image)
def update_image(image_id: UUID, image_update: ImageUpdate, db: Session = Depends(get_db)):
    try:
        image = repo.update(db, image_id, image_update)
        if not image:
            raise HTTPException(status_code=404, detail="Image not found")
        return image
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.delete("/{image_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_image(image_id: UUID, db: Session = Depends(get_db)):
    if not repo.delete(db, image_id):
        raise HTTPException(status_code=404, detail="Image not found")