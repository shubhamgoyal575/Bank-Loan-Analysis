-- creating database
CREATE DATABASE Bank_loan;

USE Bank_loan;

SELECT * FROM financial_loan;

-- changing date format 
UPDATE financial_loan
SET issue_date = DATE_FORMAT(STR_TO_DATE(issue_date, '%d-%m-%Y'), '%Y-%m-%d'),
	last_credit_pull_date = DATE_FORMAT(STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'), '%Y-%m-%d'),
	last_payment_date = DATE_FORMAT(STR_TO_DATE(last_payment_date, '%d-%m-%Y'), '%Y-%m-%d'),
	next_payment_date = DATE_FORMAT(STR_TO_DATE(next_payment_date, '%d-%m-%Y'), '%Y-%m-%d');


-- Total Number of Applications
SELECT COUNT(id) AS Total_loan_applications FROM financial_loan;

-- Application MTD
SELECT COUNT(ID) AS MTD_loan_application 
FROM financial_loan
WHERE MONTH(issue_date)=12;

-- Application PMTD
SELECT COUNT(ID) AS PMTD_loan_application 
FROM financial_loan
WHERE MONTH(issue_date)=11;

-- Monthwise Applications
SELECT MONTH(issue_date) AS No, MONTHNAME(issue_date) AS Month, COUNT(ID) AS loan_application 
FROM financial_loan
GROUP BY Month,No
ORDER BY No;




-- Funded Amount
SELECT ROUND(SUM(loan_amount)/1000000,2) as funded_amt_Million FROM financial_loan;

-- Monthwise Funded Amt distribution
SELECT MONTH(issue_date) AS No, MONTHNAME(issue_date) AS Month, ROUND(SUM(loan_amount)/1000000,2) as funded_amt_Million
FROM financial_loan
GROUP BY Month, No
ORDER BY No;

-- Funded amt MTD
SELECT  ROUND(SUM(loan_amount)/1000000,2) as MTD_funded_amt_Million
FROM financial_loan
WHERE Month(issue_date)=12;

-- Funded Amt PMTD
SELECT  ROUND(SUM(loan_amount)/1000000,2) as PMTD_funded_amt_Million
FROM financial_loan
WHERE Month(issue_date)=11;



-- Total payment amount
SELECT ROUND(SUM(total_payment)/1000000,2) as Total_payment_Million FROM financial_loan;

-- Monthwise Payment Recevied distribution
SELECT MONTH(issue_date) AS No, MONTHNAME(issue_date) AS Month, ROUND(SUM(total_payment)/1000000,2) as funded_amt_Million
FROM financial_loan
GROUP BY Month, No
ORDER BY No;

-- Payment Received MTD
SELECT  ROUND(SUM(total_payment)/1000000,2) as MTD_Payment_received_Million
FROM financial_loan
WHERE Month(issue_date)=12;

-- Payment Received PMTD
SELECT  ROUND(SUM(total_payment)/1000000,2) as PMTD_Payment_received_Million
FROM financial_loan
WHERE Month(issue_date)=11;



-- Average interest rate
SELECT ROUND(AVG(int_rate)*100,2) AS Averge_interest_rate FROM financial_loan;

-- MTD Average Interest
SELECT ROUND(AVG(int_rate)*100,2) AS MTD_Avg_Int_Rate FROM financial_loan
WHERE MONTH(issue_date) = 12;

-- PMTD Average Interest
SELECT ROUND(AVG(int_rate)*100,2) AS PMTD_Avg_Int_Rate FROM financial_loan
WHERE MONTH(issue_date) = 11;



-- Average Debt to Income Ratio
SELECT ROUND(AVG(dti) *100,2) AS avg_dti FROM financial_loan;

-- MTD Avg DTI
SELECT ROUND(AVG(dti)*100,2) AS MTD_Avg_DTI FROM financial_loan
WHERE MONTH(issue_date) = 12;

-- PMTD Avg DTI
SELECT ROUND(AVG(dti)*100,2) AS PMTD_Avg_DTI FROM financial_loan
WHERE MONTH(issue_date) = 11;



-- GOOD LOAN
-- application Percantage
SELECT 
	ROUND(((COUNT(CASE WHEN loan_status='Fully Paid' OR loan_status='Current' THEN id END))/
    COUNT(id)) *100,2) AS Good_loan_app_percentage
FROM financial_loan;

-- total loan application
SELECT 
	COUNT(CASE WHEN loan_status='Fully Paid' OR loan_status='Current' THEN id END) as Total_good_loan_application
FROM financial_loan;

-- OR

SELECT COUNT(id) as Total_good_loan_application
FROM financial_loan
WHERE loan_status='Fully Paid' OR loan_status='Current';

-- FUNDED Amount
SELECT ROUND(SUM(loan_amount)/1000000,2) as Total_funded_amt_Million
FROM financial_loan
WHERE loan_status IN ('Fully Paid','Current');

-- total payment Received
SELECT ROUND(SUM(total_payment)/1000000,2) as Total_payment_received_Million
FROM financial_loan
WHERE loan_status IN ('Fully Paid','Current');



-- BAD LOAN
-- application Percantage
SELECT 
	ROUND(((COUNT(CASE WHEN loan_status='Charged Off' THEN id END))/
    COUNT(id)) *100,2) AS Bad_loan_percentage
FROM financial_loan;

-- total loan application
SELECT 
	COUNT(CASE WHEN loan_status='Charged Off' THEN id END) as Bad_loan_application
FROM financial_loan;

-- OR 

SELECT COUNT(id) as Bad_loan_application
FROM financial_loan
WHERE loan_status='Charged Off';

-- FUNDED AMT
SELECT ROUND(SUM(loan_amount)/1000000,2) as Bad_funded_amount_Million
FROM financial_loan
WHERE loan_status='Charged Off';

-- total payment Received
SELECT ROUND(SUM(total_payment)/1000000,2) as Bad_payment_received_Million
FROM financial_loan
WHERE loan_status='Charged Off';



-- LOAN STATUS
SELECT
	loan_status,
    COUNT(id) AS Number_of_applications,
    ROUND(SUM(total_payment)/1000000,2) AS Total_amount_received_Million,
    ROUND(SUM(loan_amount)/1000000,2) AS Total_funded_amount_Million,
    ROUND(AVG(int_rate)*100 ,2) AS Avg_int_rate,
    ROUND(AVG(dti) *100 ,2) AS Avg_dti
FROM financial_loan
GROUP BY loan_status;

-- loan status by home ownershp type
SELECT
	home_ownership,
    COUNT(id) AS Number_of_applications,
    ROUND(SUM(total_payment)/1000000,2) AS Total_amount_received_Million,
    ROUND(SUM(loan_amount)/1000000,2) AS Total_funded_amount_Million,
    ROUND(AVG(int_rate)*100 ,2) AS Avg_int_rate,
    ROUND(AVG(dti) *100 ,2) AS Avg_dti
FROM financial_loan
GROUP BY home_ownership
ORDER BY home_ownership;

-- Month wise details
SELECT 
	MONTH(issue_date) AS No,
	MONTHNAME(issue_date) AS Month,
	COUNT(id) AS Total_loan_application,
	ROUND(SUM(total_payment)/1000000,2) AS Total_amount_received_Million,
    ROUND(SUM(loan_amount)/1000000,2) AS Total_funded_amount_Million
FROM financial_loan
GROUP BY No,Month
ORDER BY No;

-- city wise detials
SELECT 
	address_state,
	COUNT(id) AS Total_loan_application,
    ROUND(SUM(total_payment)/1000000,2) AS Total_amount_received_Million,
    ROUND(SUM(loan_amount)/1000000,2) AS Total_funded_amount_Million
FROM financial_loan
GROUP BY address_state
ORDER BY Total_funded_amount_Million DESC
LIMIT 10;

-- term analysis
SELECT 
	term,
	COUNT(id) AS Total_loan_application,
    ROUND(SUM(total_payment)/1000000,2) AS Total_amount_received_Million,
    ROUND(SUM(loan_amount)/1000000,2) AS Total_funded_amount_Million
FROM financial_loan
GROUP BY term
ORDER BY Total_funded_amount_Million DESC;

-- emp_length
SELECT 
	emp_length,
	COUNT(id) AS Total_loan_application,
    ROUND(SUM(total_payment)/1000000,2) AS Total_amount_received_Million,
    ROUND(SUM(loan_amount)/1000000,2) AS Total_funded_amount_Million
FROM financial_loan
GROUP BY emp_length
ORDER BY Total_funded_amount_Million DESC;

-- purpose
SELECT 
	purpose,
	COUNT(id) AS Total_loan_application,
    ROUND(SUM(total_payment)/1000000,2) AS Total_amount_received_Million,
    ROUND(SUM(loan_amount)/1000000,2) AS Total_funded_amount_Million
FROM financial_loan
GROUP BY purpose
ORDER BY Total_funded_amount_Million DESC;