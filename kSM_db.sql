CREATE DATABASE KSM_db;

---1. PRODUCT CATEGORY WITH THE HIGHEST SALES-----
SELECT TOP 1 Product_Category, SUM(Sales) AS Total_Sales
FROM KMS_Inventory
GROUP BY Product_Category
ORDER BY Total_Sales DESC

----2. TOP 3 AND BUTTOM 3REGION IN TERMS OF SALES-----
---TOP 3 REGION--
SELECT TOP 3 Region, SUM(Sales) AS Total_Sales
FROM KMS_Inventory
GROUP BY Region
ORDER BY Total_Sales DESC

---BUTTOM 3--
SELECT TOP 3 Region, SUM(Sales) AS Total_Sales
FROM KMS_Inventory
GROUP BY Region
ORDER BY Total_Sales ASC

---3. TOTAL OF SALE OF APPLIANCES IN ONTARIO---
SELECT SUM(SALES) AS Total_Sales 
FROM KMS_Inventory
WHERE Product_Sub_Category = 'Appliances'
AND Region = 'Ontario'

---4. ADVISE TO INCREASE REVENUE FOR THE BUTTOM 10 CUSTOMER----
SELECT TOP 10 Customer_Name, 
SUM(Sales) AS Lowest_Customer_Sales, 
SUM(Profit) AS Total_Profit,
SUM(Shipping_Cost) AS Total_Shipping_Cost,
SUM(Discount) AS Total_Discount,
COUNT(Order_ID) AS Total_Order
FROM KMS_Inventory
GROUP BY Customer_Name
ORDER BY Lowest_Customer_Sales ASC

---5. WHICH SHIPPING METHOD INCURED THE MOST SHIPPING COST----

SELECT TOP 1 Ship_Mode, SUM(Shipping_Cost) AS Highest_Shipping_Cost
FROM KMS_Inventory
GROUP BY Ship_Mode
ORDER BY Highest_Shipping_Cost DESC

---6. MOST VALUABLE CUSTOMERS AND PRODUCTS OR SERVICES FREQUESTLY PURCHASED

-----STEP 1: GETING THE TOP 5 CUSTOMERS AND HOW MUCH THEY SPENT---
SELECT TOP 5 Customer_Name,
SUM(Sales) AS Highest_Spent,
COUNT(Order_ID) AS Total_Order
FROM KMS_Inventory
GROUP BY Customer_Name
ORDER BY Highest_Spent DESC

----STEP 2: USING SUBQUERRY TO JOIN THE TOP CUSTOMERS AND WHAT TEHY PURCHASED----
WITH Top_Customers AS
(SELECT TOP 5
Customer_Name,
SUM(Sales) AS Total_Spent
FROM KMS_Inventory ki
GROUP BY Customer_Name
ORDER BY Total_Spent DESC
)
SELECT ki.Customer_Name,
		ki.Product_Name,
COUNT(*) AS Purchase_Count,
SUM(ki.Sales) AS Total_Spent_On_Products
FROM KMS_Inventory ki
JOIN Top_Customers tc 
ON ki.Customer_Name = tc.Customer_Name
GROUP BY ki.Customer_Name, ki.Product_Name
ORDER BY Total_Spent_On_Products DESC


------7. SMALL BUSINESS CUSTOMERS WITH THE HIGHEST SALES----
SELECT TOP 1 Customer_Name, SUM(Sales) AS Total_Sales
FROM KMS_Inventory
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Name
ORDER BY Total_Sales DESC

----8. CORPORATE CUSTOMER THAT PLACED THE MOST ORDER BETWEEN 2009 AND 2012
SELECT TOP 1 Customer_Name, 
COUNT (Order_ID) AS Total_Orders
FROM KMS_Inventory
WHERE Customer_Segment = 'Corporate' AND 
Order_Date BETWEEN '2009-01-01' AND '2012-01-01'
GROUP BY Customer_Name
ORDER BY Total_Orders DESC

-----9. THE MOST PROFITABLE CONSUMER CUSTOMER----
SELECT TOP 1 Customer_Name, SUM(Sales) AS Total_Sales
FROM KMS_Inventory
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Name
ORDER BY Total_Sales DESC

----10. CUSTOMERS THAT RETURNED ITEMS AND WHICH SEGMENT THEY BELONG TO----

ALTER VIEW KMS_VIEW
AS
SELECT KMS_Inventory.Order_ID,
KMS_Inventory.Sales,
KMS_Inventory.Customer_Name,
KMS_Inventory.Customer_Segment,
KMS_Return_Order.[Status]
FROM KMS_Inventory
FULL OUTER JOIN KMS_Return_Order
ON KMS_Return_Order.Order_ID = KMS_Inventory.Order_ID

SELECT * FROM KMS_VIEW

SELECT DISTINCT Customer_Name, Customer_Segment [STATUS]
FROM KMS_VIEW
WHERE
[Status] = 'Returned'

----11. COMPARISON BETWEEN SHIPPING MODE(EXPRESS AIR AND DELIVERY TRUCK) AS REGARDS SHIPPING COST AND ORDER PRIORITY---
SELECT Ship_Mode,
Order_Priority,
COUNT(Order_ID) AS Order_Count,
SUM(Shipping_Cost) AS Total_Shipping_Cost,
AVG(Shipping_Cost) AS Average_Shipping_Cost
FROM KMS_Inventory
WHERE Ship_Mode IN ('Express Air', 'Delivery Truck')
GROUP BY Ship_Mode, Order_Priority
ORDER BY Ship_Mode, Order_Priority

