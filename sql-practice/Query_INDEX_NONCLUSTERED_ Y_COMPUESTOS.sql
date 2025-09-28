--INDEX CLUSTERED & NONCLUSTERED 

--Index clustered en FechaTransaccion
CREATE CLUSTERED INDEX IX_Transacciones_Fecha
ON Transacciones(Fecha_Transaccion);  --No sale pq solo se permite 1 y como hay una Primary K. pues ya hay un indicex defecto


--Indice Nonclustered en ClienteID para acelerar busqueda x cliente
CREATE NONCLUSTERED INDEX IX_Transacciones_Cuenta
ON Transacciones(Id_Cuenta)
INCLUDE (Fecha_Transaccion, Monto, Tipo);


--Caso negocio: un cliente entra a la banca por internet y pide el histórico de transacciones de su cuenta.
SELECT Id_Transaccion, Id_Cuenta, Monto
FROM Transacciones
WHERE Id_Cuenta = 1005

--Caso negocio: Como harías para consultar las transacciones de un cliente en un rango de fechas

SELECT Id_Cuenta, Fecha_Transaccion, Monto, Tipo
FROM Transacciones
WHERE Id_Cuenta = 1002
	AND Fecha_Transaccion BETWEEN '2025-01-01' AND '2025-02-28'
ORDER BY Fecha_Transaccion;
--Tomó tiempo con el Indice actual 

--INDICE COMPUESTO
--Haremos un indice compuesto 
CREATE NONCLUSTERED INDEX IX_Transacciones_cuenta_fecha
ON Transacciones(Id_Cuenta, Fecha_Transaccion)
INCLUDE (Monto, Tipo); 

--Consulta + ORDENAR POR FECHA
SELECT Id_Cuenta, Fecha_Transaccion, Monto, Tipo
FROM Transacciones
WHERE Id_Cuenta = 1002
	AND Fecha_Transaccion between '2025-01-01' AND '2025-03-31'
ORDER BY Fecha_Transaccion;
--Fue más rápido :D

--NOTA: 
--Filtros WHERE → van en las columnas clave del índice. Ej: Id_Cuenta, Fecha_Transaccion.
--Ordenamiento (ORDER BY) → también debe estar en las claves del índice. Así te ahorras el paso Sort.
--Columnas adicionales que se seleccionan → se ponen como INCLUDE. Ej: Monto, Tipo_Transaccion.
--Con esta regla, casi siempre tendrás planes óptimos con Index Seek.

select * from Transacciones
