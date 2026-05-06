-- ============================================================
-- 05_yoy_growth.sql
-- Business Question: How does revenue grow year over year?
--                    Is the business accelerating or slowing?
-- Skills: CTE, INNER JOIN, GROUP BY, YEAR(), LAG(),
--         time intelligence, FORMAT, NULLIF
-- Database: Northwind | Author: Ana Dinezio | Date: 2026
-- ============================================================

WITH YearlyRevenue AS (
    SELECT
