--1 List the product names and order quantities for all orders placed. we are trying to know the product with the highest order in 2008

SELECT*
FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader
 
 SELECT pp.Name AS Product_Name,  SUM(SSOD.OrderQty) AS Order_Quantity , YEAR(SSOH.OrderDate) AS Order_Year
 FROM Sales.SalesOrderDetail SSOD
  inner JOIN Production.Product pp 
 ON SSOD.ProductID = PP.ProductID
  inner JOIN Sales.SalesOrderHeader SSOH
  ON SSOH.SalesOrderID = SSOD.SalesOrderID
  GROUP BY PP.Name, year(SSOH.OrderDate) 
  ORDER BY SUM(SSOD.OrderQty) DESC; 
  
  
  

 --2 Find the salesperson names, quantity and product names for all the orders placed.
 --we are trying to know the salesperson with the highest order  and the highest selling product 


 SELECT* FROM Sales.SalesPerson
 SELECT* FROM Sales.SalesOrderDetail
 SELECT * FROM Sales.SalesOrderHeader
 SELECT* FROM Production.Product
 SELECT * FROM Person.Person


SELECT PP.Name AS ProductName, P_P.FirstName + '' + P_P.LastName AS SalesPersonName, SUM(SSOD.OrderQty) AS QuantityOrdered
FROM Sales.SalesOrderDetail SSOD
JOIN Sales.SalesOrderHeader SSOH
ON SSOD.SalesOrderID = SSOH.SalesOrderID
JOIN Sales.SalesPerson	SSP
ON SSP.TerritoryID = SSOH.TerritoryID
JOIN Production.Product PP
ON PP.ProductID = SSOD.ProductID
JOIN Person.Person P_P
ON P_P.BusinessEntityID = SSP.BusinessEntityID 
GROUP BY PP.Name,P_P.FirstName + '' + P_P.LastName
ORDER BY SUM(SSOD.OrderQty) DESC;


--3--Along with the product name and category for products that have been sold more than 200times. we want to know the category that has most ordered product.
SELECT *FROM Sales.SalesOrderDetail;
SELECT *FROM Production.Product;
SELECT * FROM Production.ProductCategory;
SELECT * FROM Production.ProductSubcategory;



SELECT PP.Name, Pc.Name, SUM(Sod.OrderQty) AS Total_Qty
FROM Sales.SalesOrderDetail  Sod
INNER JOIN Production.Product PP
ON sod.ProductID=pp.ProductID
INNER JOIN Production.ProductSubcategory Psc
ON Pp.ProductSubcategoryID= Psc.ProductSubcategoryID
INNER JOIN Production.ProductCategory PC
ON Psc.ProductCategoryID= Pc.ProductCategoryID
GROUP BY PP.Name, PC.Name
HAVING SUM(Sod.OrderQty)>200   
ORDER BY Total_Qty DESC;


--4-Retrieve the first and last name of employee and their job title and the name of the department. we are trying to  create a list of detailed of information about the employee
SELECT HE.BusinessEntityID, PP.FirstName, PP.LastName, HE.JobTitle 
FROM HumanResources.Employee HE 
JOIN Person.Person PP
ON HE.BusinessEntityID = PP.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory EH
ON EH.BusinessEntityID = HE.BusinessEntityID
JOIN HumanResources.Department D
ON D.DepartmentID = EH.DepartmentID
ORDER BY PP.FirstName ASC;



--5-- -As a sales analyst, you are tasked with analyzing sales performance across different regions
--from the Person.CountryRegion Table. You need to compare the total sales for the current 
--year (SalesYTD) and the previous year (saleslastYear) for each country and calculate the 
--difference between these two figures. Additionally, you want to rank the countries based on 
--their current year’s sales in descending order. How would you write a SQL query to retrieve 
--the country names, total sales for the current year, total sales for the last year, and the sales 
--difference?


SELECT* 
FROM Person.CountryRegion ;

SELECT* FROM sales.SalesTerritory

SELECT *
FROM sales.SalesOrderHeader;

 

 SELECT PC.Name, SS.SalesYTD,SS.SalesLastYear,  
 (ss.SalesYTD- ss.SalesLastYear) AS SalesDifference
 FROM Person.CountryRegion PC
 JOIN  sales.SalesTerritory  SS
 ON PC.ModifiedDate=SS.ModifiedDate
 order by ss.salesYTD DESC;





 --6-You are working as a sales manager and want to analyze the sales performance of different 
--products across various sales territories for the year 2011 from Sales.SalesOrderDetail table. 
--Specifically, you need to determine the total sales amount for each product within each 
--territory and rank them in descending order of sales. How would you write a SQL query to 
--retrieve the product names, territory names, and total sales amounts for orders placed 
--between January 1, 2011, and December 31, 2011?
SELECT *
 FROM sales.SalesOrderDetail
 SELECT*FROM sales.SalesTerritory
 SELECT*FROM SALES.SalesOrderHeader
 select * from Production.Product




 SELECT  PP.ProductID, PP.Name, SSH.TerritoryID, SST.Name AS TerritoryName, SS.SalesOrderID, SST.SalesYTD,
	SUM(SS.LineTotal) AS TotalSalesAmount
 FROM Sales.SalesOrderDetail  ss
 LEFT JOIN Production.Product PP
 ON ss.ProductID = pp.ProductID
 JOIN SALES.SalesOrderHeader SSH
 ON SS.SalesOrderID= SSH.SalesOrderID
 JOIN sales.SalesTerritory SST
 ON SSH.TerritoryID=SST.TerritoryID
 WHERE SSH.orderDate BETWEEN '2011-01-01' AND '2011-12-31'
 GROUP BY PP.ProductID, PP.Name,SSH.TerritoryID, SST.Name, SS.SalesOrderID, SST.SalesYTD
 ORDER BY SST.Name,TotalSalesAmount DESC;


 --7--As a sales director, you want to identify top-performing salespeople who have generated 
--significant revenue from the Sales.SalesOrderHeader table. Specifically, you are interested in 
--finding out which salespeople have achieved total sales amounts greater than $50,000. You 
--also want to rank them in descending order of their total sales. How would you write a SQL 
--query to retrieve the first names, last names, and total sales amounts for these topperforming salespeople


SELECT * FROM sales.SalesOrderHeader
SELECT * FROM Sales.SalesPerson
SELECT * FROM person.Person



SELECT PP.FirstName, PP.LastName,SSH.TotalDue
FROM sales.SalesOrderHeader SSH
JOIN Sales.SalesPerson SSP
ON SSH.TerritoryID=SSP.TerritoryID
JOIN Person.Person PP
ON SSP.BusinessEntityID=PP.BusinessEntityID
WHERE SSH.TotalDue >50000
ORDER BY TotalDue DESC;



--8--We have some products that customers have rated in the past, and this data is 
--stored in the production.productreview table. We would like to know the average 
--rating per product rated. Expected output should be the product name, 
--productnumber, product color, product listprice, product subcategory, product 
--category, average product rating. Only consider products that have been rated 
--before. 

select p.[Name] as product_name, p.ProductNumber, p.Color as productcolor, p.ListPrice, 
		ps.[Name] as product_subcategory, pc.[Name] as product_category, avg(pr.Rating) as avg_rating
from production.ProductReview pr
join production.product p on pr.ProductID = p.ProductID
left join production.ProductSubcategory ps on p.ProductSubcategoryID = ps.ProductSubcategoryID
left join production.ProductCategory pc on ps.ProductCategoryID = pc.ProductCategoryID
group by p.[Name], p.ProductNumber, p.Color, p.ListPrice, 
		ps.[Name], pc.[Name]



--9--We are trying to do an analysis of sales done by our stores, to know which stores 
--we can start thinking of letting go. Can you share a breakdown of the sales value 
--that has been done by each store between 2011 and 2013. Nb: Please note that 
--you would need to join the sales.salesorderheader table to the 
--sales.salesperson table then to the sales.store table to get the store name. 
--Kindly share the bottom 4 stores by sales value.  

-- check the tables involved and figure how to relate them together

select top 4 ss.Name as store_name, sum(totaldue) as total
from sales.salesorderheader s
join sales.Customer c on s.CustomerID = c.CustomerID
join sales.store ss on c.StoreID = ss.BusinessEntityID
where year(OrderDate) between 2011 and 2013
group by ss.name 
order by sum(totaldue)


--10--We would like to confirm the total quantity of products we have ever had in our 
--inventory and the product category. Kindly share a total inventory quantity of 
--each of our products. The expected columns are productid, product name, 
--product number, product subcategory, product category, total quantity, Hint: the 
--inventory of each product is stored in the production.productinventory table. 

select p.ProductID, p.Name as product_name, p.ProductNumber, ps.Name as subcategory_name, 
		pc.Name as category_name, sum(pr.quantity) as total_quantity
from production.ProductInventory pr
join production.product p on pr.ProductID = p.ProductID
left join production.ProductSubcategory ps on p.ProductSubcategoryID = ps.ProductSubcategoryID
left join production.ProductCategory pc on ps.ProductCategoryID = pc.ProductCategoryID
group by p.ProductID, p.Name, p.ProductNumber, ps.Name, pc.Name 
order by sum(pr.quantity) desc








--CTE()
--11--We would like to identify employees that have changed pay history more than 
--once. Specifically we would like to see the firstname, lastname and jobtitle of 
--these employees. Kindly note the table that stores payhistory is the 
--HumanResources.EmployeePayHistory. 

-- identify employees that change pay history
-- filter employees table by 1 (also join to person table to include first and lastname)
with paycte as
(select BusinessEntityID, count(*) as total
from HumanResources.EmployeePayHistory
group by BusinessEntityID
having count(*) > 1)

select p.BusinessEntityID, p.FirstName, p.LastName, hr.JobTitle
from HumanResources.Employee hr
join person.person p on hr.BusinessEntityID = p.BusinessEntityID
where hr.BusinessEntityID in (select BusinessEntityID from paycte)



--12-- we would like to confirm the time of the year that has most Hire with some criteria attached to them
-- criteria 
-- Hired between Jan and April = No_Pressure
--Hired between May and August = Little_Pressure
--Hired between September and October = more_Pressure
-- otherwise High_pressure

WITH EmployeeData AS (
    SELECT BusinessEntityID, HireDate, DATENAME(MONTH, HireDate) As HiredMonth
    FROM HumanResources.Employee
)
SELECT BusinessEntityID, HireDate, HiredMonth,
    CASE 
        WHEN HiredMonth IN('January', 'February', 'March',  'April')  THEN 'No_Pressure'
        WHEN HiredMonth IN (' May', 'June', 'July',  'August')   THEN 'Little_Pressure'
        WHEN HiredMonth IN ('september', 'October')  THEN ' MOre_Pressure'
        ELSE 'High_Pressure'
    END AS Hired_Criteria
FROM EmployeeData;


--13----The HR team need the list of employees who have been with the company for over 15 years 
--but are still under the age of 65. Specifically, you're looking to extract the `BusinessEntityID`, 
--`LoginID`, `JobTitle`, `HireDate`, the number of years they've been in service, and their 
--estimated age. Kindly the details with the HR team before the close of business as requested.
WITH EmployeeService AS (
    SELECT BusinessEntityID,
           LoginID,
           JobTitle,
           HireDate,
           BirthDate,
           DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsInService,
           DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
    FROM HumanResources.Employee
)
SELECT BusinessEntityID,
       LoginID,
       JobTitle,
       HireDate,
       YearsInService,
       Age
FROM EmployeeService
WHERE YearsInService > 15
  AND Age < 65;

--(Subquery)
  --14----Human Resources has reached out to you asking they would need the year of hire (e.g 2010), 
--month of hire(e.g 11), and day of hire(e.g 04) in numbers in different columns for an analysis 
--they are doing in the team. Kindly share details of the employee businessentityid, jobtitle, 
--birthdate, gender, vacationhours, sickleavehours, year_of_hire, month_of_hire, day_of_hire 
--with the HR team

SELECT 
    BusinessEntityID,
    JobTitle,
    BirthDate,
    Gender,
    VacationHours,
    SickLeaveHours,
    DATEPART(YEAR, HireDate) AS Year_of_Hire,
    DATEPART(MONTH, HireDate) AS Month_of_Hire,
    DATEPART(DAY, HireDate) AS Day_of_Hire
FROM 
    (SELECT 
         BusinessEntityID,
         JobTitle,
         BirthDate,
         Gender,
         VacationHours,
         SickLeaveHours,
         HireDate
     FROM 
         HumanResources.Employee) AS EmployeeDetails;


--15----On the PRODUCTION.WORKORDERS TABLE, we would like to know the workorders that had 
--their enddate late (i.e exceeded the expected duedate), kindly share with the production team 
--all the workorders with this case, including the following fields workorderid, productid, 
--orderqty, stockedqty, startdate, enddate, duedate, dayslatefor (number of days that enddate 
--exceeded duedate by)
SELECT WorkOrderID, 
       ProductID, 
       OrderQty, 
       StockedQty, 
       StartDate, 
       EndDate, 
       DueDate, 
       DATEDIFF(DAY, DueDate, EndDate) AS DaysLateFor
FROM Production.WorkOrder 
WHERE WorkOrderID IN (
    SELECT WorkOrderID 
    FROM Production.WorkOrder 
    WHERE EndDate > DueDate
);

--16--Imagine you're working on an inventory analysis project where you need to identify which
---product subcategories have a high total list price and a substantial number of products.
---Specifically, you want to see the `ProductSubcategoryID` along with the `TotalListPrice` for
---each subcategory that meets the criteria of having a total list price over $50,000 and at least
---20 products. How would you write a SQL query to display the `ProductSubcategoryID` and the
---total list price for each subcategory, only including those that meet the specified conditions,
---and sort the results by the total list price in descending order?
SELECT ProductSubcategoryID,
       TotalListPrice,
       ProductCount
FROM (
    SELECT ProductSubcategoryID,
           SUM(ListPrice) AS TotalListPrice,
           COUNT(ProductID) AS ProductCount
    FROM Production.Product
    GROUP BY ProductSubcategoryID
) AS ProductSummary
WHERE TotalListPrice > 50000
  AND ProductCount >= 20
ORDER BY TotalListPrice DESC;









