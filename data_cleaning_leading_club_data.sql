-- DATA EXPLORATION, Let's see what we have!
SELECT * 
FROM `causal-axle-394212.lending_club_data_set.accepted`
LIMIT 5

-- Created new filtered table only containing data columns needed for exploration of data set
CREATE TABLE `causal-axle-394212.lending_club_data_set.accepted_loans_filtered` AS
    SELECT id,	loan_amnt,	funded_amnt,	funded_amnt_inv,	term,	int_rate,	installment,	grade,	sub_grade,	emp_title,	emp_length,	home_ownership,	   annual_inc,	verification_status,	loan_status,	purpose,	title,	addr_state,	dti,	fico_range_low,	fico_range_high,	open_acc,	revol_bal,	revol_util,	total_acc,	total_pymnt,	total_pymnt_inv,	application_type
    FROM `causal-axle-394212.lending_club_data_set.accepted`;

-- Removed 34 rows that are not numbers in col id, in order to change data types from STRING to NUMERIC
DELETE 
FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filtered` 
WHERE id LIKE 'Total amount funded in policy%' 
OR id LIKE 'Loans that do not meet the credi%'
OR id LIKE '%id%'

-- Created a new table with correct data types and quality of life changes for column names
CREATE TABLE `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2` AS
    SELECT 
      CAST(id AS NUMERIC) AS id,
      CAST(loan_amnt AS NUMERIC) AS loan_amount,
      CAST(funded_amnt AS NUMERIC) AS funded_amount,	
      term AS term,	
      CAST(total_pymnt AS NUMERIC) AS total_payment,
      CAST(int_rate AS NUMERIC) AS interest_rate,	
      CAST(installment AS NUMERIC) AS installment,	
      grade AS loan_grade,	
      sub_grade AS loan_sub_grade,	
      emp_title AS employment_title,	
      emp_length AS employment_length,	
      home_ownership AS home_ownership,	
      CAST(annual_inc AS NUMERIC) AS annual_income,	
      verification_status AS verification_status,	
      loan_status AS loan_status,	
      purpose AS loan_purpose,	
      addr_state AS state_address,	
      CAST(dti AS FLOAT64) AS debt_to_income,	
      CAST(fico_range_low AS NUMERIC) AS fico_range_low,	
      CAST(fico_range_high AS NUMERIC) AS fico_range_high,		
      CAST(revol_util AS NUMERIC) AS revolving_line_utilization,	
      CAST(total_acc AS NUMERIC) AS number_of_credit_lines,	
      application_type AS application_type

    FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filtered`;


-- -- CHECKING for Duplicate ID entries 
-- -- 0 rows removed (No Duplicates)
SELECT id, COUNT(id)
FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
GROUP BY id
HAVING COUNT(id) > 1

-- Elimination of values 'Default' and 'Does not meet the credit policy' due to lack of data points
-- 2789 rows removed
DELETE 
FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2` 
WHERE loan_status = 'Default' 
OR loan_status LIKE 'Does not meet the credit policy%'

-- Checking for NULL values in id
-- 0 NULL values
SELECT
  id
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  WHERE id IS NULL;

------------------------------------------------------------------------------------------------------------------------------------
-- Creating a new table for state name to use in Tableu Map visualization

-- New table to connect in Tableu
CREATE TABLE `causal-axle-394212.lending_club_data_set.state_addresses` AS (
  SELECT id, state_address
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`);

-- I figured that updating the table manually would be easier than writing a long CASE statement, therefore I went state by state changing its address into state name
UPDATE `causal-axle-394212.lending_club_data_set.state_addresses`
SET state_address = 'District of Columbia'
WHERE state_address = 'DC'

-- Check for any errors anything I missed
SELECT state_address
FROM `causal-axle-394212.lending_club_data_set.state_addresses`
WHERE length(state_address) <= 2;

-- Visualize
SELECT * 
FROM `causal-axle-394212.lending_club_data_set.state_addresses`
LIMIT 1000
-- ___________________________________________________________________________________________________

-- EXPLORATION of DISCRETE columns
SELECT
  term,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY term
  ORDER BY amount_of_loans DESC;

SELECT
  loan_grade,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY loan_grade
  ORDER BY amount_of_loans DESC;

SELECT
  loan_sub_grade,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY loan_sub_grade
  ORDER BY amount_of_loans DESC;

SELECT
  employment_title,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY employment_title
  ORDER BY amount_of_loans DESC;

SELECT
  employment_length,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY employment_length
  ORDER BY amount_of_loans DESC;

SELECT
  home_ownership,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY home_ownership
  ORDER BY amount_of_loans DESC;

SELECT
  verification_status,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY verification_status
  ORDER BY amount_of_loans DESC;

SELECT
  loan_status,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY loan_status
  ORDER BY amount_of_loans DESC;

SELECT	
  loan_purpose,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY loan_purpose
  ORDER BY amount_of_loans DESC;

SELECT
  state_address,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY state_address
  ORDER BY amount_of_loans DESC;

SELECT
  application_type,
  COUNT(id) AS amount_of_loans
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`
  GROUP BY application_type
  ORDER BY amount_of_loans DESC;

-- EXPLORATION of CONTINUOUS columns (mean, max, min)
-- loan_amount
SELECT
  MIN(loan_amount) AS Minimum,
  AVG(loan_amount) AS Mean,
  MAX(loan_amount) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;

-- funded_amount
SELECT
  MIN(funded_amount) AS Minimum,
  AVG(funded_amount) AS Mean,
  MAX(funded_amount) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;

-- total_payment
SELECT
  MIN(total_payment) AS Minimum,
  AVG(total_payment) AS Mean,
  MAX(total_payment) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;

-- interest_rate
SELECT
  MIN(interest_rate) AS Minimum,
  AVG(interest_rate) AS Mean,
  MAX(interest_rate) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;

-- installment
SELECT
  MIN(installment) AS Minimum,
  AVG(installment) AS Mean,
  MAX(installment) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;

-- annual_income
SELECT
  MIN(annual_income) AS Minimum,
  AVG(annual_income) AS Mean,
  MAX(annual_income) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;

-- debt_to_income
SELECT
  MIN(debt_to_income) AS Minimum,
  AVG(debt_to_income) AS Mean,
  MAX(debt_to_income) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;

-- fico_range_low
SELECT
  MIN(fico_range_low) AS Minimum,
  AVG(fico_range_low) AS Mean,
  MAX(fico_range_low) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;

-- fico_range_high
SELECT
  MIN(fico_range_high) AS Minimum,
  AVG(fico_range_high) AS Mean,
  MAX(fico_range_high) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;

-- revolving_line_utilization
SELECT
  MIN(revolving_line_utilization) AS Minimum,
  AVG(revolving_line_utilization) AS Mean,
  MAX(revolving_line_utilization) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;

-- number_of_credit_lines
SELECT
  MIN(number_of_credit_lines) AS Minimum,
  AVG(number_of_credit_lines) AS Mean,
  MAX(number_of_credit_lines) AS Maximum
  FROM `causal-axle-394212.lending_club_data_set.accepted_loans_filteredV2`;