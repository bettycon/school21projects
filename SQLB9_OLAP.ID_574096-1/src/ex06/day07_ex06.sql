SELECT
    pizzeria.name,
    COUNT(*) as count_of_orders,
    ROUND(AVG(menu.price),2) as average_price,
    MAX(menu.price) as max_price,
    MIN(menu.price) as min_price
FROM person_order
JOIN menu
    ON person_order.menu_id = menu.id
JOIN pizzeria
    ON menu.pizzeria_id = pizzeria.id
GROUP BY pizzeria.name
ORDER BY pizzeria.name;