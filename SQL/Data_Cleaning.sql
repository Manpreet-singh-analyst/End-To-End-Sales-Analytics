========================================================
SECTION 01 : DATA CLEANING
==========================

/* Create Database */

CREATE DATABASE Analytics_Project_1;
USE Analytics_Project_1;

/*-------------------------------------------------------
Data Type Corrections
-------------------------------------------------------*/

ALTER TABLE sales_data_raw
ALTER COLUMN item_remarks NVARCHAR(100);

ALTER TABLE sales_data_raw
ALTER COLUMN customer_code NVARCHAR(100);

/*-------------------------------------------------------
Remove Unnecessary Columns
-------------------------------------------------------*/

ALTER TABLE sales_data_raw
DROP COLUMN Target_Site_Name;

/*-------------------------------------------------------
Handle Missing Employee Records
-------------------------------------------------------*/

INSERT INTO Employee_table_raw
(Employee_code,Employee_name)
VALUES
(-1,'Unknown_employee');

/*-------------------------------------------------------
Replace Null Employee Codes
-------------------------------------------------------*/

UPDATE Sales_table_cleaned
SET employee_code=-1
WHERE employee_code IS NULL;

/*-------------------------------------------------------
Validation Checks
-------------------------------------------------------*/

SELECT invoice_no,
COUNT(DISTINCT invoice_date) Date_Count,
COUNT(DISTINCT customer_code) Customer_Count
FROM Sales_table_cleaned
GROUP BY invoice_no
ORDER BY Date_Count DESC;

select Product_key,count2,count3,count4 from (
select distinct CONCAT(item_code,'-',HSN_code) Product_key, 
count(distinct Item_code) count2, count(distinct HSN_code) count3 ,
count( distinct item_category_description) count4 from sales_data_raw
group by item_code,HSN_code) cr
where Count2 > 1 or count3>1 or  Count4 > 1;