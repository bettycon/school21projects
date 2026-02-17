WITH common_dates AS (
    SELECT order_date AS action_date, person_id
    FROM person_order
    INTERSECT
    SELECT visit_date, person_id
    FROM person_visits
)
SELECT 
    cd.action_date,
    p.name AS person_name
FROM common_dates cd
JOIN person p ON cd.person_id = p.id
ORDER BY cd.action_date ASC, p.name DESC;