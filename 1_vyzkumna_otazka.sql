WITH wage_changes AS (
    SELECT
        industry_name,
        year,
        avg_wage,
        avg_wage - LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY year) AS wage_change
    FROM t_pavol_medo_project_SQL_primary_final
    WHERE industry_name IS NOT NULL
),
summary AS (
    SELECT
        industry_name,
        ROUND(AVG(wage_change), 2) AS avg_yearly_change,
        CASE
            WHEN AVG(wage_change) > 0 THEN 'rostou'
            WHEN AVG(wage_change) < 0 THEN 'klesají'
            ELSE 'stagnují'
        END AS overall_trend
    FROM wage_changes
    GROUP BY industry_name
),
decrease_details AS (
    SELECT
        industry_name,
        year AS decrease_year,
        ROUND(wage_change, 2) AS decrease_amount
    FROM wage_changes
    WHERE wage_change < 0
)
SELECT
    s.industry_name,
    s.avg_yearly_change,
    s.overall_trend,
    d.decrease_year,
    d.decrease_amount
FROM summary s
LEFT JOIN decrease_details d
    ON s.industry_name = d.industry_name
ORDER BY s.industry_name, d.decrease_year;