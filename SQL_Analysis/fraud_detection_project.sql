CREATE DATABASE fraud_detection;
USE fraud_detection;


CREATE TABLE mobile_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    step INT,  
    type VARCHAR(20),  
    amount DECIMAL(10,2),  
    nameOrig VARCHAR(20),  
    oldbalanceOrg DECIMAL(10,2),  
    newbalanceOrig DECIMAL(10,2),  
    nameDest VARCHAR(20),  
    oldbalanceDest DECIMAL(10,2),  
    newbalanceDest DECIMAL(10,2),  
    isFraud TINYINT(1),  
    isFlaggedFraud TINYINT(1)  
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/financialdata.csv'
INTO TABLE mobile_transactions
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(@step, @type, @amount, @nameOrig, @oldbalanceOrg, @newbalanceOrig, @nameDest, @oldbalanceDest, @newbalanceDest, @isFraud, @isFlaggedFraud)
SET 
    step = @step,
    type = NULLIF(TRIM(@type), ''),
    amount = @amount,
    nameOrig = NULLIF(TRIM(@nameOrig), ''),
    oldbalanceOrg = @oldbalanceOrg,
    newbalanceOrig = @newbalanceOrig,
    nameDest = NULLIF(TRIM(@nameDest), ''),
    oldbalanceDest = @oldbalanceDest,
    newbalanceDest = @newbalanceDest,
    isFraud = @isFraud,
    isFlaggedFraud = @isFlaggedFraud;
    
SELECT COUNT(*) FROM mobile_transactions WHERE type IS NULL OR nameOrig IS NULL OR nameDest IS NULL;
SELECT type, nameOrig, nameDest FROM mobile_transactions WHERE type IS NULL LIMIT 10;

SELECT * FROM mobile_transactions LIMIT 10;

SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'mobile_transactions';
SELECT `type`, COUNT(*) FROM mobile_transactions GROUP BY `type`;
SELECT DISTINCT type FROM mobile_transactions;

SELECT transaction_id, COUNT(*) 
FROM mobile_transactions 
GROUP BY transaction_id 
HAVING COUNT(*) > 1;

-- EXPLORATORY DATA ANALYSIS 

-- basic summary statistics

SELECT 
    COUNT(*) AS total_transactions, 
    SUM(isFraud) AS fraudulent_transactions, 
    SUM(isFlaggedFraud) AS flagged_transactions,
    (SUM(isFraud) / COUNT(*)) * 100 AS fraud_percentage 
FROM mobile_transactions;

-- Check the distribution of transaction types

SELECT type, COUNT(*) AS total_count 
FROM mobile_transactions 
GROUP BY type 
ORDER BY total_count DESC;

-- finding the highest transaction amounts

SELECT * 
FROM mobile_transactions 
ORDER BY amount DESC 
LIMIT 10;

-- FRAUD DETECTION STRATEGY
-- finding fraud transactions by type

SELECT type, COUNT(*) AS fraud_count 
FROM mobile_transactions 
WHERE isFraud = 1 
GROUP BY type 
ORDER BY fraud_count DESC;

-- Checking for suspicious transactions (high amounts, multiple transactions from the same origin)

SELECT nameOrig, COUNT(*) AS transaction_count, SUM(amount) AS total_amount 
FROM mobile_transactions 
WHERE isFraud = 1 
GROUP BY nameOrig 
HAVING COUNT(*) > 1 
ORDER BY total_amount DESC;

-- rechecking or verifying
SELECT nameOrig, COUNT(*) AS fraud_count
FROM mobile_transactions
WHERE isFraud = 1
GROUP BY nameOrig
ORDER BY fraud_count DESC;


-- Checking for suspicious repeated transactions 

SELECT nameOrig, COUNT(*) AS transaction_count, SUM(amount) AS total_amount
FROM mobile_transactions
GROUP BY nameOrig
HAVING COUNT(*) > 3
ORDER BY total_amount DESC;

-- Find Fraudsters Who Sent Money to the Same Destination Multiple Times

SELECT nameOrig, nameDest, COUNT(*) AS transaction_count, SUM(amount) AS total_amount
FROM mobile_transactions
WHERE isFraud = 1
GROUP BY nameOrig, nameDest
HAVING COUNT(*) > 1
ORDER BY total_amount DESC;

-- Compare Balance Changes in Fraudulent Transactions

SELECT nameOrig, oldbalanceOrg, newbalanceOrig, amount, 
       (oldbalanceOrg - newbalanceOrig) AS balance_difference
FROM mobile_transactions
WHERE isFraud = 1
ORDER BY balance_difference DESC;

-- Detect Large Transactions Flagged as Fraud
SELECT amount, nameOrig, nameDest, isFraud
FROM mobile_transactions
WHERE isFlaggedFraud = 1
ORDER BY amount DESC;

-- Identifying suspicious recipients (money laundering)
SELECT nameDest, COUNT(*) AS fraud_count, SUM(amount) AS total_fraud_amount
FROM mobile_transactions
WHERE isFraud = 1
GROUP BY nameDest
ORDER BY fraud_count DESC;

-- Identifying transactions just below the fraud threshold
SELECT * 
FROM mobile_transactions
WHERE amount BETWEEN (SELECT MIN(amount) FROM mobile_transactions WHERE isFlaggedFraud = 1) * 0.9 
AND (SELECT MIN(amount) FROM mobile_transactions WHERE isFlaggedFraud = 1);

-- Most common transactions types in fraud
SELECT type, COUNT(*) AS fraud_count, SUM(amount) AS total_fraud_amount
FROM mobile_transactions
WHERE isFraud = 1
GROUP BY type
ORDER BY fraud_count DESC;

-- Identifying fraud trends over time
SELECT step AS time_step, COUNT(*) AS fraud_count
FROM mobile_transactions
WHERE isFraud = 1
GROUP BY step
ORDER BY time_step;

-- identification of high risk users (multiple large transactions)
SELECT nameOrig, COUNT(*) AS transaction_count, SUM(amount) AS total_amount
FROM mobile_transactions
WHERE amount > (SELECT AVG(amount) FROM mobile_transactions) * 2
GROUP BY nameOrig
HAVING transaction_count > 3
ORDER BY total_amount DESC;

-- ADVANCED ANALYSIS
-- Unusual Behavior Detection Based on Historical User Patterns

-- Calculate Average and Standard Deviation of Transaction Amounts per User
CREATE TEMPORARY TABLE user_stats AS
SELECT 
    nameOrig,
    AVG(amount) AS avg_amount,
    STDDEV(amount) AS std_dev_amount
FROM 
    mobile_transactions
GROUP BY 
    nameOrig;
-- Join with Main Table and Detect Outliers
SELECT 
    t.transaction_id,
    t.nameOrig,
    t.amount,
    us.avg_amount,
    us.std_dev_amount,
    CASE 
        WHEN t.amount > us.avg_amount + 2 * us.std_dev_amount THEN 'Anomalous'
        ELSE 'Normal'
    END AS anomaly_status
FROM 
    mobile_transactions t
JOIN 
    (
        SELECT 
            nameOrig,
            AVG(amount) AS avg_amount,
            STDDEV(amount) AS std_dev_amount
        FROM 
            mobile_transactions
        GROUP BY 
            nameOrig
    ) us ON t.nameOrig = us.nameOrig
WHERE 
    t.amount > us.avg_amount + 2 * us.std_dev_amount
ORDER BY 
    t.amount DESC;

--  Detect Top 1% Transactions (Potential Anomalies)
WITH AmountRanks AS (
    SELECT 
        transaction_id,
        nameOrig,
        type,
        amount,
        isFraud,
        isFlaggedFraud,
        NTILE(100) OVER (ORDER BY amount) AS percentile
    FROM mobile_transactions
)
SELECT 
    transaction_id,
    nameOrig,
    type,
    amount,
    isFraud,
    isFlaggedFraud
FROM AmountRanks
WHERE percentile >= 99
ORDER BY amount DESC;

-- What percent of these are frauds

SELECT 
    COUNT(*) AS total_top1_percent,
    SUM(isFraud) AS fraud_cases_in_top1_percent,
    ROUND(SUM(isFraud)*100.0 / COUNT(*), 2) AS fraud_rate_percent
FROM (
    SELECT 
        isFraud
    FROM (
        SELECT isFraud, NTILE(100) OVER (ORDER BY amount) AS percentile
        FROM mobile_transactions
    ) AS ranked
    WHERE percentile >= 99
) AS top1;

-- Top transaction types in this 1%?

SELECT 
    type,
    COUNT(*) AS count,
    SUM(isFraud) AS frauds
FROM (
    SELECT type, isFraud, NTILE(100) OVER (ORDER BY amount) AS percentile
    FROM mobile_transactions
) AS ranked
WHERE percentile >= 99
GROUP BY type
ORDER BY count DESC;

-- Fraud Trends Over Time

SELECT 
    step,
    COUNT(CASE WHEN isFraud = 1 THEN 1 END) AS fraud_count,
    COUNT(CASE WHEN isFraud = 0 THEN 1 END) AS non_fraud_count
FROM mobile_transactions
GROUP BY step
ORDER BY step;

-- SPIKE DETECTION

WITH fraud_trend AS (
    SELECT 
        step,
        COUNT(*) AS fraud_count
    FROM mobile_transactions
    WHERE isFraud = 1
    GROUP BY step
),
stats AS (
    SELECT 
        AVG(fraud_count) AS avg_fraud,
        STDDEV(fraud_count) AS std_fraud
    FROM fraud_trend
)
SELECT 
    f.step,
    f.fraud_count,
    s.avg_fraud,
    s.std_fraud,
    CASE 
        WHEN f.fraud_count > s.avg_fraud + 2 * s.std_fraud THEN 'Spike Detected'
        ELSE 'Normal'
    END AS anomaly_status
FROM fraud_trend f
JOIN stats s ON 1=1
ORDER BY f.step;

-- DETECTING FRAUD SPIKES OVER STEPS

WITH fraud_per_step_type AS (
    SELECT type, step, COUNT(*) AS fraud_count
    FROM mobile_transactions
    WHERE isFraud = 1
    GROUP BY type, step
),
avg_fraud_type AS (
    SELECT type, AVG(fraud_count) AS avg_fraud_count
    FROM fraud_per_step_type
    GROUP BY type
)
SELECT fps.type, fps.step, fps.fraud_count, a.avg_fraud_count,
       CASE 
           WHEN fps.fraud_count > a.avg_fraud_count * 1.5 THEN 'Spike Detected'
           ELSE 'Normal'
       END AS status
FROM fraud_per_step_type fps
JOIN avg_fraud_type a ON fps.type = a.type
ORDER BY fps.type, fps.fraud_count DESC;


-- TRANSACTION TYPE DISTRIBUTION AT SPIKE STEPS
-- analysis of  top 2 spikes

SELECT step, type, COUNT(*) AS txn_count
FROM mobile_transactions
WHERE isFraud = 1 AND step IN (22, 66)
GROUP BY step, type
ORDER BY step, txn_count DESC;

-- Add a Visual Summary Table

SELECT 
    step,
    type,
    COUNT(*) AS transaction_count,
    SUM(isFraud) AS fraud_count
FROM mobile_transactions
WHERE step IN (22, 66)
GROUP BY step, type
ORDER BY step, type;

-- Add % Fraud Within Each Step+Type

SELECT 
    step,
    type,
    COUNT(*) AS total_txns,
    SUM(isFraud) AS fraud_txns,
    ROUND(100.0 * SUM(isFraud) / COUNT(*), 2) AS fraud_percentage
FROM mobile_transactions;

-- Comparing against global averages

SELECT type,
    ROUND(100.0 * SUM(isFraud) / COUNT(*), 2) AS global_fraud_percentage
FROM mobile_transactions
GROUP BY type
ORDER BY global_fraud_percentage DESC;

-- Profile Suspicious users at spike steps

SELECT 
    step,
    nameOrig,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(100.0 * SUM(isFraud) / COUNT(*), 2) AS fraud_rate
FROM mobile_transactions
WHERE step IN (22, 66)
GROUP BY step, nameOrig
HAVING SUM(isFraud) > 0
ORDER BY fraud_rate DESC, fraud_transactions DESC;

-- Profile suspicious recipients

SELECT 
    step,
    nameDest,
    COUNT(*) AS total_incoming_txns,
    SUM(isFraud) AS fraud_incoming,
    ROUND(100.0 * SUM(isFraud) / COUNT(*), 2) AS incoming_fraud_rate
FROM mobile_transactions
WHERE step IN (22, 66)
GROUP BY step, nameDest
HAVING SUM(isFraud) > 0
ORDER BY fraud_incoming DESC, incoming_fraud_rate DESC;

-- Full Spike summary query

SELECT 
    step,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count,
    COUNT(DISTINCT type) AS transaction_type_count,
    GROUP_CONCAT(DISTINCT type ORDER BY type SEPARATOR ', ') AS transaction_types_involved,
    COUNT(DISTINCT nameOrig) AS suspicious_users_count,
    'Spike Detected' AS spike_flag
FROM mobile_transactions
WHERE step IN (22, 66, 6, 74, 34, 47, 59, 15, 58, 69, 71, 65, 36, 9)
  AND isFraud = 1
GROUP BY step
ORDER BY fraud_count DESC;









