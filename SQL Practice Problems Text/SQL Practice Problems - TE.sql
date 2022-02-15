-- Sql Practice Problems workbook
--

--1.
	select *
	from dbo.Shippers
	;

--2.
	select * from Categories;
	select CategoryName, Description from Categories;

--3.
	select FirstName, LastName, HireDate
	from Employees
	where Title = 'Sales Representative'
	;
	select distinct title from Employees;

--4.
	select FirstName, LastName, HireDate
	from Employees
	where Title = 'Sales Representative'
	AND Country = 'USA'
	;
	select distinct country from Employees;

--5.
	select * from Orders
	where EmployeeID = 5
	;

--6.
	select SupplierID, ContactName, ContactTitle
	from Suppliers
	where ContactTitle <> 'Marketing Manager'
	;

--7.
	select ProductID, ProductName
	from Products
	where ProductName like '%queso%'
	;

--8.
	select OrderID, CustomerID, ShipCountry
	from Orders
	where ShipCountry in('France', 'Belgium')
	;

--9.
	select OrderID, CustomerID, ShipCountry
	from Orders
	where ShipCountry in('Brazil', 'Mexico', 'Argentina', 'Venezuela')
	;

--10.
	select FirstName, LastName, Title, BirthDate
	from Employees
	order by 4
	;

--11.
	select FirstName, LastName, Title, convert(date, BirthDate)
	from Employees
	order by 4
	;

--12.
	select FirstName, LastName, CONCAT(FirstName,' ', LastName) as FullName
	from Employees
	;

--13.
	select OrderID, ProductID, UnitPrice, Quantity,
	UnitPrice * Quantity as TotalPrice
	from OrderDetails
	order by OrderID, ProductID
	;

--14.
	select count(*)
	from Customers
	;

--15.
	select min(OrderDate)
	from Orders
	;

--16.
	select distinct country
	from Customers
	;

--17.
	select ContactTitle, count(*) as TotalContactTitle
	from Customers
	group by ContactTitle
	order by 2 desc
	;

--18.
	select p.ProductID, p.ProductName, s.CompanyName as Supplier
	from Products p
	Join Suppliers s on p.SupplierID = s.SupplierID
	order by p.ProductID
	;

--19.
	select o.OrderID, convert(date, o.OrderDate), s.CompanyName as Shipper
	from Orders o
	Join Shippers s
		ON o.ShipVia = s.ShipperID
	where OrderID < 10270
	Order by OrderID
	;

	--select ShipVia from Orders;

--20.
	select c.CategoryName, count(p.ProductID)
	from Products p
	join Categories c
		on p.CategoryID = c.CategoryID
	group by CategoryName
	order by 2 desc
	;

	--select * from Categories;

--21.
	select Country, City, count(*)
	from Customers
	group by Country, City
	order by 3 desc
	;

--22.
	select ProductID, ProductName, UnitsInStock, ReorderLevel
	from Products
	where UnitsInStock <= ReorderLevel
	order by ProductID
	;

--23.
	select ProductID, ProductName, UnitsInStock,UnitsOnOrder ReorderLevel, Discontinued
	from Products
	where UnitsInStock + UnitsOnOrder <= ReorderLevel
	and Discontinued = 0
	order by ProductID
	;

--24.
	--list all customers, sort by region alphabetically
	-- null region customers at the end
	--within same region, companies sorted by Customer ID
	select CustomerID, CompanyName, Region,
	case when Region is null then 1 else 0 end as sort --can move to within the order cluase to not have the column in results
	from Customers

	Order by sort, Region, CustomerID
	;

--25.
	select top 3 ShipCountry, avg(Freight)
	from Orders
	group by ShipCountry
	Order by 2 desc
	;

--26.
	select top 3 ShipCountry, avg(Freight)
	from Orders
	where OrderDate > '2014-12-31'
		and OrderDate < '2016-01-01'
	group by ShipCountry
	Order by 2 desc
	;

--27.
	select * from orders
	where OrderDate >'2015-12-29'
	and OrderDate < '2016-01-02'
	order by OrderDate
	;
	--OrderID 10806 is the culpret due to it being during the day on the 31st

--28.
	--high freight charges for last 12 months
	select max(OrderDate) from Orders;  --2016-05-06

	select top 3 ShipCountry, avg(Freight)
	from Orders
	where OrderDate >= Dateadd(yy,-1, (select max(OrderDate) from Orders))
	group by ShipCountry
	Order by 2 desc
	;

--29.
	select e.EmployeeID, e.LastName,o.OrderID, p.ProductName, od.Quantity
	from Employees e
	join Orders o on e.EmployeeID = o.EmployeeID
	join OrderDetails od on o.OrderID = od.OrderID
	join Products p on od.ProductID = p.ProductID
	Order by o.OrderID, p.ProductID
	;

--30.
	select c.CustomerID as Customers_CustomerID, o.CustomerID as Orders_CustomerID
	from Customers c
	left join Orders o on c.CustomerID = o.CustomerID
	where o.CustomerID is null  --make sure where clause goes AFTER JOIN!!
	;

	-- alternative approach
	select CustomerID
	from Customers
	where CustomerID not in (select CustomerID from Orders)
	;
	-- a third options is to use Not Exists in a subquery

--31.
	select o.CustomerID, c.CustomerID
	from Customers c
	left join Orders o 
		on c.CustomerID = o.CustomerID
		and o.EmployeeID = 4
	where o.CustomerID is null
	order by c.CustomerID
	;


--second pass, fresh morning
	select c.CustomerID, o.CustomerID
	from Customers c
	left join Orders o
		on c.CustomerID = o.CustomerID
		and EmployeeID = 4
	Where o.EmployeeID is null
	--order by 2 
	;


--32.
	--customer list for VIP gift
	--min 1 order
	--min total value 10,000
	--in year 2016

	with SumOrderTotals AS (
		select OrderID,
			sum(UnitPrice * Quantity) as OrderTotal
		from OrderDetails
		group by OrderID
		),

		OrderCountTable AS (
		select CustomerID, count(*) as OrderCount
		from Orders
		where OrderDate > '2015-12-31'
			and OrderDate < '2017-01-01'
		group by CustomerID
		)
	
	select c.CustomerID, c.CompanyName, o.OrderID, ot.OrderTotal
	from Customers c
	join Orders o on c.CustomerID = o.CustomerID
	join SumOrderTotals ot on c.CustomerID = o.CustomerID
	join OrderCountTable oct on c.CustomerID = oct.CustomerID
	where OrderCount >1
	--having count(*) >1
	and ot.OrderTotal > 10000
	Group by 1,2,3
	;