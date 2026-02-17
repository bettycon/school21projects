import os
import sys
import time

def main():
    print("🚀 Запуск ShopAPI (3 сервера для балансировки)")
    print("=" * 50)
    
    print("1. Основной сервер (порт 8000, read-write)...")
    os.system("UVICORN_PORT=8000 uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload &")
    time.sleep(3)
    
    print("2. Read-only сервер 1 (порт 8001)...")
    os.system("UVICORN_PORT=8001 READONLY=true uvicorn app.main:app --host 0.0.0.0 --port 8001 --reload &")
    time.sleep(2)
    
    print("3. Read-only сервер 2 (порт 8002)...")
    os.system("UVICORN_PORT=8002 READONLY=true uvicorn app.main:app --host 0.0.0.0 --port 8002 --reload &")
    time.sleep(2)
    
    print("=" * 50)
    print("✅ Все серверы запущены!")
    print("\n📊 Проверка работы:")
    print("   Основной:    curl http://localhost:8000/health")
    print("   Read-only 1: curl http://localhost:8001/health")
    print("   Read-only 2: curl http://localhost:8002/health")
    print("\n⏹️  Для остановки: pkill -f uvicorn")
    print("=" * 50)
    
  
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n⏹️  Остановка...")
        os.system("pkill -f uvicorn")
        print("✅ Серверы остановлены")

if __name__ == "__main__":
    main()
