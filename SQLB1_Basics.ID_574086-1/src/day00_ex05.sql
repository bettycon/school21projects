-- day00_ex05.sql
-- Задание 05: Погружение в мир SQL
-- Имена людей, которые сделали заказы 7 января 2022 года 
-- с меню id 13, 14, 18 (без использования IN и JOIN)

SELECT 
    (SELECT name FROM person WHERE id = po.person_id) AS name
FROM 
    person_order po
WHERE 
    po.order_date = '2022-01-07'
    AND (po.menu_id = 13 OR po.menu_id = 14 OR po.menu_id = 18);