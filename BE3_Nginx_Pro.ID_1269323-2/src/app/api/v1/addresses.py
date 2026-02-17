from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app.models.address import Address
from app.schemas.address import AddressCreate, AddressUpdate, Address as AddressSchema

router = APIRouter(prefix="/addresses", tags=["addresses"])

# CREATE
@router.post("/", response_model=AddressSchema, status_code=201)
def create_address(address: AddressCreate, db: Session = Depends(get_db)):
    db_address = Address(**address.dict())
    db.add(db_address)
    db.commit()
    db.refresh(db_address)
    return db_address

# READ ALL
@router.get("/", response_model=List[AddressSchema])
def get_addresses(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    addresses = db.query(Address).offset(skip).limit(limit).all()
    return addresses

# READ ONE
@router.get("/{address_id}", response_model=AddressSchema)
def get_address(address_id: int, db: Session = Depends(get_db)):
    db_address = db.query(Address).filter(Address.id == address_id).first()
    if db_address is None:
        raise HTTPException(status_code=404, detail="Address not found")
    return db_address

# UPDATE
@router.put("/{address_id}", response_model=AddressSchema)
def update_address(address_id: int, address: AddressUpdate, db: Session = Depends(get_db)):
    db_address = db.query(Address).filter(Address.id == address_id).first()
    if db_address is None:
        raise HTTPException(status_code=404, detail="Address not found")
    
    for key, value in address.dict(exclude_unset=True).items():
        setattr(db_address, key, value)
    
    db.commit()
    db.refresh(db_address)
    return db_address

# DELETE
@router.delete("/{address_id}")
def delete_address(address_id: int, db: Session = Depends(get_db)):
    db_address = db.query(Address).filter(Address.id == address_id).first()
    if db_address is None:
        raise HTTPException(status_code=404, detail="Address not found")
    
    db.delete(db_address)
    db.commit()
    return {"message": "Address deleted successfully"}
