-- Topics 
-- Sakila Database
-- CRUD Operations 
		-- Create DB, Create Table (done)
		-- Insert Rows 
    -- READ 
		-- Select 
		-- Distinct 
		-- Where 
		-- AS 
		-- AND, OR, NOT 
        -- IN Operator 
        -- More Concept (next classes)
	-- Update and Delete (next class) 
    
USE sakila;
-- Sakila DB: Online DVD Rental Store
INSERT INTO payment(customer_id, staff_id,amount,payment_date) 
VALUES 
(500,2,300, '2023-05-04 00:54:12'),
(400,2,300, '2023-05-04 00:54:12'),
(312,2,300, '2023-05-04 00:54:12');

-- Payments View
SELECT * 
FROM payment;

-- 07:23:32	INSERT INTO payment(customer_id, staff_id,amount,payment_date)  VALUES  (500,2,300, '2024-05-04 00:54:12'), (800,2,300, '2024-05-04 00:54:12'), (700,2,300, '2024-05-04 00:54:12')	Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`sakila`.`payment`, CONSTRAINT `fk_payment_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE)	0.018 sec
SELECT customer_id 
FROM customer;

-- Insert Something Into "film" Table 
INSERT INTO film (title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, special_features) 
VALUES ('Tiger3', 'Batman fights the Joker', 2008, 1, 3, 4.99, 152, 19.99,  'Trailers'),
       ('RRR', 'Batman fights Bane', 2012, 1, 3, 4.99, 165, 19.99, 'Trailers'),
       ('DDLJ', 'Batman fights Superman', 2016, 1, 3, 4.99, 152, 19.99,'Trailers');
       

SELECT * 
FROM film
ORDER BY film_id DESC
LIMIT 3;

-- READ 
-- Select few columns
SELECT title AS movie, description, ROUND(length/60,2) AS duration, rating 
FROM film;

-- Select = Printing
-- Homework: Look around inbuilt mathematical functions 
SELECT "Hello World", ROUND(5/3, 2);

-- DISTINCT Values 
SELECT DISTINCT rating 
FROM film;

SELECT DISTINCT release_year
FROM film;

-- More columns with distinct
SELECT DISTINCT rating, release_year
FROM film;

-- More columns with distinct
SELECT DISTINCT rating, release_year,film_id  AS Id
FROM film;

-- Show films which have got rating 'G'
-- WHERE Clause 

SELECT * 
FROM film 
WHERE rating = 'G';

-- filtering out rows, eliminating duplicates, and then you print 
SELECT DISTINCT rating 
FROM film 
WHERE release_year = 2012;̀

SELECT * 
FROM film;


SELECT DISTINCT rating
FROM film 
WHERE release_year = 2012;

-- AND, OR, NOT 
SELECT title, length, release_year
FROM film 
WHERE release_year = 2006 AND length > 100;

SELECT title, length, release_year
FROM film 
WHERE release_year = 2006 OR length > 100;


-- NOT 
SELECT title, length, release_year
FROM film 
WHERE release_year != 2006;

-- NOT 
SELECT title, length, release_year
FROM film 
WHERE release_year <> 2006;

-- NOT 
SELECT title, length, release_year
FROM film 
WHERE NOT release_year = 2006;


-- movies where release_year !=2006 and length <= 100
SELECT title, length, release_year
FROM film 
WHERE NOT (release_year = 2006 OR length > 100);

SELECT title, length, release_year
FROM film 
WHERE NOT release_year = 2006 AND NOT length > 100;

-- IN Operator 
-- SELECT movies which have got G, PG, PG-13 rating
SELECT * 
FROM FILM 
WHERE rating='G' OR rating='PG' OR rating='PG-13';

SELECT * 
FROM FILM 
WHERE rating IN ('G','PG','PG-13');

-- More Doubt : Copy data from one table to another ?
CREATE TABLE film_copy(
	title VARCHAR(50),
    description VARCHAR(200)
);

-- film_copy (assume tables exists) 
INSERT INTO film_copy(title,description)
SELECT title,description 
FROM film;

SELECT * 
FROM film 
WHERE release_year BETWEEN 2010 AND 2020;

-- the comparison is case insensitive for strings
SELECT * 
FROM film 
WHERE title BETWEEN "bat" AND "cat";

-- timestamp 
SELECT * 
FROM film 
WHERE last_update BETWEEN '2020-02-15' AND '2025-02-15';

-- LIKE Operator 
-- words ending with man or just man
SELECT * 
FROM film 
WHERE description LIKE "%man %" OR description LIKE "% man %";

-- REGEXP 
SELECT * 
FROM film 
WHERE description REGEXP "man$";

-- Finding out rows with NULL Values for address2
SELECT * 
FROM address
WHERE address2 IS NULL;

-- ORDER BY (Sort the records) 
-- Filtering (WHERE) --> Sorting (ORDER) --> Printing
SELECT title,release_year
FROM film 
WHERE rating = 'G'
ORDER BY release_year ASC, title DESC;

SELECT title,release_year, last_update
FROM film 
WHERE rating = 'G'
ORDER BY last_update DESC;

-- Limit and Offset 
SELECT film_id,title,length,release_year 
FROM film 
ORDER BY length DESC
LIMIT 10;

SELECT film_id,title,length,release_year 
FROM film 
ORDER BY length DESC
LIMIT 10 OFFSET 10;

-- skip the first 20 records, give the next 100 records
SELECT film_id,title,length,release_year 
FROM film 
ORDER BY length DESC
LIMIT 100 OFFSET 20;


-- Updates (updates to data, changing the value)
UPDATE film 
SET description = "An awesome movie"
WHERE film_id = 1;

-- Update multiple columns in one go 
UPDATE film
SET rating = 'PG-13',
release_year = 2024
WHERE film_id = 1;

SELECT * 
FROM film;

-- TODO: Play with ALTER Command (HomeWork) 
-- ALTER (Changing the table structure -> Add a colm, delete a column, rename the table, add a primary key ...) 

SELECT batch_id,instructor,batch_name 
FROM batches;

-- Add a instructor col with every batch 
ALTER TABLE batches ADD instructor VARCHAR(100);

-- updating a values in a one or more columns column 
UPDATE batches 
SET instructor = "Deepak"
WHERE batch_id IN (3);

-- dropping a column 
ALTER TABLE batches DROP COLUMN instructor;


-- Deletion (use delete along with WHERE clause)
DELETE FROM batches
WHERE batch_id = 1;



-- 08:35:06	DELETE FROM batches	Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`scalerdb`.`students`, CONSTRAINT `students_ibfk_1` FOREIGN KEY (`batch_id`) REFERENCES `batches` (`batch_id`) ON DELETE RESTRICT ON UPDATE CASCADE)	0.0035 sec
SELECT * 
FROM batches;

-- Delete all the rows of the table  (Delete the data + but empty table still exists)
TRUNCATE students;

SELECT
* FROM students;

-- DROP (Delete data + table structure)

DROP TABLE students;

SELECT * 
FROM batches;

-- Delete : specify set of rows, delete all rows , rollback is possible 

-- Truncate : delete all the rows, truncate is faster (it simply DROPs the table and re-creates the structure), No rollback
-- Drop : destroy the table (including the structure), No Rollback is possible


-- DOUBTS 
-- ENUM DEMO
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    product_type ENUM('electronic', 'furniture', 'clothing', 'food', 'book')
);

INSERT INTO products (name, product_type) VALUES
(1,'Laptop', 'electronic'),
(2,'Chair', 'furniture'),
(3,'T-shirt', 'clothing'),
(4,'Chocolate', 'food'),
(5,'Novel', 'book');

SELECT * 
FROM products 
WHERE product_type = "book";

-- Remove Primary Key using the Alter COmmand 
ALTER TABLE products DROP PRIMARY KEY;


-- Alter Demo 
USE scalerDB;
ALTER TABLE batches RENAME TO scalerBatches;
ALTER TABLE scalerBatches ADD instructor VARCHAR(200);
SELECT * FROM 
scalerBatches;

