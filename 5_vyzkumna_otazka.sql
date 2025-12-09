WITH cr_data AS (
    SELECT 
        s.year,
        ROUND(s.gdp_million, 2) AS gdp_million,
        ROUND(AVG(p.avg_wage), 2) AS avg_wage,
        ROUND(AVG(p.avg_price), 2) AS avg_price
    FROM t_pavol_medo_project_SQL_secondary_final s
    JOIN t_pavol_medo_project_SQL_primary_final p
        ON s.year = p.year
    WHERE s.country_name = 'Czech Republic'
    GROUP BY s.year, s.gdp_million
),
yearly_change AS (
    SELECT
        year,
        gdp_million,
        avg_wage,
        avg_price,
        avg_wage - LAG(avg_wage) OVER (ORDER BY year) AS wage_change,
        avg_price - LAG(avg_price) OVER (ORDER BY year) AS price_change,
        CASE WHEN LAG(avg_wage) OVER (ORDER BY year) IS NOT NULL 
             THEN ROUND(100 * (avg_wage - LAG(avg_wage) OVER (ORDER BY year)) / LAG(avg_wage) OVER (ORDER BY year), 2)
             ELSE NULL
        END AS wage_change_pct,
        CASE WHEN LAG(avg_price) OVER (ORDER BY year) IS NOT NULL 
             THEN ROUND(100 * (avg_price - LAG(avg_price) OVER (ORDER BY year)) / LAG(avg_price) OVER (ORDER BY year), 2)
             ELSE NULL
        END AS price_change_pct,
        gdp_million - LAG(gdp_million) OVER (ORDER BY year) AS gdp_change
    FROM cr_data
)
SELECT
    year,
    gdp_million,
    ROUND(gdp_change, 2) AS gdp_change_million,
    avg_wage,
    ROUND(wage_change, 2) AS wage_change,
    wage_change_pct,
    CASE 
        WHEN wage_change > 0 THEN 'Mzdy rostly'
        WHEN wage_change < 0 THEN 'Mzdy klesaly'
        ELSE NULL
    END AS wage_comment,
    avg_price,
    ROUND(price_change, 2) AS price_change,
    price_change_pct,
    CASE 
        WHEN price_change > 0 THEN 'Ceny potravin rostly'
        WHEN price_change < 0 THEN 'Ceny potravin klesaly'
        ELSE NULL
    END AS price_comment
FROM yearly_change
ORDER BY year;