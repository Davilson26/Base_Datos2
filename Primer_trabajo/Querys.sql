
-- SELECT
select id, nombre from fabricantes;
select id, nombre, precio, fabricantes_id from productos;

-- INSERT
INSERT INTO fabricantes (nombre) VALUES ('prueba');
INSERT INTO productos (nombre,precio,fabricantes_id) VALUES ('cocacola', '2500', 2);

-- UPDATE
UPDATE productos SET
nombre = 'SPRITE',
precio = 2000,
fabricantes_id = 3
WHERE id = 3;

UPDATE fabricantes
SET
nombre = 'Granjita la marina'
WHERE id = 2;

-- DELETE
DELETE FROM productos WHERE id = 2;
DELETE FROM fabricantes WHERE id = 4;



