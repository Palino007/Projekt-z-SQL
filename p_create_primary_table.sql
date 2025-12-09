CREATE TABLE t_pavol_medo_project_SQL_primary_final AS
WITH common_years AS (
    SELECT DISTINCT EXTRACT(YEAR FROM p.date_from)::int AS year
    FROM czechia_price p
    JOIN czechia_payroll w
      ON EXTRACT(YEAR FROM p.date_from)::int = w.payroll_year
)
SELECT *
FROM (
    SELECT
        w.payroll_year AS year,
        i.name AS industry_name,
        ROUND(AVG(w.value)::numeric, 2) AS avg_wage,
        NULL::varchar AS category_name,
        NULL::numeric AS avg_price,
        NULL::numeric AS units
    FROM czechia_payroll w
    JOIN czechia_payroll_industry_branch i
        ON w.industry_branch_code = i.code
    WHERE w.value_type_code = 5958
      AND w.calculation_code = 200
      AND w.unit_code = 200
      AND w.payroll_year IN (SELECT year FROM common_years)
    GROUP BY w.payroll_year, i.name
    UNION ALL
    SELECT
        EXTRACT(YEAR FROM p.date_from)::int AS year,
        NULL::varchar AS industry_name,
        NULL::numeric AS avg_wage,
        pc.name AS category_name,
        ROUND(AVG(p.value)::numeric, 2) AS avg_price,
        ROUND(AVG(p.value)::numeric / w.avg_wage, 2) AS units
    FROM czechia_price p
    JOIN czechia_price_category pc
        ON p.category_code = pc.code
    JOIN (
        SELECT payroll_year, ROUND(AVG(value)::numeric, 2) AS avg_wage
        FROM czechia_payroll
        WHERE value_type_code = 5958
          AND calculation_code = 200
          AND unit_code = 200
        GROUP BY payroll_year
    ) w
        ON EXTRACT(YEAR FROM p.date_from)::int = w.payroll_year
    WHERE p.region_code IS NOT NULL
      AND EXTRACT(YEAR FROM p.date_from)::int IN (SELECT year FROM common_years)
    GROUP BY EXTRACT(YEAR FROM p.date_from), pc.name, pc.price_unit, w.avg_wage
) final
ORDER BY year, industry_name, category_name;

