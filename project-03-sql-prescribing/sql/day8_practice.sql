# SQL Practice – Window Functions

**Date:** 12 August 2026  
**Database:** SQL Server  
**Practice Context:** NHS / Healthcare Data Analysis

---

## Today's Focus

Today I focused on SQL Window Functions and applied them to healthcare-style datasets involving appointments, referrals, admissions, and waiting lists.

The main goal was to understand when to use a Window Function instead of `GROUP BY`, and how to use Window Functions for ranking, running totals, previous/next record analysis, and latest-record-per-patient reporting.

---

## 1. GROUP BY vs Window Functions

### Key Concept

- `GROUP BY` summarises data and collapses rows.
- Window Functions perform calculations while keeping individual rows.

### Example – Total Appointments per Patient While Keeping Every Appointment

```sql
SELECT AppointmentID,
       PatientID,
       Specialty,
       AppointmentDate,
       COUNT(AppointmentID) OVER (
           PARTITION BY PatientID
       ) AS TotalPatientAppointments
FROM Appointments;
```

---

## 2. COUNT() OVER()

Used `COUNT()` with `OVER()` and `PARTITION BY` to calculate totals without collapsing individual records.

```sql
SELECT AppointmentID,
       PatientID,
       Specialty,
       AppointmentDate,
       COUNT(AppointmentID) OVER (
           PARTITION BY Specialty
       ) AS TotalSpecialtyAppointments
FROM Appointments;
```

---

## 3. AVG() OVER()

Calculated the average length of stay for each ward while keeping every admission record.

```sql
SELECT AdmissionID,
       PatientID,
       Ward,
       LengthOfStay,
       AVG(LengthOfStay) OVER (
           PARTITION BY Ward
       ) AS AverageWardStay
FROM Admissions;
```

---

## 4. SUM() OVER()

Calculated total length of stay separately for each ward.

```sql
SELECT AdmissionID,
       PatientID,
       Ward,
       LengthOfStay,
       SUM(LengthOfStay) OVER (
           PARTITION BY Ward
       ) AS TotalWardStay
FROM Admissions;
```

---

## 5. ROW_NUMBER()

Used `ROW_NUMBER()` to assign a unique sequence number to each patient's appointments.

```sql
SELECT AppointmentID,
       PatientID,
       Specialty,
       AppointmentDate,
       ROW_NUMBER() OVER (
           PARTITION BY PatientID
           ORDER BY AppointmentDate DESC
       ) AS AppointmentNumber
FROM Appointments;
```

### Key Learning

```text
PARTITION BY PatientID
→ Restart numbering for every patient

ORDER BY AppointmentDate DESC
→ Most recent appointment receives number 1
```

---

## 6. Latest Record per Patient – CTE + ROW_NUMBER()

Used a CTE with `ROW_NUMBER()` to return only the latest appointment for each patient.

```sql
WITH RecentAppointments AS (
    SELECT AppointmentID,
           PatientID,
           Specialty,
           AppointmentDate,
           ROW_NUMBER() OVER (
               PARTITION BY PatientID
               ORDER BY AppointmentDate DESC
           ) AS AppointmentNumber
    FROM Appointments
)

SELECT AppointmentID,
       PatientID,
       Specialty,
       AppointmentDate
FROM RecentAppointments
WHERE AppointmentNumber = 1;
```

### Key Pattern

```text
CTE
→ ROW_NUMBER()
→ PARTITION BY PatientID
→ ORDER BY date DESC
→ WHERE RowNumber = 1
→ Latest record per patient
```

---

## 7. ROW_NUMBER() vs RANK() vs DENSE_RANK()

### ROW_NUMBER()

Every row receives a unique number.

```text
100 → 1
90  → 2
90  → 3
80  → 4
```

### RANK()

Ties receive the same rank and the next position is skipped.

```text
100 → 1
90  → 2
90  → 2
80  → 4
```

### DENSE_RANK()

Ties receive the same rank but the next position is not skipped.

```text
100 → 1
90  → 2
90  → 2
80  → 3
```

### Example – Ranking Waiting Patients Within Each Specialty

```sql
SELECT PatientID,
       Specialty,
       WaitingDays,
       DENSE_RANK() OVER (
           PARTITION BY Specialty
           ORDER BY WaitingDays DESC
       ) AS WaitingPosition
FROM WaitingList
WHERE AppointmentDate IS NULL
  AND Priority = 'Urgent';
```

---

## 8. Running Totals

Used `SUM()` with `ORDER BY` inside a Window Function to calculate cumulative totals.

```sql
SELECT MonthNumber,
       ReferralCount,
       SUM(ReferralCount) OVER (
           ORDER BY MonthNumber
       ) AS RunningReferralTotal
FROM MonthlyReferrals;
```

---

## 9. Running Total Within Each Specialty

Used `PARTITION BY` to restart the running total for each specialty.

```sql
SELECT Specialty,
       MonthNumber,
       ReferralCount,
       SUM(ReferralCount) OVER (
           PARTITION BY Specialty
           ORDER BY MonthNumber
       ) AS RunningSpecialtyTotal
FROM MonthlyReferrals;
```

---

## 10. Window Frames

Practised using an explicit row-based window frame:

```sql
SELECT Specialty,
       MonthNumber,
       ReferralCount,
       SUM(ReferralCount) OVER (
           PARTITION BY Specialty
           ORDER BY MonthNumber
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS RunningSpecialtyTotal
FROM MonthlyReferrals;
```

### Key Learning

```text
UNBOUNDED PRECEDING
→ Start from the first row

CURRENT ROW
→ Stop at and include the current row
```

Therefore:

```text
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

means:

```text
From the first row → up to and including the current row
```

Using `ROWS` also makes the running total operate row-by-row when duplicate ordering values exist.

---

## 11. LAG()

Used `LAG()` to retrieve the previous appointment date for each patient.

```sql
SELECT AppointmentID,
       PatientID,
       Specialty,
       AppointmentDate,
       LAG(AppointmentDate) OVER (
           PARTITION BY PatientID
           ORDER BY AppointmentDate
       ) AS PreviousAppointmentDate
FROM Appointments;
```

### Key Concept

```text
LAG() → Previous row
```

---

## 12. LEAD()

Used `LEAD()` to retrieve the next appointment date for each patient.

```sql
SELECT AppointmentID,
       PatientID,
       Specialty,
       AppointmentDate,
       LEAD(AppointmentDate) OVER (
           PARTITION BY PatientID
           ORDER BY AppointmentDate
       ) AS NextAppointmentDate
FROM Appointments;
```

### Key Concept

```text
LAG()  → Previous row
LEAD() → Next row
```

---

## 13. LAG() + DATEDIFF()

Combined `LAG()` with `DATEDIFF()` to calculate the number of days between consecutive appointments.

```sql
SELECT AppointmentID,
       PatientID,
       Specialty,
       AppointmentDate,
       LAG(AppointmentDate) OVER (
           PARTITION BY PatientID
           ORDER BY AppointmentDate
       ) AS PreviousAppointmentDate,
       DATEDIFF(
           day,
           LAG(AppointmentDate) OVER (
               PARTITION BY PatientID
               ORDER BY AppointmentDate
           ),
           AppointmentDate
       ) AS DaysSincePreviousAppointment
FROM Appointments;
```

### DATEDIFF Rule

```text
DATEDIFF(day, START, END)

Think:

FROM → TO
```

Examples:

```sql
DATEDIFF(day, ReferralDate, AppointmentDate)

DATEDIFF(day, AdmissionDate, DischargeDate)

DATEDIFF(day, PreviousAppointmentDate, AppointmentDate)

DATEDIFF(day, AppointmentDate, NextAppointmentDate)
```

---

## 14. LEAD() + DATEDIFF()

Calculated the number of days from the current appointment to the patient's next appointment.

```sql
SELECT AppointmentID,
       PatientID,
       AppointmentDate,
       LEAD(AppointmentDate) OVER (
           PARTITION BY PatientID
           ORDER BY AppointmentDate
       ) AS NextAppointmentDate,
       DATEDIFF(
           day,
           AppointmentDate,
           LEAD(AppointmentDate) OVER (
               PARTITION BY PatientID
               ORDER BY AppointmentDate
           )
       ) AS DaysUntilNextAppointment
FROM Appointments;
```

---

## 15. NHS Challenge – Most Recent Attended Appointment per Patient

Used a CTE and `ROW_NUMBER()` to find the most recent qualifying attended appointment for each patient.

```sql
WITH RecentAppointments AS (
    SELECT AppointmentID,
           PatientID,
           Specialty,
           AppointmentDate,
           HospitalSite,
           ROW_NUMBER() OVER (
               PARTITION BY PatientID
               ORDER BY AppointmentDate DESC
           ) AS MostRecentAppointment
    FROM Appointments
    WHERE Status = 'Attended'
      AND YEAR(AppointmentDate) = 2026
      AND Specialty IN ('Cardiology', 'Neurology', 'Oncology')
      AND HospitalSite <> 'Site C'
)

SELECT AppointmentID,
       PatientID,
       Specialty,
       AppointmentDate,
       HospitalSite
FROM RecentAppointments
WHERE MostRecentAppointment = 1;
```

---

## 16. NHS Challenge – Urgent Waiting List Ranking

Ranked currently waiting urgent patients separately within each specialty.

Patients with the same waiting time receive the same position without skipping the next position.

```sql
SELECT PatientID,
       Specialty,
       ReferralDate,
       WaitingDays,
       DENSE_RANK() OVER (
           PARTITION BY Specialty
           ORDER BY WaitingDays DESC
       ) AS WaitingPosition
FROM WaitingList
WHERE AppointmentDate IS NULL
  AND Priority = 'Urgent'
  AND YEAR(ReferralDate) = 2026
  AND HospitalSite <> 'Site C';
```

---

## 17. Final NHS Window Function Challenge

Combined:

- CTE
- LAG()
- DATEDIFF()
- ROW_NUMBER()
- PARTITION BY
- ORDER BY
- Date filtering
- Status filtering
- Specialty filtering
- Hospital-site filtering

```sql
WITH AppointmentHistory AS (
    SELECT AppointmentID,
           PatientID,
           Specialty,
           AppointmentDate,
           LAG(AppointmentDate) OVER (
               PARTITION BY PatientID
               ORDER BY AppointmentDate
           ) AS PreviousAppointmentDate
    FROM Appointments
    WHERE Status = 'Attended'
      AND YEAR(AppointmentDate) = 2026
      AND Specialty IN ('Cardiology', 'Neurology', 'Oncology')
      AND HospitalSite <> 'Site C'
)

SELECT AppointmentID,
       PatientID,
       Specialty,
       AppointmentDate,
       PreviousAppointmentDate,
       DATEDIFF(
           day,
           PreviousAppointmentDate,
           AppointmentDate
       ) AS DaysSincePreviousAppointment,
       ROW_NUMBER() OVER (
           PARTITION BY PatientID
           ORDER BY AppointmentDate
       ) AS AppointmentNumber
FROM AppointmentHistory
ORDER BY PatientID,
         AppointmentDate;
```

---

# Key Takeaways

Today I learned how to choose Window Functions based on business requirements:

| Business Requirement | SQL Approach |
|---|---|
| Need summary rows | `GROUP BY` |
| Need calculations while keeping detail rows | Window Function |
| Count within a group without collapsing rows | `COUNT() OVER()` |
| Group average while keeping rows | `AVG() OVER()` |
| Group total while keeping rows | `SUM() OVER()` |
| Unique position for every row | `ROW_NUMBER()` |
| Ranking with ties + gaps | `RANK()` |
| Ranking with ties + no gaps | `DENSE_RANK()` |
| Previous record | `LAG()` |
| Next record | `LEAD()` |
| Running/cumulative total | `SUM() OVER (ORDER BY ...)` |
| Latest record per patient | CTE + `ROW_NUMBER()` + `WHERE RowNumber = 1` |
| Days between records | `LAG()`/`LEAD()` + `DATEDIFF()` |

---

## Window Function Syntax Patterns

```sql
-- Aggregate while keeping rows
COUNT(*) OVER (PARTITION BY ColumnName)

-- Unique row numbering
ROW_NUMBER() OVER (
    PARTITION BY ColumnName
    ORDER BY DateColumn DESC
)

-- Ranking with gaps
RANK() OVER (
    PARTITION BY ColumnName
    ORDER BY ValueColumn DESC
)

-- Ranking without gaps
DENSE_RANK() OVER (
    PARTITION BY ColumnName
    ORDER BY ValueColumn DESC
)

-- Previous record
LAG(ColumnName) OVER (
    PARTITION BY GroupColumn
    ORDER BY DateColumn
)

-- Next record
LEAD(ColumnName) OVER (
    PARTITION BY GroupColumn
    ORDER BY DateColumn
)

-- Running total
SUM(ValueColumn) OVER (
    PARTITION BY GroupColumn
    ORDER BY DateColumn
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

---

# Progress

**Window Functions: Completed**

Today's practice covered Window Functions from the fundamentals through mixed NHS-style reporting scenarios.

## Next Step

Final SQL consolidation using NHS-style business requirements, combining:

- JOINs
- CTEs
- Subqueries
- Aggregations
- GROUP BY / HAVING
- Date functions
- String and data-cleaning functions
- NULL handling
- CAST / CONVERT
- Window Functions
- Multi-step business requirements
