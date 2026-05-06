-- ============================================================
-- 02_employee_performance.sql
-- Business Question: Which employees drive the most revenue?
--                    What % of total company revenue does each
--                    employee represent?
-- Skills: CTEs (x2), INNER JOIN (3 tables), GROUP BY,
--         CROSS JOIN, window functions (RANK), FORMAT
-- Database: Northwind | Author: Ana Dinezio | Date: 2026
-- ============================================================

-- CTE 1: Revenue per employee

WITH EmployeeRevenue AS (
	SELECT 
		e.employeeID,
		e.FirstName, 
		e.LastName, 
		SUM(od.UnitPrice * od.Quantity) AS Revenue,
		COUNT(DISTINCT o.OrderID) AS CountOrders

	FROM Orders o
		INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
		INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID

	GROUP BY e.employeeID, e.FirstName, e.LastName
	),

-- CTE 2: Total revenue to calculate employee contribution to total revenue in %

	CompanyRevenue AS (
	SELECT SUM(UnitPrice * Quantity) AS TotalRevenue
	FROM [Order Details]
	)
	
SELECT 
	er.EmployeeID,
	er.FirstName + ' ' + er.LastName AS EmployeeName, 
	er.CountOrders,
	FORMAT( er.Revenue, 'N2') AS Revenue,
	FORMAT( er.Revenue / cr.TotalRevenue, 'P2') AS RevenueShare,
	RANK() OVER(ORDER BY er.Revenue DESC) as Ranking

FROM EmployeeRevenue er
	CROSS JOIN CompanyRevenue cr

