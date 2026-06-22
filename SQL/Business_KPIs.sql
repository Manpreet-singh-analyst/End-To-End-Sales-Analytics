========================================================
SECTION 03 : BUSINESS KPIs & ADVANCED ANALYTICS
===============================================

---

## EXECUTIVE KPIs

/* KPI 01 Total Revenue */

SELECT
SUM(item_amount)/10000000
AS Total_Revenue_Cr
FROM Sales_table_cleaned;

/* KPI 02 Total Orders */

SELECT
COUNT(DISTINCT Invoice_no)
AS Total_Orders
FROM Sales_table_cleaned;

/* KPI 03 Total Customers */

SELECT
COUNT(DISTINCT Customer_code)
AS Total_Customers
FROM Sales_table_cleaned;

/* KPI 04 Average Order Value */

SELECT SUM(item_amount)/ COUNT(DISTINCT Invoice_no)
AS Average_Order_Value
FROM Sales_table_cleaned;

/* KPI 05 Revenue by Year */

SELECT YEAR(invoice_date) Years,SUM(item_amount) Revenue_per_year
FROM Sales_table_cleaned
GROUP BY YEAR(invoice_date)
ORDER BY Years;

/* KPI 06 Revenue by Territory */

SELECT Business_territory, SUM(item_amount)/10000000 Revenue_Cr
FROM Sales_table_cleaned
GROUP BY Business_territory;


---

## CUSTOMER ANALYTICS

/* KPI 07 : Top 10 Customers */

SELECT TOP 10
CTR.Customer_Code,Customer_name,
SUM(item_amount)/10000000 Revenue_Per_Customer
FROM sales_table_cleaned STC
LEFT JOIN customer_table_raw CTR
ON STC.Customer_code=CTR.customer_code
GROUP BY CTR.customer_code,Customer_name
ORDER BY Revenue_Per_Customer DESC;

/* KPI 08 : Customer Lifespan */

SELECT CTR.Customer_code, Customer_name,DATEDIFF(DAY,MIN(invoice_date),MAX(invoice_date)) Customer_lifespan
FROM sales_table_cleaned STC
LEFT JOIN customer_table_raw CTR
ON STC.customer_code=CTR.customer_code
GROUP BY CTR.Customer_Code,Customer_name
ORDER BY Customer_lifespan DESC;

/* KPI 09 : Customer Recency */

SELECT CTR.Customer_code,Customer_name,
DATEDIFF(DAY,MAX(invoice_date),CAST(GETDATE() AS DATE)) Customer_Recency
FROM sales_table_cleaned STC
LEFT JOIN customer_table_raw CTR
ON STC.customer_code=CTR.customer_code
GROUP BYCTR.Customer_Code,Customer_name
ORDER BY Customer_Recency ASC;

/* KPI 10 : Customer Frequency */

WITH customer_orders AS(
SELECT customer_code,COUNT(DISTINCT invoice_no)AS Orders_placed,
DATEDIFF(MONTH,MIN(invoice_date),MAX(invoice_date))+1 AS Active_months
FROM sales_table_cleaned
GROUP BY customer_code
)

SELECT customer_code,Orders_placed,Active_months,
ROUND(Orders_placed*1.0/Active_months,2) AS Order_Frequency
FROM customer_orders
ORDER BY Order_Frequency DESC;

/* KPI 11 : Revenue Contribution Percentage */

SELECT customer_code, SUM(item_amount) AS Revenue_per_customer,
ROUND((SUM(item_amount)/SUM(SUM(item_amount)) OVER())*100,2) AS Revenue_Contribution_Percentage
FROM sales_table_cleaned
GROUP BY customer_code
ORDER BY Revenue_per_customer DESC;

/* KPI 12 : Biggest Order Customer */

SELECT TOP 1 CTR.Customer_code,Customer_name,Invoice_no,SUM(item_amount) AS Biggest_order
FROM sales_table_cleaned STC
LEFT JOIN customer_table_raw CTR
ON CTR.Customer_code=STC.Customer_code
GROUP BY CTR.customer_code,Customer_name,Invoice_no
ORDER BY Biggest_order DESC;

/* KPI 13 : Most Consistent Customer */(and  gap_days >0)

With DIstinct_orders as (
select Distinct Customer_code,invoice_no ,Invoice_date 
from Sales_table_cleaned ),

order_gap as(
select Customer_code,invoice_no ,Invoice_date,lag(invoice_date) over(partition by customer_code order by invoice_date) LG,
count( invoice_no) over(partition by customer_code) Total_orders,
Datediff(day,lag(invoice_date) over(partition by customer_code order by invoice_date),invoice_date) Order_gap_in_days 
from distinct_orders),

 consistent_customers as(
select Customer_code, Avg(order_gap_in_days) Avg_order_gap,stdev(order_gap_in_days) Variation_in_gaps,
dense_rank() over(order by stdev(order_gap_in_days),Avg(order_gap_in_days)) DRN from order_gap
where order_gap_in_days is not null 
and total_orders > 2
group by customer_code)

select cc.Customer_code,customer_name,variation_in_gaps,avg_order_gap,DRN
from consistent_customers CC
left join Customer_table_raw CTR
on CTR.customer_code = CC.customer_code
where DRN = 1 ;

/* KPI 14 : Most Active Customer */

SELECT customer_name as  most_active_customers, Months_Ordered
FROM(
SELECT CTR.Customer_Code,customer_name,COUNT(DISTINCT FORMAT(invoice_date,'yyMM')) AS Months_Ordered,
DENSE_RANK()OVER(ORDER BY COUNT(DISTINCT FORMAT(invoice_date,'yyMM'))DESC) customer_rank
FROM sales_table_cleaned STC
LEFT JOIN Customer_table_raw CTR
ON STC.Customer_code=Ctr.customer_code
GROUP BY CTR.Customer_Code, customer_name
) CMO
WHERE customer_rank=1;

/* KPI 15 : Customer Segmentation */

WITH customer_revenue AS(
SELECT CTR.Customer_code, Customer_name, SUM(item_amount)revenue_per_customer,
NTILE(3)OVER(ORDER BY SUM(item_amount) DESC) Customer_segments
FROM sales_table_cleaned STC
LEFT JOIN customer_table_raw CTR
ON STC.Customer_code=CTR.Customer_code
GROUP BY CTR.Customer_code, Customer_name
)

SELECT *,CASE WHEN Customer_segments=1 THEN 'High Value Customers'
WHEN Customer_segments=2 THEN 'Average Value Customers' ELSE 'Low Value Customers'
END Customer_segmentation
FROM customer_revenue;

/* KPI 16 : Customer Churn Risk */

SELECT stc.customer_code,customer_name ,MAX(cast(invoice_date as date)) Last_order,
DATEDIFF(DAY,MAX(invoice_date),GETDATE())Days_inactive
FROM sales_table_cleaned stc
left join Customer_table_raw CTR
on CTR.Customer_Code = STC.customer_code
group by stc.customer_code,Customer_name
HAVING DATEDIFF(DAY,MAX(invoice_date),GETDATE())>180;

/* KPI 17 : Repeat Customer Rate */

WITH repeat_customers AS(
SELECT customer_code
FROM sales_table_cleaned
GROUP BY customer_code
HAVING COUNT(DISTINCT invoice_no)>1
)

SELECT ROUND(COUNT(*)*100.0/(
SELECT
COUNT(DISTINCT customer_code)FROM sales_table_cleaned),2)AS Repeat_customer_rate
FROM repeat_customers;

---

## ADVANCED SQL

/* KPI 18 : Customer Revenue Ranking */

SELECT CTR.Customer_code,Customer_name, SUM(item_amount) Revenue_per_customer,
DENSE_RANK() OVER( ORDER BY SUM(item_amount) DESC) Customer_rank
FROM sales_table_cleaned STC
LEFT JOIN customer_table_raw CTR
ON CTR.customer_code=STC.customer_code
GROUP BY CTR.customer_code,Customer_name;

/* KPI 19 : Product Revenue Ranking */

SELECT PT.Product_key,Item_code, SUM(item_amount) Revenue_per_product,
DENSE_RANK()OVER(ORDER BY SUM(item_amount) DESC) Product_rank
FROM sales_table_cleaned STC
LEFT JOIN Product_table_raw PT
ON PT.product_key=STC.product_key
GROUP BY PT.product_key,Item_code;

/* KPI 20 : Running Revenue */

SELECT *,SUM(Revenue_per_year)OVER(ORDER BY Years)Running_total_Revenue
FROM(
SELECT YEAR(invoice_date) Years, SUM(item_amount) Revenue_per_year
FROM sales_table_cleaned
GROUP BY YEAR(invoice_date)) AP;

/* KPI 21 : YoY Growth */

SELECT YEAR(invoice_date) Years,SUM(item_amount)Revenue_per_year,LAG(SUM(item_amount))OVER(ORDER BY YEAR(invoice_date))Revenue_previous_year,
ROUND(((SUM(item_amount)/LAG(SUM(item_amount))OVER(ORDER BY YEAR(invoice_date)))-1)*100,2)AS YoY_growth
FROM sales_table_cleaned
GROUP BY YEAR(invoice_date);

/* KPI 22 : Moving Average Revenue */

WITH monthly_revenue AS (
SELECT
FORMAT(invoice_date,'yyyy-MM') AS Month_Year,SUM(item_amount) AS Revenue
FROM sales_table_cleaned
GROUP BY FORMAT(invoice_date,'yyyy-MM')
)

SELECT Month_Year, Revenue,AVG(Revenue) OVER(ORDER BY Month_YearROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Avg_3_Month
FROM monthly_revenue
ORDER BY Month_Year;

/* KPI 23 : Top Product Per Region */

WITH ProductRank AS(
SELECT business_territory, PTR.product_key, Item_code,SUM(item_amount) Revenue,
ROW_NUMBER() OVER(PARTITION BY business_territory ORDER BY SUM(item_amount) DESC
) Product_rank
FROM sales_table_cleaned STC
LEFT JOIN Product_table_raw PTR
ON STC.product_key=PTR.product_key
GROUP BY business_territory,PTR.product_key,Item_code
)

SELECT * FROM ProductRank
WHERE Product_rank=1;

/* KPI 24 : Top Customer Per Region */

WITH CustomerRank AS(
SELECT business_territory,CTR.customer_code,Customer_name,
SUM(item_amount) Revenue,ROW_NUMBER() OVER( PARTITION BY business_territory ORDER BY SUM(item_amount) DESC) Customer_rank
FROM sales_table_cleaned STC
LEFT JOIN Customer_table_raw CTR
ON STC.customer_code=CTR.customer_code
GROUP BY business_territory,CTR.customer_code,Customer_name
)

SELECT *
FROM CustomerRank
WHERE Customer_rank=1;

/* KPI 25 : Top 5 Customers Per Region */

WITH CustomerRank AS(

SELECT business_territory,CTR.customer_code,Customer_name,SUM(item_amount) Revenue,
ROW_NUMBER() OVER( PARTITION BY business_territoryORDER BY SUM(item_amount) DESC) Customer_rank
FROM sales_table_cleaned STC
LEFT JOIN Customer_table_raw CTR
ON STC.customer_code=CTR.customer_code
GROUP BY business_territory,CTR.customer_code,Customer_name
)

SELECT * FROM CustomerRank WHERE Customer_rank<=5;

/* KPI 26 : Biggest Order Per Year */

WITH BiggestOrders AS(
SELECT
YEAR(invoice_date) Years,CTR.customer_code,Customer_name,invoice_no,
SUM(item_amount) Order_value,DENSE_RANK() OVER(PARTITION BY YEAR(invoice_date)ORDER BY SUM(item_amount) DESC) Order_rank
FROM sales_table_cleaned STC
LEFT JOIN Customer_table_raw CTR
ON STC.customer_code=CTR.customer_code
GROUP BY YEAR(invoice_date),CTR.customer_code,Customer_name,invoice_no
)

SELECT *
FROM BiggestOrders
WHERE Order_rank=1;

/* KPI 27 : Pareto Analysis (80/20 Rule) */

WITH TopCustomers AS(
SELECT customer_code, SUM(item_amount) Revenue_per_customer,
PERCENT_RANK() OVER(ORDER BY SUM(item_amount) DESC) Customer_percentile
FROM sales_table_cleaned
GROUP BY customer_code
),

TotalRevenue AS(
SELECT SUM(item_amount) Total_revenue
FROM sales_table_cleaned
)

SELECT ROUND((SUM(Revenue_per_customer)/MAX(Total_revenue))*100,2)AS Revenue_from_top_20_percent
FROM TopCustomers
CROSS JOIN TotalRevenue
WHERE Customer_percentile<=0.20;