WITH available_pizzeria AS (
    SELECT DISTINCT pz.id
    FROM pizzeria pz
    JOIN menu m ON m.pizzeria_id = pz.id
    WHERE m.price < 800
      AND pz.name NOT IN (SELECT name FROM mv_dmitriy_visits_and_eats)
    LIMIT 1
)
INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
SELECT 
    (SELECT MAX(id) + 1 FROM person_visits),
    (SELECT id FROM person WHERE name = 'Dmitriy'),
    ap.id,
    '2022-01-08'
FROM available_pizzeria ap
WHERE ap.id IS NOT NULL;
REFRESH MATERIALIZED VIEW mv_dmitriy_visits_and_eats;
SELECT *
FROM mv_dmitriy_visits_and_eats;