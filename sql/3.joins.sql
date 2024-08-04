USE scalerDB;

-- Example of Cross JOIN (without ON condition)
-- Every row gets joined with every other row of the other table
SELECT * 
FROM students 
JOIN batches;

-- Example of Join
SELECT CONCAT(first_name," ",last_name) AS "Full Name",batch_name, s.batch_id 
FROM students s
JOIN batches b
ON s.batch_id = b.batch_id;

-- 07:26:12	SELECT CONCAT(first_name," ",last_name) AS "Full Name",batch_name, batch_id  FROM students s JOIN batches b ON s.batch_id = b.batch_id	Error Code: 1052. Column 'batch_id' in field list is ambiguous	0.0014 sec

-- Todo: Show just the batch_name where student first_name is Satyam
SELECT first_name,last_name,batch_name 
FROM students s
JOIN batches b
ON s.batch_id = b.batch_id
WHERE s.first_name = "Satyam";

-- Another Way - Faster!
SELECT first_name,last_name,batch_name 
FROM students s
JOIN batches b
ON s.first_name = "Satyam" AND s.batch_id = b.batch_id;

-- Todo: Print all students who belong to SQL batch.
SELECT first_name,last_name,batch_name 
FROM students s
JOIN batches b
ON s.batch_id = b.batch_id
WHERE b.batch_name = "SQL";

-- Another Way - Faster!
SELECT first_name,last_name,batch_name 
FROM students s
JOIN batches b
ON b.batch_name = "SQL" AND s.batch_id = b.batch_id;

-- Order of Joining Two Tables DOESN't Matter!
SELECT first_name,batch_name 
FROM batches b
JOIN students s
ON  b.batch_id = s.batch_id;

SELECT first_name,batch_name
FROM students s
JOIN batches b
ON  b.batch_id = s.batch_id;

-- 8.05 AM (10 Min Break) 
-- Download : https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/
USE classicmodels;

SELECT * 
FROM employees;

-- Query to show every employee, jobTitle along with its manager name, manger Job Title.alter
SELECT CONCAT(emp.lastName," ",emp.firstName) AS "EmployeeName",emp.jobTitle, CONCAT(mgr.lastName," ",mgr.firstName) AS "ManagerName",mgr.jobTitle AS "ManagerJob" 
FROM employees emp 
JOIN employees mgr 
ON emp.reportsTo = mgr.employeeNumber;


-- PRACTICE PROBLEMS on Sakila Database
-- Todo 1 : Sakila Database (Film Table)
-- For every film name all the films that were release in the range +- 2 years from the current film, 
-- and there rental rate was more than the rental rate of current film 

SELECT f1.title,f1.release_year, f1.rental_rate, f2.title,f2.release_year, f2.rental_rate
FROM film f1 
JOIN film f2 
ON f2.release_year BETWEEN f1.release_year - 2 AND f1.release_year + 2 
AND f2.rental_rate > f1.rental_rate;

-- Todo
-- PRACTICE PROBLEMS on Classic Models DB
-- Todo 2: Show all orders From France along with customer information
-- Sort orders according to date (latest orders first)alter
SELECT o.*,c.customerName,c.country
FROM orders o
JOIN customers c
ON c.country = "France" AND o.customerNumber = c.customerNumber
ORDER BY orderDate DESC;


-- Homework: Sakila Database
-- Show each actor with film(s) they have done 
-- Deepika,f1
-- Deepika, f7 
-- Sharukhan, f8

SELECT a.* , f.*
FROM film_actor fa 
JOIN actor a 
ON fa.actor_id = a.actor_id
JOIN film f
ON fa.film_id = f.film_id;

-- LEFT Outer Join
SELECT * 
FROM students s
LEFT JOIN batches b 
ON s.batch_id = b.batch_id;

-- RIGHT Outer Join
SELECT * 
FROM students s
RIGHT JOIN batches b 
ON s.batch_id = b.batch_id;

-- CROSS JOIN (Cross keyword is optional)
SELECT * 
FROM students
JOIN batches;

-- USING Keyword
SELECT * 
FROM students s
JOIN batches b 
USING (batch_id);

-- NATURAL JOIN (inner join based upon batch_id since 'batch_id' is the only column that is same in both)
SELECT * 
FROM students s 
NATURAL JOIN batches; 

-- Implicit JOIN (same as cross join)
SELECT * 
FROM students s, batches b;

-- Implicit JOIN (then filter using where) [SLOW --> Bigger Table because of cross join and then you are filtering]

-- smaller table 
SELECT * 
FROM students s
JOIN batches b
USING (batch_id);


-- bigger table and then filtering
SELECT * 
FROM students s, batches b
WHERE s.batch_id = b.batch_id;

SELECT * 
FROM students s
JOIN batches b
WHERE s.batch_id = b.batch_id;

-- UNION  data 
USE classicmodels;

SELECT customerName AS "Name", phone  AS "Contact Info"
FROM customers
UNION
SELECT CONCAT(firstName," ",lastName), email 
FROM employees
UNION
SELECT CONCAT(lastName," ",firstName), email 
FROM employees;


