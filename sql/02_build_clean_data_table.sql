-- Step 4:
-- Create a clean analytics table from the raw data.
-- Purpose:
-- 1. Convert string-based fields (e.g. billing_amount) into proper numeric types (e.g. integer)
-- 2. Parse date fields safely and handle invalid or inconsistent records.
-- 3. Create business-ready derived columns (days_of_stay, age_group).
-- 4. Keep the raw table unchanged and reproducible.

DROP TABLE IF EXISTS healthcare_clean;

CREATE TABLE healthcare_clean AS
SELECT
    -- Core patient attributes
    name,
    age,
    gender,
    blood_type,
    medical_condition,

    -- Admission & discharge dates
    date_of_admission,
    discharge_date,

    -- Hospital & administrative information
    doctor,
    hospital,
    insurance_provider,

    -- Convert billing amount from text to numeric for cost analysis setting the appropriate symbols
    CAST(
        REPLACE(
            REPLACE(billing_amount, '$', ''),
            ',', ''
        ) AS DECIMAL(10,2)
    ) AS billing_amount,

    room_number,
    admission_type,
    medication,
    test_results,

    -- Create new metric: length of hospital stay (in days)
    -- Used as a key operational KPI in healthcare analytics
    CASE
        WHEN discharge_date IS NULL OR date_of_admission IS NULL THEN NULL
        WHEN discharge_date < date_of_admission THEN NULL
        ELSE DATEDIFF(discharge_date, date_of_admission)
    END AS days_of_stay,

    -- Create patient segmentation by age group
    -- Enables demographic analysis and aggregated reporting
    CASE
        WHEN age <= 17 THEN '0-17'
        WHEN age BETWEEN 18 AND 34 THEN '18-34'
        WHEN age BETWEEN 35 AND 49 THEN '35-49'
        WHEN age BETWEEN 50 AND 64 THEN '50-64'
        ELSE '65+'
    END AS age_group

FROM raw_healthcare_data;

-- Step 5: Validation of clean data table, to evaluate if data shown are the proper one, and correctly formatted.
SELECT
    COUNT(*) AS total_rows,
	MIN(date_of_admission) AS first_admission_date,
    MAX(date_of_admission) AS last_admission_date,
    MIN(billing_amount) AS min_billing,
    MAX(billing_amount) AS max_billing
FROM healthcare_clean;

-- Comment: Detected that the minimum billing was negative, as also other billing amounts, maybe because of paybacks or refunds, so then tried.

-- Identification of the number of negative bill amounts:
SELECT
	COUNT(*) AS negative_billing_rows,
    MIN(billing_amount) AS min_negative_value
FROM healthcare_clean
WHERE billing_amount < 0;

-- Found 108 negative billing rows that may affect averages and generally numeric analysis that are not going to be used for the KPIs calculations.
