USE AdventureWorks2022;

/*1. List of all customers */

SELECT CustomerID, FirstName, LastName
FROM Sales.Customer
JOIN Person.Person ON Sales.Customer.PersonID = Person.Person.BusinessEntityID;

/*2. list of all customers where company name ending in N */

SELECT CustomerID, FirstName, LastName, PersonType
FROM Sales.Customer
JOIN Person.Person ON Sales.Customer.PersonID = Person.Person.BusinessEntityID
WHERE PersonType LIKE '%N';



/*3. list of all customers who live in Berlin or London*/

SELECT CustomerID, FirstName, LastName, City
FROM Sales.Customer
JOIN Person.Person ON Sales.Customer.PersonID = Person.Person.BusinessEntityID
JOIN Person.BusinessEntityAddress ON Sales.Customer.PersonID = Person.BusinessEntityAddress.BusinessEntityID
JOIN Person.Address ON Person.BusinessEntityAddress.AddressID = Person.Address.AddressID
WHERE City IN ('Berlin', 'London');

SELECT C.CustomerID, P.FirstName, P.LastName, A.City
FROM Sales.Customer AS C
JOIN Person.Person AS P ON C.PersonID = P.BusinessEntityID
JOIN Person.BusinessEntityAddress AS BEA ON C.PersonID = BEA.BusinessEntityID
JOIN Person.Address AS A ON BEA.AddressID = A.AddressID
WHERE A.City IN ('Berlin', 'London');



/*4. list of all customers who live in UK or USA*/

SELECT CustomerID, FirstName, LastName
FROM Sales.Customer
JOIN Person.Person ON Sales.Customer.PersonID = Person.Person.BusinessEntityID
JOIN Person.BusinessEntityAddress ON Sales.Customer.PersonID = Person.BusinessEntityAddress.BusinessEntityID
JOIN Person.Address ON Person.BusinessEntityAddress.AddressID = Person.Address.AddressID
JOIN Person.StateProvince ON Person.Address.StateProvinceID = Person.StateProvince.StateProvinceID
WHERE Person.StateProvince.CountryRegionCode IN ('GB', 'US');

/*5. list of all products sorted by product name*/
SELECT ProductID, Name, ProductNumber
FROM Production.Product
ORDER BY Name;

SELECT p.ProductID, p.Name, p.ProductNumber, pc.Name AS Category, ps.Name AS Subcategory
FROM Production.Product AS p
JOIN Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory AS pc ON ps.ProductCategoryID = pc.ProductCategoryID
ORDER BY p.Name;

/*6. list of all products where product name starts with an A*/
USE AdventureWorks2022;

SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE Name LIKE 'A%'
ORDER BY Name;


/*7. List of customers who ever placed an order*/

SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID;



/*8. list of Customers who live in London and have bought chai*/
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE a.City = 'London' AND pr.Name = 'Chai';


/*9. List of customers who never place an order*/
SELECT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE soh.CustomerID IS NULL;

/*10. List of customers who ordered Tofu*/
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE pr.Name = 'Tofu';

/*11. Details of first order of the system*/
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;

/*12. Find the details of most expensive order date*/
SELECT TOP 1 soh.SalesOrderID, soh.OrderDate, soh.TotalDue
FROM Sales.SalesOrderHeader soh
ORDER BY soh.TotalDue DESC;


/*13. For each order get the OrderID and Average quantity of items in that order*/
SELECT sod.SalesOrderID, AVG(sod.OrderQty) AS AverageQuantity
FROM Sales.SalesOrderDetail sod
GROUP BY sod.SalesOrderID;

/*14. For each order get the orderID, minimum quantity and maximum quantity for that order*/
SELECT sod.SalesOrderID, MIN(sod.OrderQty) AS MinQuantity, MAX(sod.OrderQty) AS MaxQuantity
FROM Sales.SalesOrderDetail sod
GROUP BY sod.SalesOrderID;

/*15. Get a list of all managers and total number of employees who report to them.*/
SELECT m.BusinessEntityID AS ManagerID, COUNT(e.BusinessEntityID) AS NumberOfReports
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.BusinessEntityID = m.BusinessEntityID
GROUP BY m.BusinessEntityID;

/*16. Get the OrderID and the total quantity for each order that has a total quantity of greater than 300*/
SELECT sod.SalesOrderID, SUM(sod.OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail sod
GROUP BY sod.SalesOrderID
HAVING SUM(sod.OrderQty) > 300;

/*17. list of all orders placed on or after 1996/12/31*/
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';

/*18. list of all orders shipped to Canada*/
SELECT soh.SalesOrderID, soh.OrderDate, soh.ShipToAddressID, a.City, sp.CountryRegionCode
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'CA';


/*19. list of all orders with order total > 200*/
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

/*20. List of countries and sales made in each country*/
SELECT sp.CountryRegionCode, COUNT(soh.SalesOrderID) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
GROUP BY sp.CountryRegionCode;

/*21. List of Customer ContactName and number of orders they placed*/
SELECT p.FirstName, p.LastName, COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName;

/*22. List of customer contactnames who have placed more than 3 orders*/
SELECT p.FirstName, p.LastName, COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 3;

/*23. List of discontinued products which were ordered between 1/1/1997 and 1/1/1998*/
SELECT DISTINCT pr.Name
FROM Production.Product pr
JOIN Sales.SalesOrderDetail sod ON pr.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE pr.DiscontinuedDate IS NOT NULL AND soh.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

/*24. List of employee firstname, lastName, superviser FirstName, LastName */
SELECT e1.BusinessEntityID, e1.FirstName AS EmployeeFirstName, e1.LastName AS EmployeeLastName, 
       e2.FirstName AS SupervisorFirstName, e2.LastName AS SupervisorLastName
FROM HumanResources.Employee e1
LEFT JOIN HumanResources.Employee e2 ON e1.ManagerID = e2.BusinessEntityID;

/*25. List of Employees id and total sale condcuted by employee*/
SELECT e.BusinessEntityID, COUNT(soh.SalesOrderID) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN HumanResources.Employee e ON soh.SalesPersonID = e.BusinessEntityID
GROUP BY e.BusinessEntityID;

/*26. List of employees whose first name contains the character 'a':*/
SELECT BusinessEntityID, FirstName, LastName
FROM Person.Person
WHERE FirstName LIKE '%a%';

/*27. List of managers who have more than four people reporting to them:*/
SELECT m.BusinessEntityID AS ManagerID, COUNT(e.BusinessEntityID) AS NumberOfReports
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.ManagerID = m.BusinessEntityID
GROUP BY m.BusinessEntityID
HAVING COUNT(e.BusinessEntityID) > 4;

/*28.List of orders and product names:*/
SELECT soh.SalesOrderID, p.Name AS ProductName
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID;

/*29. List of orders placed by the best customer:*/
WITH CustomerOrderCount AS (
    SELECT c.CustomerID, COUNT(soh.SalesOrderID) AS NumberOfOrders
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
)
SELECT soh.SalesOrderID, soh.OrderDate
FROM Sales.SalesOrderHeader soh
JOIN CustomerOrderCount coc ON soh.CustomerID = coc.CustomerID
WHERE coc.NumberOfOrders = (
    SELECT MAX(NumberOfOrders) FROM CustomerOrderCount
);

/*30. List of orders placed by customers who do not have a Fax number:*/
SELECT soh.SalesOrderID, soh.OrderDate
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE p.FaxNumber IS NULL;

/*31. List of postal codes where the product Tofu was shipped:*/
SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';

/*32. List of product names that were shipped to France:*/
SELECT DISTINCT pr.Name
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'FR';

/*33. List of product names and categories for the supplier 'Specialty Biscuits, Ltd.':*/
SELECT p.Name AS ProductName, pc.Name AS CategoryName
FROM Production.Product p
JOIN Production.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';

/*34. List of products that were never ordered:*/
SELECT p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.SalesOrderID IS NULL;

/*35. List of products where units in stock is less than 10 and units on order are 0:*/
SELECT p.ProductID, p.Name
FROM Production.Product p
WHERE p.UnitsInStock < 10 AND p.UnitsOnOrder = 0;


/*36. List of top 10 countries by sales:*/
SELECT TOP 10 sp.CountryRegionCode, COUNT(soh.SalesOrderID) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
GROUP BY sp.CountryRegionCode
ORDER BY TotalSales DESC;

/*37. Number of orders each employee has taken for customers with CustomerIDs between A and AO:*/
SELECT soh.SalesPersonID, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE c.CustomerID BETWEEN 'A' AND 'AO'
GROUP BY soh.SalesPersonID;


/*38. Order date of most expensive order:*/
SELECT TOP 1 soh.OrderDate
FROM Sales.SalesOrderHeader soh
ORDER BY soh.TotalDue DESC;

/*39. Product name and total revenue from that product:*/
SELECT p.Name AS ProductName, SUM(sod.LineTotal) AS TotalRevenue
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY p.Name;

/*40. Supplier ID and number of products offered:*/
SELECT pv.BusinessEntityID AS SupplierID, COUNT(pv.ProductID) AS ProductCount
FROM Production.ProductVendor pv
GROUP BY pv.BusinessEntityID;

/*41. Top ten customers based on their business*/
SELECT TOP 10 c.CustomerID, p.FirstName, p.LastName, SUM(soh.TotalDue) AS TotalBusiness
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, p.FirstName, p.LastName
ORDER BY TotalBusiness DESC;

/*42. What is the total revenue of the company*/
SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;




















