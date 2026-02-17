DELETE FROM person_order WHERE order_date IN ('2022-02-24', '2022-02-25');
DELETE FROM person_visits WHERE visit_date = '2022-02-24';
DELETE FROM menu WHERE pizza_name IN ('greek pizza', 'sicilian pizza');

SELECT '=== Проверка после сброса ===' as info;
SELECT 'menu' as table_name, COUNT(*) as count, MAX(id) as max_id FROM menu
UNION ALL
SELECT 'person_visits', COUNT(*), MAX(id) FROM person_visits
UNION ALL
SELECT 'person_order', COUNT(*), MAX(id) FROM person_order
ORDER BY table_name;