# NHS A&E Admissions Analysis (Project 1)

Analysis of NHS England's A&E Attendances and Emergency Admissions data (May–June 2026), 
examining hospital performance metrics across 192 NHS Trusts in England, including a 
month-over-month comparison.

## Data Source

Data sourced from NHS England's open statistics publication (Monthly A&E Attendances 
and Emergency Admissions), for May 2026 and June 2026.

**Note:** ECDS-based demographic breakdowns (age, gender, ethnicity) are marked 
"experimental" by NHS England and were not used in this analysis; the standard 
monthly figures remain the official source.

## Methodology

- Loaded and cleaned the May and June 2026 monthly A&E datasets using pandas
- Removed a hidden "Total" summary row present in each file before any aggregation, 
  to avoid double-counting (192 Trusts remained per month)
- Calculated total attendances, total emergency admissions, admission rate (%), and 
  4-hour breach rate (%) per Trust, for both months
- Identified and corrected infinite/missing admission rate values, caused by a small, 
  consistent set of community/mental health Trusts with zero recorded A&E attendances 
  (9 Trusts affected in both months)
- Split the 4-hour breach rate into DTA (Decision To Admit) wait sub-categories 
  (4-12 hrs vs 12+ hrs) to identify "cascading severity" patterns masked by the 
  headline breach rate
- Verified all headline findings against raw patient counts, not just percentages, 
  to rule out small-sample artifacts
- Merged the two months on Org Code to calculate month-over-month change per Trust

## Key Findings

- **Nottingham University Hospitals shows a persistent, structural wait-time crisis**: 
  across both May and June 2026, over 1,100 patients per month waited 12+ hours from 
  the decision to admit to actually receiving a bed — roughly 7 times more than the 
  number waiting a more moderate 4-12 hours (severity ratio: 6.93 in June, 7.28 in May). 
  This was independently verified against raw patient counts in both months, confirming 
  it reflects a genuine, ongoing operational pattern rather than a single-month anomaly.

- **Admission rate and 4-hour breach rate are strongly correlated (r = 0.83)** across 
  Trusts in June — Trusts admitting a higher proportion of patients also tend to have 
  more patients breaching the 4-hour target, consistent with more complex cases taking 
  longer to process and place.

- **East Cheshire NHS Trust is a notable outlier**: its 4-hour breach rate (48.4%) matches 
  the highest in England, despite a comparatively low admission rate (16.9%), suggesting 
  its wait-time pressure may be driven more by general department congestion than by 
  bed-capacity strain specifically — a hypothesis, not a confirmed cause.

- **Some Trusts deteriorated sharply between May and June despite falling admission 
  pressure**: Salisbury, North Bristol, and County Durham and Darlington all showed 
  significant breach rate increases (+3.9 to +6.7 percentage points) while their 
  admission rates stayed flat or improved — meaning their decline is not explained by 
  rising case complexity, and likely reflects a separate operational factor (e.g. 
  staffing, seasonal demand, local incidents) worth further investigation.

- **Regional performance varies meaningfully**: NHS England North West had both the 
  highest average 4-hour breach rate (23.6%) and tied for the highest severe (12+ hr) 
  wait rate (2.79%) among all regions, while North East and Yorkshire had a relatively 
  high overall breach rate (20.1%) but the lowest severe-wait rate (0.68%).

## Charts

![Admission rate distribution](outputs/admission_rate_distribution.png)

![Admission rate vs 4-hour breach rate](outputs/admission_vs_breach_scatter.png)

## Next Steps

- Extend to additional months to build a longer trend line
- Apply formal statistical hypothesis testing to the admission rate / breach rate relationship
- Investigate the drivers behind Nottingham's persistent pattern and the Salisbury-style 
  sudden deteriorations, using additional NHS datasets (e.g. workforce/staffing data)

## Tools Used

Python, pandas, matplotlib
