# 🧹 Mental Health Clinic Data Cleaning using SQL

## 📌 Project Overview

This project focuses on cleaning and validating highly inconsistent operational data from a mental health clinic database.

The dataset contained major issues related to invalid dates, inconsistent payment values, incorrect session durations, missing records, and relational inconsistencies across multiple tables.

The objective was not dashboard creation or visualization, but building a reliable and structured database suitable for future analytics and reporting.

The cleaning process involved extensive SQL-based validation, transformation, correction, and relational integrity checks.

---

## 🎯 Project Objective

The clinic dataset was entered by a new receptionist, resulting in multiple data quality issues and inconsistencies across the database.

The goal of this project was to:

- Detect and correct invalid records
- Validate relationships across tables
- Standardize inconsistent values
- Improve database integrity
- Prepare the dataset for future analytical use

Even after cleaning, the dataset still contains limitations that make it unsuitable for direct visualization or production-level analytics.

---

## 📊 Dataset Overview

The database consisted of multiple related tables including:

- Patients
- Therapists
- Appointments
- Sessions
- Payments

### Key Dataset Characteristics

- Patient IDs: 1–3000
- Therapist IDs: 1–200
- Appointment IDs: 1–4000
- Session IDs: 1–3500
- Payment IDs: 1–3500

Initial assessment confirmed that ID ranges and relationships were mostly consistent across tables. :contentReference[oaicite:0]{index=0}

---

## 🛠️ Tools & Technologies Used

- **SQL** → Data cleaning, validation, transformation, and integrity checks
- **Excel** → Initial inspection and verification

---

## 🔧 SQL Skills Demonstrated

This project involved extensive practical SQL data-cleaning operations including:

- Data validation using conditional logic
- Handling missing and inconsistent values
- Referential integrity checks
- Foreign key updates
- Data standardization
- Duplicate detection
- Multi-table relationship validation
- Date validation and correction
- Business rule implementation
- Data deletion based on validation logic
- Derived column creation
- CASE statements
- JOIN operations
- Aggregate validation queries
- UPDATE and DELETE operations
- Constraint handling
- Data consistency auditing

---

## 🧹 Data Cleaning & Validation Performed

### ✅ Structural Validation

- Verified there were no duplicate IDs across tables
- Checked consistency of primary and foreign keys
- Added and updated foreign key constraints
- Enabled:
  - `ON UPDATE CASCADE`
  - `ON DELETE CASCADE`

### ✅ Patient & Therapist Data Cleaning

- Identified invalid signup dates occurring after date of birth
- Corrected therapist experience inconsistencies
- Added derived columns:
  - `Experience`
  - `Age`

### ✅ Appointment Validation

- Identified **2333 appointment records** with invalid date relationships
- Detected cases where:
  - Therapist joining date was later than appointment date
  - Client signup date was later than appointment date
- Invalid records were removed

### ✅ Session Data Cleaning

- Session timings were expected to be:
  - 45 minutes
  - 60 minutes
  - 75 minutes

- Found invalid session duration values
- Updated **351 incorrect rows** to default 60 minutes :contentReference[oaicite:1]{index=1}

- Deleted sessions linked to cancelled appointments
- Verified no therapist had multiple sessions on the same day
- Added `Session Mode` column:
  - Online
  - Offline

### ✅ Payment Validation

- Identified invalid payment amounts outside expected fee structure:
  - ₹1500
  - ₹2000
  - ₹2500

- Corrected **495 incorrect “No Show” payment entries** to ₹1000 :contentReference[oaicite:2]{index=2}

- Corrected **302 incorrect fee records** for completed and no-show sessions :contentReference[oaicite:3]{index=3}

### ✅ Missing Record Detection

- Found **725 rows** where payment status records were missing :contentReference[oaicite:4]{index=4}
- Identified **347 sessions** without corresponding payment IDs :contentReference[oaicite:5]{index=5}

### ✅ Date Consistency Checks

- Verified all sessions occurred within 7 days of appointment dates
- Identified **723 records** with invalid session/payment date relationships :contentReference[oaicite:6]{index=6}

---

## 🔍 Key Findings from Cleaning Process

- The dataset contained severe operational inconsistencies across multiple tables
- Most major issues originated from:
  - Invalid date relationships
  - Incorrect payment entries
  - Missing transaction records
  - Inconsistent business-rule implementation

- Although many inconsistencies were corrected, the dataset still requires additional validation before reliable business reporting or visualization can be performed.

---

## ⚠️ Remaining Data Quality Issues

Even after cleaning, several limitations still exist:

- Missing payment records for multiple sessions
- Large number of deleted invalid appointment records
- Potential business-rule inconsistencies not fully traceable
- Incomplete transaction linkage in some cases
- Possible hidden anomalies not detectable through available rules
- Dataset reliability still insufficient for production-grade dashboards

Because of these limitations, the cleaned dataset should be treated as partially reliable and requires further validation before advanced analytics or visualization.

---

## 🚀 Project Value

This project demonstrates practical SQL data-cleaning skills commonly required in real-world analytics environments where datasets are often incomplete, inconsistent, and operationally unreliable.

The project highlights the ability to:

- Work with messy relational databases
- Apply business-rule-based validation
- Improve database consistency
- Detect hidden data quality issues
- Prepare raw operational data for future analytical workflows

---

## 👨‍💻 Author

[Manasi Gandhi](https://manasigandhiportfolio.lovable.app/)

**SQL | Excel | Data Cleaning | Data Validation | Database Integrity**
