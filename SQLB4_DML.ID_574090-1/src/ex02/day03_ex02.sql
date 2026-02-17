SELECT 
    m.pizza_name,
    m.price,
    pz.name AS pizzeria_name
FROM menu m
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE m.id NOT IN (
    SELECT DISTINCT menu_id 
    FROM person_order
)
ORDER BY m.pizza_name, m.price;