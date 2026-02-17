from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.schemas.address import Address, AddressCreate, AddressUpdate
from app.repositories.address import AddressRepository

router = APIRouter()
repo = AddressRepository()

@router.post("/", response_model=Address, status_code=status.HTTP_201_CREATED)
def create_address(address: AddressCreate, db: Session = Depends(get_db)):
    return repo.create(db, address)

@router.get("/{address_id}", response_model=Address)
def get_address(address_id: int, db: Session = Depends(get_db)):
    address = repo.get(db, address_id)
    if not address:
        raise HTTPException(status_code=404, detail="Address not found")
    return address

@router.get("/", response_model=List[Address])
def get_addresses(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    return repo.get_all(db, skip, limit)

@router.put("/{address_id}", response_model=Address)
def update_address(address_id: int, address: AddressUpdate, db: Session = Depends(get_db)):
    db_address = repo.get(db, address_id)
    if not db_address:
        raise HTTPException(status_code=404, detail="Address not found")
    return repo.update(db, db_address, address)

@router.delete("/{address_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_address(address_id: int, db: Session = Depends(get_db)):
    if not repo.delete(db, address_id):
        raise HTTPException(status_code=404, detail="Address not found")