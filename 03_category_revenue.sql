
-- ============================================================
-- 03_category_revenue.sql
-- Business Question: Which product categories generate the most
--                    revenue? How does each product rank within
--                    its category?
-- Skills: INNER JOIN (3 tables), GROUP BY, RANK() with 
--         PARTITION BY, CTE, FORMAT
-- Database: Northwind | Author: Ana Dinezio | Date: 2026
-- ============================================================

WITH CategoryRevenue AS (
	SELECT 
		c.CategoryName, 
		p.ProductName,
		SUM(od.UnitPrice * od.Quantity) AS Revenue,
		COUNT(DISTINCT OrderID) AS TimesSold

	FROM  Products p
		INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
		INNER JOIN Categories c ON p.CategoryID = c.CategoryID

	GROUP BY 
		c.CategoryName, 
		p.ProductName
	)

SELECT 
	CategoryName, 
	ProductName,
	FORMAT(Revenue, 'N2') AS Revenue,
	TimesSold,
	RANK() OVER(PARTITION BY CategoryName ORDER BY Revenue DESC) AS RankInCategory

FROM CategoryRevenue
ORDER BY Revenue DESC