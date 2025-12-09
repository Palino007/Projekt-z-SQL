WITH price_changes AS (
    SELECT
        category_name,
        year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY category_name ORDER BY year) AS prev_price
    FROM t_pavol_medo_project_SQL_primary_final
    WHERE category_name IS NOT NULL
)
SELECT
    category_name,
    ROUND(AVG((avg_price - prev_price) / prev_price * 100), 2) AS avg_yearly_pct_change
FROM price_changes
WHERE prev_price IS NOT NULL
GROUP BY category_name
ORDER BY avg_yearly_pct_change ASC
LIMIT 1;