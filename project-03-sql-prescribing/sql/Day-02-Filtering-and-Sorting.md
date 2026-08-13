# Day 02 – Filtering and Sorting Data

**Database:** SQL Server  
**Practice Context:** NHS / Healthcare Data Analysis

---

## Topics Covered

- `WHERE`
- Comparison operators
- `AND`
- `OR`
- `NOT`
- `IN`
- `BETWEEN`
- `LIKE`
- `%` and `_` wildcards
- `IS NULL`
- `IS NOT NULL`
- `ORDER BY`
- `ASC`
- `DESC`
- `TOP`
- Combining multiple filters

---

# 1. WHERE

`WHERE` is used to filter rows.

Example – patients older than 65:

```sql
SELECT PatientID,
       FirstName,
       LastName,
       Age
FROM Patients
WHERE Age > 65;
```

### Key Concept

```text
SELECT → What columns do I want?
FROM   → Which table?
WHERE  → Which rows do I want?
```

---

# 2. Comparison Operators

Common SQL comparison operators:

| Operator | Meaning |
|---|---|
| `=` | Equal to |
| `<>` | Not equal to |
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater than or equal to |
| `<=` | Less than or equal to |

Example:

```sql
SELECT PatientID,
       FirstName,
       Age
FROM Patients
WHERE Age >= 65;
```

### Not Equal

```sql
SELECT PatientID,
       FirstName,
       HospitalSite
FROM Patients
WHERE HospitalSite <> 'Site C';
```

---

# 3. AND

`AND` means **all conditions must be true**.

Example – urgent Cardiology referrals:

```sql
SELECT ReferralID,
       PatientID,
       Specialty,
       Priority
FROM Referrals
WHERE Specialty = 'Cardiology'
  AND Priority = 'Urgent';
```

Both conditions must be satisfied.

---

# 4. OR

`OR` means **at least one condition must be true**.

```sql
SELECT ReferralID,
       PatientID,
       Specialty
FROM Referrals
WHERE Specialty = 'Cardiology'
   OR Specialty = 'Neurology';
```

This returns referrals belonging to either specialty.

---

# 5. Combining AND and OR

Parentheses are important when combining conditions.

```sql
SELECT ReferralID,
       PatientID,
       Specialty,
       Priority
FROM Referrals
WHERE Priority = 'Urgent'
  AND (
      Specialty = 'Cardiology'
      OR Specialty = 'Neurology'
  );
```

This means:

```text
Priority must be Urgent

AND

Specialty must be either:
Cardiology OR Neurology
```

---

# 6. NOT

`NOT` reverses a condition.

```sql
SELECT PatientID,
       FirstName,
       Age
FROM Patients
WHERE NOT Age < 18;
```

This returns patients who are not younger than 18.

Often the same condition can be written more clearly as:

```sql
WHERE Age >= 18;
```

---

# 7. IN

`IN` is useful when checking one column against several possible values.

Instead of:

```sql
WHERE Specialty = 'Cardiology'
   OR Specialty = 'Neurology'
   OR Specialty = 'Oncology'
```

we can write:

```sql
WHERE Specialty IN (
    'Cardiology',
    'Neurology',
    'Oncology'
);
```

Example:

```sql
SELECT ReferralID,
       PatientID,
       Specialty
FROM Referrals
WHERE Specialty IN (
    'Cardiology',
    'Neurology',
    'Oncology'
);
```

### Key Concept

```text
IN
→ Is this value inside this list?
```

---

# 8. NOT IN

`NOT IN` excludes values from a list.

```sql
SELECT ReferralID,
       PatientID,
       Specialty
FROM Referrals
WHERE Specialty NOT IN (
    'Cardiology',
    'Neurology'
);
```

---

# 9. BETWEEN

`BETWEEN` is useful for ranges.

Example – patients aged between 40 and 60:

```sql
SELECT PatientID,
       FirstName,
       Age
FROM Patients
WHERE Age BETWEEN 40 AND 60;
```

`BETWEEN` includes both boundary values.

Therefore:

```sql
WHERE Age BETWEEN 40 AND 60
```

includes:

```text
40 ✅
41 ✅
...
59 ✅
60 ✅
```

It is similar to:

```sql
WHERE Age >= 40
  AND Age <= 60;
```

---

# 10. BETWEEN With Dates

`BETWEEN` can also be used with dates.

```sql
SELECT ReferralID,
       PatientID,
       ReferralDate
FROM Referrals
WHERE ReferralDate BETWEEN '2026-01-01' AND '2026-06-30';
```

For datetime columns containing time values, explicit start/end comparisons can sometimes be safer than relying on an end-date midnight value.

---

# 11. LIKE

`LIKE` is used for pattern matching.

Example – last names beginning with `S`:

```sql
SELECT PatientID,
       FirstName,
       LastName
FROM Patients
WHERE LastName LIKE 'S%';
```

---

# 12. % Wildcard

`%` represents **zero or more characters**.

### Starts with S

```sql
WHERE LastName LIKE 'S%'
```

Examples:

```text
Smith     ✅
Singh     ✅
Scott     ✅
Jones     ❌
```

### Ends with son

```sql
WHERE LastName LIKE '%son'
```

Examples:

```text
Johnson    ✅
Wilson     ✅
Anderson   ✅
Smith      ❌
```

### Contains "card"

```sql
WHERE Specialty LIKE '%card%'
```

This searches for `card` anywhere within the value.

---

# 13. _ Wildcard

`_` represents exactly **one character**.

Example:

```sql
WHERE Code LIKE 'A_1'
```

Possible matches:

```text
AB1 ✅
AC1 ✅
AX1 ✅
AAB1 ❌
```

---

# 14. NULL

`NULL` represents a missing or unknown value.

We should not write:

```sql
WHERE Email = NULL;
```

Instead use:

```sql
WHERE Email IS NULL;
```

Example:

```sql
SELECT PatientID,
       FirstName,
       Email
FROM Patients
WHERE Email IS NULL;
```

---

# 15. IS NOT NULL

To find records where a value exists:

```sql
SELECT PatientID,
       FirstName,
       Email
FROM Patients
WHERE Email IS NOT NULL;
```

### Memory Rule

```text
Missing value
→ IS NULL

Value available
→ IS NOT NULL
```

---

# 16. ORDER BY

`ORDER BY` sorts query results.

Example:

```sql
SELECT PatientID,
       FirstName,
       Age
FROM Patients
ORDER BY Age;
```

The default direction is ascending.

Therefore:

```sql
ORDER BY Age;
```

is equivalent to:

```sql
ORDER BY Age ASC;
```

---

# 17. ASC

`ASC` means ascending.

For numbers:

```text
1
2
3
4
5
```

For dates:

```text
Oldest
↓
Newest
```

Example:

```sql
SELECT AppointmentID,
       PatientID,
       AppointmentDate
FROM Appointments
ORDER BY AppointmentDate ASC;
```

---

# 18. DESC

`DESC` means descending.

For ages:

```text
Oldest patient
↓
Youngest patient
```

Example:

```sql
SELECT PatientID,
       FirstName,
       Age
FROM Patients
ORDER BY Age DESC;
```

For dates:

```sql
ORDER BY AppointmentDate DESC;
```

means:

```text
Newest appointment
↓
Oldest appointment
```

---

# 19. Sorting by Multiple Columns

SQL can sort using more than one column.

```sql
SELECT PatientID,
       Specialty,
       AppointmentDate
FROM Appointments
ORDER BY Specialty ASC,
         AppointmentDate DESC;
```

This first groups the output order by specialty and then shows the newest appointments first within each specialty.

---

# 20. TOP

In SQL Server, `TOP` limits the number of returned rows.

Example – first 5 patients:

```sql
SELECT TOP 5
       PatientID,
       FirstName,
       LastName
FROM Patients;
```

---

# 21. TOP + ORDER BY

`TOP` becomes much more useful when combined with `ORDER BY`.

Example – 5 oldest patients:

```sql
SELECT TOP 5
       PatientID,
       FirstName,
       LastName,
       Age
FROM Patients
ORDER BY Age DESC;
```

### Key Concept

```text
ORDER BY Age DESC
→ oldest first

TOP 5
→ keep first five
```

Therefore:

```text
TOP 5 + Age DESC
→ five oldest patients
```

---

# 22. SQL Server TOP vs LIMIT

Because this practice uses **SQL Server**, use:

```sql
SELECT TOP 5 *
FROM Patients;
```

rather than:

```sql
SELECT *
FROM Patients
LIMIT 5;
```

`LIMIT` is commonly used by databases such as MySQL and PostgreSQL.

For SQL Server:

```text
TOP
```

is the syntax used in these exercises.

---

# 23. Combining Multiple Filters

Real analytical queries usually contain several conditions.

Example:

```sql
SELECT ReferralID,
       PatientID,
       Specialty,
       Priority,
       ReferralDate,
       HospitalSite
FROM Referrals
WHERE Priority = 'Urgent'
  AND Specialty IN (
      'Cardiology',
      'Neurology',
      'Oncology'
  )
  AND ReferralDate BETWEEN '2026-01-01' AND '2026-06-30'
  AND HospitalSite <> 'Site C'
ORDER BY ReferralDate DESC;
```

This combines:

```text
WHERE
AND
IN
BETWEEN
<>
ORDER BY
DESC
```

---

# 24. NHS Example – Waiting List

Find urgent patients who are still waiting.

```sql
SELECT PatientID,
       Specialty,
       Priority,
       WaitingDays,
       AppointmentDate
FROM WaitingList
WHERE Priority = 'Urgent'
  AND AppointmentDate IS NULL
ORDER BY WaitingDays DESC;
```

### Business Meaning

```text
Priority = 'Urgent'
→ urgent patients only

AppointmentDate IS NULL
→ appointment has not been assigned

ORDER BY WaitingDays DESC
→ longest-waiting patients appear first
```

---

# 25. NHS Example – Older Patients With Contact Details

```sql
SELECT PatientID,
       FirstName,
       LastName,
       Age,
       Email
FROM Patients
WHERE Age BETWEEN 65 AND 90
  AND Email IS NOT NULL
ORDER BY Age DESC;
```

---

# Key Decision Rules

```text
Filter rows
→ WHERE

Several conditions must all be true
→ AND

Either condition can be true
→ OR

Check against several values
→ IN

Check a range
→ BETWEEN

Search text patterns
→ LIKE

Missing value
→ IS NULL

Existing value
→ IS NOT NULL

Sort smallest/oldest first
→ ORDER BY ... ASC

Sort largest/newest first
→ ORDER BY ... DESC

Return only first N rows in SQL Server
→ TOP N
```

---

# Common Mistakes

### Incorrect NULL comparison

```sql
WHERE Email = NULL;
```

Correct:

```sql
WHERE Email IS NULL;
```

### Using LIMIT in SQL Server

```sql
LIMIT 5;
```

For this SQL Server practice:

```sql
SELECT TOP 5 ...
```

### Forgetting DESC when looking for largest/newest values

```sql
ORDER BY Age DESC;
```

### Using many OR conditions unnecessarily

Instead of:

```sql
WHERE Specialty = 'Cardiology'
   OR Specialty = 'Neurology'
   OR Specialty = 'Oncology';
```

prefer:

```sql
WHERE Specialty IN (
    'Cardiology',
    'Neurology',
    'Oncology'
);
```

---

# Day 02 Key Takeaways

Today I learned how to control **which rows are returned and how the results are displayed**.

I practised:

- Filtering with `WHERE`
- Comparison operators
- Combining conditions using `AND` and `OR`
- Filtering lists using `IN`
- Filtering ranges using `BETWEEN`
- Pattern matching using `LIKE`
- Handling missing values using `IS NULL`
- Sorting using `ORDER BY`
- Using `ASC` and `DESC`
- Limiting SQL Server results using `TOP`
- Combining multiple business conditions in one query

These techniques form the foundation for building more complex SQL analysis.

---

## Next Topic

**Day 03 – Aggregate Functions**

Including:

- `COUNT()`
- `SUM()`
- `AVG()`
- `MIN()`
- `MAX()`
- `COUNT(DISTINCT ...)`
- Healthcare reporting examples
