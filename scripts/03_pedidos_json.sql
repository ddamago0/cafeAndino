-- Seleccion del contexto de trabajo
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE CAFE_ANDINO_WH;
USE DATABASE CAFE_ANDINO_DB;
USE SCHEMA CAFE_ANDINO_ESQUEMA;

-- Creacion de la tabla para pedidos semiestructurados en formato crudo
CREATE TABLE IF NOT EXISTS PEDIDOS_RAW (
    DATOS VARIANT,
    NOMBRE_ARCHIVO VARCHAR(255),
    FECHA_CARGA TIMESTAMP_NTZ
);

-- Creacion del formato de archivo para JSON
CREATE FILE FORMAT IF NOT EXISTS JSON_FORMAT
    TYPE = 'JSON'
    STRIP_OUTER_ARRAY = FALSE;

-- Creacion del stage interno para pedidos JSON
CREATE STAGE IF NOT EXISTS PEDIDOS_STAGE
    FILE_FORMAT = JSON_FORMAT;

-- Instruccion para subir el archivo pedidos_1.json:
-- Opcion A (SnowSQL): PUT file:///ruta/local/datos/pedidos_1.json @PEDIDOS_STAGE AUTO_COMPRESS=TRUE;
-- Opcion B (Snowsight): Ir a Stages > PEDIDOS_STAGE y subir pedidos_1.json.

-- Comprobacion del archivo en el stage
LIST @PEDIDOS_STAGE;

-- Carga del JSON extrayendo datos y metadatos de archivo y fecha
COPY INTO PEDIDOS_RAW (DATOS, NOMBRE_ARCHIVO, FECHA_CARGA)
FROM (
    SELECT
        $1,
        METADATA$FILENAME,
        CURRENT_TIMESTAMP()
    FROM @PEDIDOS_STAGE/pedidos_1.json
)
FILE_FORMAT = JSON_FORMAT;

-- Verificacion de registros en la tabla cruda
SELECT COUNT(*) AS TOTAL_PEDIDOS_RAW FROM PEDIDOS_RAW;

-- Consulta de contenido de la tabla cruda
SELECT * FROM PEDIDOS_RAW;

-- Creacion de la vista relacional que aplana los items de cada pedido
CREATE OR REPLACE VIEW PEDIDOS_DETALLE AS
SELECT
    DATOS:pedido_id::INTEGER AS PEDIDO_ID,
    DATOS:cliente.ciudad::VARCHAR(50) AS CIUDAD,
    item.value:producto::VARCHAR(50) AS PRODUCTO,
    item.value:cantidad::INTEGER AS CANTIDAD
FROM PEDIDOS_RAW,
LATERAL FLATTEN(input => DATOS:items) item;

-- Verificacion de la vista relacional generada
SELECT * FROM PEDIDOS_DETALLE ORDER BY PEDIDO_ID, PRODUCTO;
