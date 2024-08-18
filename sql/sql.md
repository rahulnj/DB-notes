# Introduction to DBMS and SQL

## Contents

- What is a Database
- Types of Databases
- Intro to Relational Databases
- Keys in Relational Databases

## What is a Database

In daily life, people often use software like Excel, Google Sheets, Notion, or Notes apps to save information for later reference, such as monthly expenses, to-do lists, or shopping lists. Organizations, similarly, have the need to store large amounts of data for future use. For example, A school might need to track attendance, assignments, codes, mentor sessions, emails, phone numbers, and passwords for students, instructors, mentors, TAs, and batches.

As a new programmer unfamiliar with databases, the natural approach would be to store data in files, such as CSV files, for later retrieval and processing. For example:

```students.csv
name, batch, psp, attendance, coins, rank
Naman, 1, 94, 100, 0, 1
Amit, 2, 81, 70, 400, 1
Aditya, 1, 31, 100, 100, 2
```

```instructors.csv
name, subjects, average_rating
Rachit, C++, 4.5
Rishabh, Java, 4.8
Aayush, C++, 4.9
```

```batches.csv
id, name, start_date, end_date
1, AUG 22 Intermediate, 2022-08-01, 2023-08-01
2, AUG 22 Beginner, 2022-08-01, 2023-08-01
```

To perform operations such as finding the average attendance of students in each batch, you would need to write code to read and process data from these files. This approach, however, presents several challenges:

### Issues with Files as a Database

1. Inefficient

Processing large files is slow, especially with millions of records, and simple tasks like finding a student's PSP (personal score percentage) can be time-consuming.

2. Integrity

There is no mechanism to prevent invalid data entries, which can lead to data integrity issues.

3. Concurrency

Handling simultaneous data access and updates is difficult, leading to potential conflicts and inconsistencies.

4. Security

Storing sensitive data like passwords in files is insecure, as there are no user-level access controls.

### What's a Database

A database is a collection of related data. For example, A school database would store information about students, users, batches, classes, instructors, and more. The file-based storage approach mentioned earlier is a basic form of a database, but it is inefficient and lacks essential features.

### What's a Database Management System (DBMS)

A DBMS is a software system that manages a database efficiently, providing mechanisms to create, retrieve, update, and delete data (CRUD operations). It ensures data integrity, security, concurrency, and provides efficient querying capabilities. There are many types of DBMSs, each with its own trade-offs.

## Types of Databases

### Relational Databases

Relational databases represent a database as a collection of related tables. Each table consists of rows (records) and columns (fields). For example, to track students' attendance and PSP, an instructor might create a table with columns for name, attendance, and PSP.

Key properties of relational databases include:

1. Table-Based Structure: Data is stored in tables, each representing an entity or a relationship between entities.

2. Uniqueness: Each row is unique, ensuring no two rows have identical values across all columns.

3. Consistent Data Types: All values in a column must be of the same data type.

4. Atomic Values: Values in a column must be indivisible, meaning that a column cannot store lists or sets of values.

5. Unordered Columns: The order of columns is not guaranteed, so queries should reference column names, not positions.

6. Unordered Rows: The order of rows is not guaranteed, so queries should use the ORDER BY clause when a specific order is required.

7. Unique Column Names: Column names must be unique within a table.

### Non-Relational Databases

Non-relational databases do not follow the relational model and do not store data in tables. Instead, they store data in formats such as documents, key-value pairs, or graphs. Non-relational databases will be discussed in the High-Level Design (HLD) module.

## Keys in Relational Databases

Keys are crucial for uniquely identifying rows in a table. The main types of keys include:

### Super Keys

A super key is a combination of columns whose values can uniquely identify a row in a table. For example, in a table with columns for name, email, and phone number, each of the following combinations could be a super key:

- (email)
- (phone number)
- (name, email)
- (name, phone number)

### Primary Key

A primary key is a candidate key that is chosen to uniquely identify rows in a table. A table can have only one primary key. For example, in a students table, the primary key might be the email address or a newly created student ID.

### Foreign Keys

A foreign key is a column or combination of columns in one table that refers to the primary key in another table. It is used to establish a relationship between the two tables, ensuring referential integrity.
