-- ============================================================
-- 01_top_customers.sql
-- Business Question: Who are the top 10 customers by revenue?
-- Skills: INNER JOIN (3 tables), GROUP BY, aggregate functions,
--         FORMAT, ORDER BY
-- Database: Northwind | Author: Ana Dinezio | Date: 2026
-- ============================================================


SELECT TOP 10
    c.CustomerID,
    c.CompanyName,
    c.Country,
    FORMAT(SUM(od.UnitPrice * od.Quantity), 'N2') AS TotalRevenue,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    FORMAT(SUM(od.UnitPrice * od.Quantity)  / COUNT(DISTINCT o.OrderID), 'N2') AS AvgOrderValue

FROM Orders o
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID

GROUP BY
    c.CustomerID,
    c.CompanyName,
    c.Country

ORDER BY SUM(od.UnitPrice * od.Quantity) DESC