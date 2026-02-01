-- Creating a view table in order to avoid negative values of billing (identified in /sql/02_creat_clean_data_table) that may affect calculations.
DROP VIEW IF EXISTS v_healthcare_positive_billing;

CREATE VIEW v_healthcare_positive_billing AS
SELECT *
FROM healthcare_clean
WHERE billing_amount >= 0;


-- Step 6: Calculating basic metrics from the view table with positive billing amount values

-- 6.1: Average Days of Stay with 1 decimal point
SELECT
    ROUND(AVG(days_of_stay), 1) AS avg_length_of_stay
FROM v_healthcare_positive_billing;

-- Finding: 15.5 Average Days of Stay indicate suggests prolonged hospitalizations, 
-- indication the need for proper resource and staff allocation.

-- 6.2: Metrics based on the age-group/demographic data:
SELECT
    age_group,
    COUNT(*) AS admissions,
    ROUND(AVG(days_of_stay), 1) AS avg_los,
    ROUND(AVG(billing_amount),0) AS avg_billing
FROM v_healthcare_positive_billing
GROUP BY age_group
ORDER BY avg_billing DESC;

-- Finding: Patients aged 65+ show higher admission volume and longer length of stay,
-- indicating increased care needs, while the 0–17 age group exhibits higher average billing.

-- 6.3: Metrics per medical condition:
SELECT
    medical_condition,
    COUNT(*) AS admissions,
    ROUND(AVG(days_of_stay),1) AS avg_los,
	ROUND(AVG(billing_amount), 0) AS avg_billing
FROM v_healthcare_positive_billing
GROUP BY medical_condition
ORDER BY admissions DESC;

-- Finding: Arthritis accounts for the highest number of admissions,
-- while asthma is associated with longer average length of stay.

-- 6.4: Admission type metrics
SELECT
    admission_type,
    COUNT(*) AS admissions,
    ROUND(AVG(days_of_stay),1) AS avg_los,
	ROUND(AVG(billing_amount), 0) AS avg_billing
FROM v_healthcare_positive_billing
GROUP BY admission_type
ORDER BY admissions DESC;

-- Finding: Elective admissions account for the highest admission volume
-- and the highest average billing among admission types.

-- 6.5: Metrics per month start:
SELECT
    DATE_FORMAT(date_of_admission, '%Y-%m-01') AS month_start,
    COUNT(*) AS admissions,
    ROUND(AVG(days_of_stay),1) AS avg_los,
	ROUND(AVG(billing_amount), 0) AS avg_billing
FROM v_healthcare_positive_billing
GROUP BY month_start
ORDER BY admissions DESC;

-- Finding: Months with higher admission volumes are not consistently associated
-- with longer length of stay or higher average billing.

-- 6.6: Average cost per day per admission type:
SELECT
	admission_type,
    ROUND(AVG(billing_amount / NULLIF(days_of_stay, 0)), 1) AS avg_cost_per_day
FROM v_healthcare_positive_billing
WHERE days_of_stay > 0
GROUP BY admission_type
ORDER BY avg_cost_per_day DESC;

-- Finding: Urgent admissions show the highest average cost per day,
-- followed by elective and emergency admissions.


-- 6.7: Average cost per day per medical condition
SELECT
	medical_condition,
    ROUND(AVG(billing_amount / NULLIF(days_of_stay, 0)), 1) AS avg_cost_per_day
FROM v_healthcare_positive_billing
WHERE days_of_stay > 0
GROUP BY medical_condition
ORDER BY avg_cost_per_day DESC;

-- Finding: Obesity is associated with the highest average cost per day among
-- medical conditions, while cancer shows the lowest.

-- 6.8: Distribution of admissions based on different days of stay groups:
SELECT
   CASE
       WHEN days_of_stay <= 8 THEN '0–8 days'
       WHEN days_of_stay BETWEEN 9 AND 15 THEN '8–15 days'
       ELSE '15+ days'
   END AS los_bucket,
   COUNT(*) AS admissions
FROM v_healthcare_positive_billing
WHERE days_of_stay IS NOT NULL
GROUP BY los_bucket
ORDER BY admissions DESC;

-- Finding: The highest admission volume is associated with stays of 15+ days.

-- 6.9: Distribution of admissions based on different billing amount groups:
SELECT
	CASE
        WHEN billing_amount < 2000 THEN '< 2K'
        WHEN billing_amount BETWEEN 2000 AND 4999 THEN '2K–5K'
        WHEN billing_amount BETWEEN 5000 AND 9999 THEN '5K–10K'
        WHEN billing_amount BETWEEN 10000 AND 19999 THEN '10K–20K'
        WHEN billing_amount BETWEEN 20000 AND 34999 THEN '20K–35K'
        ELSE '35K+'
	END AS billing_bucket,
	COUNT(*) AS admissions
FROM v_healthcare_positive_billing
GROUP BY billing_bucket
ORDER BY admissions DESC;

-- Finding: The 20K+ billing amount accounts for the highest number of admissions.

-- 6.10: Identify high-cost cases (e.g. billing_amount >= 45000)
SELECT
    CASE
        WHEN billing_amount >= 45000 THEN 'High-cost'
        ELSE 'Standard'
    END AS cost_group,
    COUNT(*) AS admissions,
    ROUND(AVG(days_of_stay), 1) AS avg_los
FROM v_healthcare_positive_billing
WHERE days_of_stay IS NOT NULL
GROUP BY cost_group;

-- Finding: The majority of admissions fall below the 45K billing threshold.

-- 6.11: Identifying high-cost cases rate/percentage (billing amount >= 45000)
SELECT
  COUNT(*) AS total_admissions,
  SUM(CASE WHEN billing_amount >= 45000 THEN 1 ELSE 0 END) AS high_cost_admissions,
  ROUND(SUM(CASE WHEN billing_amount >= 45000 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS high_cost_rate_pct
FROM v_healthcare_positive_billing;

-- Finding: High-cost cases (>45K billing) account for 10.36% of total admissions.


