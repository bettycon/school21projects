(SELECT pz.name AS pizzeria_name
FROM person p
JOIN person_visits pv ON p.id = pv.person_id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
WHERE p.gender = 'female'

EXCEPT ALL

SELECT pz.name AS pizzeria_name
FROM person p
JOIN person_visits pv ON p.id = pv.person_id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
WHERE p.gender = 'male')

UNION ALL

(SELECT pz.name AS pizzeria_name
FROM person p
JOIN person_visits pv ON p.id = pv.person_id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
WHERE p.gender = 'male'

EXCEPT ALL

SELECT pz.name AS pizzeria_name
FROM person p
JOIN person_visits pv ON p.id = pv.person_id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
WHERE p.gender = 'female')
ORDER BY pizzeria_name;