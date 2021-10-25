-- 1. Get Product name and quantity/unit.
SELECT ProductName, QuantityPerUnit 
FROM Products;
-- 2. Get most expense and least expensive Product list (name and unit price)
SELECT ProductName, UnitPrice 
FROM Products 
ORDER BY UnitPrice DESC;
-- 3. Get Product list (id, name, unit price) where current products cost less than $20.
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE (((UnitPrice)<20) AND ((Discontinued)=False))
ORDER BY UnitPrice DESC;
-- 4. Get Product list (name, unit price) where products cost between $15 and $25.
SELECT ProductName, UnitPrice
FROM Products
WHERE (((UnitPrice)>=15 And (UnitPrice)<=25) 
AND ((Products.Discontinued)=False))
ORDER BY Products.UnitPrice DESC;
-- 5. Get Product list (name, unit price) of twenty most expensive products
SELECT DISTINCT ProductName as Twenty_Most_Expensive_Products, UnitPrice
FROM Products AS a
WHERE 20 >= (SELECT COUNT(DISTINCT UnitPrice)
                    FROM Products AS b
                    WHERE b.UnitPrice >= a.UnitPrice)
ORDER BY UnitPrice desc;
-- 6. Get Product list (name, units on order , units in stock) of stock is less than the quantity on order.
SELECT ProductName,  UnitsOnOrder , UnitsInStock
FROM Products
WHERE (((Discontinued)=False) AND ((UnitsInStock)<UnitsOnOrder));
-- 7. Order subtotals: for each order, calculate a subtotal for each Order (identified by OrderID).
select OrderID, 
    format(sum(UnitPrice * Quantity * (1 - Discount)), 2) as Subtotal
from order_details
group by OrderID
order by OrderID;
-- 8. Sales by year: this query shows how to get the year part from Shipped_Date column. A subtotal is calculated by a sub-query for each order.
select distinct date(a.ShippedDate) as ShippedDate, 
    a.OrderID, 
    b.Subtotal, 
    year(a.ShippedDate) as Year
from Orders a 
inner join
(
    -- Get subtotal for each order
    select distinct OrderID, 
        format(sum(UnitPrice * Quantity * (1 - Discount)), 2) as Subtotal
    from order_details
    group by OrderID    
) b on a.OrderID = b.OrderID
where a.ShippedDate is not null
    and a.ShippedDate between date('1996-12-24') and date('1997-09-30')
order by a.ShippedDate;
-- 9. Employee Sales by Country: for each employee, get their sales amount, broken down by country name.
select distinct b.*, a.CategoryName
from Categories a 
inner join Products b on a.CategoryID = b.CategoryID
where b.Discontinued = 'N'
order by b.ProductName;
-- 10. Alphabetical List of Products
select distinct b.*, a.Category_Name
from Categories a 
inner join Products b on a.Category_ID = b.Category_ID
where b.Discontinued = 'N'
order by b.Product_Name;
-- 11. Current Product List
select ProductID, ProductName
from products
where Discontinued = 'N'
order by ProductName;
-- 12. Order Details Extended
select distinct y.OrderID, 
    y.ProductID, 
    x.ProductName, 
    y.UnitPrice, 
    y.Quantity, 
    y.Discount, 
    round(y.UnitPrice * y.Quantity * (1 - y.Discount), 2) as ExtendedPrice
from Products x
inner join Order_Details y on x.ProductID = y.ProductID
order by y.OrderID;
-- 13. Sales by Category: For each category, we get the list of products sold and the total sales amount. 
/*
Query 1: normal joins
*/
select distinct a.CategoryID, 
    a.CategoryName,  
    b.ProductName, 
    sum(round(y.UnitPrice * y.Quantity * (1 - y.Discount), 2)) as ProductSales
from Order_Details y
inner join Orders d on d.OrderID = y.OrderID
inner join Products b on b.ProductID = y.ProductID
inner join Categories a on a.CategoryID = b.CategoryID
where d.OrderDate between date('1997/1/1') and date('1997/12/31')
group by a.CategoryID, a.CategoryName, b.ProductName
order by a.CategoryName, b.ProductName, ProductSales;
/*
Query 2: join with a sub query
 
This query returns identical result as above, but here
sub query is used to calculate extended price which 
then used in the main query to get ProductSales
*/ 
select distinct a.CategoryID, 
    a.CategoryName, 
    b.ProductName, 
    sum(c.ExtendedPrice) as ProductSales
from Categories a 
inner join Products b on a.CategoryID = b.CategoryID
inner join 
(
    select distinct y.OrderID, 
        y.ProductID, 
        x.ProductName, 
        y.UnitPrice, 
        y.Quantity, 
        y.Discount, 
        round(y.UnitPrice * y.Quantity * (1 - y.Discount), 2) as ExtendedPrice
    from Products x
    inner join Order_Details y on x.ProductID = y.ProductID
    order by y.OrderID
) c on c.ProductID = b.ProductID
inner join Orders d on d.OrderID = c.OrderID
where d.OrderDate between date('1997/1/1') and date('1997/12/31')
group by a.CategoryID, a.CategoryName, b.ProductName
order by a.CategoryName, b.ProductName, ProductSales;
-- 14. Ten Most Expensive Products
/* Query 1 */
select distinct ProductName as Ten_Most_Expensive_Products, 
         UnitPrice
from Products as a
where 10 >= (select count(distinct UnitPrice)
                    from Products as b
                    where b.UnitPrice >= a.UnitPrice)
order by UnitPrice desc;
/* Query 2 */
select * from
(
    select distinct ProductName as Ten_Most_Expensive_Products, 
           UnitPrice
    from Products
    order by UnitPrice desc
) as a
limit 10;
-- 15. Products by Category
select distinct a.CategoryName, 
    b.ProductName, 
    b.QuantityPerUnit, 
    b.UnitsInStock, 
    b.Discontinued
from Categories a
inner join Products b on a.CategoryID = b.CategoryID
where b.Discontinued = 'N'
order by a.CategoryName, b.ProductName;
-- 16. Customers and Suppliers by City
select City, CompanyName, ContactName, 'Customers' as Relationship 
from Customers
union
select City, CompanyName, ContactName, 'Suppliers'
from Suppliers
order by City, CompanyName;
-- 17. Products Above Average Price
select distinct ProductName, UnitPrice
from Products
where UnitPrice > (select avg(UnitPrice) from Products)
order by UnitPrice;
-- 18. Product Sales for 1997
select distinct a.CategoryName, 
    b.ProductName, 
    format(sum(c.UnitPrice * c.Quantity * (1 - c.Discount)), 2) as ProductSales,
    concat('Qtr ', quarter(d.ShippedDate)) as ShippedQuarter
from Categories a
inner join Products b on a.CategoryID = b.CategoryID
inner join Order_Details c on b.ProductID = c.ProductID
inner join Orders d on d.OrderID = c.OrderID
where d.ShippedDate between date('1997-01-01') and date('1997-12-31')
group by a.CategoryName, 
    b.ProductName, 
    concat('Qtr ', quarter(d.ShippedDate))
order by a.CategoryName, 
    b.ProductName, 
    ShippedQuarter;
 -- 19. Category Sales for 1997
 select CategoryName, format(sum(ProductSales), 2) as CategorySales
from
(
    select distinct a.CategoryName, 
        b.ProductName, 
        format(sum(c.UnitPrice * c.Quantity * (1 - c.Discount)), 2) as ProductSales,
        concat('Qtr ', quarter(d.ShippedDate)) as ShippedQuarter
    from Categories as a
    inner join Products as b on a.CategoryID = b.CategoryID
    inner join Order_Details as c on b.ProductID = c.ProductID
    inner join Orders as d on d.OrderID = c.OrderID 
    where d.ShippedDate between date('1997-01-01') and date('1997-12-31')
    group by a.CategoryName, 
        b.ProductName, 
        concat('Qtr ', quarter(d.ShippedDate))
    order by a.CategoryName, 
        b.ProductName, 
        ShippedQuarter
) as x
group by CategoryName
order by CategoryName;
-- 20. Quarterly Orders by Product
select a.ProductName, 
    d.CompanyName, 
    year(OrderDate) as OrderYear,
    format(sum(case quarter(c.OrderDate) when '1' 
        then b.UnitPrice*b.Quantity*(1-b.Discount) else 0 end), 0) "Qtr 1",
    format(sum(case quarter(c.OrderDate) when '2' 
        then b.UnitPrice*b.Quantity*(1-b.Discount) else 0 end), 0) "Qtr 2",
    format(sum(case quarter(c.OrderDate) when '3' 
        then b.UnitPrice*b.Quantity*(1-b.Discount) else 0 end), 0) "Qtr 3",
    format(sum(case quarter(c.OrderDate) when '4' 
        then b.UnitPrice*b.Quantity*(1-b.Discount) else 0 end), 0) "Qtr 4" 
from Products a 
inner join Order_Details b on a.ProductID = b.ProductID
inner join Orders c on c.OrderID = b.OrderID
inner join Customers d on d.CustomerID = c.CustomerID 
where c.OrderDate between date('1997-01-01') and date('1997-12-31')
group by a.ProductName, 
    d.CompanyName, 
    year(OrderDate)
order by a.ProductName, d.CompanyName;
-- 21. Invoice data
select distinct b.ShipName, 
    b.ShipAddress, 
    b.ShipCity, 
    b.ShipRegion, 
    b.ShipPostalCode, 
    b.ShipCountry, 
    b.CustomerID, 
    c.CompanyName, 
    c.Address, 
    c.City, 
    c.Region, 
    c.PostalCode, 
    c.Country, 
    concat(d.FirstName,  ' ', d.LastName) as Salesperson, 
    b.OrderID, 
    b.OrderDate, 
    b.RequiredDate, 
    b.ShippedDate, 
    a.CompanyName, 
    e.ProductID, 
    f.ProductName, 
    e.UnitPrice, 
    e.Quantity, 
    e.Discount,
    e.UnitPrice * e.Quantity * (1 - e.Discount) as ExtendedPrice,
    b.Freight
from Shippers a 
inner join Orders b on a.ShipperID = b.ShipVia 
inner join Customers c on c.CustomerID = b.CustomerID
inner join Employees d on d.EmployeeID = b.EmployeeID
inner join Order_Details e on b.OrderID = e.OrderID
inner join Products f on f.ProductID = e.ProductID
order by b.ShipName;
-- 22. Number of units in stock by category and supplier continent
select c.CategoryName as "Product Category", 
       case when s.Country in 
                 ('UK','Spain','Sweden','Germany','Norway',
                  'Denmark','Netherlands','Finland','Italy','France')
            then 'Europe'
            when s.Country in ('USA','Canada','Brazil') 
            then 'America'
            else 'Asia-Pacific'
        end as "Supplier Continent", 
        sum(p.UnitsInStock) as UnitsInStock
from Suppliers s 
inner join Products p on p.SupplierID=s.SupplierID
inner join Categories c on c.CategoryID=p.CategoryID 
group by c.CategoryName, 
         case when s.Country in 
                 ('UK','Spain','Sweden','Germany','Norway',
                  'Denmark','Netherlands','Finland','Italy','France')
              then 'Europe'
              when s.Country in ('USA','Canada','Brazil') 
              then 'America'
              else 'Asia-Pacific'
         end;
-- 23. Customer and supplier count
select a.CustomersCount, b.SuppliersCount
from
(select count(CustomerID) as CustomersCount from customers) as a
join
(select count(SupplierID) as SuppliersCount from suppliers) as b;
-- 24. Customer and supplier count ratio
select concat(round(a.CustomersCount / b.SuppliersCount), ":1") as Customer_vs_Supplier_Ratio
from
(select count(CustomerID) as CustomersCount from customers) as a
join
(select count(SupplierID) as SuppliersCount from suppliers) as b;
-- 25. Calculate the number of orders and products on each order date
select date(t2.OrderDate) as OrderDate,
    count(distinct t1.OrderID) as NumOfOrders,
    count(t1.ProductID) as NumOfProducts
from order_details as t1
join orders as t2 on t1.OrderID=t2.OrderID
join products as t3 on t1.ProductID=t3.ProductID
where year(t2.OrderDate)=1997 and month(t2.OrderDate)=6
group by t2.OrderDate;
-- 26. Calculate total number of orders and products for the month in June 1997
select 'Total',
    count(distinct t1.OrderID) as NumOfOrders,
    count(t1.ProductID) as NumOfProducts
from order_details as t1
join orders as t2 on t1.OrderID=t2.OrderID
join products as t3 on t1.ProductID=t3.ProductID
where year(t2.OrderDate)=1997 and month(t2.OrderDate)=6;
-- 27. Rollup
select date(t2.OrderDate) as OrderDate,
    count(distinct t1.OrderID) as NumOfOrders,
    count(t1.ProductID) as NumOfProducts
from order_details as t1
join orders as t2 on t1.OrderID=t2.OrderID
join products as t3 on t1.ProductID=t3.ProductID
where year(t2.OrderDate)=1997 and month(t2.OrderDate)=6
group by t2.OrderDate WITH ROLLUP;
-- 28. Three ways to calculate top n rows
select ProductName as Ten_Most_Expensive_Products, 
	UnitPrice    
from Products
order by UnitPrice desc
limit 10;
select distinct ProductName as Ten_Most_Expensive_Products, 
         UnitPrice
from Products a
where 10 >= (select count(distinct(UnitPrice))
                    from Products b
                    where b.UnitPrice >= a.UnitPrice)
order by UnitPrice desc;
select Ten_Most_Expensive_Products, UnitPrice
from
(
    select distinct ProductName as Ten_Most_Expensive_Products, 
           UnitPrice,
           ROW_NUMBER() over (order by UnitPrice desc) as PriceRank
    from Products
    order by UnitPrice desc
) as x
where PriceRank between 1 and 10;
