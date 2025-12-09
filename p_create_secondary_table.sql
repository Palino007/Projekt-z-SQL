CREATE TABLE t_pavol_medo_project_SQL_secondary_final AS
SELECT
    c.country AS country_name,
    e.year,
    ROUND(e.gdp::numeric / 1000000, 2) AS gdp_million,
    e.gini,
    e.population
FROM countries c
JOIN economies e
    ON c.country = e.country
WHERE e.year IN (
    SELECT DISTINCT year
    FROM t_pavol_medo_project_SQL_primary_final
)
ORDER BY c.country, e.year;

