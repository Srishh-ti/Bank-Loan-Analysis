## Data Cleaning
create database bank_loan_data_db;
use bank_loan_data_db;
describe bank_loan_data;

alter table bank_loan_data
change column ï»¿id id int;

update bank_loan_data
set 
issue_date = str_to_date(issue_date, '%d-%m-%Y'),
last_credit_pull_date = str_to_date(last_credit_pull_date, '%d-%m-%Y'),
last_payment_date = STR_TO_DATE(last_payment_date, '%d-%m-%Y'),
next_payment_date = STR_TO_DATE(next_payment_date, '%d-%m-%Y');

ALTER TABLE bank_loan_data
MODIFY COLUMN issue_date DATE,
MODIFY COLUMN last_credit_pull_date DATE,
MODIFY COLUMN last_payment_date DATE,
MODIFY COLUMN next_payment_date DATE;

-- Total Amount Received
select sum(total_payment) as Total_Amount_Collected 
from bank_loan_data;

-- MTD Total Amount Received
select sum(total_payment) as Total_Amount_Collected
from bank_loan_data
where month(issue_date) = 12;

-- Month-over-month (MOM)
select date_format(issue_date, '%m-%Y') as Month,
sum(total_payment) as Total_Amount_Collected
from bank_loan_data
group by month
order by month;

-- Total Loan Applications
select count(id) as Total_Applications 
from bank_loan_data;

-- Month-to-Date (MTD) Loan Applications
select count(id) as Total_Applications
from bank_loan_data
where month(issue_date) = 12;

-- Month-over-Month (MoM)
select date_format(issue_date, '%m-%Y') as month, count(id) as Total_Applications
from bank_loan_data
group by month
order by month;

-- Total Funded Amount
select sum(loan_amount) as Total_Funded_Amount 
from bank_loan_data;

-- MTD Total Funded Amount
select sum(loan_amount) as Total_Funded_Amount
from bank_loan_data
where month(issue_date) = 12;

-- Month-over-Month (MoM)
select date_format(issue_date, '%m-%Y') as Month, sum(loan_amount) as Total_Funded_Amount
from bank_loan_data
group by month
order by month;

-- Good Loan Application Percentage
select (
count(
case
	when loan_status = 'Fully Paid' or loan_status = 'Current' then id
    end
)*100.0)/
count(id) as Good_Loan_Percentage
from bank_loan_data;

-- Good Loan Applications
select count(id) as Good_Loan_Applications 
from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Good Loan Funded Amount
select sum(loan_amount) as Good_Loan_Funded_amount 
from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Good Loan Total Received Amount
select sum(total_payment) as Good_Loan_amount_received 
from bank_loan_data
where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Loan Status Grid View
select loan_status,
count(id) as Total_Loan_Applications,
sum(loan_amount) as total_funded_amount,
sum(total_payment) as total_amount_received,
avg(int_rate * 100) as avg_int_rate,
avg(dti * 100) as avg_dti
from bank_loan_data
group by loan_status;

select loan_status,
sum(total_payment) as MTD_Total_Amount_Received,
sum(loan_amount) as MTD_Total_Funded_Amount
from bank_loan_data
where month(issue_date) = 12
group by loan_status;

-- Average Interest Rate
select avg(int_rate)*100 as Avg_Int_Rate 
from bank_loan_data;

-- MTD Average Interest
select avg(int_rate)*100 as Avg_Int_Rate
from bank_loan_data
where month(issue_date) = 12;

-- Month-over-month
select date_format(issue_date, '%m-%Y') as month,
avg(int_rate)*100 as Avg_Int_Rate
from bank_loan_data
group by month
order by month;

-- Bad Loan Application Percentage:
select (
count(
case
	when loan_status = 'Charged Off' then id
    end
)*100.0)/ count(id) as Bad_Loan_Percentage
from bank_loan_data;

-- Bad Loan Applications
select count(id) as Bad_Loan_Applications 
from bank_loan_data
where loan_status = 'Charged Off';

-- Bad Loan Funded Amount
select sum(loan_amount) as Bad_Loan_Funded_amount 
from bank_loan_data
where loan_status = 'Charged Off';

-- Bad Loan Amount Received
select sum(total_payment) as Bad_Loan_amount_received 
from bank_loan_data
where loan_status = 'Charged Off';

-- Monthly Trends by Issue Date
select month(issue_date) as month_number,
monthname(issue_date) as month,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from bank_loan_data
group by month_number, month
order by month_number;

--  Regional Analysis by State
select address_state as state,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from bank_loan_data
group by state
order by state;

-- Loan Term Analysis
select term as Term,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from bank_loan_data
group by term
order by term;

-- Employee Length Analysis 
select emp_length,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from bank_loan_data
group by emp_length
order by emp_length;

-- Loan Purpose Breakdown 
select purpose,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from bank_loan_data
group by purpose
order by purpose;

-- Home Ownership Analysis
select home_ownership,
count(id) as Total_Loan_Applications,
sum(loan_amount) as Total_Funded_Amount,
sum(total_payment) as Total_Amount_Received
from bank_loan_data
group by home_ownership
order by home_ownership;

-- Average Debt-to-Income Ratio (DTI):
select avg(dti)*100 as Avg_DTI 
from bank_loan_data;

-- MTD Avg DTI
select avg(dti)*100 as Avg_DTI
from bank_loan_data
where month(issue_date) = 12;

-- Month-over-month
select date_format(issue_date, '%m-%Y') as month,
avg(dti)*100 as Avg_DTI
from bank_loan_data
group by month
order by month;