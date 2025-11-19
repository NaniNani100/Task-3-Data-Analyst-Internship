- Drop view if exists (to avoid errors when re-running)
DROP VIEW IF EXISTS customer_sales;

-- Create tables (use InnoDB so foreign keys work)
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    country VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) ENGINE=InnoDB;

-- Insert sample data (MySQL syntax: INSERT IGNORE)
INSERT IGNORE INTO customers (customer_id, customer_name, country) VALUES
(1, 'John', 'USA'),
(2, 'Priya', 'India'),
(3, 'Akira', 'Japan'),
(4, 'Sara', 'Canada');

INSERT IGNORE INTO orders (order_id, customer_id, order_date, amount) VALUES
(101, 1, '2023-10-10', 250.00),
(102, 2, '2023-10-11', 400.00),
(103, 3, '2023-10-12', 150.00),
(104, 1, '2023-10-12', 300.00),
(105, 2, '2023-10-13', 200.00);

-- 1. View all orders
SELECT * FROM orders;

-- 2. Filter + Sort
SELECT customer_id, amount
FROM orders
WHERE amount > 200
ORDER BY amount DESC;

-- 3. Group by + Sum
SELECT customer_id, SUM(amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- 4. Inner Join
SELECT c.customer_name, o.order_id, o.amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- 5. Left Join
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 6. Subquery (above average)
SELECT order_id, amount
FROM orders
WHERE amount > (SELECT AVG(amount) FROM orders);

-- 7. Create View
CREATE VIEW customer_sales AS
SELECT c.customer_name, SUM(o.amount) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- 8. Select from View
SELECT * FROM customer_sales;
