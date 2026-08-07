# Project 2: NHS RTT Waiting Times Dashboard (Power BI)

An interactive Power BI dashboard analysing NHS Referral to Treatment (RTT) waiting times across 215 NHS Trusts and 7 regions in England, comparing April and May 2026.

## The question

How big is the current NHS treatment backlog, is it getting better or worse, and is the pressure spread evenly across the country — or concentrated in specific regions and specialties?

## Data source

NHS England, Referral to Treatment Waiting Times statistics (Incomplete Pathways, Provider-level), April and May 2026.
Source: https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/rtt-data-2026-27

RTT measures the time from a patient being referred by a GP to starting treatment. The NHS target is 92% of patients treated within 18 weeks. This dashboard uses "Incomplete Pathways" data — patients still waiting, as of the reporting month — broken down by Trust and Treatment Function (medical specialty).

## Data cleaning

The raw NHS files needed substantial cleaning before analysis:

- Removed title/metadata rows sitting above the real header row
- Removed ~100 weekly wait-time breakdown columns not needed for this analysis, keeping only the pre-aggregated summary columns
- Removed hidden Trust-level subtotal rows (Treatment Function Code `C_999`) that were double-counting patients when initially summed
- Handled suppressed values (`-`) correctly: converted to blank/null for statistical columns (median, 92nd percentile) rather than zero, to avoid falsely implying instant treatment for small patient groups
- Combined April and May into a single table with a Month field for comparison

## A data quality issue I caught and fixed

While building the "% within 18 weeks" measure, I initially used a simple `AVERAGE()` across rows. This produced misleading results: a Trust's tiny specialty (e.g. 14 patients, 100% on time) was weighted equally with a huge specialty (e.g. 121,632 patients, 63.4% on time), inflating apparent performance by up to 20+ percentage points.

**Fix:** replaced the simple average with a weighted calculation — `DIVIDE(SUM(patients seen on time), SUM(total patients))` — so every individual patient counts equally, rather than every row counting equally regardless of size. This is the correct approach any time percentage figures are aggregated across groups of unequal size.

## Key findings

- As of **May 2026**, approximately **7 million** people were waiting for NHS treatment in England, with 64.87% seen within the 18-week target (weighted, patient-level accurate) — below the NHS's 92% goal.
- **Backlog size and treatment speed are not the same thing.** London carries the largest waiting list in the country (2.50M) but is the 2nd best-performing region (66.64% on target). East of England has a comparatively smaller backlog (1.64M) but the worst on-target performance of any region (60.12%).
- **Month-over-month change was mixed, not uniform.** Among the 15 largest Trusts by backlog, 9 saw their waiting list grow between April and May while 6 improved. Notably, Mid and South Essex — the single largest backlog nationally — was also the biggest improver (-2,903 patients), while Royal Free London saw the largest deterioration (+2,331 patients).
- **The most-delayed specialties aren't always the most complex ones.** Oral Surgery (54.81%) and Plastic Surgery (57.01%) had the lowest on-target rates nationally — lower than Trauma and Orthopaedics (57.78%). Elderly Medicine (82.51%) and Mental Health Services (80.69%) performed best, despite being commonly assumed to be under strain.

## Dashboard pages

1. **Overview** — headline KPIs, Top 10 Trusts by backlog size, Bottom 10 Trusts by on-target performance
2. **Trust Comparison** — April vs May by Trust, colour-coded month-over-month change
3. **Regional & Trends** — backlog and performance by region, and by medical specialty

## Tools

Power BI Desktop (Power Query, DAX), Excel

## Files

- `dashboard/nhs-rtt-waiting-times-dashboard.pbix` — full Power BI file
- `outputs/` — dashboard page screenshots
- `data/raw/README.md` — pointer to NHS source data (raw files not committed, per NHS data licensing/size)
