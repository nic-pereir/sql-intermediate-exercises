# SQL Library Management Exercises

This project was created as a practical exercise to strengthen SQL fundamentals and understand how relational databases can be queried and analyzed.
A collection of SQL exercises built around a simple library management database.
The exercises focus on relational database fundamentals, including table relationships, joins, aggregation, filtering grouped results, and sorting.

## Database Structure

The database contains four tables:

* **Category** — stores book categories.
* **Book** — stores books, authors, and categories.
* **Member** — stores library members and their registration information.
* **Loan** — stores book loans, including loan dates, return dates, and status.

### Relationships

```text
Category 1 ──── N Book
Member   1 ──── N Loan
Book     1 ──── N Loan
```

## Concepts Practiced

* `CREATE TABLE`
* Primary keys and foreign keys
* `UNIQUE` and `CHECK` constraints
* `DEFAULT` values
* `ON DELETE`
* `INSERT INTO`
* `INNER JOIN`
* `LEFT JOIN`
* `WHERE`
* `COUNT()`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `LIMIT`
* Table aliases

## How to Run

### Requirements

* PostgreSQL
* A PostgreSQL client such as pgAdmin, DBeaver, or `psql`

### Steps

1. Create a PostgreSQL database.
2. Open the SQL file in your preferred PostgreSQL client.
3. Run the **schema and sample data** section first.
4. Run the exercises to execute the queries and inspect their results.

> The exercises depend on the tables and sample data created at the beginning of the file.

## Technologies

* PostgreSQL
* SQL
