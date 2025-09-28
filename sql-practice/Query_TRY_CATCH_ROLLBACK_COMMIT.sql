--MANEJO TRANSACCIONES (BEGIN TRAN, COMMIT, ROLLBACK)

--CASO NEGOCIO: Simulación: Transferencia de fondos:
--Queremos transferir 500 unidades de la cuenta 1001 a la cuenta 1002.
--COMMIT EXITOSO
BEGIN TRAN
--Debitar cta origen
UPDATE Cuentas
SET Saldo = Saldo - 100
WHERE Id_Cuenta = 1002
--Acreditar cta destino
UPDATE Cuentas
SET Saldo = Saldo + 100
WHERE Id_Cuenta = 1001
--Si todo OK
COMMIT;

--CASO FALLIDO
BEGIN TRAN
UPDATE Cuentas
SET Saldo = Saldo - 100
WHERE Id_Cuenta = 1002
--Simulamos un error a cta estino
UPDATE Cuentas
SET Saldo = Saldo + 100
WHERE Id_Cuenta = 9999
--Algo falla → revertimos todo
ROLLBACK;

--TRY -- CATCH
--CASO EXITO: Transferir 300 soles de la cuenta 1002 a la cta 1001
BEGIN TRY 
	BEGIN TRAN
	--Debitar 
	UPDATE Cuentas
	SET Saldo = Saldo - 300
	WHERE Id_Cuenta = 1002
	--Acreditar
	UPDATE Cuentas
	SET Saldo = Saldo + 300
	WHERE Id_Cuenta = 1001

	--Si no hay errores 
	COMMIT;
	PRINT 'Transferencia realizada con éxito'
END TRY
BEGIN CATCH
	--si hay error
	ROLLBACK;
	PRINT 'Error en la transacción. Se revirtieron los cambios'
END CATCH

--CASO FALLIDO: Transferir 300 soles de la cuenta 1001 a la cta 9999 ( ERROR, NO EXISTE EN LA TABLA) 
BEGIN TRY

	BEGIN TRAN
	--Debitar 
	UPDATE Cuentas
	SET Saldo = Saldo - 300
	WHERE Id_Cuenta = 1001

	--Validar la cta y si no existe pasar al catch
	IF @@ROWCOUNT = 0  --cuenta las celdas afecta, codigo interno y esto activa el THROW
		THROW 50001, 'Cuenta Origen no encontrada', 1; --el 50001 es un codigo mio personalizado para darle al error

	--Acreditar
	UPDATE Cuentas
	SET Saldo = Saldo + 300
	WHERE Id_Cuenta = 9999   --Esta cta no existe

	--Validar la cta y si no existe pasar al catch
	IF @@ROWCOUNT = 0 
		THROW 50002, 'Cuenta Destion no encontrada', 1;

	--Si no hay errores 
	COMMIT;
	PRINT 'Transferencia realizada con éxito'
END TRY
BEGIN CATCH
	--si hay error
	ROLLBACK;
	PRINT 'Error en la transacción. Se revirtieron los cambios'
END CATCH

SELECT * FROM Cuentas

-- CASO TECNICO 
-- Contexto de negocio:
--Un banco necesita que cada transferencia de dinero entre cuentas cumpla con estas reglas:
	--La cuenta origen debe existir.
	--La cuenta destino debe existir.
	--La cuenta origen debe tener saldo suficiente.
	--Si cualquiera de estas condiciones falla → la transacción debe revertirse (ROLLBACK).
	--Si todo es correcto → se registra en la tabla Transacciones.
--Tú, como analista de datos, debes crear la lógica SQL que automatice la validación.

--LA TABLA DE MOVIMIENTOS SE CREO EN OTRA QUERY, PORQUE SINO GENERA CONFUSION Y ROLLBACK REVIERTE TODO HASTA LA TABLA CREADA

DECLARE @Origen INT = 1002;
DECLARE @Destino INT = 1001;
DECLARE @Monto DECIMAL(18,2) = 100

BEGIN TRY
	BEGIN TRAN
	--Debito
	UPDATE Cuentas
	SET Saldo = Saldo- @Monto
	WHERE Id_Cuenta = @Origen
		--Valido cta existe
	IF @@ROWCOUNT = 0
		THROW 50001, 'Cuenta Origen no encontrada', 1;
		--validar saldo en cta
	IF (SELECT SALDO FROM Cuentas WHERE Id_Cuenta = @Origen) < 0
		THROW 50003, 'Saldo insuficiente en ceunta origen', 1;
	
	--acreditar
	UPDATE Cuentas
	SET Saldo = Saldo + @Monto
	WHERE Id_Cuenta = @Destino
		--valido cta existe
	IF @@ROWCOUNT = 0
		THROW 50002, 'Cuenta destino no encontrada', 1;

	--REGISTRAR EN TRANSACCIONES
	INSERT INTO Movimientos (Id_Cuenta_Origen, Id_Cuenta_Destino, Monto) 
	Values( @Origen, @Destino, @Monto);

	COMMIT;
	PRINT 'TRANSACCION REALIZADA CON EXITO'
END TRY

BEGIN CATCH
	ROLLBACK;
	PRINT 'ERROR EN LA TRANSACCION'
	PRINT ERROR_MESSAGE();
END CATCH;

select top 2 * from Cuentas
select * from Movimientos


