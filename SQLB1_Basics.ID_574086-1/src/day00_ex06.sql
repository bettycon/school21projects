-- day00_ex06.sql
-- Задание 06: Погружение в мир SQL
-- Добавляем проверку имени

SELECT 
    (SELECT name FROM person WHERE id = po.person_id) AS name,
    (SELECT name FROM person WHERE id = po.person_id) = 'Denis' AS check_name
FROM 
    person_order po
WHERE 
    po.order_date = '2022-01-07'
    AND (po.menu_id = 13 OR po.menu_id = 14 OR po.menu_id = 18);