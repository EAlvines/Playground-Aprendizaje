select * from Clientes_Staging
select * from Productos_Staging
select * from Ventas_Staging

-- ETL CON STORED PROCEDURE
-- OBJ : Validar y cargar de staging a final asegurando integridad
CREATE TABLE Clientes_Final (
	ClienteId varchar(10) primary key,
	Nombre nvarchar(50),
	Telefono nvarchar(10),
	Ciudad nvarchar(10)
);

create table Productos_Final(
	ProductoId INT primary Key,
	NombreProducto Nvarchar(100),
	Precio decimal (10,2)
);

create table Ventas_Finales(
	IdVenta varchar(10) primary key,
	ClienteId varchar(10),
	ProductoId INT, 
	Fecha DATE,
	Monto decimal(10,2),
	foreign key (ClienteId) references Clientes_Final(ClienteId),
	foreign key (ProductoId) references Productos_Final(ProductoId)
);

--Crear los SP - CLIENTE
CREATE OR ALTER PROCEDURE SP_CargarClientes
AS
BEGIN 
	INSERT INTO Clientes_final(ClienteId, Nombre, Telefono, Ciudad)
	SELECT DISTINCT s.ClienteId, s.Nombre, s.Telefono, s.Ciudad --Evitamos duplicados
	FROM Clientes_Staging s
		where not exists (
		select 1 from Clientes_Final f where f.ClienteId = s.ClienteId
		--este condicion impide que se inserte un cliente si ya existe en la tabla final
		--si existe no lo inserta  // si no existe lo inserta
    );
END;

--SP - PRODUCTO
CREATE OR ALTER PROCEDURE SP_CargarProductos
AS
BEGIN
	INSERT INTO Productos_Final(ProductoId, NombreProducto, Precio)
	select distinct s.ProductoId, s.NombreProducto, s.Precio
	from Productos_Staging s
	where not exists (
		select 1 from Productos_Final f where f.ProductoId = s.ProductoId
	);
END;

--SP - VENTAS
CREATE OR ALTER PROCEDURE SP_CargarVentas
AS
BEGIN
	INSERT INTO Ventas_Finales( IdVenta, ClienteId, ProductoId, Fecha, Monto)
	select s.IdVenta, s.ClienteId, s.ProductoId, try_cast(s.Fecha as date), s.Monto 
	--Si la fecha viene mal formateada, TRY_CAST devuelve NULL en vez de romper la ejecución.
	from Ventas_Staging s
	where
		exists (select 1 from Clientes_Final c where c.ClienteId = s.ClienteId)
		--Verifica que el ClienteId de la venta staging exista en la tabla Clientes_Final
		--Si no existe → esa venta no se carga (Garantiza integridad referencial con la tabla de clientes)
		and exists (select 1 from Productos_Final p where p.ProductoId = s.ProductoId)
		--productoId de Ventas staging exista en la tabla producto final
		and not exists (select 1 from Ventas_Finales v where v.IdVenta = s.IdVenta);
end;

--La tabla de Clientes, colum Telefono la long era menor, se modifico la columna 
ALTER TABLE Clientes_Final
ALTER COLUMN Telefono NVARCHAR(50);

--ejecutar los procedimientos almacenados
--Cada vez que se desee poblar tu tabla final, solo correr los SP, ya está configurado para evitar duplicados:
exec SP_CargarClientes
exec SP_CargarProductos
exec SP_CargarVentas

select * from Clientes_Final
select * from Productos_Final
select * from Ventas_Finales


