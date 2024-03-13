-- INSERCION DEL CLIENTE
INSERT INTO cliente (cedula, nombre, email, telefono ) VALUES ('123', 'Davilson', 'davilson@gmail.com', '3136329121');
INSERT INTO cliente (cedula, nombre, email, telefono ) VALUES ('567', 'Diego', 'diego@gmail.com', '3213445123');
-- INSERCIÓN DE LA CUENTA AL USUARIO
INSERT INTO cuenta (numero_cuenta,idcliente) VALUES ('987654321011',1);
INSERT INTO cuenta (numero_cuenta,saldo,idcliente) VALUES ('123456789011',500000,2);
-- INSERSION DE LOS TIPOS DE TRANSACCION
INSERT INTO tipo_transaccion (nombre,descripcion) VALUES('deposito usuario', 'Transaccion del usuario donde deposita dinero a la cuenta');
INSERT INTO tipo_transaccion (nombre,descripcion) VALUES('retiro usuario', 'Transaccion del usuario donde retira dinero de la cuenta');
INSERT INTO tipo_transaccion (nombre,descripcion) VALUES('transferir a usuario', 'Transaccion donde un usuario transfiere dinero a otra cuenta');
INSERT INTO tipo_transaccion (nombre,descripcion) VALUES('transferencia de otro usuario', 'Transaccion donde se recibe dinero de otra cuenta');
