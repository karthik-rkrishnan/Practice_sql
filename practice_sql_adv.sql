Basic SQL Queries
SELECT * FROM employees;
SELECT name, age FROM customers WHERE age > 30;
SELECT DISTINCT department FROM employees;
SELECT COUNT(*) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT department, AVG(salary) FROM employees GROUP BY department;
SELECT * FROM orders WHERE order_date >= '2024-01-01';
SELECT product_name, price FROM products ORDER BY price DESC;
SELECT * FROM customers WHERE city = 'New York';

 Sorting and Filtering
SELECT * FROM orders ORDER BY order_date DESC;
SELECT * FROM products WHERE price BETWEEN 100 AND 500;
SELECT * FROM sales WHERE quantity > 10 ORDER BY quantity DESC;
SELECT * FROM employees WHERE hire_date > '2020-01-01';
SELECT * FROM customers WHERE country = 'USA' ORDER BY name ASC;
SELECT * FROM orders WHERE status = 'Completed' AND amount > 500;
SELECT * FROM products WHERE stock_quantity < 20 ORDER BY stock_quantity ASC;
SELECT * FROM suppliers WHERE rating >= 4.5;

 Joins
SELECT employees.name, departments.dept_name FROM employees INNER JOIN departments ON employees.dept_id = departments.dept_id;
SELECT customers.name, orders.order_date FROM customers LEFT JOIN orders ON customers.id = orders.customer_id;
SELECT products.product_name, categories.category_name FROM products RIGHT JOIN categories ON products.category_id = categories.id;
SELECT employees.name, salaries.amount FROM employees FULL JOIN salaries ON employees.id = salaries.emp_id;
SELECT orders.order_id, customers.name FROM orders INNER JOIN customers ON orders.customer_id = customers.id WHERE orders.amount > 1000;

 Aggregations
SELECT department, COUNT(*) FROM employees GROUP BY department;
SELECT product_id, SUM(quantity) FROM sales GROUP BY product_id HAVING SUM(quantity) > 100;
SELECT supplier_id, AVG(price) FROM products GROUP BY supplier_id;
SELECT category_id, COUNT(*) FROM products GROUP BY category_id ORDER BY COUNT(*) DESC;
SELECT country, SUM(sales) FROM orders GROUP BY country HAVING SUM(sales) > 50000;

 Subqueries
SELECT name FROM customers WHERE id IN (SELECT customer_id FROM orders WHERE amount > 500);
SELECT name, salary FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);
SELECT product_name FROM products WHERE price > (SELECT MAX(price) FROM products WHERE category_id = 2);
SELECT order_id FROM orders WHERE customer_id IN (SELECT id FROM customers WHERE country = 'Canada');

 Common Table Expressions (CTEs)
WITH high_salary AS (
    SELECT * FROM employees WHERE salary > 70000
) SELECT * FROM high_salary;
WITH avg_salary AS (
    SELECT department, AVG(salary) as avg_salary FROM employees GROUP BY department
) SELECT * FROM avg_salary WHERE avg_salary > 60000;

 Window Functions
SELECT name, department, salary, RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank FROM employees;
SELECT name, salary, SUM(salary) OVER (PARTITION BY department) AS dept_salary FROM employees;
SELECT order_id, amount, ROW_NUMBER() OVER (ORDER BY amount DESC) AS row_num FROM orders;

 Stored Procedure Example
DELIMITER //
CREATE PROCEDURE GetHighSalaryEmployees()
BEGIN
    SELECT * FROM employees WHERE salary > 80000;
END //
DELIMITER ;

 Indexing for Performance
CREATE INDEX idx_employee_name ON employees(name);
CREATE INDEX idx_order_date ON orders(order_date);
CREATE INDEX idx_product_price ON products(price);

 Transactions
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
ROLLBACK;

 Advanced Queries
SELECT e.name, d.dept_name, COUNT(p.project_id) AS project_count FROM employees e LEFT JOIN projects p ON e.emp_id = p.emp_id INNER JOIN departments d ON e.dept_id = d.dept_id GROUP BY e.name, d.dept_name;
SELECT c.name, COUNT(o.order_id) FROM customers c LEFT JOIN orders o ON c.id = o.customer_id GROUP BY c.name HAVING COUNT(o.order_id) > 5;

 JSON Handling (MySQL 5.7+)
SELECT json_extract(details, '$.address.city') FROM customers;
SELECT name, details->'$.phone' AS phone_number FROM users;

 Full-Text Search
SELECT * FROM articles WHERE MATCH(title, body) AGAINST('database' IN NATURAL LANGUAGE MODE);
SELECT * FROM posts WHERE MATCH(content) AGAINST('SQL optimization' IN BOOLEAN MODE);

 Recursive CTE Example
WITH RECURSIVE employee_hierarchy AS (
    SELECT emp_id, name, manager_id FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.name, e.manager_id FROM employees e INNER JOIN employee_hierarchy eh ON e.manager_id = eh.emp_id
) SELECT * FROM employee_hierarchy;

