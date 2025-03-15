-- Database Creation
CREATE DATABASE ECommerceDB;
USE ECommerceDB;

-- Creating Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20),
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(255) NOT NULL,
    Category VARCHAR(100),
    Price DECIMAL(10,2) NOT NULL,
    Stock INT DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2),
    Status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- Creating OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT CHECK (Quantity > 0),
    SubTotal DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

-- Creating an Index for Faster Searches
CREATE INDEX idx_customer_email ON Customers(Email);
CREATE INDEX idx_product_category ON Products(Category);

-- Creating a View for Order Summaries
CREATE VIEW OrderSummary AS
SELECT o.OrderID, c.FirstName, c.LastName, o.OrderDate, o.TotalAmount, o.Status
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- Creating a Stored Procedure for Top Customers
DELIMITER //
CREATE PROCEDURE GetTopCustomers()
BEGIN
    SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpent
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID
    ORDER BY TotalSpent DESC
    LIMIT 5;
END //
DELIMITER ;

-- Creating a Trigger to Update Stock After Order
DELIMITER //
CREATE TRIGGER ReduceStockAfterOrder
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Products
    SET Stock = Stock - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END //
DELIMITER ;

-- Complex Query: Finding High-Value Customers and Their Recent Orders
SELECT c.CustomerID, c.FirstName, c.LastName, COUNT(o.OrderID) AS TotalOrders, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > (NOW() - INTERVAL 6 MONTH)
GROUP BY c.CustomerID
HAVING TotalSpent > 500;

-- CTE for Finding Most Popular Products
WITH PopularProducts AS (
    SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS TotalSold
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY p.ProductID
    HAVING TotalSold > 100
)
SELECT * FROM PopularProducts;
