WITH visits AS (
    SELECT pizzeria.name, COUNT(*) AS count, 'visits' AS action_type
    FROM person_visits
    RIGHT JOIN pizzeria ON person_visits.pizzeria_id = pizzeria.id
    GROUP BY pizzeria.name
),
orders AS (
    SELECT pizzeria.name, COUNT(person_order.menu_id) AS count, 'order' AS action_type
    FROM person_order
    RIGHT JOIN menu ON person_order.menu_id = menu.id
    RIGHT JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
    GROUP BY pizzeria.name
)
SELECT name, SUM(count) AS total_count
FROM (
    SELECT * FROM visits
    UNION ALL
    SELECT * FROM orders
) AS statistic
GROUP BY name
ORDER BY total_count DESC, name;