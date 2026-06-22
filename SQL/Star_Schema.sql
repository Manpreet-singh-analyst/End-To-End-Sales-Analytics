========================================================
SECTION 02 : STAR SCHEMA CREATION
=================================

/*-------------------------------------------------------
Customer Dimension
-------------------------------------------------------*/

SELECT DISTINCT
customer_code,customer_name
INTO Customer_table_raw FROM sales_data_raw;

/*-------------------------------------------------------
Product Dimension
-------------------------------------------------------*/

SELECT DISTINCT
CONCAT(item_code,'-',HSN_code)AS Product_key,
item_code,HSN_code,item_category_description INTO Product_table_raw
FROM sales_data_raw;

/*-------------------------------------------------------
Employee Dimension
-------------------------------------------------------*/

SELECT DISTINCT
employee_code,employee_name INTO Employee_table_raw
FROM sales_data_raw 
WHERE employee_code IS NOT NULL
AND employee_name IS NOT NULL;

/*-------------------------------------------------------
Business Territory Dimension
-------------------------------------------------------*/

SELECT DISTINCT Party_category_code AS Business_territory
INTO Territory_lookup FROM sales_data_raw;

/*-------------------------------------------------------
Calendar Dimension
-------------------------------------------------------*/

SELECT DISTINCT invoice_date AS Dates INTO Calendar_lookup_table
FROM sales_data_raw;

/*-------------------------------------------------------
Fact Sales Table
-------------------------------------------------------*/

SELECT Invoice_No,Invoice_Date,Customer_Code,Employee_Code,
Party_Category_Code AS Business_Territory,
ship_to_address_city AS Customer_delivery_city,
ship_to_address_pincode AS Delivery_Pincode,Site,
Item_Amount,Item_Rate,Item_Sales_Qty,Item_Sales_UOM,
Item_Base_Qty,Item_Base_UOM,Invoice_Status,
Invoice_Type,SO_customer_PO_Number,SO_customer_PO_Date,
CONCAT(item_code,'-',HSN_code) AS Product_key
INTO Sales_table_cleaned
FROM Sales_data_raw;