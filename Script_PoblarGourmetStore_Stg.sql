
use GourmetStore_Stg


--limpiar tablas
DELETE FROM Ventas_Stg;
DELETE FROM Producto_Stg;
DBCC CHECKIDENT(Producto_Stg, RESEED, 0);
DELETE FROM Categoria_Stg;
DBCC CHECKIDENT(Categoria_Stg, RESEED, 0);
DELETE FROM Transportista_Stg;
DBCC CHECKIDENT(Transportista_Stg, RESEED, 0);
DELETE FROM Cliente_Stg;
DBCC CHECKIDENT(Cliente_Stg, RESEED, 0);
DELETE FROM Empleado_Stg;
DBCC CHECKIDENT(Empleado_Stg, RESEED, 0);
DELETE FROM Proveedor_Stg;
DBCC CHECKIDENT(Proveedor_Stg, RESEED, 0);
DELETE FROM Tiempo_Stg;
DBCC CHECKIDENT(Tiempo_Stg, RESEED, 0);



--Poblar Tablas de BD GourmetStore_Stg
--tabla Categoría
insert into GourmetStore_Stg..Categoria_Stg
select CategoryID, CategoryName
from Categories

--tabla Cliente
insert into GourmetStore_Stg..Cliente_Stg
select CustomerID,ContactName as NombreCliente,City as Ciudad,Country as País
from Customers

--tabla Empleado
insert into GourmetStore_Stg..Empleado_Stg
select EmployeeID,LastName+', '+FirstName as NombreEmpleado
from Employees

--tabla Producto
insert into GourmetStore_Stg..Producto_Stg
select p.ProductID,p.ProductName as NombreProducto,p.QuantityPerUnit as Presentación, p.UnitPrice as PrecioUnitario,p.CategoryID as Categoría
from Products p inner join Categories c on p.CategoryID = c.CategoryID

--tabla Proveedor
insert into GourmetStore_Stg..Proveedor_Stg
select SupplierID,ContactName as NombreProveedor,City as Ciudad,Country as País
from Suppliers



--Tabla Tiempo
insert into GourmetStore_Stg..Tiempo_Stg
select distinct CONVERT(date, OrderDate) as Fecha,
    DAY(OrderDate) as Día,
	MONTH(OrderDate) AS Mes,
	DATEPART(quarter, OrderDate) AS Trimestre,
	year(orderdate) as Año,
	CASE
		WHEN convert(varchar,DATEPART(quarter, OrderDate)) IN (1)
			THEN 'Trimestre1'
		WHEN convert(varchar,DATEPART(quarter, OrderDate))  IN (2)
			THEN 'Trimestre2'
		WHEN convert(varchar,DATEPART(quarter, OrderDate))  IN (3)
			THEN 'Trimestre3'
		ELSE 'Trimestre4'
		end as NombreTrimestre,
	Convert(varchar,DATENAME(mm,orderdate)) as NombreMes
	
FROM Orders;



--tabla Transportista
insert into GourmetStore_Stg..Transportista_Stg
select ShipperID ,CompanyName as NombreTransportista
from Shippers 

--tabla Ventas_Stg
insert into GourmetStore_Stg..Ventas_Stg
select od.ProductID as skProducto,cli.skCliente,p.SupplierID as skProveedor,
	   o.EmployeeID as skEmpleado,sh.ShipperID as skTransportista,t.skTiempo, 
	   od.Quantity as UnidadesVendidas,od.UnitPrice as PrecioVenta,
	   o.OrderDate as Fecha,od.Quantity * od.UnitPrice *(1 - od.Discount) AS MontoVendido
from Northwind.dbo.Products p inner join Northwind.dbo.[Order Details] od on p.ProductID = od.ProductID
				inner join Northwind.dbo.Orders o on o.OrderID = od.OrderID
				inner join Northwind.dbo.Suppliers s on s.SupplierID = p.SupplierID
				inner join Northwind.dbo.Categories c on c.CategoryID = p.CategoryID
				inner join Northwind.dbo.Employees e on e.EmployeeID = o.EmployeeID
				inner join Northwind.dbo.Shippers sh on sh.ShipperID = o.ShipVia
				inner join Northwind.dbo.Customers cu on cu.CustomerID = o.CustomerID
				inner join GourmetStore_Stg.dbo.Tiempo_Stg t on t.fecha = CONVERT(date, o.OrderDate)
				inner join GourmetStore_Stg.dbo.Cliente_Stg cli on cu.CustomerID = convert(varchar,cli.idCliente)

				

		





