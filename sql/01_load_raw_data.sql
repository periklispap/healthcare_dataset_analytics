-- Step 1:  Create the database
CREATE DATABASE IF NOT EXISTS healthcare_analytics;
USE healthcare_analytics;

-- Step 2: Create a raw/blank table with the colimn names and data types before loading into it the data from the .csv file.

DROP TABLE IF EXISTS raw_healthcare_data; -- Used to avoid duplicate columns error when testing is performed

CREATE TABLE IF NOT EXISTS raw_healthcare_data (
    name VARCHAR(100),
    age INT,
    gender VARCHAR(20),
    blood_type VARCHAR(10),
    medical_condition VARCHAR(100),
    date_of_admission DATE,
    doctor VARCHAR(100),
    hospital VARCHAR(100),
    insurance_provider VARCHAR(100),
    billing_amount VARCHAR(50),
    room_number INT,
    admission_type VARCHAR(50),
    discharge_date DATE,
    medication VARCHAR(100),
    test_results VARCHAR(50)
);

-- Step 3: Load all the data of the .csv  file (excluding the headings row) into the created raw/blank table.
-- Dataset source: Kaggle (see README for link)
LOAD DATA LOCAL INFILE
'/Users/periklespapadopoulos/Desktop/PP/Healthcare_Project/healthcare_dataset.csv'
INTO TABLE raw_healthcare_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

