CREATE TABLE employees
(
	employee_id int PRIMARY KEY NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	title varchar(50) NOT NULL,
	birth_date date NOT NULL,
	notes varchar(50) NOT NULL
	
);

CREATE TABLE customers
(
	customer_id varchar(10) PRIMARY KEY NOT NULL,
	company_name varchar(50) NOT NULL,
	contact_name varchar(50) NOT NULL
	
);

CREATE TABLE orders
(
	order_id int PRIMARY KEY NOT NULL,
	customer_id char(5) REFERENCES customers(customer_id) NOT NULL,
	employee_id int REFERENCES employees(employee_id) NOT NULL,
	order_date date NOT NULL,
	ship_city varchar(80) NOT NULL
);