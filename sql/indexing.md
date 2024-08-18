# Indexing

## Contents

- Introduction to Indexing
- How Indexes Work
- Indexes and Range Queries
  - Data structures used for indexing
- Cons of Indexes
- Indexes on Multiple Columns
- Indexing on Strings
- How to create index

## Introduction to Indexing

When discussing SQL queries, a common approach is to outline how these queries might operate behind the scenes. However, if a database functioned strictly according to these outlines, significant performance issues would arise. This is because the outlined approach typically involves iterating over each row in the database to retrieve the desired data, leading to a minimum time complexity of O(N) for every query. This complexity can increase further when joins or other operations are added to the query.

## Storage on Disk

Data in a database is stored on disk, and accessing data from disk is much slower than accessing it from RAM—approximately 20 times slower. When data is fetched from disk, the operating system retrieves data in blocks, meaning that not only the target data but also nearby locations are read.

```sql
select * from students where id = 100;
```

Executing this query would involve scanning through each row on the disk, leading to performance issues. To understand the inefficiency, consider the analogy of a book: to find a specific topic, one would use the book's index to quickly locate the correct page, rather than reading the book from the beginning. Similarly, a database index helps quickly locate the correct disk block.

### Clarification on Indexes

Indexes do not sort a table; their primary function is to reduce the number of disk block accesses, thereby improving query performance.

## How Indexes Work

Indexes optimize queries by allowing direct access to the relevant disk block. For instance, consider a table with millions of rows, and a query like:

```sql
select * from students where id = 100;
```

To avoid scanning irrelevant disk blocks, a hashmap can be used, where the key is the student ID and the value is the corresponding disk block. This approach allows for direct access to the block containing the target row.

However, if the column being queried contains duplicates, such as:

```sql
select * from students where name = 'Naman';
```

The hashmap can be modified so that each key maps to a list of blocks containing that name. This modification still prevents unnecessary disk block accesses, thus improving performance.

## Indexes and Range Queries

Not all SQL queries involve exact matches; range queries are also common, such as:

```sql
select * from students where psp between 40.1 and 90.1;
```

A simple hashmap is inefficient for handling range queries because it requires checking each value individually, resulting in O(N) time complexity. Instead, a TreeMap, which uses a balanced binary search tree (e.g., AVL Tree or Red-Black Tree), can be employed. A TreeMap allows for efficient retrieval of nodes in O(log N) time, making it suitable for range queries.

## B and B+ Trees

Databases often use B Trees or B+ Trees for indexing. These structures allow each node to have multiple children, reducing the tree's height and further speeding up queries.

## Cons of Indexes

While indexes enhance read query performance, they have drawbacks, particularly when updating data. Updating data often requires updating the corresponding index nodes, slowing down operations. Additionally, storing indexes on disk requires extra space. The primary disadvantages of indexes are:

1. Slower write operations
2. Increased storage requirements
Therefore, it is advisable to create indexes only when necessary.

## Indexes on Multiple Columns

The effectiveness of an index depends on the column it is created on. For example, an index on the id column will speed up queries involving id, but not those involving other columns like psp. Multiple-column indexes can be created, but the order matters. For instance, an index on (id, name) will first index by id and use name only as a tie-breaker, making it ineffective for filtering by name.

## Indexing on Strings

When querying string columns, such as:

```sql
SELECT * FROM user WHERE email = 'abc@someone.com';
```

Creating an index on the entire string can be inefficient. Instead, indexing the first part of the string (before the @ in an email) and mapping it to a list of blocks can save space while still improving performance. For pattern matching queries like:

```sql
SELECT * FROM user
WHERE address LIKE '%ambala%';
```

Standard indexing is ineffective, and Full-Text Indexing is used instead.

## How to create index

The syntax for creating an index on the film table is as follows:

```sql
CREATE INDEX idx_film_title_release
ON film(title, release_year);
```

Best practices for creating indexes:

1. Prefix the index name by 'idx'
2. Use the format idx_<table_name>_<attribute_name1>_<attribute_name2>...

To use the index in a query:

```sql
EXPLAIN ANALYZE SELECT * FROM film
WHERE title = 'Shawshank Redemption';
```

The query log will indicate whether an index lookup was performed. Removing the index and rerunning the query will show a noticeable difference in execution time, demonstrating the effectiveness of indexing.
