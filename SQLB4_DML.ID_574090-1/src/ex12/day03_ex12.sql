DELETE FROM person_order WHERE order_date = '2022-02-25';

INSERT INTO person_order (id, person_id, menu_id, order_date)
SELECT 
    (SELECT MAX(id) FROM person_order) + gs.n,
    p.id,
    (SELECT id FROM menu WHERE pizza_name = 'greek pizza'),
    '2022-02-25'
FROM generate_series(1, (SELECT COUNT(*) FROM person)) AS gs(n)
JOIN (
    SELECT id, 
           (SELECT COUNT(*) FROM person p2 WHERE p2.id <= p1.id) as rn
    FROM person p1
) p ON gs.n = p.rn
ORDER BY p.id;