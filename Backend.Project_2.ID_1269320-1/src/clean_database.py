from app.database import SessionLocal
from app.models.client import Client

def clean_null_addresses():
    db = SessionLocal()
    try:
        # Найдем клиентов с address_id = NULL
        clients_with_null_address = db.query(Client).filter(Client.address_id == None).all()
        
        if clients_with_null_address:
            print(f"Найдено клиентов с NULL address_id: {len(clients_with_null_address)}")
            
            # Установим им address_id = 1 (или другой существующий адрес)
            for client in clients_with_null_address:
                client.address_id = 1
                print(f"Обновлен клиент ID {client.id}")
            
            db.commit()
            print("✅ База данных очищена от NULL значений")
        else:
            print("✅ Проблемных записей не найдено")
            
    except Exception as e:
        print(f"❌ Ошибка: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    clean_null_addresses()