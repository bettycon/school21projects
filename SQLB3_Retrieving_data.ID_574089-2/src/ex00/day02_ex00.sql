SELECT pz.name AS pizzeria_name, pz.rating
FROM pizzeria pz
LEFT JOIN person_visits pv ON pz.id = pv.pizzeria_id
WHERE pv.id IS NULL
ORDER BY pizzeria_name;