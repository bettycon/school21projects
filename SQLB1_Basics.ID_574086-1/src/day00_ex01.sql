-- day00_ex01.sql
-- Задание 01: Погружение в мир SQL
-- Имена и возраст всех женщин из города «Казань»

SELECT 
    name,
    age
FROM 
    person
WHERE 
    address = 'Kazan' 
    AND gender = 'female'
ORDER BY 
    name;