-- day00_ex00.sql
-- Задание 00: Погружение в мир SQL
-- Вывод имен и возраста всех людей из города «Казань»

SELECT 
    name,
    age
FROM 
    person
WHERE 
    address = 'Kazan';