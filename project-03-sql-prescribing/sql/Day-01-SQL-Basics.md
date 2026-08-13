# Day 01 – SQL Basics

**Database:** SQL Server  
**Practice Context:** NHS / Healthcare Data Analysis

---

## Topics Covered

- What SQL is
- Database tables, rows and columns
- `SELECT`
- `FROM`
- Selecting specific columns
- Selecting all columns with `*`
- Column aliases using `AS`
- `DISTINCT`
- Basic query structure

---

## 1. SELECT

`SELECT` is used to choose the columns that should appear in the result.

```sql
SELECT PatientID,
       FirstName,
       LastName
FROM Patients;
```

---

## 2. SELECT *

`*` returns all columns from a table.

```sql
SELECT *
FROM Patients;
```

For analytical work, selecting only the required columns is usually clearer than using `SELECT *`.

---

## 3. Selecting Multiple Columns

```sql
SELECT PatientID,
       FirstName,
       LastName,
       Age,
       Email
FROM Patients;
```

---

## 4. Column Aliases

`AS` gives a result column a more readable name.

```sql
SELECT PatientID,
       FirstName AS PatientFirstName,
       LastName AS PatientLastName
FROM Patients;
```

The alias changes the column heading in the result; it does not rename the original database column.

---

## 5. DISTINCT

`DISTINCT` removes duplicate combinations from the result.

```sql
SELECT DISTINCT Specialty
FROM Referrals;
```

Example input:

```text
Cardiology
Cardiology
Neurology
Oncology
Neurology
```

Result:

```text
Cardiology
Neurology
Oncology
```

---

## 6. DISTINCT With Multiple Columns

```sql
SELECT DISTINCT Specialty,
                HospitalSite
FROM Referrals;
```

Here SQL returns each unique **combination** of `Specialty` and `HospitalSite`.

For example:

```text
Cardiology | Site A
Cardiology | Site B
Neurology  | Site A
```

---

## 7. Basic SQL Query Structure

The basic pattern is:

```sql
SELECT Column1,
       Column2
FROM TableName;
```

Example:

```sql
SELECT PatientID,
       FirstName,
       Age
FROM Patients;
```

---

## Key Concepts Learned

```text
SELECT
→ Which columns do I want?

FROM
→ Which table contains the data?

AS
→ What should the result column be called?

DISTINCT
→ Remove duplicate result values
```

---

## Example – NHS Patient Report

```sql
SELECT PatientID,
       FirstName,
       LastName,
       Age
FROM Patients;
```

This returns patient-level information while keeping one database row for every matching patient record.

---

## Example – Available Specialties

```sql
SELECT DISTINCT Specialty
FROM Referrals;
```

This can be used to identify the different specialties represented in the referral data.

---

## Important Difference

```sql
SELECT Specialty
FROM Referrals;
```

can return the same specialty many times.

Whereas:

```sql
SELECT DISTINCT Specialty
FROM Referrals;
```

returns each specialty only once.

---

# Day 01 Key Takeaways

- SQL is used to retrieve and analyse data stored in relational databases.
- Tables contain rows and columns.
- `SELECT` determines which columns are returned.
- `FROM` determines which table is queried.
- `AS` creates readable output aliases.
- `DISTINCT` removes duplicate result combinations.
- Selecting only required columns makes analytical queries easier to understand.

---

## Next Topic

Filtering and sorting data using:

- `WHERE`
- Comparison operators
- `AND`
- `OR`
- `NOT`
- `IN`
- `BETWEEN`
- `LIKE`
- `IS NULL`
- `ORDER BY`
- `TOP`
