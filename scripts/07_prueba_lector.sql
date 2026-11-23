-- Configuración con rol de lectura
USE ROLE CAFE_LECTOR;
USE WAREHOUSE CAFE_ANDINO_WH;
USE DATABASE CAFE_ANDINO_DB;
USE SCHEMA CAFE_ANDINO_ESQUEMA;

-- Consulta permitida en ventas
SELECT * FROM VENTAS LIMIT 5;

-- Consulta permitida en pedidos
SELECT * FROM PEDIDOS_DETALLE LIMIT 5;

-- Inserción bloqueada por permisos esperada
INSERT INTO VENTAS (ID_VENTA, FECHA, TIENDA, PRODUCTO, CANTIDAD, PRECIO_UNIT)
VALUES (99, '2026-11-08', 'Bogotá', 'Croissant', 1, 8000);

-- Retorno al rol de trabajo
USE ROLE SYSADMIN;
