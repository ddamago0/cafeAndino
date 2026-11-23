-- Configuración del contexto
USE ROLE SYSADMIN;
USE WAREHOUSE CAFE_ANDINO_WH;
USE DATABASE CAFE_ANDINO_DB;
USE SCHEMA CAFE_ANDINO_ESQUEMA;

-- Comprobación del stage
LIST @PEDIDOS_STAGE;

-- Carga de pedidos con metadatos
COPY INTO PEDIDOS_RAW (DATOS, NOMBRE_ARCHIVO, FECHA_CARGA)
FROM (
    SELECT
        $1,
        METADATA$FILENAME,
        CURRENT_TIMESTAMP()
    FROM @PEDIDOS_STAGE/pedidos_1.json
)
FILE_FORMAT = JSON_FORMAT;

-- Verificación de la tabla cruda
SELECT COUNT(*) AS TOTAL_PEDIDOS_RAW FROM PEDIDOS_RAW;

-- Consulta de pedidos en crudo
SELECT * FROM PEDIDOS_RAW;

-- Creación de la vista relacional
CREATE OR REPLACE VIEW PEDIDOS_DETALLE AS
SELECT
    DATOS:pedido_id::INTEGER AS PEDIDO_ID,
    DATOS:cliente.ciudad::VARCHAR(50) AS CIUDAD,
    item.value:producto::VARCHAR(50) AS PRODUCTO,
    item.value:cantidad::INTEGER AS CANTIDAD
FROM PEDIDOS_RAW,
LATERAL FLATTEN(input => DATOS:items) item;

-- Verificación de la vista detallada
SELECT COUNT(*) AS TOTAL_ITEMS FROM PEDIDOS_DETALLE;

-- Consulta del detalle de pedidos
SELECT * FROM PEDIDOS_DETALLE ORDER BY PEDIDO_ID, PRODUCTO;
