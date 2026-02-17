SELECT
    address,
    ROUND((MAX(age::numeric) - MIN(age::numeric) / MAX(age::numeric)),2) as formula,
    ROUND(AVG(age::numeric),2) as average,
    case
        when ROUND((MAX(age::numeric) - MIN(age::numeric) / MAX(age::numeric)),2) > ROUND(AVG(age::numeric),2) then 'true' else 'false'
    end comparison
FROM person
GROUP BY address
ORDER BY address;