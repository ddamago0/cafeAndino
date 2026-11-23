# Lista de verificación de resultados en Snowflake

Esta tabla consolida los puntos de control y los valores exactos esperados en cada script del proyecto Café Andino. La columna "Resultado real" debe ser completada por el usuario al ejecutar las sentencias en Snowflake.

| Script | Punto de control | Valor exacto esperado | Resultado real |
|---|---|---|---|
| `01_entorno.sql` | Creación de warehouse, BD, esquema y rol lector | Contexto activo: SYSADMIN, CAFE_ANDINO_WH, CAFE_ANDINO_DB, CAFE_ANDINO_ESQUEMA | |
| `02_objetos.sql` | Creación de formatos de archivo | Formatos CSV_FORMAT y JSON_FORMAT creados sin error | |
| `02_objetos.sql` | Creación de tablas base | Tablas VENTAS y PEDIDOS_RAW creadas | |
| `02_objetos.sql` | Creación de stages internos | Stages VENTAS_STAGE, PEDIDOS_STAGE y PEDIDOS_PIPE_STAGE creados | |
| `03_ventas_csv.sql` | LIST @VENTAS_STAGE | Muestra el archivo `ventas_1.csv` (o `ventas_1.csv.gz`) | |
| `03_ventas_csv.sql` | Validación previa (RETURN_ERRORS) | 1 fila de error en columna `CANTIDAD` con el valor `'dos'` (línea 8 del archivo con cabecera) | |
| `03_ventas_csv.sql` | Conteo en tabla VENTAS | `COUNT(*) = 9` | |
| `03_ventas_csv.sql` | Tabla VENTAS_RECHAZADAS | Exactamente 1 fila con el registro rechazado de Bogotá | |
| `03_ventas_csv.sql` | COPY_HISTORY de VENTAS | `ROW_PARSED = 10`, `ROW_COUNT = 9`, `ERROR_COUNT = 1` | |
| `04_pedidos_json.sql` | LIST @PEDIDOS_STAGE | Muestra el archivo `pedidos_1.json` | |
| `04_pedidos_json.sql` | Conteo en PEDIDOS_RAW | `COUNT(*) = 3` (pedidos 101, 102 y 103) | |
| `04_pedidos_json.sql` | Conteo en PEDIDOS_DETALLE | `COUNT(*) = 5` filas de productos aplanados | |
| `05_snowpipe.sql` | LIST @PEDIDOS_PIPE_STAGE | Contiene únicamente `pedidos_2.json` | |
| `05_snowpipe.sql` | SYSTEM$PIPE_STATUS | Objeto JSON con `"executionState":"RUNNING"` | |
| `05_snowpipe.sql` | Conteo en PEDIDOS_RAW tras REFRESH | `COUNT(*) = 5` (pedidos 101 al 105, sin IDs repetidos) | |
| `05_snowpipe.sql` | Conteo en PEDIDOS_DETALLE acumulado | `COUNT(*) = 8` filas de productos aplanados | |
| `06_consultas.sql` | Consulta 1: Venta neta por tienda | Cali: 80000.00, Medellín: 74500.00, Bogotá: 61500.00 (Total: 216000.00) | |
| `06_consultas.sql` | Consulta 2: Producto online líder | Bogotá: Capuchino (5), Cali: Café americano (4), Medellín: Croissant (4) | |
| `07_prueba_lector.sql` | Consultas SELECT con rol CAFE_LECTOR | Ejecución exitosa (devuelve datos de VENTAS y PEDIDOS_DETALLE) | |
| `07_prueba_lector.sql` | Inserción INSERT con rol CAFE_LECTOR | Error por permisos insuficientes: `SQL compilation error: ... insufficient privileges` | |
