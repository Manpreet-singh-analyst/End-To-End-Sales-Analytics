# End-to-End Industrial Adhesive Sales Analytics Dashboard

## Project Overview

This project focuses on performing end-to-end sales analytics using SQL Server and Power BI on anonymized industrial adhesive sales data. The objective was to transform raw sales transactions into meaningful business insights through data cleaning, schema design, KPI analysis, and interactive dashboards.


The project follows a complete analytics workflow:

Raw Data → Data Cleaning → Star Schema Design → SQL Business Analysis → Power BI Dashboard → Business Insights

---

## Business Problem

Organizations generate large amounts of sales data but often struggle to convert raw transactional information into actionable insights.

The purpose of this project was to:

* Clean and validate raw sales data
* Build a structured star schema model
* Analyze customer and product performance
* Generate business KPIs
* Create dashboards for decision-making

---

## Dataset Information

The dataset contains anonymized industrial adhesive sales transactions including:

- Invoice details
- Customer information
- Product information
- Employee information
- Business territories
- Order values
- Sales quantities
- Order dates

Note:

Customer names and sensitive business information were anonymized before publication.

---

## Tools Used

* SQL Server
* SQL Server Management Studio (SSMS)
* Power BI
* Power Query
* Excel
* GitHub

---

## Project Workflow

### Step 1: Data Cleaning

Performed:

* Removed unnecessary columns
* Inspected null values
* Checked duplicate records
* Validated customer information
* Validated product information
* Corrected data types
* Standardized records

---

### Step 2: Star Schema Creation

Dimension Tables:

* Customer Table
* Product Table
* Employee Table
* Calendar Table
* Territory Table

Fact Table:

* Sales Table

---

### Step 3: SQL Analytics & KPIs

## SQL Analysis & Business KPIs

### Core Business KPIs

* Total Revenue
* Total Orders
* Total Customers
* Average Order Value (AOV)
* Revenue by Year
* Revenue by Business Territory
* Top 10 Customers
* Top 10 Products

### Customer Analytics

* Customer Lifespan Analysis
* Customer Recency Analysis
* Customer Purchase Frequency
* Revenue Contribution %
* Biggest Order Customer
* Most Active / Most Consistent Customers

### Advanced SQL Analytics

* Customer Revenue Ranking (DENSE_RANK)
* Product Revenue Ranking
* Running Revenue Analysis
* Year-over-Year Growth (LAG)
* Moving Average Revenue Trends
* Top Product per Region
* Top Customer per Region

### CTE & Window Function Problems

* Top 5 Customers per Region
* Biggest Order per Year
* Customer Segmentation
* Pareto Analysis (80/20 Rule)
* Customer Churn Risk Detection
* Repeat Customer Rate Analysis

### SQL Concepts Demonstrated

* JOIN operations
* CTEs
* Window functions
* Aggregate functions
* DENSE_RANK(), ROW_NUMBER(), LAG(), NTILE()
* Running totals
* Business KPI calculations
* Customer segmentation logic
* Analytical problem solving


---

## Dashboard Pages

### Executive Dashboard

Contains:

* Total Revenue
* Total Orders
* Total Customers
* Revenue trends
* Territory performance

### Customer Dashboard

Contains:

* Top customers
* Customer segmentation
* Customer revenue contribution
* Customer behavior insights

### Product Dashboard

Contains:

* Top products
* Product performance
* Revenue trends
* Product ranking

---

## Key Business Insights

* Revenue concentration exists among top customers
* Some territories contribute significantly higher revenue than others
* Customer purchasing behavior varies significantly
* Repeat customers generate a major portion of sales
* Product performance differs across territories

---

## Repository Structure

Sales-Analytics-Project/

├── SQL
│ ├── Data_Cleaning.sql
│ ├── Star_Schema.sql
│ └── Business_KPIs.sql

├── Dashboard
│ ├── Executive_Dashboard.png
│ ├── Customer_Dashboard.png
│ ├── Product_Dashboard.png
│ └── Dashboard.pbix

├── Documentation
│ ├── Data_Cleaning_Log.md
│ └── Data_Model.png

└── README.md

---

## Future Improvements

* Customer retention analysis
* Predictive analytics
* Time-series forecasting
* Advanced segmentation techniques

---

## Author

Manpreet Singh

