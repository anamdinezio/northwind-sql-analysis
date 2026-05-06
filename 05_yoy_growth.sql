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
        YEAR(o.OrderDate) AS [Year],
        SUM(od.UnitPrice * od.Quantity) AS Revenue

    FROM Orders o
        INNER JOIN [Order Details] od ON o.OrderID = od.OrderID

    GROUP BY
        YEAR(o.OrderDate)
)

SELECT
    [Year],
    FORMAT(Revenue, 'N2') AS YearlyRevenue,

    -- Previous year revenue
    FORMAT(LAG(Revenue) OVER (ORDER BY [Year]), 'N2') AS PrevYearRevenue,

    -- Absolute growth
    FORMAT(Revenue - LAG(Revenue) OVER (ORDER BY [Year]), 'N2') AS YoYDifference,

    -- Growth percentage
    FORMAT(
        (Revenue / NULLIF(LAG(Revenue) OVER (ORDER BY [Year]), 0)) - 1, 'P1') AS YoYGrowth

FROM YearlyRevenue

ORDER BY [Year]