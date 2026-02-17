-- day00_ex08.sql
-- Задание 08: Погружение в мир SQL
-- Все заказы с четными id

SELECT 
    *
FROM 
    person_order
WHERE 
    MOD(id, 2) = 0
ORDER BY 
    id;