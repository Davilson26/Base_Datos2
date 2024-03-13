-- ----------------------------------------------------------------------------------------
-- ITERACIONES 1 Y 2
DROP PROCEDURE IF EXISTS DepositarDinero;
-- Función para depositar dinero en una cuenta
DELIMITER //
CREATE  PROCEDURE DepositarDinero(IN cliente_nombre VARCHAR(45), IN monto DOUBLE)
BEGIN
	DECLARE cuenta_id INT;
    IF monto <= 0 THEN
        SELECT 'El monto a depositar debe ser mayor a cero' AS mensaje;
    ELSE
        -- Obtenemos el id de la cuenta del cliente
        SELECT idcuenta INTO cuenta_id FROM cuenta WHERE idcliente = (
            SELECT idcliente FROM cliente WHERE nombre = cliente_nombre
        ) LIMIT 1;

        -- Insertamos la transacción de depósito a la cuenta
        INSERT INTO transaccion (`monto`, `idcuenta`, `idtipo_transaccion`)
        VALUES (monto, cuenta_id, 1);

        -- Actualizamos el saldo de la cuenta
        UPDATE cuenta SET saldo = saldo + monto WHERE idcuenta = cuenta_id;
    END IF;
END //
DELIMITER ;
-- ---------------------------------------------------------------------------------
CALL DepositarDinero('Diego', 100000); -- ITERACIÓN 1
CALL DepositarDinero('Diego', -100000); -- ITERACIÓN 2
select * from cuenta;

-- ---------------------------------------------------------------------------------
-- ITERACCIONES 3, 4 Y 5;
DROP PROCEDURE IF EXISTS RetirarDinero;
-- Función para retirar dinero de una cuenta 
DELIMITER //
CREATE PROCEDURE RetirarDinero(IN cliente_nombre VARCHAR(45), IN monto DOUBLE)
BEGIN
    DECLARE cuenta_id INT;
    DECLARE saldo_actual DOUBLE;

    -- Obtener el id de la cuenta del cliente y su saldo actual
    SELECT idcuenta, saldo INTO cuenta_id, saldo_actual FROM cuenta WHERE idcliente = (
        SELECT idcliente FROM cliente WHERE nombre = cliente_nombre
    ) LIMIT 1;
        IF monto <= 0 THEN
        SELECT 'El monto a retirar debe ser mayor a cero' AS mensaje;
    ELSE
		-- Verificar si el saldo es suficiente para el retiro
		IF saldo_actual >= monto THEN
			-- Insertar la transacción de retiro
			INSERT INTO transaccion (`monto`, `idcuenta`, `idtipo_transaccion`)
			VALUES (monto, cuenta_id, 2);

			-- Actualizar el saldo de la cuenta
			UPDATE cuenta SET saldo = saldo - monto WHERE idcuenta = cuenta_id;
		ELSE
			SELECT 'Saldo insuficiente para realizar el retiro' AS mensaje;
		END IF;
	END IF;
END //
DELIMITER ;
-- --------------------------------------------------------------------------------------------------
UPDATE cuenta SET saldo = 100000 WHERE idcliente = 2;
CALL RetirarDinero('Diego', 10000);
CALL RetirarDinero('Diego', -10000);
select * from cuenta;

select * from cliente;

-- --------------------------------------------------------------------------------------------------
-- ITERACCION 6
-- Característica: transferir dinero a otra cuenta 
-- Como cliente del banco 
-- quiero trasnferir dinero de mi cuenta a otra cuenta 
-- para pagar mis gastos
-- Escenario ideal: un cliente existente transfiere dinero de su cuenta a la cuenta de otro cliente
-- Dado un cliente existente con nombre "Diego" con $500.000 pesos en su cuenta 
-- debe transferirle $400.000 de su cuenta a la cuenta de "Davilson"
-- Entonces el nuevo saldo es de $100.000 pesos.

-- Escenario f1: como cliente del banco quiero intentar transferir mas dinero del que tengo en la cuenta
-- Dado un cliente existente con nombre “Diego” con $500.000 pesos en su cuenta
-- Cuando intenta transferirle $600.000 pesos a la cuenta de "Davilson"
-- Entonces se muestra un mensaje indicando "El monto a transferir debe ser menor o igual al saldo de la cuenta"

-- Escenario f2: como cliente del banco quiero intentar transferir un monto negativo a otra cuenta
-- Dado un cliente existente con nombre “Diego” con $500.000 pesos en su cuenta
-- Cuando intenta transferirle $-100000 pesos a la cuenta de "Davilson"
-- Entonces se muestra un mensaje indicando "El monto a transferir debe ser mayor a 0"

-- Escenario f3: como cliente del banco quiero intentar transferir a una cuenta que no existe
-- Dado un cliente existente con nombre “Diego” con $500.000 pesos en su cuenta
-- Cuando intenta transferirle $100000 pesos a una cuenta que no está registrada
-- Entonces se muestra un mensaje indicando "La cuenta a transferir no existe"

-- Escenario f4: como cliente del banco quiero intentar transferir dinero de mi cuenta a mi cuenta
-- Dado un cliente existente con nombre “Diego” con $500.000 pesos en su cuenta
-- Cuando intenta transferirle $500.000 pesos a su misma cuenta
-- Entonces se muestra un mensaje indicando "No se puede transferir a su misma cuenta"

DROP PROCEDURE IF EXISTS TransferirDinero;
DELIMITER //
CREATE PROCEDURE TransferirDinero(
    IN cliente_origen VARCHAR(45),
    IN monto_transferencia DOUBLE,
    IN cuenta_destino VARCHAR(45)
)
BEGIN
    DECLARE cuenta_id_origen INT;
    DECLARE saldo_actual_origen DOUBLE;
    DECLARE cuenta_id_destino INT;
    DECLARE saldo_actual_destino DOUBLE;

    -- Obtener el id de la cuenta del cliente y su saldo actual
    SELECT idcuenta, saldo INTO cuenta_id_origen, saldo_actual_origen 
    FROM cuenta 
    WHERE idcliente = (
        SELECT idcliente FROM cliente WHERE nombre = cliente_origen
    ) LIMIT 1;
    
    -- Obtener el id de la cuenta del cliente y su saldo actual
    SELECT idcuenta, saldo INTO cuenta_id_destino, saldo_actual_destino 
    FROM cuenta 
    WHERE idcliente = (
        SELECT idcliente FROM cliente WHERE nombre = cuenta_destino
    ) LIMIT 1;
    
    -- Escenario f1 
    IF saldo_actual_origen < monto_transferencia THEN
        SELECT 'El monto a transferir debe ser menor o igual al saldo de la cuenta' AS mensaje;
    -- Escenario f2
    ELSEIF monto_transferencia <= 0 THEN
        SELECT 'El monto a depositar debe ser mayor a cero' AS mensaje;
    -- Escenario f3
    ELSEIF cuenta_id_destino IS NULL THEN
        SELECT 'La cuenta a transferir no existe' AS mensaje;
    -- Escenario f4
    ELSEIF cliente_origen = cuenta_destino THEN
        SELECT 'No se puede transferir a su misma cuenta' AS mensaje;
    ELSE
        -- Insertamos las transacciones
        INSERT INTO transaccion (`monto`, `idcuenta`, `idtipo_transaccion`)
        VALUES (monto_transferencia, cuenta_id_origen, 3);
        
        INSERT INTO transaccion (`monto`, `idcuenta`, `idtipo_transaccion`)
        VALUES (monto_transferencia, cuenta_id_destino, 4);
        
        -- Actualizamos el saldo de ambas cuentas
        UPDATE cuenta SET saldo = saldo - monto_transferencia WHERE idcuenta = cuenta_id_origen;
        UPDATE cuenta SET saldo = saldo + monto_transferencia WHERE idcuenta = cuenta_id_destino;
    END IF;
END //

DELIMITER ;

-- ---------------------------------------------------------------------------------
CALL TransferirDinero('Diego', 600000, 'Davilson');   -- Escenario f1 
CALL TransferirDinero('Diego', -100000, 'Davilson');   -- Escenario f2
CALL TransferirDinero('Diego', 100000, 'Jennifer');   -- Escenario f3
CALL TransferirDinero('Diego', 500000, 'diego');   -- Escenario f4
CALL TransferirDinero('Diego', 400000, 'Davilson');   -- Escenario ideal
