-- Analyzing Customers Behavior

--1 Combine the menu_items and order_details into a single table.
	
	Select *
	From menu_items
	Select *
	From order_details;

	 Select * 
	  from order_details Od
	  Left Join menu_items Mi
	  On Od.order_details_id = Mi.menu_item_id;
	
--2 What were the least and most ordered items? What categories were they in ?

	Select item_name, count(order_details_id)As Num_Purchase
	  from order_details Od
	  Left Join menu_items Mi
	  On Od.order_details_id = Mi.menu_item_id
	  Group By item_name
	  Order By Num_Purchase;

	  
	Select item_name, Category,count(order_details_id)As Num_Purchase
	  from order_details Od
	  Left Join menu_items Mi
	  On Od.order_details_id = Mi.menu_item_id
	  Group By item_name, Category
	  Order By Num_Purchase Desc;

--3 What were the top 5 orders that spent the most money?
	
	 Select order_id,SUM(price) As Total_spend 
	  from order_details Od
	  Left Join menu_items Mi
	  On Od.order_details_id = Mi.menu_item_id
	  Group By order_id
	  order By Total_spend Desc
	  
	
--4 View the details of the highest spend order. What insights can you gather from the results?
	
	Select category, COUNT(item_id) As Num_item
	  from order_details Od
	  Left Join menu_items Mi
	  On Od.order_details_id = Mi.menu_item_id
	  Where order_id =440
	  Group By category;
	

--5 View the details of the top 5 highest spend orders. What insight can you gather from the results?

	Select order_id, category, COUNT(item_id) As Num_item
	  from order_details Od
	  Left Join menu_items Mi
	  On Od.order_details_id = Mi.menu_item_id
	  Where order_id in (440,2075,1957,330,2675)
	  Group By Order_id,category;

