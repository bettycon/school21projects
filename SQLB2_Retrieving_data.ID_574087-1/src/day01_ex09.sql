-- Решение с IN
SELECT name
FROM pizzeria
WHERE id NOT IN (
    SELECT DISTINCT pizzeria_id 
    FROM person_visits
)
ORDER BY name;

-- Решение с EXISTS
SELECT name
FROM pizzeria p
WHERE NOT EXISTS (
    SELECT 1
    FROM person_visits pv
    WHERE pv.pizzeria_id = p.id
)
ORDER BY name;