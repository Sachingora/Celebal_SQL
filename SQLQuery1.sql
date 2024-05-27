CREATE DATABASE Northwind;
USE Northwind;
CREATE TABLE Customers (
    CustomerID VARCHAR(5) PRIMARY KEY,
    CompanyName VARCHAR(40),
    ContactName VARCHAR(30),
    ContactTitle VARCHAR(30),
    Address VARCHAR(60),
    City VARCHAR(15),
    Region VARCHAR(15),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    Phone VARCHAR(24),
    Fax VARCHAR(24)
);
CREATE TABLE Orders (
	OrderID INT PRIMARY KEY,
    CustomerID VARCHAR(5),
    EmployeeID INT,
    OrderDate DATE,
    RequiredDate DATE,
    ShippedDate DATE,
    ShipVia INT,
    Freight DECIMAL(10, 2),
    ShipName VARCHAR(40),
    ShipAddress VARCHAR(60),
    ShipCity VARCHAR(15),
    ShipRegion VARCHAR(15),
    ShipPostalCode VARCHAR(10),
    ShipCountry VARCHAR(15),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(10, 2),
    Quantity INT,
    Discount DECIMAL(4, 2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(40),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit VARCHAR(20),
    UnitPrice DECIMAL(10, 2),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(40),
    ContactName VARCHAR(30),
    ContactTitle VARCHAR(30),
    Address VARCHAR(60),
    City VARCHAR(15),
    Region VARCHAR(15),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    Phone VARCHAR(24),
    Fax VARCHAR(24)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(15),
    Description TEXT
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    LastName VARCHAR(20),
    FirstName VARCHAR(10),
    Title VARCHAR(30),
    TitleOfCourtesy VARCHAR(25),
    BirthDate DATE,
    HireDate DATE,
    Address VARCHAR(60),
    City VARCHAR(15),
    Region VARCHAR(15),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    HomePhone VARCHAR(24),
    Extension VARCHAR(4),
    Photo TEXT,
    Notes TEXT,
    ReportsTo INT
);

INSERT INTO Customers (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax) VALUES
('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Sales Rep', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', '030-0074321', '030-0076545'),
('ANATR', 'Ana Trujillo Emparedados', 'Ana Trujillo', 'Owner', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico', '(5) 555-4729', NULL),
('BERGS', 'Berglunds snabbköp', 'Christina Berglund', 'Order Administrator', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden', '0921-12 34 65', '0921-12 34 67'),
('BLAUS', 'Blauer See Delikatessen', 'Hanna Moos', 'Sales Rep', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany', '0621-08460', NULL),
('BOLID', 'Bólido Comidas preparadas', 'Martín Sommer', 'Owner', 'C/ Araquil, 67', 'Madrid', NULL, '28023', 'Spain', '(91) 555 22 82', NULL),
('BONAP', 'Bon app''', 'Laurence Lebihan', 'Owner', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', '91.24.45.40', '91.24.45.41'),
('BOTTM', 'Bottom-Dollar Markets', 'Elizabeth Lincoln', 'Accounting Manager', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', '(604) 555-4729', '(604) 555-3745');

INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry) VALUES
(10248, 'ALFKI', 5, '1996-07-04', '1996-08-01', '1996-07-16', 3, 32.38, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany'),
(10249, 'ANATR', 6, '1996-07-05', '1996-08-16', '1996-07-10', 1, 11.61, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico'),
(10250, 'BERGS', 4, '1996-07-08', '1996-08-05', '1996-07-12', 2, 65.83, 'Berglunds snabbköp', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden'),
(10251, 'BONAP', 4, '1996-07-08', '1996-08-05', '1996-07-15', 2, 41.34, 'Bon app''', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France'),
(10252, 'BLAUS', 4, '1996-07-09', '1996-08-06', '1996-07-11', 2, 51.30, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany'),
(10253, 'BOTTM', 3, '1996-07-10', '1996-07-24', '1996-07-12', 3, 10.68, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada');

INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount) VALUES
(10248, 11, 14.00, 12, 0),
(10248, 42, 9.80, 10, 0),
(10248, 72, 34.80, 5, 0),
(10249, 14, 18.60, 9, 0),
(10249, 51, 42.40, 40, 0),
(10250, 41, 7.70, 10, 0),
(10250, 51, 42.40, 35, 0.15),
(10250, 65, 21.05, 21, 0.15),
(10251, 22, 16.80, 6, 0.05),
(10251, 57, 19.50, 15, 0.15),
(10252, 20, 81.00, 6, 0.05),
(10252, 35, 18.00, 20, 0.15),
(10252, 60, 34.00, 8, 0),
(10253, 71, 21.50, 30, 0),
(10253, 42, 9.80, 2, 0);

INSERT INTO Products (ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued) VALUES
(11, 'Queso Cabrales', 5, 4, '1 kg pkg.', 21.00, 22, 30, 30, 0),
(14, 'Tofu', 6, 7, '40 - 100 g pkgs.', 23.25, 35, 0, 20, 0),
(20, 'Sir Rodney''s Marmalade', 8, 3, '30 gift boxes', 81.00, 40, 0, 0, 0),
(22, 'Gustaf''s Knäckebröd', 9, 5, '24 - 500 g pkgs.', 21.00, 104, 0, 25, 0),
(35, 'Steeleye Stout', 1, 1, '24 - 12 oz bottles', 18.00, 20, 0, 15, 0),
(41, 'Jack''s New England Clam Chowder', 8, 8, '12 - 12 oz cans', 9.65, 85, 0, 10, 0),
(42, 'Singaporean Hokkien Fried Mee', 9, 1, '32 - 1 kg pkgs.', 14.00, 26, 0, 0, 0),
(51, 'Manjimup Dried Apples', 3, 7, '50 - 300 g pkgs.', 53.00, 20, 0, 10, 0),
(57, 'Ravioli Angelo', 1, 6, '24 - 250 g pkgs.', 19.50, 36, 0, 20, 0),
(60, 'Camembert Pierrot', 7, 4, '15 - 300 g rounds', 34.00, 19, 0, 0, 0),
(65, 'Louisiana Fiery Hot Pepper Sauce', 2, 2, '32 - 8 oz bottles', 21.05, 76, 0, 0, 0),
(71, 'Flotemysost', 15, 4, '10 - 500 g pkgs.', 21.50, 26, 0, 0, 0),
(72, 'Mozzarella di Giovanni', 14, 4, '24 - 200 g pkgs.', 34.80, 14, 0, 0, 0);

INSERT INTO Suppliers (SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax) VALUES
(1, 'Exotic Liquids', 'Charlotte Cooper', 'Purchasing Manager', '49 Gilbert St.', 'London', NULL, 'EC1 4SD', 'UK', '(171) 555-2222', NULL),
(2, 'New Orleans Cajun Delights', 'Shelley Burke', 'Order Administrator', 'P.O. Box 78934', 'New Orleans', 'LA', '70117', 'USA', '(100) 555-4822', NULL),
(3, 'Grandma Kelly''s Homestead', 'Regina Murphy', 'Sales Representative', '707 Oxford Rd.', 'Ann Arbor', 'MI', '48104', 'USA', '(313) 555-5735', '(313) 555-3349'),
(5, 'Cooperativa de Quesos ''Las Cabras''', 'Antonio del Valle Saavedra', 'Export Administrator', 'Calle del Rosal 4', 'Oviedo', 'Asturias', '33007', 'Spain', '(98) 598 76 54', NULL),
(6, 'Mayumi''s', 'Mayumi Ohno', 'Marketing Representative', '92 Setsuko Chuo-ku', 'Osaka', NULL, '545', 'Japan', '(06) 431-7877', NULL),
(7, 'Pavlova, Ltd.', 'Ian Devling', 'Marketing Manager', '74 Rose St. Moonie Ponds', 'Melbourne', 'Victoria', '3058', 'Australia', '(03) 444-2343', '(03) 444-6588'),
(8, 'Specialty Biscuits, Ltd.', 'Peter Wilson', 'Sales Representative', '29 King''s Way', 'Manchester', NULL, 'M14 GSD', 'UK', '(161) 555-4448', NULL),
(9, 'PB Knäckebröd AB', 'Lars Peterson', 'Sales Agent', 'Kaloadagatan 13', 'Göteborg', NULL, 'S-345 67', 'Sweden', '031-987 65 43', NULL),
(14, 'Formaggi Fortini s.r.l.', 'Elio Rossi', 'Sales Representative', 'Viale Dante, 75', 'Ravenna', NULL, '48100', 'Italy', '(0544) 60323', '(0544) 60608'),
(15, 'Norske Meierier', 'Beate Vileid', 'Marketing Manager', 'Storgt. 13', 'Stavern', NULL, '4110', 'Norway', '07-98 76 54', '07-98 76 55');

INSERT INTO Categories (CategoryID, CategoryName, Description) VALUES
(1, 'Beverages', 'Soft drinks, coffees, teas, beers, and ales'),
(2, 'Condiments', 'Sweet and savory sauces, relishes, spreads, and seasonings'),
(3, 'Confections', 'Desserts, candies, and sweet breads'),
(4, 'Dairy Products', 'Cheeses'),
(5, 'Grains/Cereals', 'Breads, crackers, pasta, and cereal'),
(6, 'Meat/Poultry', 'Prepared meats'),
(7, 'Produce', 'Dried fruit and bean curd'),
(8, 'Seafood', 'Seaweed and fish');

INSERT INTO Employees (EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo) VALUES
(1, 'Davolio', 'Nancy', 'Sales Representative', 'Ms.', '1948-12-08', '1992-05-01', '507 - 20th Ave. E.\nApt. 2A', 'Seattle', 'WA', '98122', 'USA', '(206) 555-9857', '5467', '0x', 'Education includes a BA in psychology from Colorado State University. She also completed "The Art of the Cold Call." Nancy is a member of Toastmasters International.', NULL),
(2, 'Fuller', 'Andrew', 'Vice President, Sales', 'Dr.', '1952-02-19', '1992-08-14', '908 W. Capital Way', 'Tacoma', 'WA', '98401', 'USA', '(206) 555-9482', '3457', '0x', 'Andrew received his BTS commercial in 1974 and a Ph.D. in international marketing from the University of Dallas in 1981. He is fluent in French and Italian.', 1),
(3, 'Leverling', 'Janet', 'Sales Representative', 'Ms.', '1963-08-30', '1992-04-01', '722 Moss Bay Blvd.', 'Kirkland', 'WA', '98033', 'USA', '(206) 555-3412', '3355', '0x', 'Janet has a BS degree in chemistry from Boston College (1984). She has also completed a certificate program in food retailing management. Janet was hired as a sales associate in 1991 and promoted to sales representative in February 1992.', 2),
(4, 'Peacock', 'Margaret', 'Sales Representative', 'Mrs.', '1937-09-19', '1993-05-03', '4110 Old Redmond Rd.', 'Redmond', 'WA', '98052', 'USA', '(206) 555-8122', '5176', '0x', 'Margaret holds a BA in English literature from Concordia College (1958) and an MA from the American Institute of Culinary Arts (1966).', 2),
(5, 'Buchanan', 'Steven', 'Sales Manager', 'Mr.', '1955-03-04', '1993-10-17', '14 Garrett Hill', 'London', NULL, 'SW1 8JR', 'UK', '(71) 555-4848', '3453', '0x', 'Steven Buchanan graduated from St. Andrews University, Scotland, with a BSc degree in 1976. Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and was then assigned to the London office. Steven was promoted to sales manager in March 1993.', 2);


SELECT * FROM Customers;

SELECT * FROM Customers
WHERE CompanyName LIKE '%N';

SELECT * FROM Customers
WHERE City IN ('Berlin', 'London');

SELECT * FROM Customers
WHERE Country IN ('UK', 'USA');

SELECT * FROM Products
ORDER BY ProductName;

SELECT * FROM Products
WHERE ProductName LIKE 'A%';

SELECT DISTINCT Customers.*
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

SELECT DISTINCT Customers.*
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Customers.City = 'London' AND Products.ProductName = 'Chai';


SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

SELECT DISTINCT Customers.*
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Products.ProductName = 'Tofu';

SELECT OrderID, AVG(Quantity) AS AvgQuantity
FROM OrderDetails
GROUP BY OrderID;

SELECT OrderID, MIN(Quantity) AS MinQuantity, MAX(Quantity) AS MaxQuantity
FROM OrderDetails
GROUP BY OrderID;

SELECT E1.EmployeeID AS ManagerID, E1.FirstName, E1.LastName, COUNT(E2.EmployeeID) AS NumberOfReports
FROM Employees E1
JOIN Employees E2 ON E1.EmployeeID = E2.ReportsTo
GROUP BY E1.EmployeeID, E1.FirstName, E1.LastName;

SELECT TOP 1
    o.OrderID,
    o.OrderDate,
    o.CustomerID,
    c.CompanyName,
    o.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    od.UnitPrice,
    od.Quantity,
    od.Discount,
    (od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalPrice
FROM
    Orders o
INNER JOIN
    Customers c ON o.CustomerID = c.CustomerID
INNER JOIN
    Employees e ON o.EmployeeID = e.EmployeeID
INNER JOIN
    OrderDetails od ON o.OrderID = od.OrderID
WHERE
    o.OrderDate = (
        SELECT
            TOP 1 OrderDate
        FROM
            Orders
        ORDER BY
            Freight DESC
    )
ORDER BY
    TotalPrice DESC;

SELECT OrderID, SUM(Quantity) AS TotalQuantity
FROM OrderDetails
GROUP BY OrderID
HAVING TotalQuantity > 300;


SELECT * FROM Orders
WHERE OrderDate >= '1996-12-31';

SELECT * FROM Orders
WHERE ShipCountry = 'Canada';


SELECT Orders.OrderID, SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) AS OrderTotal
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Orders.OrderID
HAVING OrderTotal > 200;


SELECT ShipCountry, SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) AS TotalSales
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY ShipCountry;

SELECT Customers.ContactName, COUNT(Orders.OrderID) AS NumberOfOrders
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.ContactName;

SELECT Customers.ContactName
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.ContactName
HAVING COUNT(Orders.OrderID) > 3;

SELECT DISTINCT Products.*
FROM Products
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
WHERE Products.Discontinued = 1 AND Orders.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';


SELECT E1.FirstName AS EmployeeFirstName, E1.LastName AS EmployeeLastName, E2.FirstName AS SupervisorFirstName, E2.LastName AS SupervisorLastName
FROM Employees E1
LEFT JOIN Employees E2 ON E1.ReportsTo = E2.EmployeeID;

SELECT Employees.EmployeeID, SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) AS TotalSales
FROM Employees
JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Employees.EmployeeID;


SELECT * FROM Employees
WHERE FirstName LIKE '%a%';


SELECT E1.EmployeeID, E1.FirstName, E1.LastName, COUNT(E2.EmployeeID) AS NumberOfReports
FROM Employees E1
JOIN Employees E2 ON E1.EmployeeID = E2.ReportsTo
GROUP BY E1.EmployeeID, E1.FirstName, E1.LastName
HAVING NumberOfReports > 4;


SELECT Orders.OrderID, Products.ProductName
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID;


SELECT Orders.*
FROM Orders
JOIN (
    SELECT CustomerID, SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) AS TotalSales
    FROM Orders
    JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    GROUP BY CustomerID
    ORDER BY TotalSales DESC
    LIMIT 1
) AS BestCustomer ON Orders.CustomerID = BestCustomer.CustomerID;

SELECT Orders.*
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Fax IS NULL;

SELECT DISTINCT Orders.ShipPostalCode
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Products.ProductName = 'Tofu';


SELECT DISTINCT Products.ProductName
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Orders.ShipCountry = 'France';


SELECT Products.ProductName, Categories.CategoryName
FROM Products
JOIN Categories ON Products.CategoryID = Categories.CategoryID
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.CompanyName = 'Specialty Biscuits, Ltd.';

SELECT * FROM Products
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails);



SELECT * FROM Products
WHERE UnitsInStock < 10 AND UnitsOnOrder = 0;


SELECT ShipCountry, SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) AS TotalSales
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY ShipCountry
ORDER BY TotalSales DESC
LIMIT 10;


SELECT Employees.EmployeeID, COUNT(Orders.OrderID) AS NumberOfOrders
FROM Employees
JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.CustomerID BETWEEN 'A' AND 'AO'
GROUP BY Employees.EmployeeID;

SELECT Orders.OrderDate
FROM Orders
JOIN (
    SELECT OrderID, SUM(UnitPrice * Quantity) AS Total
    FROM OrderDetails
    GROUP BY OrderID
    ORDER BY Total DESC
    LIMIT 1
) AS MostExpensiveOrder ON Orders.OrderID = MostExpensiveOrder.OrderID;


SELECT Products.ProductName, SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) AS TotalRevenue
FROM Products
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName;

SELECT SupplierID, COUNT(ProductID) AS NumberOfProducts
FROM Products
GROUP BY SupplierID;


SELECT Customers.CustomerID, SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) AS TotalSales
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Customers.CustomerID
ORDER BY TotalSales DESC
LIMIT 10;
