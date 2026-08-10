/*
=========================================================
DAY 6 - SQL PRACTICE
NHS Data Analytics Portfolio Preparation

Topics practised:
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL OUTER JOIN
- Multi-table JOINs
- JOIN row multiplication
- COUNT(DISTINCT)
- Conditional aggregation
- UNION
- UNION ALL
- Source columns
- Subqueries
=========================================================
*/


-- =====================================================
-- 1. FULL OUTER JOIN
-- Combine patients and referrals, including unmatched
-- records from both tables
-- =====================================================

SELECT
    p.PatientID,
    p.FirstName,
    p.LastName,
    r.ReferralID,
    r.ReferralDate,
    r.Specialty
FROM Patients p
FULL OUTER JOIN Referrals r
    ON p.PatientID = r.PatientID;


-- =====================================================
-- 2. JOIN ROW MULTIPLICATION
-- Count unique referrals and appointments per patient
-- COUNT(DISTINCT) protects counts when JOINs multiply rows
-- =====================================================

SELECT
    p.PatientID,
    COUNT(DISTINCT r.ReferralID) AS UniqueReferrals,
    COUNT(DISTINCT a.AppointmentID) AS UniqueAppointments
FROM Patients p
LEFT JOIN Referrals r
    ON p.PatientID = r.PatientID
LEFT JOIN Appointments a
    ON p.PatientID = a.PatientID
GROUP BY p.PatientID;


-- =====================================================
-- 3. UNIQUE REFERRALS AND ATTENDED APPOINTMENTS
-- Patients aged 40+
-- =====================================================

SELECT
    p.PatientID,
    p.FirstName,
    p.LastName,
    COUNT(DISTINCT r.ReferralID) AS UniqueReferrals,
    COUNT(
        DISTINCT CASE
            WHEN a.Status = 'Attended'
            THEN a.AppointmentID
        END
    ) AS UniqueAttendedAppointments
FROM Patients p
LEFT JOIN Referrals r
    ON p.PatientID = r.PatientID
LEFT JOIN Appointments a
    ON p.PatientID = a.PatientID
WHERE p.Age >= 40
GROUP BY
    p.PatientID,
    p.FirstName,
    p.LastName;


-- =====================================================
-- 4. FULL CONSOLIDATION CHALLENGE
-- Patients + Referrals + Appointments
-- =====================================================

SELECT
    a.Specialty,
    COUNT(DISTINCT p.PatientID) AS UniquePatients,
    COUNT(DISTINCT r.ReferralID) AS TotalReferrals,

    COUNT(
        DISTINCT CASE
            WHEN r.Priority = 'Urgent'
            THEN r.ReferralID
        END
    ) AS UrgentReferrals,

    COUNT(
        DISTINCT CASE
            WHEN a.Status = 'Attended'
            THEN a.AppointmentID
        END
    ) AS AttendedAppointments,

    COUNT(
        DISTINCT CASE
            WHEN a.Status = 'Cancelled'
            THEN a.AppointmentID
        END
    ) AS CancelledAppointments,

    COUNT(
        DISTINCT CASE
            WHEN a.Status = 'Cancelled'
            THEN a.AppointmentID
        END
    ) * 100.0
        / COUNT(DISTINCT a.AppointmentID)
        AS CancellationPercentage,

    AVG(p.Age) AS AverageAge,
    MIN(p.Age) AS YoungestPatient,
    MAX(p.Age) AS OldestPatient

FROM Patients p
INNER JOIN Referrals r
    ON p.PatientID = r.PatientID
INNER JOIN Appointments a
    ON p.PatientID = a.PatientID

WHERE p.Age BETWEEN 40 AND 80
  AND (p.LastName LIKE 'S%' OR p.LastName LIKE 'P%')
  AND p.FirstName NOT LIKE 'A%'
  AND p.Email IS NOT NULL
  AND r.Priority IN ('Urgent', 'Routine')
  AND r.ReferralDate BETWEEN '2026-01-01' AND '2026-07-31'
  AND r.ReferralStatus <> 'Cancelled'
  AND a.Specialty NOT IN ('Dermatology', 'Ophthalmology')
  AND a.AppointmentDate BETWEEN '2026-01-01' AND '2026-07-31'
  AND a.HospitalSite <> 'Site C'

GROUP BY a.Specialty

HAVING COUNT(DISTINCT p.PatientID) > 5
   AND AVG(p.Age) > 45

ORDER BY
    CancellationPercentage DESC,
    AverageAge DESC

LIMIT 5;


-- =====================================================
-- 5. NHS ADMISSIONS + APPOINTMENTS CHALLENGE
-- INNER JOIN because patients must have both
-- admission and appointment activity
-- =====================================================

SELECT
    ad.Ward,
    COUNT(DISTINCT p.PatientID) AS UniquePatients,
    COUNT(DISTINCT ad.AdmissionID) AS TotalAdmissions,

    COUNT(
        DISTINCT CASE
            WHEN ad.AdmissionType = 'Emergency'
            THEN ad.AdmissionID
        END
    ) AS EmergencyAdmissions,

    AVG(ad.LengthOfStay) AS AverageLengthOfStay,
    MAX(ad.LengthOfStay) AS LongestStay,

    COUNT(
        DISTINCT CASE
            WHEN ap.Status = 'Attended'
            THEN ap.AppointmentID
        END
    ) AS AttendedAppointments,

    COUNT(
        DISTINCT CASE
            WHEN ap.Status = 'Did Not Attend'
            THEN ap.AppointmentID
        END
    ) AS DNAAppointments,

    COUNT(
        DISTINCT CASE
            WHEN ap.Status = 'Did Not Attend'
            THEN ap.AppointmentID
        END
    ) * 100.0
        / COUNT(DISTINCT ap.AppointmentID)
        AS DNAPercentage

FROM Patients p
INNER JOIN Admissions ad
    ON p.PatientID = ad.PatientID
INNER JOIN Appointments ap
    ON p.PatientID = ap.PatientID

WHERE p.Age BETWEEN 30 AND 80
  AND (p.LastName LIKE 'M%' OR p.LastName LIKE 'S%')
  AND p.Email IS NOT NULL

  AND ad.AdmissionDate BETWEEN '2026-01-01' AND '2026-07-31'
  AND ad.AdmissionType IN ('Emergency', 'Urgent')
  AND ad.DischargeDate IS NOT NULL
  AND ad.HospitalSite <> 'Site C'
  AND ad.LengthOfStay BETWEEN 2 AND 40

  AND ap.AppointmentDate BETWEEN '2026-01-01' AND '2026-07-31'
  AND ap.Specialty NOT IN ('Dermatology', 'Ophthalmology')
  AND ap.Status IN ('Attended', 'Did Not Attend')
  AND ap.HospitalSite <> 'Site C'

GROUP BY ad.Ward

HAVING COUNT(DISTINCT p.PatientID) > 5
   AND AVG(ad.LengthOfStay) > 5

ORDER BY
    DNAPercentage DESC,
    AverageLengthOfStay DESC

LIMIT 5;


-- =====================================================
-- 6. UNION
-- Combine Referrals and WaitingList
-- Remove duplicate PatientID + Specialty combinations
-- =====================================================

SELECT
    PatientID,
    Specialty
FROM Referrals

UNION

SELECT
    PatientID,
    Specialty
FROM WaitingList;


-- =====================================================
-- 7. UNION ALL
-- Keep all rows including duplicates
-- Apply same filters to both datasets
-- =====================================================

SELECT
    PatientID,
    Specialty,
    Priority
FROM Referrals
WHERE Priority = 'Urgent'
  AND Specialty IN ('Cardiology', 'Neurology', 'Oncology')
  AND ReferralDate BETWEEN '2026-01-01' AND '2026-07-31'

UNION ALL

SELECT
    PatientID,
    Specialty,
    Priority
FROM WaitingList
WHERE Priority = 'Urgent'
  AND Specialty IN ('Cardiology', 'Neurology', 'Oncology')
  AND ReferralDate BETWEEN '2026-01-01' AND '2026-07-31';


-- =====================================================
-- 8. UNION + DIFFERENT FILTERS + ORDER BY
-- ORDER BY sorts the final combined result
-- =====================================================

SELECT
    PatientID,
    Specialty,
    Priority,
    ReferralDate
FROM Referrals
WHERE Priority = 'Urgent'
  AND Specialty = 'Cardiology'

UNION

SELECT
    PatientID,
    Specialty,
    Priority,
    ReferralDate
FROM WaitingList
WHERE Priority = 'Routine'
  AND Specialty = 'Neurology'

ORDER BY ReferralDate DESC;


-- =====================================================
-- 9. UNION ALL + SOURCE COLUMN
-- Create a label showing where each record came from
-- =====================================================

SELECT
    PatientID,
    Specialty,
    Priority,
    ReferralDate,
    'Referral' AS Source
FROM Referrals
WHERE Specialty IN ('Cardiology', 'Neurology', 'Oncology')
  AND Priority = 'Urgent'
  AND ReferralDate BETWEEN '2026-01-01' AND '2026-07-31'
  AND HospitalSite <> 'Site C'

UNION ALL

SELECT
    PatientID,
    Specialty,
    Priority,
    ReferralDate,
    'Waiting List' AS Source
FROM WaitingList
WHERE Specialty IN ('Cardiology', 'Neurology', 'Oncology')
  AND Priority = 'Urgent'
  AND ReferralDate BETWEEN '2026-01-01' AND '2026-07-31'
  AND HospitalSite <> 'Site C';


-- =====================================================
-- 10. SUBQUERY
-- Patients waiting longer than the overall average
-- =====================================================

SELECT
    PatientID,
    Specialty,
    Priority,
    WaitingDays
FROM WaitingList
WHERE WaitingDays > (
    SELECT AVG(WaitingDays)
    FROM WaitingList
);


-- =====================================================
-- 11. SUBQUERY WITH FILTERS
-- Emergency admissions with LOS above the average
-- Emergency LOS for the same reporting period
-- =====================================================

SELECT
    PatientID,
    Ward,
    AdmissionType,
    LengthOfStay,
    AdmissionDate
FROM Admissions
WHERE AdmissionType = 'Emergency'
  AND AdmissionDate BETWEEN '2026-01-01' AND '2026-07-31'
  AND LengthOfStay > (
      SELECT AVG(LengthOfStay)
      FROM Admissions
      WHERE AdmissionType = 'Emergency'
        AND AdmissionDate BETWEEN '2026-01-01' AND '2026-07-31'
  );


-- =====================================================
-- 12. SUBQUERY WITH DIFFERENT INNER/OUTER FILTERS
--
-- Outer query:
-- Urgent Cardiology patients referred Jan-Jul
--
-- Inner query:
-- Average waiting time of ALL currently waiting patients
-- =====================================================

SELECT
    PatientID,
    Specialty,
    Priority,
    WaitingDays,
    ReferralDate
FROM WaitingList
WHERE Priority = 'Urgent'
  AND Specialty = 'Cardiology'
  AND AppointmentDate IS NULL
  AND ReferralDate BETWEEN '2026-01-01' AND '2026-07-31'
  AND WaitingDays > (
      SELECT AVG(WaitingDays)
      FROM WaitingList
      WHERE AppointmentDate IS NULL
  );
