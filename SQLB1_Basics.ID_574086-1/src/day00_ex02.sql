-- day00_ex02.sql
-- Задание 02: Погружение в мир SQL
-- Два разных запроса для пиццерий с рейтингом от 3.5 до 5

-- Запрос 1: с операторами сравнения
SELECT 
    name,
    rating
FROM 
    pizzeria
WHERE 
    rating >= 3.5 AND rating <= 5
ORDER BY 
    rating;

-- Запрос 2: с оператором BETWEEN
SELECT 
    name,
    rating
FROM 
    pizzeria
WHERE 
    rating BETWEEN 3.5 AND 5
ORDER BY 
    rating;