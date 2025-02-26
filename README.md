# Library Management System using SQL Project

## Project Overview

**Project Title**: Library Management System  
**Database**: `library_management_system_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/Cod-Bibek/EDA-On-Library-Management-System/blob/main/library.jpeg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branch, employee, members, book, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/Cod-Bibek/EDA-On-Library-Management-System/blob/main/ERD%20Of%20LMS.png)

- **Database Creation**: Created a database named `library_management_db`.
- **Table Creation**: Created tables for branch, employee, members, book, issued status, and return status. Each table includes relevant columns and relationships.

```sql
-- Project : library Management System

-- Create 'branch' Table

CREATE DATABASE library_management_system_db;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
		(
			branch_id VARCHAR(10) PRIMARY KEY,
			manager_id VARCHAR(10),
			branch_address VARCHAR(50),
			conact_num VARCHAR(20)
			
		);


-- Create 'employee' Table
DROP TABLE IF EXISTS employee;
CREATE TABLE employee
		(
			emp_id VARCHAR(10) PRIMARY KEY,
			emp_name VARCHAR(50),
			emp_position VARCHAR(20),
			salary INT,
			branch_id VARCHAR(10), -- FK

		);

-- Create 'book' Table
DROP TABLE IF EXISTS book;
CREATE TABLE book
		(
			isbn VARCHAR(30) PRIMARY KEY,
			book_title VARCHAR(100),
			category VARCHAR(20),
			rental_price FLOAT,
			status VARCHAR(10),
			author VARCHAR(50),
			publisher VARCHAR(50)

		)


-- Create 'members' Table
DROP TABLE IF EXISTS members;
CREATE TABLE members
		(
			member_id VARCHAR(10) PRIMARY KEY,
			member_name VARCHAR(50),
			member_address VARCHAR(50),
			join_date DATE
		);


-- Create 'issued_status' Table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
		(
			issued_id VARCHAR(10) PRIMARY KEY,
			issued_member_id VARCHAR(10), -- FK
			issued_book_name VARCHAR(100), 
			issued_date DATE,
			issued_book_isbn VARCHAR(30), -- FK
			issued_emp_id VARCHAR(10) -- FK

		);


-- Create return_status Table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
		(
			return_id VARCHAR(10) PRIMARY KEY,
			issued_id VARCHAR(10),
			return_book_name VARCHAR(100),
			return_date DATE,
			return_book_isbn VARCHAR(30) -- FK
		);



-- FOREGIN KEY 

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members (member_id);


ALTER TABLE issued_status
ADD CONSTRAINT fk_book
FOREIGN KEY (issued_book_isbn)
REFERENCES book (isbn);


ALTER TABLE issued_status
ADD CONSTRAINT fk_employee
FOREIGN KEY (issued_emp_id)
REFERENCES employee (emp_id);


ALTER TABLE return_status
ADD CONSTRAINT fk_book_issued
FOREIGN KEY (return_book_isbn)
REFERENCES book (isbn);


ALTER TABLE employee
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch (branch_id);


-- Ensuring data imported for all tables.
SELECT * FROM book;
SELECT * FROM employee;
SELECT * FROM branch;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
```sql
--  "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO book (isbn,book_title, category, rental_price, status, author, publisher)
VALUES
	(
		'978-1-60129-456-2',
		'To Kill a Mockingbird',
		'Classic',
		6.00,
		'yes', 
		'Harper Lee', 
		'J.B Lipptincoot & Co.' -- 'J.B. Lippincott & Co.'
	);

-- Edit Publisher name

UPDATE book
SET publisher = 'J.B. Lippincott & Co.'
WHERE isbn = '978-1-60129-456-2';

SELECT * FROM book;
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = '6/123-125 Main St' , join_date = '2021-05-14'
WHERE member_id = 'C101';

SELECT * FROM members
WHERE member_id = 'C101';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
SELECT * FROM issued_status
WHERE issued_id = 'IS121';

-- DELETE record
DELETE FROM issued_status
WHERE issued_id = 'IS121';

-- Find the record
SELECT * FROM issued_status
WHERE issued_id = 'IS121'; -- DELETED 
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT 
	issued_member_id, 
	COUNT(issued_id) AS num_of_books_issued 
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(issued_id) > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnts**

```sql
CREATE TABLE book_issued_cnts
AS
SELECT 
	issued_book_name,
	COUNT(issued_id) as total_book_issued
FROM issued_status
GROUP BY issued_book_name;
	
-- View CTAS

SELECT * FROM book_issued_cnts
ORDER BY 2 DESC;


-- ALTERNATE METHOD using JOIN

CREATE TABLE book_issued_cnt 
AS
SELECT 
	b.isbn,
	b.book_title,
	COUNT(ist.issued_id) as total_book_issued
FROM book as b
JOIN issued_status as ist 
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2;


-- View CTAS

SELECT * FROM book_issued_cnt
ORDER BY 3 DESC;

```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve number of Books in an each Category**:

```sql
SELECT 
	category,
	COUNT(isbn) AS num_of_books
FROM book
GROUP BY category
ORDER BY 2 DESC;
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT 
	b.category,
	COUNT(ist.issued_book_isbn) AS rented_times,
	SUM(b.rental_price) AS total_rental_earning
FROM issued_status AS ist
JOIN book AS b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1
ORDER BY 3 DESC;
```

9. **List Members Who Registered in the Last 730 Days**:
```sql
SELECT member_name FROM members
WHERE join_date >= CURRENT_DATE - INTERVAL '730 days';
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
	e1.emp_name,
	b.*,
	e2.emp_name AS manager
FROM employee AS e1
JOIN branch AS b
ON b.branch_id = e1.branch_id
JOIN employee AS e2
ON e2.emp_id = b.manager_id;
```

Task 11. **Create a Table of Books with Rental Price Above 6$ Threshold**:
```sql
CREATE TABLE expensive_books
AS
SELECT *FROM book
WHERE rental_price > 6;

SELECT * FROM expensive_books;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT 
	i.issued_book_name,
	i.issued_date,
	r.return_date
FROM issued_status AS i
LEFT JOIN return_status AS r
ON r.issued_id = i.issued_id
WHERE return_id IS NULL;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT 
	iss.issued_member_id,
	mem.member_name,
	iss.issued_book_name,
	iss.issued_date,
	res.return_date,
	CURRENT_DATE -  iss.issued_date AS overdue_days	
	
FROM issued_status iss
JOIN return_status res
ON res.issued_id = iss.issued_id
JOIN members mem
ON mem.member_id = iss.issued_member_id
WHERE 
	res.return_date IS NULL
	AND
	( CURRENT_DATE - iss.issued_date ) > 30
ORDER BY 6 DESC; -- overdue_days
```


**Task 14:  Create a Table of Active Members**  
Use the CREATE TABLE AS (CTS) statement to create a new active_members containing members who have issued at least one book in the last 2 months:

```sql

-- Use join for better performance
DROP TABLE IF EXISTS active_members;
CREATE TABLE active_members 
AS
SELECT
	DISTINCT ON (mem.member_id) mem.*
FROM members mem
LEFT JOIN issued_status iss
ON iss.issued_member_id  = mem.member_id
WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month' ;

SELECT * FROM active_members;



-- Alternate Method

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (
			SELECT 
	                        DISTINCT issued_member_id   
			FROM issued_status
			WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month'
                     );


SELECT * FROM active_members;
```




**Task 15: Find Employees with the most book issues processed**  
Write a query to find the top 3 employees who have processed the most book issued. Display the employee name, number of books processed, and their branch.

```sql
SELECT 
	emp.emp_name,
	b.branch_id,
	COUNT(iss.issued_id) AS num_of_books_issued

FROM issued_status iss
JOIN employee emp
ON emp.emp_id = iss.issued_emp_id
JOIN branch b
ON b.branch_id = emp.branch_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 3;
```

**Task 16:Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status 'damaged' in the books table. Display the member name, book title, and the number of times they 've issued damaged books. Update the status column in the book table for records where the rental price is between 0 and 4.

```sql
SELECT 
	mem.member_name,
	b.book_title,
	COUNT(*) AS issue_count
FROM issued_status AS iss
JOIN members AS mem
ON mem.member_id = iss.issued_member_id
JOIN book AS b
ON b.isbn = iss.issued_book_isbn
WHERE b.status = 'damaged'
GROUP BY mem.member_name, b.book_title
HAVING COUNT(*) > 2;
```


**Task 17: Update Book Status on Return**  
 Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table.

```sql
CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
	v_isbn VARCHAR(30);
	v_book_name VARCHAR(100);
BEGIN
	-- logic and code
	-- Inserting into return based on users input
	INSERT INTO return_status(return_id,issued_id,return_date)
	VALUES
		(p_return_id,p_issued_id,CURRENT_DATE);

	SELECT 
		issued_book_isbn,
		issued_book_name
		INTO
		v_isbn,
		v_book_name
		
	FROM issued_status
	WHERE issued_id = p_issued_id;

	UPDATE book
	SET status = 'yes'
	WHERE isbn = v_isbn;

	RAISE NOTICE 'Thank you for returning the book: ''%''', v_book_name;


END;
$$

-- Testing FUNCTION add_return_records - 1

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1';

SELECT * FROM book
WHERE  isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';


SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- Testing FUNCTION add_return_records - 2
isbn = '978-0-7432-7357-1'
issued_id = IS136
return_id = RS139

SELECT * FROM book
WHERE  isbn = '978-0-7432-7357-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-7432-7357-1';


SELECT * FROM return_status
WHERE issued_id = 'IS136';


-- Testing FUNCTION add_return_records - 3
isbn = '978-0-375-41398-8'
issued_id = IS134
return_id = RS140

SELECT * FROM book
WHERE  isbn = '978-0-375-41398-8';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-375-41398-8';


SELECT * FROM return_status
WHERE issued_id = 'IS134';


-- 	Calling function
CALL add_return_records('RS138','IS135') -- 1
CALL add_return_records('RS139','IS136') -- 2
CALL add_return_records('RS140','IS137') -- 3
```

**Task 18: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
```sql
DROP TABLE IF EXISTS branch_performance;
CREATE TABLE branch_performance
AS
SELECT 
	br.branch_id,
	COUNT(i.issued_id) num_of_books_issued,
	COUNT(r.return_id) num_of_books_returned,
	SUM(b.rental_price) total_revenue
FROM  book b
JOIN issued_status i
ON i.issued_book_isbn = b.isbn
JOIN employee e
ON e.emp_id = i.issued_emp_id
JOIN branch br
ON br.branch_id = e.branch_id
JOIN return_status r
ON r.issued_id = i.issued_id
GROUP BY 1
ORDER BY 4 DESC;

SELECT * FROM branch_performance;
```


**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_name VARCHAR(100), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10) )
LANGUAGE plpgsql
AS $$

DECLARE
-- all the variables
v_status VARCHAR(10);


BEGIN
-- all logic here
	-- checking if book is available 'yes'
	SELECT
		status
		INTO
		v_status
	FROM book
	WHERE isbn = p_issued_book_isbn;

	IF v_status = 'yes' THEN

		INSERT INTO issued_status(issued_id,issued_member_id, issued_book_name, issued_date, issued_book_isbn,issued_emp_id)
		VALUES
		(p_issued_id,p_issued_member_id,p_issued_book_name, CURRENT_DATE ,p_issued_book_isbn, p_issued_emp_id);

		UPDATE book
		SET status = 'no'
		WHERE isbn = p_issued_book_isbn;

		RAISE NOTICE 'Book records added successfully for book isbn : ''%''', p_issued_book_isbn;

	ELSE

		RAISE NOTICE 'Sorry to inform you the book you have requested is unavaiable book_isbn: ''%''', p_issued_book_isbn;
	END IF;

END;
$$

-- Testing The Function
SELECT * FROM book
WHERE isbn = '978-0-553-29698-2'
-- '978-0-553-29698-2' -- yes
-- '978-0-553-29698-2' -- no
-- '978-0-679-76489-8' -- yes

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-553-29698-2'-- issued_id = IS137

SELECT * FROM return_status
WHERE issued_id = 'IS137'


-- Calling a Function
CALL issue_book('IS143','C102',NULL,'978-0-553-29698-2','E104');
CALL issue_book('IS144','C102','Harry Potter and the Sorcerers Stone','978-0-679-76489-8','E104');
CALL issue_book('IS145','C102',NULL,'978-0-09-957807-9','E104');
```



**Task 20: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of overdue_books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines
```sql

-- logic: Join Tables - issued_status -> return_status -> members
-- fine amount: 0.50$ per day for late return

DROP TABLE IF EXISTS due_penalty;
CREATE TABLE due_penalty
AS
SELECT 
    subquery.issued_member_id,
    subquery.member_name,
    COUNT(subquery.issued_id) AS due_books,
    SUM(subquery.total_fine) AS total_fine  -- Summing fines for each member
FROM 
    (
	SELECT 
            iss.issued_member_id,
            iss.issued_id,
            mem.member_name,
            (CURRENT_DATE - iss.issued_date) * 0.50 AS total_fine  -- Fine per overdue day
        FROM issued_status iss
        JOIN return_status res
	ON res.issued_id = iss.issued_id
        JOIN members mem
        ON mem.member_id = iss.issued_member_id
        WHERE 
		res.return_date IS NULL
          	AND 
		(CURRENT_DATE - iss.issued_date) > 30
    ) AS subquery
GROUP BY subquery.issued_member_id, subquery.member_name;

SELECT * FROM due_penalty;
```



## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


## Author - Bibek Parajuli

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions or feedback, feel free to get in touch!

### Socials

- **Email**: [Contact me on Email](bibekparajuli48@gmail.com)
- **Linkedln**: [Catch me on Linkedln](https://www.linkedin.com/in/bibek-parajuli-b61373186/)
- **Twitter | X**: [Connect with on X](https://x.com/bibekparajuli48)
- **Web Protfolio**: [Explore my projects on Github pages(Web protfolio](https://cod-bibek.github.io/Cod_Bibek.github.io/)

Thank you for exploring my project.
