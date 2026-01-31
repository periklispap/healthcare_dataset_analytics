# Healthcare Analytics – SQL Project

## Overview
This project demonstrates how raw healthcare admissions data can be cleaned
and analyzed using SQL in order to produce meaningful analytics KPIs.

The main goal is to showcase core SQL and data analytics skills for
entry-level data and business analytics roles.

## Dataset
Synthetic healthcare admissions dataset from Kaggle:  
https://www.kaggle.com/datasets/prasad22/healthcare-dataset

The dataset includes patient demographics, admission and discharge dates,
billing information, and administrative attributes.

## What Was Done
- Loaded raw CSV data into MySQL
- Built a clean analytics table with validated data types
- Derived key metrics such as length of stay and age groups
- Handled anomalous billing values using SQL views
- Calculated healthcare-related KPIs

## Key KPIs
- Average length of stay (LOS)
- Admissions by age group and medical condition
- Billing amount and cost per day
- Length of stay and billing distributions
- High-cost patient rate

## Tools
- MySQL Workbench
- SQL

## How to run
Run the scripts in this order:
1. sql/01_load_raw.sql
2. sql/02_build_clean.sql
3. sql/03_kpi_queries.sql

Note: Update the CSV file path in the load script before execution.

## Notes
This project uses synthetic data and focuses on analytics logic rather than
real-world hospital reporting.


