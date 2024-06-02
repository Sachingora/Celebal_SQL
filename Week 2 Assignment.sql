/*
Create a procedure InsertOrderDetails that takes OrderID, ProductID, UnitPrice, Quantiy, Discount as input parameters and inserts that order information in the Order Details table. After each order inserted, check the @@rowcount value to make sure that order was inserted properly. If for any reason the order was not inserted, print the message: Failed to place the order. Please try again. Also your procedure should have these functionalities

Make the UnitPrice and Discount parameters optional

If no UnitPrice is given, then use the UnitPrice value from the product table.

If no Discount is given, then use a discount of 0.

Adjust the quantity in stock (UnitsInStock) for the product by subtracting the quantity sold from inventory.

However, if there is not enough of a product in stock, then abort the stored procedure without making any changes to the database.

Print a message if the quantity in stock of a product drops below its Reorder Level as a result of the update.
*/


CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT,
    @Discount DECIMAL(4, 2) = 0
AS
BEGIN
    DECLARE @ActualUnitPrice DECIMAL(10, 2)
    DECLARE @UnitsInStock INT
    DECLARE @ReorderLevel INT

    -- Begin transaction to ensure atomicity
    BEGIN TRANSACTION

    -- Get the necessary details from the Product table
    SELECT 
        @ActualUnitPrice = ISNULL(@UnitPrice, UnitPrice),
        @UnitsInStock = UnitsInStock,
        @ReorderLevel = ReorderLevel
    FROM 
        Production.Product
    WHERE 
        ProductID = @ProductID

    -- Check if there are enough units in stock
    IF @UnitsInStock < @Quantity
    BEGIN
        PRINT 'Not enough units in stock. Order cannot be placed.'
        ROLLBACK TRANSACTION
        RETURN
    END

    -- Insert the order details
    INSERT INTO Sales.OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
    VALUES (@OrderID, @ProductID, @ActualUnitPrice, @Quantity, @Discount)

    -- Check if the insert was successful
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.'
        ROLLBACK TRANSACTION
        RETURN
    END

    -- Update the units in stock
    UPDATE Production.Product
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID

    -- Check if the quantity in stock drops below the reorder level
    IF @UnitsInStock - @Quantity < @ReorderLevel
    BEGIN
        PRINT 'The quantity in stock of the product has dropped below the reorder level.'
    END

    -- Commit transaction if everything is successful
    COMMIT TRANSACTION
END
GO


/*
Create a procedure UpdateOrderDetails that takes OrderID, ProductID, UnitPrice, Quantity, and discount, and updates these values for that ProductID in that Order. 
All the parameters except the OrderID and ProductID should be optional so that if the user wants to only update Quantity s/he should be able to do so without 
providing the rest of the values. You need to also make sure that if any of the values are being passed in as NULL, then you want to retain the original value instead 
of overwriting it with NULL. To accomplish this, look for the ISNULL() function in google or sql server books online. Adjust the UnitsInStock value in products table 
accordingly.
*/

CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT = NULL,
    @Discount DECIMAL(4, 2) = NULL
AS
BEGIN
    DECLARE @OriginalUnitPrice DECIMAL(10, 2)
    DECLARE @OriginalQuantity INT
    DECLARE @OriginalDiscount DECIMAL(4, 2)
    DECLARE @NewUnitPrice DECIMAL(10, 2)
    DECLARE @NewQuantity INT
    DECLARE @NewDiscount DECIMAL(4, 2)
    DECLARE @UnitsInStock INT
    DECLARE @ReorderLevel INT
    DECLARE @QuantityChange INT

    -- Begin transaction to ensure atomicity
    BEGIN TRANSACTION

    -- Get the original values from Order Details
    SELECT 
        @OriginalUnitPrice = UnitPrice,
        @OriginalQuantity = Quantity,
        @OriginalDiscount = Discount
    FROM 
        Sales.OrderDetails
    WHERE 
        OrderID = @OrderID AND ProductID = @ProductID

    -- Determine the new values, retaining original if NULL
    SET @NewUnitPrice = ISNULL(@UnitPrice, @OriginalUnitPrice)
    SET @NewQuantity = ISNULL(@Quantity, @OriginalQuantity)
    SET @NewDiscount = ISNULL(@Discount, @OriginalDiscount)

    -- Get the current stock levels
    SELECT 
        @UnitsInStock = UnitsInStock,
        @ReorderLevel = ReorderLevel
    FROM 
        Production.Product
    WHERE 
        ProductID = @ProductID

    -- Calculate the change in quantity and update the stock levels
    SET @QuantityChange = @NewQuantity - @OriginalQuantity

    -- Check if there are enough units in stock if quantity is increasing
    IF @QuantityChange > 0 AND @UnitsInStock < @QuantityChange
    BEGIN
        PRINT 'Not enough units in stock to increase the order quantity. Update cannot be processed.'
        ROLLBACK TRANSACTION
        RETURN
    END

    -- Update the order details
    UPDATE Sales.OrderDetails
    SET 
        UnitPrice = @NewUnitPrice,
        Quantity = @NewQuantity,
        Discount = @NewDiscount
    WHERE 
        OrderID = @OrderID AND ProductID = @ProductID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to update the order. Please try again.'
        ROLLBACK TRANSACTION
        RETURN
    END

    -- Update the units in stock
    UPDATE Production.Product
    SET UnitsInStock = UnitsInStock - @QuantityChange
    WHERE ProductID = @ProductID

    -- Check if the quantity in stock drops below the reorder level
    IF @UnitsInStock - @QuantityChange < @ReorderLevel
    BEGIN
        PRINT 'The quantity in stock of the product has dropped below the reorder level.'
    END

    -- Commit transaction if everything is successful
    COMMIT TRANSACTION
END
GO


/*
Create a procedure GetOrderDetails that takes OrderID as input parameter and returns all the 
records for that OrderID. If no records are found in Order Details table, then it should print 
the line: "The OrderID XXXX does not exits", where XXX should be the OrderID entered by user 
and the procedure should RETURN the value 1.
*/

CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    -- Declare a variable to hold the row count
    DECLARE @RowCount INT

    -- Select all records for the given OrderID
    SELECT *
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID

    -- Check if any records were found
    SET @RowCount = @@ROWCOUNT

    IF @RowCount = 0
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR(10)) + ' does not exist.'
        RETURN 1
    END
END
GO


/*
Create a procedure DeleteOrderDetails that takes OrderID and ProductID and deletes that from Order Details table. Your procedure should validate parameters. It should return an error code (-1) and print a message if the parameters are invalid. Parameters are valid if the given order 
ID appears in the table and if the given product ID appears in that order
*/

CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the given OrderID exists in the SalesOrderDetail table
    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @OrderID)
    BEGIN
        PRINT 'Invalid OrderID. The OrderID ' + CAST(@OrderID AS VARCHAR(10)) + ' does not exist.'
        RETURN -1
    END

    -- Check if the given ProductID exists in the specified OrderID
    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @OrderID AND ProductID = @ProductID)
    BEGIN
        PRINT 'Invalid ProductID. The ProductID ' + CAST(@ProductID AS VARCHAR(10)) + ' does not exist in OrderID ' + CAST(@OrderID AS VARCHAR(10)) + '.'
        RETURN -1
    END

    -- Delete the order detail record
    DELETE FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID

    PRINT 'Order detail for ProductID ' + CAST(@ProductID AS VARCHAR(10)) + ' in OrderID ' + CAST(@OrderID AS VARCHAR(10)) + ' has been deleted.'
END
GO

/*
Create a function that takes an input parameter type datetime and returns the date in the format MM/DD/YYYY. For example if I pass in '2006-11-21 23:34:05.920', the output of the functions 
should be 11/21/2006
*/

USE AdventureWorks2022; 
IF OBJECT_ID('dbo.FormatDate_MMDDYYYY', 'FN') IS NOT NULL
    DROP FUNCTION dbo.FormatDate_MMDDYYYY;
GO

-- Create the function
CREATE FUNCTION dbo.FormatDate_MMDDYYYY
(
    @InputDate DATETIME
)
RETURNS NVARCHAR(10)
AS
BEGIN
    DECLARE @FormattedDate NVARCHAR(10)

    -- Format the date as MM/DD/YYYY
    SET @FormattedDate = CONVERT(NVARCHAR(10), @InputDate, 101)

    RETURN @FormattedDate
END;
GO
/*
Create a function that takes an input parameter type datetime and returns the date in the format YYYYMMDD

*/

USE AdventureWorks2022; 
IF OBJECT_ID('dbo.FormatDate_YYYYMMDD', 'FN') IS NOT NULL
    DROP FUNCTION dbo.FormatDate_YYYYMMDD;
GO

-- Create the function
CREATE FUNCTION dbo.FormatDate_YYYYMMDD
(
    @InputDate DATETIME
)
RETURNS NVARCHAR(8)
AS
BEGIN
    DECLARE @FormattedDate NVARCHAR(8)

    -- Format the date as YYYYMMDD
    SET @FormattedDate = CONVERT(NVARCHAR(8), @InputDate, 112)

    RETURN @FormattedDate
END;
GO


/*
Views

*/

/*
Create a view vwCustomerOrders which retums CompanyName, OrderID, OrderDate. ProductID, Product 
Name, Quantity, UnitPrice.Quantity od. UnitPrice

*/

USE AdventureWorks2022; 
IF OBJECT_ID('dbo.vwCustomerOrders', 'V') IS NOT NULL
    DROP VIEW dbo.vwCustomerOrders;
GO

-- Create the view
CREATE VIEW dbo.vwCustomerOrders
AS
    SELECT
        c.CompanyName,
        soh.SalesOrderID AS OrderID,
        soh.OrderDate,
        sod.ProductID,
        p.Name AS ProductName,
        sod.OrderQty AS Quantity,
        sod.UnitPrice,
        sod.OrderQty * sod.UnitPrice AS TotalPrice
    FROM 
        Sales.SalesOrderHeader soh
    INNER JOIN 
        Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN 
        Sales.Customer c ON soh.CustomerID = c.CustomerID
    INNER JOIN 
        Production.Product p ON sod.ProductID = p.ProductID;
GO


/*Create a copy of the above view and modify it so that it only returns the above information for orders that were placed yesterday
*/

USE AdventureWorks2022; 
IF OBJECT_ID('dbo.vwCustomerOrdersYesterday', 'V') IS NOT NULL
    DROP VIEW dbo.vwCustomerOrdersYesterday;
GO

-- Create the view
CREATE VIEW dbo.vwCustomerOrdersYesterday
AS
    SELECT
        c.CompanyName,
        soh.SalesOrderID AS OrderID,
        soh.OrderDate,
        sod.ProductID,
        p.Name AS ProductName,
        sod.OrderQty AS Quantity,
        sod.UnitPrice,
        sod.OrderQty * sod.UnitPrice AS TotalPrice
    FROM 
        (
            SELECT SalesOrderID, ProductID, OrderQty, UnitPrice
            FROM Sales.SalesOrderDetail
            WHERE DATEDIFF(DAY, OrderDate, GETDATE()) = 1
        ) sod
    INNER JOIN 
        Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    INNER JOIN 
        Sales.Customer c ON soh.CustomerID = c.CustomerID
    INNER JOIN 
        Production.Product p ON sod.ProductID = p.ProductID;
GO

/*Use a CREATE VIEW statement to create a view called MyProducts. Your view should contain the ProductID, ProductName, QuantityPerUnit and Unit Price columns from the Products table. It should also contain the Company Name column from the Suppliers table and the Category Name column from the Categories fable. Your view should only contain products that are not discontinued.
*/
USE AdventureWorks2022; 
IF OBJECT_ID('dbo.MyProducts', 'V') IS NOT NULL
    DROP VIEW dbo.MyProducts;
GO

-- Create the view
CREATE VIEW dbo.MyProducts
AS
    SELECT 
        p.ProductID,
        p.Name AS ProductName,
        p.QuantityPerUnit,
        p.UnitPrice,
        s.CompanyName,
        c.Name AS CategoryName
    FROM 
        Production.Product p
    INNER JOIN 
        Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
    INNER JOIN 
        Purchasing.Vendor v ON pv.VendorID = v.VendorID
    INNER JOIN 
        Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    INNER JOIN 
        Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    INNER JOIN 
        Sales.Customer c ON soh.CustomerID = c.CustomerID
    WHERE 
        p.DiscontinuedDate IS NULL;
GO


/*
Triggers
*/

/*If someone cancels an order in northwind database, then you want to delete that order from the Orders table. But you will not be able to delete that Order before deleting the records from Order Details table for that particular order due to referential integrity constraints. Create an Instead of Delete trigger on Orders table so that if some one tries to delete an Order that trigger gets fired and that trigger should first delete everything in order details table and then delete that order from the Orders table
*/
USE AdventureWorks2022; 
IF OBJECT_ID('trInsteadOfDeleteOrder', 'TR') IS NOT NULL
    DROP TRIGGER trInsteadOfDeleteOrder;
GO

-- Create the trigger
CREATE TRIGGER trInsteadOfDeleteOrder
ON Sales.SalesOrderHeader
INSTEAD OF DELETE
AS
BEGIN
    -- Delete from Order Details first
    DELETE FROM Sales.SalesOrderDetail
    WHERE SalesOrderID IN (SELECT SalesOrderID FROM deleted);

    -- Delete from Orders table
    DELETE FROM Sales.SalesOrderHeader
    WHERE SalesOrderID IN (SELECT SalesOrderID FROM deleted);
END;
GO

/*When an order is placed for X units of product Y, we must first check the Products table to ensure that there is sufficient stock to fill the order. This trigger will operate on the Order Details table
. If sufficient stock exists, then fill the order and decrement X units from the UnitsInStock column in Products. If insufficient stock exists, then refuse the order (Le do not insert it) and notify the 
user that the order could not be filled because of insufficient stock.*/

USE AdventureWorks2022; 

-- Drop the trigger if it already exists
IF OBJECT_ID('trInsteadOfInsertOrderDetail', 'TR') IS NOT NULL
    DROP TRIGGER trInsteadOfInsertOrderDetail;
GO

-- Create the trigger
CREATE TRIGGER trInsteadOfInsertOrderDetail
ON Sales.SalesOrderDetail
INSTEAD OF INSERT
AS
BEGIN
    -- Check if there is sufficient stock to fill the order
    IF EXISTS (
        SELECT p.ProductID, p.Name, p.UnitsInStock, i.ProductID, SUM(i.Quantity) AS OrderedQuantity
        FROM Production.Product p
        INNER JOIN inserted i ON p.ProductID = i.ProductID
        GROUP BY p.ProductID, p.Name, p.UnitsInStock, i.ProductID
        HAVING SUM(i.Quantity) <= p.UnitsInStock
    )
    BEGIN
        -- Sufficient stock exists, proceed with the insert and update
        DECLARE @ProductID INT, @Quantity INT;

        -- Iterate through each inserted row
        DECLARE cur CURSOR FOR
        SELECT ProductID, Quantity
        FROM inserted;

        OPEN cur;
        FETCH NEXT FROM cur INTO @ProductID, @Quantity;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Insert into Order Details
            INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount)
            SELECT SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount
            FROM inserted
            WHERE ProductID = @ProductID;

            -- Update UnitsInStock in Products table
            UPDATE Production.Product
            SET UnitsInStock = UnitsInStock - @Quantity
            WHERE ProductID = @ProductID;

            FETCH NEXT FROM cur INTO @ProductID, @Quantity;
        END