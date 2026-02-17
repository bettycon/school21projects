CREATE TABLE IF NOT EXISTS routes (
    point1 TEXT NOT NULL,
    point2 TEXT NOT NULL,
    cost INTEGER NOT NULL
);

TRUNCATE TABLE routes;
INSERT INTO routes (point1, point2, cost) VALUES
('a', 'b', 10), ('b', 'a', 10),
('a', 'c', 15), ('c', 'a', 15),
('a', 'd', 20), ('d', 'a', 20),
('b', 'c', 35), ('c', 'b', 35),
('b', 'd', 25), ('d', 'b', 25),
('c', 'd', 30), ('d', 'c', 30);

WITH RECURSIVE all_paths AS (
    SELECT 
        point2 AS last_city,
        ARRAY['a', point2] AS path_array,
        cost AS total_cost,
        1 AS step
    FROM routes
    WHERE point1 = 'a'
    
    UNION ALL
    
    SELECT 
        r.point2,
        ap.path_array || r.point2,
        ap.total_cost + r.cost,
        ap.step + 1
    FROM all_paths ap
    JOIN routes r ON ap.last_city = r.point1
    WHERE NOT r.point2 = ANY(ap.path_array)
      AND ap.step < 3
),
complete_tours AS (
    SELECT 
        ap.total_cost + r.cost AS total_cost,
        '{' || array_to_string(ap.path_array || ARRAY['a'], ',') || '}' AS tour
    FROM all_paths ap
    JOIN routes r ON ap.last_city = r.point1 AND r.point2 = 'a'
    WHERE ap.step = 3
)
SELECT 
    total_cost,
    tour
FROM complete_tours
WHERE total_cost = (SELECT MIN(total_cost) FROM complete_tours)
ORDER BY total_cost, tour;
