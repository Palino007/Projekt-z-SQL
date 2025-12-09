WITH wages_per_year AS (
    SELECT year, ROUND(AVG(avg_wage), 2) AS avg_wage
    FROM t_pavol_medo_project_SQL_primary_final
    WHERE industry_name IS NOT NULL
    GROUP BY year
),
relevant_data AS (
    SELECT
        p.year,
        p.category_name,
        p.avg_price,
        w.avg_wage,
        ROUND(w.avg_wage / p.avg_price, 2) AS units
    FROM t_pavol_medo_project_SQL_primary_final p
    JOIN wages_per_year w
        ON p.year = w.year
    WHERE p.category_name IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
)
SELECT DISTINCT
    category_name,
    FIRST_VALUE(year) OVER (PARTITION BY category_name ORDER BY year ASC) AS first_year,
    FIRST_VALUE(avg_wage) OVER (PARTITION BY category_name ORDER BY year ASC) AS wage_first_year,
    FIRST_VALUE(avg_price) OVER (PARTITION BY category_name ORDER BY year ASC) AS price_first_year,
    FIRST_VALUE(units) OVER (PARTITION BY category_name ORDER BY year ASC) AS units_first_year,
    FIRST_VALUE(year) OVER (PARTITION BY category_name ORDER BY year DESC) AS last_year,
    FIRST_VALUE(avg_wage) OVER (PARTITION BY category_name ORDER BY year DESC) AS wage_last_year,
    FIRST_VALUE(avg_price) OVER (PARTITION BY category_name ORDER BY year DESC) AS price_last_year,
    FIRST_VALUE(units) OVER (PARTITION BY category_name ORDER BY year DESC) AS units_last_year
FROM relevant_data
ORDER BY category_name;