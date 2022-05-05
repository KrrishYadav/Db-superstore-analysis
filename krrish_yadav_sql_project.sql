/*
Task 1: Understanding the data in hand
A. Describe the data in hand in your own words. (Word Limit is 500)

##
In the dataset there are mainly 5 tables present that are following:
 1. cust_dimen
 2. market_fact
 3. orders_dimen
 4. prod_dimen
 5. shipping_dimen
 
* In the cust_dimen table there are 5 parameters present like:
  Customer_Name, Province, Region, Customer_Segment and Cust_id.

* In the market_fact table there are 10 parameters present like:
  Ord_id, Prod_id, Ship_id, Cust_id, Sales, Discount, Order_Quantity, Profit, Shipping_Cost and Product_Base_Margin.
  
* In the orders_dimen table there are 4 parameters present like:
  Order_ID, Order_Date, Order_Priority and Ord_id.
  
* In the prod_dimen table there are 3 parameters present like:
  Product_Category, Product_Sub_Category and Prod_id. 
  
* In the orders_dimen table there are 4 parameters present like:
  Order_ID, Ship_Mode, Ship_Date and Ship_id. 

This database contains Sales details of transaction of a superstore. The structure has 5 tables, namely cust_dimen (containing details about 
customer and their respective locations), prod_dimen (containing product category and their subcategories), orders_dimen (with order no,
date, and priority), shipping_dimen (with ship date, order and shipping mode), and market_fact (orderwise customerwise marketwise orderquantity, 
sales value, discount profit and shipping cost details).

Upon proper database design these tables will get informationn handy upon querying. These are having dimensions and has facts releated to it. using 
market_fact we can derive various insights which will aid in helping decisions regarding Product segmentwise sales and profitability, Shipping mode wise 
profitability etc.




B. Identify and list the Primary Keys and Foreign Keys for this dataset
	(Hint: If a table don’t have Primary Key or Foreign Key, then specifically mention it in your answer.)

## As the tables don't have any key assigned to them , we can create the following primary and foreign key pairs:

    1. cust_dimen
		Primary Key: Cust_id
        Foreign Key: NA
	
    2. market_fact
		Primary Key: NA
        Foreign Key: Ord_id referencing to orders_dimen , 
                     Prod_id referencing to prod_dimen , 
                     Ship_id referencing to shipping_dimen , 
                     Cust_id referencing to cust_dimen
	
    3. orders_dimen
		Primary Key: Ord_id, although Order_ID is also there but it is advisable to use 
							 Ord_id as primary Key to ensure relationship consistency. 
        Foreign Key: NA
	
    4. prod_dimen
		Primary Key: Prod_id
        Foreign Key: NA
	
    5. shipping_dimen
		Primary Key: Ship_id
        Foreign Key: NA

*/



####Task 2: Basic Analysis 
# A.	Find the total and the average sales (display total_sales and avg_sales)  

select sum(sales) as total_sales, avg(sales) as avg_sales 
from market_fact;


# B.	Display the number of customers in each region in decreasing order of no_of_customers. The result should contain columns Region, no_of_customers 

select count(customer_name) as no_of_customers, region 
from cust_dimen
group by region
order by no_of_customers desc;


# C.	Find the region having maximum customers (display the region name and max(no_of_customers)

select count(customer_name) as no_of_customers,region 
from cust_dimen
group by region
order by no_of_customers desc
limit 1;




# D.	Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold) 

select prod_id as product_id, sum(order_quantity) as no_of_products_sold
from market_fact
group by Prod_id
order by no_of_products_sold desc;



# E.	Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased) 

select d.customer_name, d.region , sum(m.order_quantity) as number_of_tables_purchased
from cust_dimen as d
join market_fact as m
on d.Cust_id = m.Cust_id
join prod_dimen as p
on p.Prod_id = m.Prod_id
where p.Product_Sub_Category = 'tables' and d.Region = 'Atlantic'
group by d.Customer_Name
order by number_of_tables_purchased desc;


select d.customer_name , d.region, sum(m.order_quantity) as no_of_tables_purchased
from cust_dimen as d
join market_fact as m
on d.Cust_id = m.Cust_id
where d.Region = 'Atlantic' and 
m.Prod_id = (select prod_id from prod_dimen where product_sub_category = 'tables')
group by d.customer_name
order by no_of_tables_purchased desc;



#####Task 3: Advanced Analysis 
#A.	Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)? 

select d.Product_Category, round(sum(m.profit),0) as profits
from market_fact as m
join prod_dimen as d
on m.Prod_id = d.Prod_id
group by d.Product_Category
order by profits desc;



#B.	Display the product category, product sub-category and the profit within each subcategory in three columns.  

select d.Product_Category, d.Product_Sub_Category, round(sum(m.profit),0) as total_profits
from prod_dimen as d
join market_fact as m
on d.prod_id = m.prod_id
group by Product_Sub_Category
order by Product_Category;



#C.	Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, 
#   display the  region-wise no_of_shipments and the profit made in each region in decreasing order of profits 
#   (i.e. region, no_of_shipments, profit_in_each_region).    o Note: You can hardcode the name of the least profitable product subcategory 

select pd.Product_Sub_Category, cd.region, count(m.ship_id) as no_of_shipments, round(sum(m.profit),0) as profits
from market_fact as m
join prod_dimen as pd
on m.Prod_id = pd.Prod_id
join cust_dimen as cd
on m.Cust_id = cd.Cust_id
where pd.Product_Sub_Category = ( select pd.Product_Sub_Category       -- Query for identifying the least profitable sub-category
from market_fact m 
join prod_dimen pd 
on m.Prod_id = pd.Prod_id
group by Product_Sub_Category
order by sum(m.Profit)
limit 1 )
group by cd.Region
order by profits desc;



 