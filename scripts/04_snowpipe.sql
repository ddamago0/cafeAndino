-- Seleccion del contexto de trabajo
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE CAFE_ANDINO_WH;
USE DATABASE CAFE_ANDINO_DB;
USE SCHEMA CAFE_ANDINO_ESQUEMA;

-- Creacion del nuevo stage dedicado para la ingesta continua con Snowpipe
CREATE STAGE IF NOT EXISTS PEDIDOS_PIPE_STAGE
    FILE_FORMAT = JSON_FORMAT;

-- Creacion del pipe con AUTO_INGEST en FALSE debido al uso de stage interno
CREATE OR REPLACE PIPE PEDIDOS_PIPE
    AUTO_INGEST = FALSE
AS
COPY INTO PEDIDOS_RAW (DATOS, NOMBRE_ARCHIVO, FECHA_CARGA)
FROM (
    SELECT
        $1,
        METADATA$FILENAME,
        CURRENT_TIMESTAMP()
    FROM @PEDIDOS_PIPE_STAGE
)
FILE_FORMAT = JSON_FORMAT;

-- Instruccion para subir solo pedidos_2.json y evitar duplicar pedidos_1.json:
-- Opcion A (SnowSQL): PUT file:///ruta/local/datos/pedidos_2.json @PEDIDOS_PIPE_STAGE AUTO_COMPRESS=TRUE;
-- Opcion B (Snowsight): Subir unicamente pedidos_2.json al stage PEDIDOS_PIPE_STAGE.

-- Comprobacion del archivo nuevo en el stage
LIST @PEDIDOS_PIPE_STAGE;

-- Refresco manual de Snowpipe para procesar los archivos pendientes del stage interno
ALTER PIPE PEDIDOS_PIPE REFRESH;

-- Verificacion del estado de ejecucion del pipe
SELECT SYSTEM$PIPE_STATUS('PEDIDOS_PIPE');

-- Verificacion de total de pedidos en la tabla cruda (deben ser 5 pedidos en total)
SELECT COUNT(*) AS TOTAL_PEDIDOS FROM PEDIDOS_RAW;

-- Comprobacion de que no existen pedidos duplicados
SELECT
    DATOS:pedido_id::INTEGER AS PEDIDO_ID,
    NOMBRE_ARCHIVO,
    FECHA_CARGA
FROM PEDIDOS_RAW
ORDER BY PEDIDO_ID;

-- Revision del historial de ingesta del pipe
SELECT
    FILE_NAME,
    STATUS,
    ROW_COUNT,
    ROW_PARSED,
    ERROR_COUNT,
    FIRST_ERROR_MESSAGE
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'PEDIDOS_RAW',
    START_TIME => DATEADD(HOURS, -1, CURRENT_TIMESTAMP())
));

-- Comprobacion de los items reflejados en la vista detallada
SELECT * FROM PEDIDOS_DETALLE ORDER BY PEDIDO_ID, PRODUCTO;
