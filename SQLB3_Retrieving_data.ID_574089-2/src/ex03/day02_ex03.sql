WITH date_series AS (
    SELECT generate_series('2022-01-01'::date, '2022-01-10'::date, interval '1 day') AS missing_date
)
SELECT ds.missing_date::date AS missing_date
FROM date_series ds
LEFT JOIN (
    SELECT DISTINCT visit_date
    FROM person_visits
    WHERE person_id = 1 OR person_id = 2
) AS visits ON ds.missing_date = visits.visit_date
WHERE visits.visit_date IS NULL
ORDER BY ds.missing_date;