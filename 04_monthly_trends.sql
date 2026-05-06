-- ============================================================
-- 04_monthly_trends.sql
-- Business Question: What does monthly revenue look like?
--                    How is the business trending over time?
-- Skills: CTE, INNER JOIN, GROUP BY, YEAR(), MONTH(),
--         window functions (SUM OVER for running total,
--         LAG for month over month change), FORMAT
-- Database: Northwind | Author: Ana Dinezio | Date: 2026
-- ============================================================

WITH MonthlyRevenue AS (
	SELECT 
		YEAR(o.OrderDate) AS [Year],
		MONTH(o.OrderDate) AS [Month],
		SUM(od.UnitPrice * od.Quantity) AS MonthRevenue

	FROM Orders o
		INNER JOIN [Order Details] od ON o.OrderID = od.OrderID

	GROUP BY 
		YEAR(o.OrderDate),
		MONTH(o.OrderDate)
	)

SELECT 
	[Year],
	[Month],
	FORMAT(MonthRevenue, 'N2') AS MonthlyRevenue,
	-- Running total revenue, cummulative revenue
	FORMAT(SUM(MonthRevenue) OVER(ORDER BY [Year],[Month]), 'N2') AS RunningTotal,

	-- Previous month revenue
	FORMAT(LAG(MonthRevenue) OVER(ORDER BY [Year],[Month]), 'N2')  AS PrevMonthRevenue,

	-- MoM difference
	FORMAT(MonthRevenue - LAG(MonthRevenue) OVER(ORDER BY [Year],[Month]), 'N2') AS MoMDifference,

	-- MoM growth %
	FORMAT(MonthRevenue / NULLIF(LAG(MonthRevenue) OVER(ORDER BY [Year],[Month]),0) -1, 'P2') AS MoMGrowth

FROM MonthlyRevenue

ORDER BY [Year], [Month]