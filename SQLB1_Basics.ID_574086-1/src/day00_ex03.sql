-- day00_ex03.sql
-- Задание 03: Погружение в мир SQL
-- Уникальные идентификаторы людей, посетивших пиццерии 

SELECT DISTINCT 
    person_id
FROM 
    person_visits
WHERE 
    (visit_date BETWEEN '2022-01-06' AND '2022-01-09')
    OR pizzeria_id = 2
ORDER BY 
    person_id DESC;