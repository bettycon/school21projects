from typing import List, Optional
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from app import crud, schemas
from app.dependencies import get_db

router = APIRouter()

@router.post("/", response_model=schemas.ClientRead)
async def create_client(
    client_in: schemas.ClientCreate,
    db: AsyncSession = Depends(get_db)
):
    return await crud.client.create(db=db, obj_in=client_in)

@router.get("/", response_model=List[schemas.ClientRead])
async def read_clients(
    skip: Optional[int] = Query(0, ge=0),
    limit: Optional[int] = Query(100, ge=1, le=1000),
    name: Optional[str] = None,
    surname: Optional[str] = None,
    db: AsyncSession = Depends(get_db)
):
    if name and surname:
        client = await crud.client.get_by_name(db, name=name, surname=surname)
        return [client] if client else []
    return await crud.client.get_multi(db, skip=skip, limit=limit)

@router.get("/{client_id}", response_model=schemas.ClientRead)
async def read_client(client_id: UUID, db: AsyncSession = Depends(get_db)):
    client = await crud.client.get(db, id=client_id)
    if not client:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Client not found"
        )
    return client

@router.delete("/{client_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_client(client_id: UUID, db: AsyncSession = Depends(get_db)):
    await crud.client.remove(db, id=client_id)
    return None

@router.patch("/{client_id}/address", response_model=schemas.ClientRead)
async def update_client_address(
    client_id: UUID,
    address_update: schemas.AddressUpdate,  # Нужно создать эту схему
    db: AsyncSession = Depends(get_db)
):
    # Логика обновления адреса клиента
    pass