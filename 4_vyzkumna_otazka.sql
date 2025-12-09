WITH food_prices AS (
    SELECT
        year,
        AVG(avg_price) AS avg_price_food
    FROM t_pavol_medo_project_SQL_primary_final
    WHERE category_name IS NOT NULL
    GROUP BY year
),
wages AS (
    SELECT
        year,
        AVG(avg_wage) AS avg_wage
    FROM t_pavol_medo_project_SQL_primary_final
    WHERE industry_name IS NOT NULL
    GROUP BY year
),
price_changes AS (
    SELECT
        f.year,
        f.avg_price_food,
        LAG(f.avg_price_food) OVER (ORDER BY f.year) AS prev_price_food
    FROM food_prices f
),
wage_changes AS (
    SELECT
        w.year,
        w.avg_wage,
        LAG(w.avg_wage) OVER (ORDER BY w.year) AS prev_wage
    FROM wages w
)
SELECT
    p.year,
    ROUND(((p.avg_price_food - p.prev_price_food)/p.prev_price_food)*100, 2) AS price_change_pct,
    ROUND(((w.avg_wage - w.prev_wage)/w.prev_wage)*100, 2) AS wage_change_pct,
    ROUND((((p.avg_price_food - p.prev_price_food)/p.prev_price_food) - ((w.avg_wage - w.prev_wage)/w.prev_wage))*100, 2) AS difference_pct,
    CASE
        WHEN (((p.avg_price_food - p.prev_price_food)/p.prev_price_food) - ((w.avg_wage - w.prev_wage)/w.prev_wage))*100 > 10 
        THEN 'ceny rostou výrazně rychleji než mzdy'
        ELSE 'bez výrazného rozdílu'
    END AS comment
FROM price_changes p
JOIN wage_changes w ON p.year = w.year
WHERE p.prev_price_food IS NOT NULL
ORDER BY p.year;