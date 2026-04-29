# 🏦 Bank Loan Analysis — SQL Project Report

A complete end-to-end analysis of **38,576 bank loan records** using **MySQL**, covering loan performance, borrower behavior, regional trends, and financial KPIs.

---

## 📁 Project Structure

```
bank-loan-analysis/
├── financial_loan_data_excel.csv   # Raw dataset (38,576 records)
├── bank_loan_sql_queries.sql       # All SQL queries used in this project
└── README.md                       # This report
```

---

## 🗃️ Dataset Overview

| Field | Description |
|---|---|
| `id` | Unique loan identifier |
| `loan_amount` | Principal loan amount disbursed |
| `total_payment` | Total amount received from borrower |
| `int_rate` | Annual interest rate |
| `dti` | Debt-to-Income ratio |
| `loan_status` | Fully Paid / Current / Charged Off |
| `issue_date` | Date loan was issued |
| `address_state` | Borrower's state |
| `purpose` | Stated reason for loan |
| `term` | 36 months or 60 months |
| `emp_length` | Employment length of borrower |
| `home_ownership` | RENT / MORTGAGE / OWN |
| `grade / sub_grade` | Credit risk grade assigned to loan |
| `annual_income` | Borrower's annual income |
| `verification_status` | Income verification status |

---

## 🛠️ Data Cleaning

Before analysis, the dataset required cleaning and type conversions.

```sql
-- Fix encoding issue with the ID column
ALTER TABLE bank_loan_data
CHANGE COLUMN ï»¿id id INT;

-- Convert date strings to proper DATE format
UPDATE bank_loan_data
SET
  issue_date            = STR_TO_DATE(issue_date, '%d-%m-%Y'),
  last_credit_pull_date = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'),
  last_payment_date     = STR_TO_DATE(last_payment_date, '%d-%m-%Y'),
  next_payment_date     = STR_TO_DATE(next_payment_date, '%d-%m-%Y');

-- Alter columns to DATE type
ALTER TABLE bank_loan_data
MODIFY COLUMN issue_date            DATE,
MODIFY COLUMN last_credit_pull_date DATE,
MODIFY COLUMN last_payment_date     DATE,
MODIFY COLUMN next_payment_date     DATE;
```

---

## 📊 Key Performance Indicators (KPIs)

### 1. Total Loan Applications

> **38,576 total applications** | **4,314 in December (MTD)**

```sql
-- Total Loan Applications
SELECT COUNT(id) AS Total_Applications
FROM bank_loan_data;

-- MTD (Month-to-Date) — December
SELECT COUNT(id) AS Total_Applications
FROM bank_loan_data
WHERE MONTH(issue_date) = 12;

-- Month-over-Month Trend
SELECT DATE_FORMAT(issue_date, '%m-%Y') AS Month,
       COUNT(id) AS Total_Applications
FROM bank_loan_data
GROUP BY Month
ORDER BY Month;
```

**Insight:** December alone accounts for ~11.2% of all loan applications — the highest monthly volume, indicating year-end borrowing demand.

---

### 2. Total Funded Amount

> **$435.76 Million total funded** | **$53.98 Million in December (MTD)**

```sql
-- Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM bank_loan_data;

-- MTD Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 12;

-- Month-over-Month
SELECT DATE_FORMAT(issue_date, '%m-%Y') AS Month,
       SUM(loan_amount) AS Total_Funded_Amount
FROM bank_loan_data
GROUP BY Month
ORDER BY Month;
```

---

### 3. Total Amount Received

> **$473.07 Million total received** | **$58.07 Million in December (MTD)**

```sql
-- Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected
FROM bank_loan_data;

-- MTD Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected
FROM bank_loan_data
WHERE MONTH(issue_date) = 12;

-- Month-over-Month
SELECT DATE_FORMAT(issue_date, '%m-%Y') AS Month,
       SUM(total_payment) AS Total_Amount_Collected
FROM bank_loan_data
GROUP BY Month
ORDER BY Month;
```

**Insight:** The bank collected **$37.31 million more** than it disbursed — a positive net recovery driven by interest income.

---

### 4. Average Interest Rate

> **12.05% overall** | **12.36% in December (MTD)**

```sql
-- Average Interest Rate
SELECT AVG(int_rate) * 100 AS Avg_Int_Rate
FROM bank_loan_data;

-- MTD Average Interest Rate
SELECT AVG(int_rate) * 100 AS Avg_Int_Rate
FROM bank_loan_data
WHERE MONTH(issue_date) = 12;

-- Month-over-Month
SELECT DATE_FORMAT(issue_date, '%m-%Y') AS Month,
       AVG(int_rate) * 100 AS Avg_Int_Rate
FROM bank_loan_data
GROUP BY Month
ORDER BY Month;
```

---

### 5. Average Debt-to-Income Ratio (DTI)

> **13.33% overall**

```sql
-- Average DTI
SELECT AVG(dti) * 100 AS Avg_DTI
FROM bank_loan_data;

-- MTD Avg DTI
SELECT AVG(dti) * 100 AS Avg_DTI
FROM bank_loan_data
WHERE MONTH(issue_date) = 12;

-- Month-over-Month
SELECT DATE_FORMAT(issue_date, '%m-%Y') AS Month,
       AVG(dti) * 100 AS Avg_DTI
FROM bank_loan_data
GROUP BY Month
ORDER BY Month;
```

**Insight:** An average DTI of 13.33% indicates borrowers are generally within a manageable debt range, though it should be monitored per risk grade.

---

## ✅ Good Loan vs ❌ Bad Loan Analysis

### Definitions
- **Good Loan:** Status = `Fully Paid` or `Current`
- **Bad Loan:** Status = `Charged Off`

---

### Good Loans

| Metric | Value |
|---|---|
| Good Loan % | **86.18%** |
| Applications | **33,243** |
| Total Funded | **$370.22 Million** |
| Total Received | **$435.79 Million** |

```sql
-- Good Loan Application Percentage
SELECT (
  COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0
) / COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data;

-- Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Good Loan Total Received Amount
SELECT SUM(total_payment) AS Good_Loan_Amount_Received
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';
```

---

### Bad Loans

| Metric | Value |
|---|---|
| Bad Loan % | **13.82%** |
| Applications | **5,333** |
| Total Funded | **$65.53 Million** |
| Total Received | **$37.28 Million** |

```sql
-- Bad Loan Application Percentage
SELECT (
  COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0
) / COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan_data;

-- Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications
FROM bank_loan_data
WHERE loan_status = 'Charged Off';

-- Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount
FROM bank_loan_data
WHERE loan_status = 'Charged Off';

-- Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_Amount_Received
FROM bank_loan_data
WHERE loan_status = 'Charged Off';
```

**Insight:** Charged-off loans resulted in a **$28.25 million loss** (funded $65.53M but recovered only $37.28M), highlighting the importance of early risk scoring.

---

## 📋 Loan Status Grid View

```sql
SELECT
  loan_status,
  COUNT(id)            AS Total_Loan_Applications,
  SUM(loan_amount)     AS Total_Funded_Amount,
  SUM(total_payment)   AS Total_Amount_Received,
  AVG(int_rate * 100)  AS Avg_Int_Rate,
  AVG(dti * 100)       AS Avg_DTI
FROM bank_loan_data
GROUP BY loan_status;

-- MTD by Loan Status
SELECT
  loan_status,
  SUM(total_payment) AS MTD_Total_Amount_Received,
  SUM(loan_amount)   AS MTD_Total_Funded_Amount
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
GROUP BY loan_status;
```

---

## 📈 Trend & Segmentation Analysis

### Monthly Trends by Issue Date

```sql
SELECT
  MONTH(issue_date)     AS Month_Number,
  MONTHNAME(issue_date) AS Month,
  COUNT(id)             AS Total_Loan_Applications,
  SUM(loan_amount)      AS Total_Funded_Amount,
  SUM(total_payment)    AS Total_Amount_Received
FROM bank_loan_data
GROUP BY Month_Number, Month
ORDER BY Month_Number;
```

**Insight:** Loan volumes show a steady upward trend throughout the year, peaking in December — suggesting seasonal borrowing patterns tied to year-end expenses.

---

### Regional Analysis by State

> **Top 5 States:** California (6,894), New York (3,701), Florida (2,773), Texas (2,664), New Jersey (1,822)

```sql
SELECT
  address_state        AS State,
  COUNT(id)            AS Total_Loan_Applications,
  SUM(loan_amount)     AS Total_Funded_Amount,
  SUM(total_payment)   AS Total_Amount_Received
FROM bank_loan_data
GROUP BY State
ORDER BY State;
```

**Insight:** California dominates with nearly 18% of all applications, reflecting both population size and higher cost-of-living borrowing needs.

---

### Loan Term Analysis

| Term | Applications |
|---|---|
| 36 Months | 28,237 (73.2%) |
| 60 Months | 10,339 (26.8%) |

```sql
SELECT
  term                 AS Term,
  COUNT(id)            AS Total_Loan_Applications,
  SUM(loan_amount)     AS Total_Funded_Amount,
  SUM(total_payment)   AS Total_Amount_Received
FROM bank_loan_data
GROUP BY Term
ORDER BY Term;
```

**Insight:** The overwhelming preference for 36-month terms suggests borrowers favour shorter repayment cycles to minimise total interest paid.

---

### Employee Length Analysis

> **Longest-tenured borrowers (10+ years) form the largest group at 8,870 applications.**

```sql
SELECT
  emp_length,
  COUNT(id)            AS Total_Loan_Applications,
  SUM(loan_amount)     AS Total_Funded_Amount,
  SUM(total_payment)   AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;
```

**Insight:** Experienced employees (10+ years) apply the most, likely reflecting greater financial confidence and higher loan eligibility.

---

### Loan Purpose Breakdown

> **Top purpose: Debt Consolidation — 18,214 applications (47.2% of all loans)**

```sql
SELECT
  purpose,
  COUNT(id)            AS Total_Loan_Applications,
  SUM(loan_amount)     AS Total_Funded_Amount,
  SUM(total_payment)   AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose;
```

| Purpose | Applications |
|---|---|
| Debt Consolidation | 18,214 |
| Credit Card | 4,998 |
| Other | 3,824 |
| Home Improvement | 2,876 |
| Major Purchase | 2,110 |
| Small Business | 1,776 |
| Car | 1,497 |

**Insight:** Nearly half of all loans are taken for debt consolidation — indicating widespread reliance on refinancing to manage existing obligations.

---

### Home Ownership Analysis

| Ownership | Applications |
|---|---|
| RENT | 18,439 (47.8%) |
| MORTGAGE | 17,198 (44.6%) |
| OWN | 2,838 (7.4%) |

```sql
SELECT
  home_ownership,
  COUNT(id)            AS Total_Loan_Applications,
  SUM(loan_amount)     AS Total_Funded_Amount,
  SUM(total_payment)   AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership;
```

**Insight:** Renters are the largest borrower segment — they may lack asset-based borrowing options, making unsecured personal loans their primary tool.

---

## 🔑 Summary of Key Insights

| # | Insight |
|---|---|
| 1 | **86.18% of loans are "good"** (Fully Paid or Current), reflecting strong underwriting standards overall. |
| 2 | **Charged-off loans caused a ~$28.25M loss**, underscoring the need for better risk prediction at the application stage. |
| 3 | **Debt consolidation dominates at 47%** of all loan purposes — borrowers are primarily managing existing debt. |
| 4 | **California leads all states** with 17.9% of applications, far ahead of any other state. |
| 5 | **73% of borrowers prefer 36-month terms**, indicating preference for faster repayment despite higher monthly installments. |
| 6 | **Average interest rate is 12.05%**, with December applications carrying a slightly higher rate of 12.36%. |
| 7 | **Renters make up the largest borrower group** (47.8%), suggesting limited access to asset-backed credit. |
| 8 | **10+ year employed borrowers** are the most active loan applicants, pointing to income stability as a key loan driver. |
| 9 | **Total collections exceed disbursements by $37.31M**, confirming the portfolio generates positive net interest income. |
| 10 | **December sees peak volumes** (4,314 applications, $53.98M funded), likely driven by year-end financial pressures. |

---

## 🛠️ Tools Used

- **Database:** MySQL
- **Analysis:** SQL (aggregations, date functions, conditional logic, GROUP BY)
- **Dataset:** 38,576 loan records with 24 fields

---

*Project by — Bank Loan SQL Analysis Portfolio Project*
