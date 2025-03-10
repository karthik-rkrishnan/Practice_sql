/* SQL Practice Queries Document
 Author: Karthik Radhakrishnan
 Description: A comprehensive SQL practice document with queries covering various topics from basics to advanced concepts
*/

 1. Create Sample Tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    SignupDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

 2. Basic Queries
SELECT * FROM Customers;
SELECT Name, Email FROM Customers WHERE City = 'New York';
INSERT INTO Customers VALUES (1, 'John Doe', 'john@example.com', 'Los Angeles', '2023-01-15');
UPDATE Customers SET City = 'San Francisco' WHERE CustomerID = 1;
DELETE FROM Customers WHERE CustomerID = 1;

 3. Joins
SELECT Customers.Name, Orders.OrderID, Orders.TotalAmount 
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

SELECT Customers.Name, Orders.OrderID, Orders.TotalAmount 
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

 4. Aggregations
SELECT City, COUNT(CustomerID) AS TotalCustomers 
FROM Customers
GROUP BY City;

SELECT ProductID, SUM(Quantity) AS TotalSold 
FROM OrderDetails
GROUP BY ProductID
HAVING SUM(Quantity) > 100;

 5. Subqueries
SELECT Name FROM Customers 
WHERE CustomerID IN (SELECT CustomerID FROM Orders WHERE TotalAmount > 500);

 6. Common Table Expressions (CTEs)
WITH HighValueOrders AS (
    SELECT OrderID, CustomerID, TotalAmount 
    FROM Orders 
    WHERE TotalAmount > 1000
)
SELECT * FROM HighValueOrders;

 7. Window Functions
SELECT CustomerID, OrderID, TotalAmount, 
       RANK() OVER (PARTITION BY CustomerID ORDER BY TotalAmount DESC) AS Rank
FROM Orders;

 8. Stored Procedure
DELIMITER //
CREATE PROCEDURE GetCustomerOrders(IN CustID INT)
BEGIN
    SELECT * FROM Orders WHERE CustomerID = CustID;
END //
DELIMITER ;

 9. Indexing for Performance
CREATE INDEX idx_customer_city ON Customers(City);
CREATE INDEX idx_order_customer ON Orders(CustomerID);

 10. Triggers
DELIMITER //
CREATE TRIGGER BeforeOrderInsert 
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.TotalAmount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TotalAmount cannot be negative';
    END IF;
END //
DELIMITER ;

 11. Advanced Queries & Performance Optimization
 Fetch the top 5 customers who have spent the most
SELECT CustomerID, SUM(TotalAmount) AS TotalSpent 
FROM Orders
GROUP BY CustomerID
ORDER BY TotalSpent DESC
LIMIT 5;

 Find customers who placed orders in the last 6 months
SELECT Name, Email FROM Customers
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID FROM Orders
    WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);

 Get monthly revenue trends
SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, SUM(TotalAmount) AS Revenue
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year DESC, Month DESC;

 Using Recursive CTE for hierarchical data (e.g., employee-manager relationships)
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT EmployeeID, ManagerID, Name, 1 AS Level
    FROM Employees WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.ManagerID, e.Name, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy;

 Simulating Row-Level Security using Views
CREATE VIEW CustomerOrderSummary AS
SELECT c.Name, c.Email, o.OrderID, o.TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > 500;

 More Window Functions
SELECT CustomerID, OrderID, TotalAmount, 
       SUM(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningTotal,
       AVG(TotalAmount) OVER (PARTITION BY CustomerID) AS AvgOrderValue
FROM Orders;

 Stored Procedure for inserting new orders
DELIMITER //
CREATE PROCEDURE InsertNewOrder(IN CustID INT, IN OrderAmt DECIMAL(10,2))
BEGIN
    INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
    VALUES (CustID, CURDATE(), OrderAmt);
END //
DELIMITER ;
