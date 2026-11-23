# Revisión técnica de scripts SQL

## Resumen de la revisión
Informe elaborado por el agente de Ingeniería SQL tras la reestructuración completa del flujo de scripts (`01_entorno.sql` a `07_prueba_lector.sql`). Se verificó la consistencia de roles, orden de creación de objetos, gestión de errores, idempotencia y límites de estilo.

## Hallazgos por script

### 01_entorno.sql
- Jerarquía y privilegios:
  - El warehouse `CAFE_ANDINO_WH` (tamaño XSMALL, auto-suspend 60 s), la base de datos `CAFE_ANDINO_DB` y el esquema `CAFE_ANDINO_ESQUEMA` se crean con `USE ROLE SYSADMIN`.
  - Se utiliza `USE ROLE ACCOUNTADMIN` exclusivamente para la creación del rol `CAFE_LECTOR`, la concesión de sus privilegios (`USAGE` y `SELECT`) y la asignación `GRANT ROLE CAFE_LECTOR TO ROLE SYSADMIN`.
  - Se eliminaron cambios de rol duplicados y se finaliza retornando a `USE ROLE SYSADMIN`.
  - Se incluye la línea comentada `-- GRANT ROLE CAFE_LECTOR TO USER <TU_USUARIO>;` para que el usuario asigne el rol lector a su usuario en Snowflake.

### 02_objetos.sql
- Desacoplamiento y orden:
  - Se separó la creación DDL de las sentencias de carga. Este script centraliza los formatos `CSV_FORMAT` y `JSON_FORMAT`, las tablas base `VENTAS` y `PEDIDOS_RAW`, y los tres stages internos (`VENTAS_STAGE`, `PEDIDOS_STAGE`, `PEDIDOS_PIPE_STAGE`).
  - Permite que los stages existan antes de que el usuario proceda a subir los archivos físicos mediante Snowsight o SnowSQL.
  - No contiene instrucciones textuales de PUT ni rutas locales, las cuales se trasladaron exclusivamente al README.

### 03_ventas_csv.sql
- Validación y aislamiento de errores:
  - Ejecuta `LIST @VENTAS_STAGE;` para comprobar la presencia del archivo.
  - La sentencia previa con `VALIDATION_MODE = RETURN_ERRORS` identifica el error en la columna `CANTIDAD` (valor 'dos').
  - La carga real con `ON_ERROR = CONTINUE` inserta las 9 filas válidas en `VENTAS`.
  - Se implementó la creación de la tabla `VENTAS_RECHAZADAS` mediante `CREATE TABLE IF NOT EXISTS VENTAS_RECHAZADAS AS SELECT * FROM TABLE(VALIDATE(VENTAS, JOB_ID => '_last'));`, permitiendo auditar la fila errónea sin interrumpir la operación.
  - Incluye consultas de conteo, inspección de registros y auditoría mediante `INFORMATION_SCHEMA.COPY_HISTORY`.

### 04_pedidos_json.sql
- Carga semiestructurada y vista:
  - Carga `pedidos_1.json` en `PEDIDOS_RAW` extrayendo el documento en una columna `VARIANT` junto con metadatos (`METADATA$FILENAME` y `CURRENT_TIMESTAMP()`).
  - Crea la vista relacional `PEDIDOS_DETALLE` usando `LATERAL FLATTEN(input => DATOS:items)`, aplanando los artículos sin alterar la tabla en bruto.
  - Verifica que la tabla contenga 3 registros y la vista 5 filas.

### 05_snowpipe.sql
- Idempotencia y canalización continua:
  - Se cambió `CREATE OR REPLACE PIPE` por `CREATE PIPE IF NOT EXISTS PEDIDOS_PIPE`, asegurando que ejecuciones posteriores del script no redefinan el pipe, no pierdan el historial de carga y no generen pedidos duplicados.
  - Mantiene `AUTO_INGEST = FALSE` debido al uso de un stage interno.
  - Ejecuta `ALTER PIPE PEDIDOS_PIPE REFRESH;` para procesar `pedidos_2.json`.
  - Monitorea el estado mediante `SYSTEM$PIPE_STATUS`, confirma 5 pedidos únicos en `PEDIDOS_RAW` y 8 registros detallados en `PEDIDOS_DETALLE`.

### 06_consultas.sql
- Consultas analíticas:
  - Consulta 1 calcula ventas netas físicas (`SUM(CANTIDAD * PRECIO_UNIT)`) agrupadas por `TIENDA` y ordenadas de mayor a menor. Opera exclusivamente sobre las 9 filas válidas de `VENTAS`.
  - Consulta 2 determina el producto más solicitado online por ciudad mediante una CTE con `ROW_NUMBER() OVER (PARTITION BY CIUDAD ORDER BY SUM(CANTIDAD) DESC) WHERE POSICION = 1`.

### 07_prueba_lector.sql
- Validación de seguridad:
  - Comienza cambiando a `USE ROLE CAFE_LECTOR`.
  - Ejecuta consultas `SELECT` sobre `VENTAS` y `PEDIDOS_DETALLE` para confirmar lectura permitida.
  - Ejecuta un `INSERT INTO VENTAS` intencional que debe fallar con error de permisos insuficientes, confirmando que el rol no permite mutaciones.
  - Retorna a `USE ROLE SYSADMIN`.

## Conclusión
Todos los scripts cumplen con las restricciones de SQL básico, sin procedimientos ni tareas. Los comentarios en código son únicamente encabezados cortos de bloque de 6 palabras o menos. Los nombres de objetos están en mayúsculas y sin tildes.
