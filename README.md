# Loan Management System

A simple **Loan Management System** built using **MySQL** to manage customer loan applications, approvals, and records. This project is designed to help track loan data efficiently and demonstrate database design and query handling skills.

---

## Table of Contents

- [Overview](#overview)  
- [Features](#features)  
- [Database Schema](#database-schema)  
- [Setup Instructions](#setup-instructions)  
- [Sample Data](#sample-data)  
- [Usage](#usage)  
- [Technologies Used](#technologies-used)  
- [License](#license)  

---

## Overview

The Loan Management System allows an organization to:

- Store customer information and loan applications  
- Track loan status (approved, pending, rejected)  
- Generate and view reports on loans  

This project emphasizes **database design**, **SQL queries**, and **data management skills**.

---

## Features

- Add new customers and their loan applications  
- Approve or reject loans  
- Track the status of existing loans  
- Query loan data using MySQL commands  

---

## Database Schema

### Customers Table
```sql
CREATE TABLE customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE loans (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  amount DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id)
);

---

Setup Instructions :
1.Clone the repository

git clone https://github.com/Arunesh-Raja/Mysql.git

2.Create Database

CREATE DATABASE loan_management;
USE loan_management;

3.Run SQL Scripts
Execute the schema.sql and sample_data.sql files to create tables and insert sample data.

4.Connect Application
Use your MySQL client or application to interact with the database.

-----

###Sample Data
  INSERT INTO customers (name, email) VALUES 
  ('Arunesh', 'arunesh@example.com'),
  ('Ramesh', 'ramesh@example.com');
  
  INSERT INTO loans (customer_id, amount, status) VALUES
  (1, 50000, 'pending'),
  (2, 75000, 'approved');

----

### Usage

> View all customers:
  SELECT * FROM customers;

> View all loans:
  SELECT * FROM loans;

> Approve a loan:
  UPDATE loans SET status='approved' WHERE id=1;

-----

Technologies Used :
MySQL – Relational Database
SQL Queries – CRUD operations and data manipulation

License :
This project is open-source and available under the MIT License.


