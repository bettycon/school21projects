import os
from fastapi import FastAPI, HTTPException, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

app = FastAPI(
    title="ShopAPI",
    description="REST API для магазина бытовой техники",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
    redirect_slashes=False
)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.middleware("http")
async def check_readonly(request: Request, call_next):
    
    current_port = int(os.getenv("UVICORN_PORT", 8000))
    
    
    if current_port in [8001, 8002]:
       
        if request.method not in ["GET", "HEAD", "OPTIONS"]:
            return JSONResponse(
                status_code=status.HTTP_403_FORBIDDEN,
                content={
                    "detail": f"Это read-only сервер (порт {current_port}). Изменения запрещены. Используйте основной сервер порт 8000.",
                    "port": current_port,
                    "mode": "read-only",
                    "allowed_methods": ["GET", "HEAD", "OPTIONS"]
                }
            )
    
    response = await call_next(request)
    return response


from app.api.v1 import addresses, clients, products, suppliers, images


app.include_router(addresses.router, prefix="/api/v1")
app.include_router(clients.router, prefix="/api/v1")
app.include_router(products.router, prefix="/api/v1")
app.include_router(suppliers.router, prefix="/api/v1")
app.include_router(images.router, prefix="/api/v1")

@app.on_event("startup")
async def on_startup():
    from app.database import create_tables
    create_tables()

@app.get("/")
async def root():
    port = os.getenv("UVICORN_PORT", 8000)
    mode = "READ-ONLY" if port in [8001, 8002] else "READ-WRITE"
    return {
        "message": f"ShopAPI - REST API для магазина бытовой техники",
        "port": port,
        "mode": mode,
        "note": "Используйте порт 8000 для записи данных" if mode == "READ-ONLY" else "Это основной сервер"
    }

@app.get("/health")
async def health_check():
    port = os.getenv("UVICORN_PORT", 8000)
    mode = "READ-ONLY" if port in [8001, 8002] else "READ-WRITE"
    return {
        "status": "healthy",
        "port": port,
        "mode": mode
    }
