-- 1. Recursive CTE: Organization Hierarchy
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT EmployeeID, ManagerID, EmployeeName, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL  
    UNION ALL
    SELECT e.EmployeeID, e.ManagerID, e.EmployeeName, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy ORDER BY Level, EmployeeID;

-- 2. Window Functions: Running Total and Rank
SELECT ProductID, SaleDate, Amount,
       SUM(Amount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS RunningTotal,
       RANK() OVER (ORDER BY SUM(Amount) OVER (PARTITION BY ProductID) DESC) AS ProductRank
FROM Sales;

-- 3. JSON Parsing (PostgreSQL / MySQL / SQL Server)
SELECT 
    OrderID, 
    OrderDetails->>'customer' AS CustomerName,  
    OrderDetails->'items'->0->>'product' AS FirstProduct
FROM Orders;

-- 4. Pivoting Data (SQL Server / PostgreSQL)
SELECT * FROM (
    SELECT Region, Year, Sales FROM SalesData
) AS SourceTable
PIVOT (
    SUM(Sales) FOR Year IN ([2023], [2024], [2025])
) AS PivotTable;

-- 5. Lateral Join: Top 2 Products Per Category (PostgreSQL / Snowflake)
SELECT Category, ProductName, Revenue
FROM Categories c
CROSS JOIN LATERAL (
    SELECT ProductName, Revenue
    FROM Products p
    WHERE p.CategoryID = c.CategoryID
    ORDER BY Revenue DESC
    LIMIT 2
) AS TopProducts;

-- 6. Deduplication Using Window Functions
WITH RankedUsers AS (
    SELECT UserID, Email, CreatedAt,
           ROW_NUMBER() OVER (PARTITION BY UserID ORDER BY CreatedAt DESC) AS RowNum
    FROM Users
)
DELETE FROM Users WHERE RowNum > 1;

-- 7. Indexing Strategy: Finding Unused Indexes (PostgreSQL)
SELECT relname AS TableName, indexrelname AS IndexName, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
WHERE idx_scan = 0;

-- 8. Materialized Views: Refresh Strategy (PostgreSQL)
CREATE MATERIALIZED VIEW SalesSummary AS
SELECT ProductID, SUM(Amount) AS TotalSales, COUNT(*) AS SaleCount
FROM Sales
GROUP BY ProductID;

REFRESH MATERIALIZED VIEW SalesSummary;

-- 9. Graph Query: Finding Shortest Paths (PostgreSQL with pgRouting)
SELECT * FROM pgr_dijkstra(
    'SELECT id, source, target, cost FROM roads',
    1, -- Start Node
    10, -- End Node
    FALSE
);

-- 10. Common Table Expressions (CTEs) with Multiple Levels
WITH CTE1 AS (
    SELECT EmployeeID, Salary FROM Employees WHERE Salary > 50000
),
CTE2 AS (
    SELECT EmployeeID, Salary, Salary * 1.1 AS AdjustedSalary FROM CTE1
)
SELECT * FROM CTE2;
