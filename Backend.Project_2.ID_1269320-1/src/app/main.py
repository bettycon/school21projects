from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .database import create_tables
from .api.v1 import clients, products, suppliers, images, addresses  # Добавили addresses

app = FastAPI(
    title="ShopAPI",
    description="REST API для магазина бытовой техники",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Create tables on startup
@app.on_event("startup")
def on_startup():
    create_tables()

# Include routers
app.include_router(clients.router, prefix="/api/v1/clients", tags=["clients"])
app.include_router(products.router, prefix="/api/v1/products", tags=["products"])
app.include_router(suppliers.router, prefix="/api/v1/suppliers", tags=["suppliers"])
app.include_router(images.router, prefix="/api/v1/images", tags=["images"])
app.include_router(addresses.router, prefix="/api/v1/addresses", tags=["addresses"])  # Добавили