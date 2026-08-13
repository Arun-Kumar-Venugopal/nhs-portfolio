/*
==========================================================
SQL LEARNING JOURNEY — NHS / HEALTHCARE DATA ANALYTICS
==========================================================

Topics completed:
1. SELECT
2. WHERE
3. Comparison operators
4. AND / OR / NOT
5. BETWEEN
6. IN / NOT IN
7. LIKE / NOT LIKE
8. NULL handling
9. ORDER BY
10. LIMIT
11. Aggregate functions
12. DISTINCT
13. GROUP BY
14. HAVING
15. CASE WHEN
16. Conditional aggregation
17. Percentage calculations
18. INNER JOIN
19. LEFT JOIN
20. RIGHT JOIN
21. FULL OUTER JOIN
22. Multiple-table JOINs
23. JOIN row multiplication
24. UNION
25. UNION ALL
26. Single-value subqueries
27. Multiple-value subqueries with IN
28. NOT IN subqueries
29. EXISTS
30. NOT EXISTS
31. Nested subqueries

Healthcare tables used:
- Patients
- Appointments
- Referrals
- Admissions
- WaitingList
*/


-- ========================================================
-- 1. SELECT
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Age
FROM Patients;


-- ========================================================
-- 2. WHERE
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Age
FROM Patients
WHERE Age >= 50;


-- ========================================================
-- 3. AND
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Age
FROM Patients
WHERE Age >= 50
  AND Email IS NOT NULL;


-- ========================================================
-- 4. OR
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName
FROM Patients
WHERE LastName LIKE 'S%'
   OR LastName LIKE 'M%';


-- ========================================================
-- 5. BETWEEN
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Age
FROM Patients
WHERE Age BETWEEN 40 AND 80;


-- Date BETWEEN

SELECT AppointmentID,
       PatientID,
       AppointmentDate,
       Specialty
FROM Appointments
WHERE AppointmentDate
      BETWEEN '2026-01-01' AND '2026-07-31';


-- ========================================================
-- 6. IN
-- ========================================================

SELECT AppointmentID,
       PatientID,
       Specialty
FROM Appointments
WHERE Specialty IN (
    'Cardiology',
    'Neurology',
    'Oncology'
);


-- ========================================================
-- 7. NOT IN
-- ========================================================

SELECT AppointmentID,
       PatientID,
       Specialty
FROM Appointments
WHERE Specialty NOT IN (
    'Dermatology',
    'Ophthalmology'
);


-- ========================================================
-- 8. LIKE
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName
FROM Patients
WHERE LastName LIKE 'S%';


-- Multiple LIKE conditions

SELECT PatientID,
       FirstName,
       LastName
FROM Patients
WHERE LastName LIKE 'M%'
   OR LastName LIKE 'S%';


-- ========================================================
-- 9. NOT LIKE
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName
FROM Patients
WHERE FirstName NOT LIKE 'A%';


-- ========================================================
-- 10. NULL
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Email
FROM Patients
WHERE Email IS NOT NULL;


-- Currently waiting patients

SELECT PatientID,
       Specialty,
       WaitingDays
FROM WaitingList
WHERE AppointmentDate IS NULL;


-- ========================================================
-- 11. ORDER BY
-- ========================================================

SELECT PatientID,
       Age
FROM Patients
ORDER BY Age DESC;


-- Multiple sorting levels

SELECT Specialty,
       Status
FROM Appointments
ORDER BY Specialty ASC,
         Status ASC;


-- ========================================================
-- 12. LIMIT
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Age
FROM Patients
ORDER BY Age DESC
LIMIT 5;


-- ========================================================
-- 13. AGGREGATE FUNCTIONS
-- COUNT / AVG / MIN / MAX / SUM
-- ========================================================

SELECT COUNT(*) AS TotalPatients
FROM Patients;


SELECT AVG(Age) AS AverageAge
FROM Patients;


SELECT MIN(Age) AS YoungestPatient,
       MAX(Age) AS OldestPatient
FROM Patients;


-- ========================================================
-- 14. DISTINCT
-- ========================================================

SELECT DISTINCT Specialty
FROM Appointments;


-- Count unique patients

SELECT COUNT(DISTINCT PatientID) AS UniquePatients
FROM Appointments;


/*
IMPORTANT:

SELECT DISTINCT
→ removes duplicate output combinations

COUNT(DISTINCT column)
→ counts unique values

Do not use DISTINCT automatically just because
multiple rows exist.

First ask:

"What should one output row represent?"
*/


-- ========================================================
-- 15. GROUP BY
-- ========================================================

SELECT Specialty,
       COUNT(DISTINCT PatientID) AS UniquePatients
FROM Appointments
GROUP BY Specialty;


/*
One result row represents one Specialty.
*/


-- ========================================================
-- 16. HAVING
-- ========================================================

SELECT Specialty,
       COUNT(DISTINCT PatientID) AS UniquePatients
FROM Appointments
GROUP BY Specialty
HAVING COUNT(DISTINCT PatientID) > 10;


/*
WHERE
→ filters individual rows BEFORE grouping

HAVING
→ filters groups AFTER aggregation
*/


-- ========================================================
-- 17. CASE WHEN
-- ========================================================

SELECT Specialty,

       COUNT(CASE
           WHEN Status = 'Attended'
           THEN AppointmentID
       END) AS AttendedAppointments,

       COUNT(CASE
           WHEN Status = 'Cancelled'
           THEN AppointmentID
       END) AS CancelledAppointments

FROM Appointments
GROUP BY Specialty;


-- ========================================================
-- 18. CONDITIONAL AGGREGATION + DISTINCT
-- ========================================================

SELECT Specialty,

       COUNT(DISTINCT PatientID)
           AS UniquePatients,

       COUNT(DISTINCT AppointmentID)
           AS TotalAppointments,

       COUNT(DISTINCT CASE
           WHEN Status = 'Attended'
           THEN AppointmentID
       END) AS AttendedAppointments,

       COUNT(DISTINCT CASE
           WHEN Status = 'Cancelled'
           THEN AppointmentID
       END) AS CancelledAppointments

FROM Appointments
GROUP BY Specialty;


-- ========================================================
-- 19. PERCENTAGE CALCULATION
-- ========================================================

SELECT Specialty,

       COUNT(DISTINCT AppointmentID)
           AS TotalAppointments,

       COUNT(DISTINCT CASE
           WHEN Status = 'Cancelled'
           THEN AppointmentID
       END) AS CancelledAppointments,

       COUNT(DISTINCT CASE
           WHEN Status = 'Cancelled'
           THEN AppointmentID
       END) * 100.0
       / COUNT(DISTINCT AppointmentID)
           AS CancellationPercentage

FROM Appointments
GROUP BY Specialty;


/*
Percentage pattern:

PART * 100.0 / TOTAL

Example:

Cancelled appointments
----------------------  × 100
Total appointments
*/


-- ========================================================
-- 20. INNER JOIN
-- ========================================================

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       a.AppointmentDate,
       a.Specialty
FROM Patients p
INNER JOIN Appointments a
    ON p.PatientID = a.PatientID;


/*
INNER JOIN:

Return only records where a match exists
in BOTH tables.
*/


-- ========================================================
-- 21. LEFT JOIN
-- ========================================================

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       a.AppointmentDate
FROM Patients p
LEFT JOIN Appointments a
    ON p.PatientID = a.PatientID;


/*
LEFT JOIN:

Keep ALL rows from the left/main table.

If no matching appointment exists,
appointment columns become NULL.
*/


-- Find patients with no appointment

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       p.Age
FROM Patients p
LEFT JOIN Appointments a
    ON p.PatientID = a.PatientID
WHERE a.AppointmentID IS NULL;


-- ========================================================
-- 22. RIGHT JOIN
-- ========================================================

SELECT a.AppointmentID,
       a.AppointmentDate,
       a.Specialty,
       p.PatientID,
       p.FirstName,
       p.LastName
FROM Patients p
RIGHT JOIN Appointments a
    ON p.PatientID = a.PatientID;


/*
RIGHT JOIN:

Keep all rows from the RIGHT table.
*/


-- ========================================================
-- 23. FULL OUTER JOIN
-- ========================================================

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       r.ReferralID,
       r.ReferralDate,
       r.Specialty
FROM Patients p
FULL OUTER JOIN Referrals r
    ON p.PatientID = r.PatientID;


/*
FULL OUTER JOIN:

Matched rows
+
unmatched Patients
+
unmatched Referrals
*/


-- ========================================================
-- 24. CONDITIONS INSIDE LEFT JOIN ON
-- ========================================================

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       a.AppointmentDate,
       a.Specialty,
       a.Status
FROM Patients p
LEFT JOIN Appointments a
    ON p.PatientID = a.PatientID
   AND a.Specialty = 'Cardiology';


/*
Putting the condition inside ON allows us
to keep all Patients while matching only
Cardiology appointments.
*/


-- ========================================================
-- 25. MULTIPLE TABLE JOINS
-- ========================================================

SELECT p.PatientID,

       COUNT(DISTINCT r.ReferralID)
           AS UniqueReferrals,

       COUNT(DISTINCT a.AppointmentID)
           AS UniqueAppointments

FROM Patients p

LEFT JOIN Referrals r
    ON p.PatientID = r.PatientID

LEFT JOIN Appointments a
    ON p.PatientID = a.PatientID

GROUP BY p.PatientID;


/*
JOIN MULTIPLICATION:

If one patient has:

2 referrals
3 appointments

JOIN may produce:

2 × 3 = 6 rows

Therefore:

COUNT(r.ReferralID)
could overcount.

Use:

COUNT(DISTINCT r.ReferralID)

COUNT(DISTINCT a.AppointmentID)
*/


-- ========================================================
-- 26. GROUPED HEALTHCARE REPORT
-- ========================================================

SELECT a.Specialty,

       COUNT(DISTINCT p.PatientID)
           AS UniquePatients,

       COUNT(DISTINCT a.AppointmentID)
           AS TotalAppointments,

       COUNT(DISTINCT CASE
           WHEN a.Status = 'Attended'
           THEN a.AppointmentID
       END) AS AttendedAppointments,

       COUNT(DISTINCT CASE
           WHEN a.Status = 'Cancelled'
           THEN a.AppointmentID
       END) AS CancelledAppointments,

       COUNT(DISTINCT CASE
           WHEN a.Status = 'Cancelled'
           THEN a.AppointmentID
       END) * 100.0
       / COUNT(DISTINCT a.AppointmentID)
           AS CancellationPercentage,

       AVG(p.Age)
           AS AveragePatientAge

FROM Appointments a

INNER JOIN Patients p
    ON a.PatientID = p.PatientID

WHERE p.Age BETWEEN 40 AND 80
  AND a.AppointmentDate
      BETWEEN '2026-01-01' AND '2026-07-31'
  AND a.HospitalSite <> 'Site C'
  AND a.Status IN ('Attended', 'Cancelled')

GROUP BY a.Specialty

HAVING COUNT(DISTINCT p.PatientID) > 10

ORDER BY CancellationPercentage DESC;


/*
IMPORTANT AVERAGE AGE ISSUE:

AVG(p.Age)

can overweight patients who have
multiple appointments/referrals.

AVG(DISTINCT p.Age)

is NOT the correct fix because it removes
duplicate AGE VALUES, not duplicate PATIENTS.

Example:

Patient 101 = age 50
Patient 102 = age 50
Patient 103 = age 70

Correct average:

(50 + 50 + 70) / 3 = 56.67

AVG(DISTINCT Age):

(50 + 70) / 2 = 60  -- WRONG

Correct solution requires first creating
one row per PatientID per group.

We will solve this properly using CTEs.
*/


-- ========================================================
-- 27. UNION
-- ========================================================

SELECT PatientID,
       Specialty
FROM Referrals

UNION

SELECT PatientID,
       Specialty
FROM WaitingList;


/*
UNION:
Stack rows and remove duplicate rows.
*/


-- ========================================================
-- 28. UNION ALL
-- ========================================================

SELECT PatientID,
       Specialty,
       Priority
FROM Referrals

UNION ALL

SELECT PatientID,
       Specialty,
       Priority
FROM WaitingList;


/*
UNION ALL:
Stack rows and KEEP duplicates.
*/


-- ========================================================
-- 29. ADD SOURCE LABEL WITH UNION ALL
-- ========================================================

SELECT PatientID,
       Specialty,
       Priority,
       ReferralDate,
       'Referral' AS Source
FROM Referrals

UNION ALL

SELECT PatientID,
       Specialty,
       Priority,
       ReferralDate,
       'Waiting List' AS Source
FROM WaitingList;


/*
Source will show where each row came from.

Example:

101 | Cardiology | Urgent | 2026-02-01 | Referral

105 | Neurology  | Urgent | 2026-03-10 | Waiting List
*/


-- ========================================================
-- 30. SINGLE-VALUE SUBQUERY
-- ========================================================

SELECT PatientID,
       Ward,
       AdmissionType,
       LengthOfStay
FROM Admissions
WHERE LengthOfStay > (
    SELECT AVG(LengthOfStay)
    FROM Admissions
);


/*
Inner query returns ONE value.

Example:

AVG(LengthOfStay) = 8

Outer query effectively becomes:

WHERE LengthOfStay > 8
*/


-- ========================================================
-- 31. SINGLE-VALUE SUBQUERY
-- SAME COMPARISON POPULATION
-- ========================================================

SELECT PatientID,
       Specialty,
       Priority,
       WaitingDays
FROM WaitingList
WHERE Priority = 'Urgent'
  AND WaitingDays > (
      SELECT AVG(WaitingDays)
      FROM WaitingList
      WHERE Priority = 'Urgent'
  );


/*
Outer:
Urgent patients

Inner:
Average of Urgent patients
*/


-- ========================================================
-- 32. DIFFERENT OUTER AND INNER POPULATIONS
-- ========================================================

SELECT PatientID,
       Specialty,
       Priority,
       WaitingDays
FROM WaitingList
WHERE Priority = 'Urgent'
  AND Specialty = 'Cardiology'
  AND AppointmentDate IS NULL
  AND WaitingDays > (
      SELECT AVG(WaitingDays)
      FROM WaitingList
      WHERE AppointmentDate IS NULL
  );


/*
Outer:
Urgent Cardiology patients currently waiting

Inner:
Average waiting time of ALL currently
waiting patients
*/


-- ========================================================
-- 33. MULTIPLE-VALUE SUBQUERY — IN
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Age
FROM Patients
WHERE PatientID IN (
    SELECT PatientID
    FROM Referrals
    WHERE Priority = 'Urgent'
      AND ReferralDate
          BETWEEN '2026-01-01' AND '2026-07-31'
);


/*
IN:

Inner query returns MANY values.

Example:

101
105
108

Outer query asks:

Is PatientID IN (101,105,108)?
*/


-- ========================================================
-- 34. IN WITH OUTER + INNER CONDITIONS
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Age
FROM Patients
WHERE Age BETWEEN 50 AND 80
  AND PatientID IN (
      SELECT PatientID
      FROM Appointments
      WHERE Specialty = 'Cardiology'
        AND Status = 'Attended'
        AND AppointmentDate
            BETWEEN '2026-01-01' AND '2026-07-31'
        AND HospitalSite <> 'Site C'
  );


-- ========================================================
-- 35. NOT IN
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Age
FROM Patients
WHERE PatientID NOT IN (
    SELECT PatientID
    FROM Appointments
    WHERE Specialty = 'Cardiology'
);


/*
NOT IN:

Inner query finds patients who HAVE Cardiology.

Outer query removes them.

Important:

This is NOT equivalent to:

WHERE PatientID IN (
    SELECT PatientID
    FROM Appointments
    WHERE Specialty <> 'Cardiology'
)

because a patient could have BOTH
Cardiology and Neurology appointments.
*/


-- ========================================================
-- 36. NOT IN — HEALTHCARE EXAMPLE
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Age,
       Email
FROM Patients
WHERE Age BETWEEN 50 AND 80
  AND Email IS NOT NULL
  AND PatientID NOT IN (
      SELECT PatientID
      FROM Admissions
      WHERE AdmissionType = 'Emergency'
        AND AdmissionDate
            BETWEEN '2026-01-01' AND '2026-07-31'
        AND LengthOfStay > 5
        AND HospitalSite <> 'Site C'
  );


-- ========================================================
-- 37. EXISTS
-- ========================================================

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       p.Age
FROM Patients p
WHERE EXISTS (
    SELECT 1
    FROM Appointments a
    WHERE a.PatientID = p.PatientID
      AND a.Specialty = 'Cardiology'
);


/*
EXISTS:

For EACH patient:

Does at least ONE matching row exist?

YES → keep patient
NO  → remove patient


SELECT 1 does NOT return 1 to the outer query.

EXISTS only cares whether the subquery
found at least one row.

Think:

IN
→ Is this ID in a list?

EXISTS
→ Does a matching row exist for THIS patient?
*/


-- ========================================================
-- 38. EXISTS — MEDIUM EXAMPLE
-- ========================================================

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       p.Age,
       p.Email
FROM Patients p
WHERE p.Age BETWEEN 50 AND 80
  AND p.Email IS NOT NULL
  AND EXISTS (
      SELECT 1
      FROM Appointments a
      WHERE a.PatientID = p.PatientID
        AND a.Specialty = 'Cardiology'
        AND a.Status = 'Attended'
        AND a.AppointmentDate
            BETWEEN '2026-01-01' AND '2026-07-31'
        AND a.HospitalSite <> 'Site C'
  );


-- ========================================================
-- 39. EXISTS — HEALTHCARE EXAMPLE
-- ========================================================

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       p.Age,
       p.Email
FROM Patients p
WHERE p.Age BETWEEN 50 AND 80
  AND p.Email IS NOT NULL
  AND EXISTS (
      SELECT 1
      FROM Referrals r
      WHERE r.PatientID = p.PatientID
        AND r.Priority = 'Urgent'
        AND r.ReferralDate
            BETWEEN '2026-01-01' AND '2026-07-31'
        AND r.Specialty IN (
            'Cardiology',
            'Neurology',
            'Oncology'
        )
        AND r.HospitalSite <> 'Site C'
  );


-- ========================================================
-- 40. NOT EXISTS
-- ========================================================

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       p.Age
FROM Patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM Appointments a
    WHERE a.PatientID = p.PatientID
      AND a.Specialty = 'Cardiology'
);


/*
NOT EXISTS:

For EACH patient:

Does a Cardiology appointment exist?

YES
→ EXISTS = TRUE
→ NOT EXISTS = FALSE
→ exclude patient

NO
→ EXISTS = FALSE
→ NOT EXISTS = TRUE
→ keep patient
*/


-- ========================================================
-- 41. NOT EXISTS — REFERRALS
-- ========================================================

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       p.Age,
       p.Email
FROM Patients p
WHERE p.Age BETWEEN 50 AND 80
  AND p.Email IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM Referrals r
      WHERE r.PatientID = p.PatientID
        AND r.Priority = 'Urgent'
        AND r.Specialty = 'Cardiology'
        AND r.ReferralDate
            BETWEEN '2026-01-01' AND '2026-07-31'
  );


-- ========================================================
-- 42. NOT EXISTS — NHS DNA EXAMPLE
-- ========================================================

SELECT p.PatientID,
       p.FirstName,
       p.LastName,
       p.Age,
       p.Email
FROM Patients p
WHERE p.Age BETWEEN 50 AND 80
  AND p.Email IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM Appointments a
      WHERE a.PatientID = p.PatientID
        AND a.Status = 'Did Not Attend'
        AND a.AppointmentDate
            BETWEEN '2026-01-01' AND '2026-07-31'
        AND a.Specialty IN (
            'Cardiology',
            'Neurology',
            'Oncology'
        )
        AND a.HospitalSite <> 'Site C'
  );


-- ========================================================
-- 43. NESTED SUBQUERY
-- IN + SINGLE-VALUE AVG SUBQUERY
-- ========================================================

SELECT PatientID,
       FirstName,
       LastName,
       Age,
       Email
FROM Patients
WHERE Age BETWEEN 50 AND 80
  AND Email IS NOT NULL
  AND PatientID IN (

      SELECT PatientID
      FROM WaitingList

      WHERE AppointmentDate IS NULL
        AND Priority = 'Urgent'
        AND Specialty IN (
            'Cardiology',
            'Neurology',
            'Oncology'
        )
        AND ReferralDate
            BETWEEN '2026-01-01' AND '2026-07-31'
        AND HospitalSite <> 'Site C'

        AND WaitingDays > (

            SELECT AVG(WaitingDays)
            FROM WaitingList
            WHERE AppointmentDate IS NULL

        )
  );


/*
Read nested subqueries INSIDE → OUT.

STEP 1:
Calculate average WaitingDays
of all currently waiting patients.

STEP 2:
Find WaitingList PatientIDs satisfying
the business conditions and above average.

STEP 3:
Return patient details for those IDs.
*/


-- ========================================================
-- SQL DECISION FRAMEWORK
-- ========================================================

/*

QUESTION 1:

Do I need columns from BOTH tables?

YES
→ JOIN


QUESTION 2:

Do I need final columns from ONE table,
but another table determines who qualifies?

YES
→ SUBQUERY


QUESTION 3:

Am I stacking similar rows from
multiple datasets?

YES
→ UNION / UNION ALL


----------------------------------------------------------

JOIN CHOICE:

Need only matched rows
→ INNER JOIN

Need all rows from main/left table
even if no match exists
→ LEFT JOIN


----------------------------------------------------------

SUBQUERY CHOICE:

Inner query returns ONE value
→ comparison operator

Example:

WHERE WaitingDays > (
    SELECT AVG(WaitingDays)
)


Inner query returns MANY values
→ IN

Example:

WHERE PatientID IN (
    SELECT PatientID ...
)


Need to exclude IDs from a returned list
→ NOT IN


Need to ask:

"Does at least one matching row exist
for THIS patient?"

→ EXISTS


Need to ask:

"Does NO matching row exist
for THIS patient?"

→ NOT EXISTS


----------------------------------------------------------

DISTINCT:

Need unique displayed values
→ SELECT DISTINCT

Need number of unique things
→ COUNT(DISTINCT column)

JOIN creates duplicate IDs while counting
→ COUNT(DISTINCT ID)

Do NOT automatically use DISTINCT
just because multiple rows appear.


----------------------------------------------------------

MOST IMPORTANT QUESTION BEFORE WRITING SQL:

"What should ONE output row represent?"

Examples:

One patient
One appointment
One referral
One admission
One specialty
One hospital site

This determines the grain of the report.

*/


-- ========================================================
-- SQL LOGICAL EXECUTION ORDER
-- ========================================================

/*

A useful simplified order:

1. FROM
2. JOIN / ON
3. WHERE
4. GROUP BY
5. HAVING
6. SELECT
7. DISTINCT
8. ORDER BY
9. LIMIT

*/


-- ========================================================
-- CURRENT PROGRESS
-- ========================================================

/*

COMPLETED:

SELECT
WHERE
AND / OR / NOT
BETWEEN
IN / NOT IN
LIKE / NOT LIKE
NULL
ORDER BY
LIMIT
DISTINCT

COUNT
SUM
AVG
MIN
MAX

GROUP BY
HAVING

CASE WHEN
Conditional aggregation
Percentage calculations

INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL OUTER JOIN
Multiple JOINs
JOIN multiplication awareness

UNION
UNION ALL

Single-value subqueries
IN subqueries
NOT IN subqueries
EXISTS
NOT EXISTS
Nested subqueries


NEXT:

CTEs (WITH)
Date functions
String / data-cleaning functions
COALESCE
CAST
Window functions
Final NHS-style mixed SQL practice

==========================================================
*/
