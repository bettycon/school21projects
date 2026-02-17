SELECT
    p.name AS name,
    m.pizza_name,
    m.price,
    ROUND(m.price * (100 - pd.discount) / 100) AS discount_price,
    pz.name AS pizzeria_name
FROM person_order po
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
JOIN person p ON po.person_id = p.id
JOIN person_discounts pd ON p.id = pd.person_id AND pz.id = pd.pizzeria_id
ORDER BY name, pizza_name;