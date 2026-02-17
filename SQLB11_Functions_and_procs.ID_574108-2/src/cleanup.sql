-- 1. Удаляем таблицу (самостоятельный объект)
DROP TABLE IF EXISTS person_audit CASCADE;

-- 2. Удаляем триггеры (зависят от таблиц)
DROP TRIGGER IF EXISTS trg_person_audit ON person CASCADE;
DROP TRIGGER IF EXISTS trg_person_insert_audit ON person CASCADE;
DROP TRIGGER IF EXISTS trg_person_update_audit ON person CASCADE;
DROP TRIGGER IF EXISTS trg_person_delete_audit ON person CASCADE;

-- 3. Удаляем функции (независимые объекты)
-- Можно в любом порядке с CASCADE
DROP FUNCTION IF EXISTS fnc_trg_person_audit() CASCADE;
DROP FUNCTION IF EXISTS fnc_trg_person_insert_audit() CASCADE;
DROP FUNCTION IF EXISTS fnc_trg_person_update_audit() CASCADE;
DROP FUNCTION IF EXISTS fnc_trg_person_delete_audit() CASCADE;
DROP FUNCTION IF EXISTS fnc_persons_female() CASCADE;
DROP FUNCTION IF EXISTS fnc_persons_male() CASCADE;
DROP FUNCTION IF EXISTS fnc_persons(varchar) CASCADE;
DROP FUNCTION IF EXISTS fnc_person_visits_and_eats_on_date(varchar, numeric, date) CASCADE;
DROP FUNCTION IF EXISTS func_minimum(numeric[]) CASCADE;
DROP FUNCTION IF EXISTS fnc_fibonacci(integer) CASCADE;

-- 4. Чистим данные
DELETE FROM person WHERE id = 10;