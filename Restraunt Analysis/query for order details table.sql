-- exploring details table
-- 1 view order-details table.
	select *
	From order_details;
--2 What is the date range of the table?
	select *
	From order_details
	Order by order_date;

	select Max(order_date) From order_details

	Select order_date
	from order_details
	order by order_date Desc;
	--OR
	Select Min(order_date) as least_date, MAX(order_date) as Max_date
	From order_details;

--3 How many orders were made within this date range?
	Select COUNT(Distinct order_id) As No_order
	From order_details;

--4 How many items were ordered within this date range ?
	select COUNT(*) As Total_item
	From order_details;
-- 5 Which orders has the most number of items ?
	Select order_id, COUNT(item_id) As Num_item
	From order_details
	Group by order_id
	Order by Num_item DESC;

	
--6 How many orders had more than 12 items ?
	select Count(*) 
	From
		(Select order_id, COUNT(item_id) As Num_item
		From order_details
		Group by order_id
		HAVING Count(item_id)> 12) AS Num_orders;
