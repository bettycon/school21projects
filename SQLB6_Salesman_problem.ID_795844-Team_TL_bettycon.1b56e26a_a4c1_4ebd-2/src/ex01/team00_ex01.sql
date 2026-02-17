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
),
min_max_costs AS (
    SELECT 
        MIN(total_cost) AS min_cost,
        MAX(total_cost) AS max_cost
    FROM complete_tours
)
SELECT 
    ct.total_cost,
    ct.tour
FROM complete_tours ct
CROSS JOIN min_max_costs mmc
WHERE ct.total_cost = mmc.min_cost OR ct.total_cost = mmc.max_cost
ORDER BY ct.total_cost, ct.tour;
