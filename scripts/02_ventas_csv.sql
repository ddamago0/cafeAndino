-- Seleccion del contexto de trabajo
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE CAFE_ANDINO_WH;
USE DATABASE CAFE_ANDINO_DB;
USE SCHEMA CAFE_ANDINO_ESQUEMA;

-- Creacion de la tabla de ventas fisicas
CREATE TABLE IF NOT EXISTS VENTAS (
    ID_VENTA INTEGER,
    FECHA DATE,
    TIENDA VARCHAR(50),
    PRODUCTO VARCHAR(50),
    CANTIDAD INTEGER,
    PRECIO_UNIT NUMBER(10, 2)
);

-- Creacion del formato de archivo para CSV
CREATE FILE FORMAT IF NOT EXISTS CSV_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    ENCODING = 'UTF8'
    NULL_IF = ('NULL', 'null', '');

-- Creacion del stage interno para ventas
CREATE STAGE IF NOT EXISTS VENTAS_STAGE
    FILE_FORMAT = CSV_FORMAT;

-- Instruccion para subir el archivo ventas_1.csv:
-- Opcion A (SnowSQL): PUT file:///ruta/local/datos/ventas_1.csv @VENTAS_STAGE AUTO_COMPRESS=TRUE;
-- Opcion B (Snowsight): Ir a Data > Databases > CAFE_ANDINO_DB > CAFE_ANDINO_ESQUEMA > Stages > VENTAS_STAGE y pulsar '+ Files'.

-- Comprobacion del archivo en el stage
LIST @VENTAS_STAGE;

-- Validacion previa del archivo antes de la carga real para detectar inconsistencias
COPY INTO VENTAS
FROM @VENTAS_STAGE/ventas_1.csv
FILE_FORMAT = CSV_FORMAT
VALIDATION_MODE = RETURN_ERRORS;

-- Se usa ON_ERROR = CONTINUE para cargar las 9 filas validas y no frenar la operacion, aislando la fila 7 para corregirla despues.
COPY INTO VENTAS
FROM @VENTAS_STAGE/ventas_1.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = CONTINUE;

-- Verificacion del total de filas cargadas
SELECT COUNT(*) AS TOTAL_FILAS FROM VENTAS;

-- Consulta de filas cargadas en la tabla
SELECT * FROM VENTAS ORDER BY ID_VENTA;

-- Revision del historial de carga para confirmar 9 filas cargadas y 1 con error
SELECT
    FILE_NAME,
    STATUS,
    ROW_COUNT,
    ROW_PARSED,
    ERROR_COUNT,
    FIRST_ERROR_MESSAGE
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'VENTAS',
    START_TIME => DATEADD(HOURS, -1, CURRENT_TIMESTAMP())
));
