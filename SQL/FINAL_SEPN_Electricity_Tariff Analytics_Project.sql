-- BEGINNING OF PERSONAL PROJECT SCRIPT

-- Creating a database named 'SEPN_charges_db' and using the database for personal project.

DROP DATABASE IF EXISTS SEPN_charges_db;
CREATE DATABASE IF NOT EXISTS SEPN_charges_db;

USE SEPN_charges_db; -- Selecting the databse to use for personal project.

-- Creating 3 tables in Project database 'sepn_charges_db'

-- Creating 22/23 table: sepn_charges_2022_23_tb

DROP TABLE IF EXISTS sepn_charges_2022_23_tb;
CREATE TABLE IF NOT EXISTS sepn_charges_2022_23_tb (
    Name VARCHAR(50) NOT NULL,
    Import_Super_Red_charge DECIMAL(10,2) NOT NULL,
    Import_fixed_charge DECIMAL(10,2) NOT NULL,
    Export_Super_Red_charge DECIMAL(10,2) NOT NULL,
    Export_fixed_charge DECIMAL(10,2) NOT NULL
    );

-- Creating 23/24 table: sepn_charges_2023_24_tb

DROP TABLE IF EXISTS sepn_charges_2023_24_tb;

CREATE TABLE IF NOT EXISTS sepn_charges_2023_24_tb (
	Name VARCHAR (50) NOT NULL,
	Residual_Charging_Band TINYINT UNSIGNED NOT NULL,
	Import_Super_Red_charge DECIMAL (10,2) NOT NULL,
	Import_fixed_charge DECIMAL (10,2) NOT NULL,
	Export_Super_Red_charge DECIMAL (10,2) NOT NULL,
	Export_fixed_charge DECIMAL (10,2) NOT NULL
    );

-- Creating 24/25 table: sepn_charges_2024_25_tb

DROP TABLE IF EXISTS sepn_charges_2024_25_tb;

CREATE TABLE IF NOT EXISTS sepn_charges_2024_25_tb (
Name VARCHAR (50) NOT NULL,
Residual_Charging_Band TINYINT UNSIGNED NOT NULL,
Import_Super_Red_charge DECIMAL (10,2) NOT NULL,
Import_fixed_charge DECIMAL (10,2) NOT NULL,
Export_Super_Red_charge DECIMAL (10,2) NOT NULL,
Export_fixed_charge DECIMAL (10,2) NOT NULL
);

-- Load the below three csv files into each tables.
-- 1. sepn_charges_2022_23.csv
-- 2. sepn_charges_2023_24.csv
-- 3. sepn_charges_2024_25.csv

-- Loading data from sepn_charges_2022_23.csv into sepn_charges_2022_23_tb.

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PERSONAL PROJECT\\sepn_charges_2022_23.csv'
INTO TABLE sepn_charges_2022_23_tb
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verifying data inputs for table sepn_charges_2022_23_tb
SELECT *
FROM sepn_charges_2022_23_tb
LIMIT 5;

-- Loading data from sepn_charges_2023_24.csv into sepn_charges_2023_24_tb.

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PERSONAL PROJECT\\sepn_charges_2023_24.csv'
INTO TABLE sepn_charges_2023_24_tb
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verifying data inputs for sepn_charges_2023_24_tb
SELECT *
FROM sepn_charges_2023_24_tb
LIMIT 5;

-- Loading data from sepn_charges_2024_25.csv into sepn_charges_2024_25_tb.

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PERSONAL PROJECT\\sepn_charges_2024_25.csv'
INTO TABLE sepn_charges_2024_25_tb
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verifying data inputs for sepn_charges_2024_25_tb
SELECT *
FROM sepn_charges_2024_25_tb
LIMIT 5;
 
-- 1. Write SQL codes to check the structures of each of the 3 tables
DESC sepn_charges_2022_23_tb;
DESC sepn_charges_2023_24_tb;
DESC sepn_charges_2024_25_tb;

-- 2. Write SQL codes to display the number of records in each table.
SELECT COUNT(*)
FROM sepn_charges_2022_23_tb;

SELECT COUNT(*)
FROM sepn_charges_2023_24_tb;

SELECT COUNT(*)
FROM sepn_charges_2024_25_tb;

-- 3. Write SQL codes to display the number of customers who are
-- non-final demand (That is customers with zero(0) values as Residual Bands
-- for the year 2023/24 and 2024/25.

-- Count Non-final demand customers for 2023/24

SELECT COUNT(*) AS non_final_2023_24
FROM sepn_charges_2023_24_tb
WHERE Residual_Charging_Band = 0;

-- Count Non-final demand customers for 2024/25

SELECT COUNT(*) AS non_final_2024_25
FROM sepn_charges_2024_25_tb
WHERE Residual_Charging_Band = 0;

-- 4. Write SQL codes to display the number of customers who are final demand
-- (That is customers with values 1 to 4 as Residual Bands for the year 2023/24
-- and 2024/25.

-- Final demand customers for 2023/24
SELECT COUNT(*) AS final_2023_24
FROM sepn_charges_2023_24_tb
WHERE Residual_Charging_Band BETWEEN 1 AND 4;

-- Final demand customers for 2024/25
SELECT COUNT(*) AS final_2024_25
FROM sepn_charges_2024_25_tb
WHERE Residual_Charging_Band BETWEEN 1 AND 4;

-- 5. Write SQL Codes to calculate the annual import fixed charges
-- for each customers of the three years.

-- Annual import fixed charges for 2022/23
SELECT Name AS Customer_name, (Import_fixed_charge*12) AS Y22_23_Annual_IFC
FROM sepn_charges_2022_23_tb
LIMIT 5;

-- Annual import fixed charges for 2023/24
SELECT Name AS Customer_name, (Import_fixed_charge*12) AS Y23_24_Annual_IFC
FROM sepn_charges_2023_24_tb
LIMIT 5;

-- Annual import fixed charges for 2024/25
SELECT Name AS Customer_name, (Import_fixed_charge*12) AS Y24_25_Annual_IFC
FROM sepn_charges_2024_25_tb
LIMIT 5;

-- 6. Write SQL code to extract the year 2023/24 customer name,
-- 2023/24 residual bands, each year daily import fixed charge,
-- and each year annual import fixed charge. The result should be
-- extracted where 23/24 residual bands is equal to 24/25 residual bands,
-- and the 2023/24 customer names is equal to 2024/25 customer names and 2022/23 customer names. 

-- 7. Create a temporary table (view) based on the query results in question 6.

DROP TEMPORARY TABLE IF EXISTS Yearly_IFC_summary_tb;

CREATE TEMPORARY TABLE Yearly_IFC_summary_tb AS
SELECT
    t23_24.Name AS Y23_24_Customer_name,
    t23_24.Residual_Charging_Band AS Y23_24_Residual_bands,
    CAST(t22_23.Import_fixed_charge / 30 AS DECIMAL(10,4)) AS Y22_23_Daily_IFC,
    CAST(t23_24.Import_fixed_charge / 30 AS DECIMAL(10,4)) AS Y23_24_Daily_IFC,
    CAST(t24_25.Import_fixed_charge / 30 AS DECIMAL(10,4)) AS Y24_25_Daily_IFC,
    CAST(t22_23.Import_fixed_charge * 12 AS DECIMAL(15,4)) AS Y22_23_Annual_IFC,
    CAST(t23_24.Import_fixed_charge * 12 AS DECIMAL(15,4)) AS Y23_24_Annual_IFC,
    CAST(t24_25.Import_fixed_charge * 12 AS DECIMAL(15,4)) AS Y24_25_Annual_IFC
FROM sepn_charges_2022_23_tb t22_23,
     sepn_charges_2023_24_tb t23_24,
     sepn_charges_2024_25_tb t24_25
WHERE t23_24.Name = t24_25.Name
  AND t23_24.Name = t22_23.Name
  AND t23_24.Residual_Charging_Band = t24_25.Residual_Charging_Band;

-- Taking a peep into the temporary table Yearly_IFC_summary_tb
SELECT *
FROM Yearly_IFC_summary_tb;
    
    -- 8. Write a SQL query to extract the residual bands 
    -- and annual fixed charges from the view created in question 7 and
    -- then Aggregate the annual fixed charges based on bands for each year
    -- and order them based on bands.
SELECT
    Y23_24_Residual_bands,
    SUM(Y22_23_Annual_IFC) AS TOTAL_22_23_Annual_IFC,
    SUM(Y23_24_Annual_IFC) AS TOTAL_23_24_Annual_IFC,
    SUM(Y24_25_Annual_IFC) AS TOTAL_24_25_Annual_IFC
FROM Yearly_IFC_summary_tb
GROUP BY Y23_24_Residual_bands
ORDER BY Y23_24_Residual_bands;

-- END OF PERSONAL PROJECT SCRIPT
