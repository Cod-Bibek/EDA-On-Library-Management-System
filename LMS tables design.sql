-- Project : library Management System

-- Create Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
		(
			branch_id VARCHAR(10) PRIMARY KEY,
			manager_id VARCHAR(10),
			branch_address VARCHAR(50),
			conact_num VARCHAR(20)
			
		);


-- Create Employees Table
DROP TABLE IF EXISTS employee;
CREATE TABLE employee
		(
			emp_id VARCHAR(10) PRIMARY KEY,
			emp_name VARCHAR(50),
			emp_position VARCHAR(20),
			salary INT,
			branch_id VARCHAR(10), -- FK

		);

-- Create Books Table
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


-- Create Member Table
DROP TABLE IF EXISTS members;
CREATE TABLE members
		(
			member_id VARCHAR(10) PRIMARY KEY,
			member_name VARCHAR(50),
			member_address VARCHAR(50),
			join_date DATE
		);


-- Create Issued Status Table
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


-- Create Return Status Table
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


-- Ensuring data import for all tables.
SELECT * FROM book;
SELECT * FROM employee;
SELECT * FROM branch;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;


