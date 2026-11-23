# Revision tecnica de scripts SQL

## Resumen de la revision
Revision realizada por el agente de Ingenieria SQL sobre los scripts generados para el proyecto Cafe Andino. Se evaluo la sintaxis, tipos de datos, control de errores, cumplimiento de buenas practicas y limites de complejidad tecnica.

## Hallazgos por script

### 01_entorno.sql
- Parametrizacion del warehouse: Se empleo tamano XSMALL con AUTO_SUSPEND = 60 y AUTO_RESUME = TRUE. Cumple con la minimizacion de costos de computo.
- Jerarquia de objetos: Se configuran correctamente base de datos CAFE_ANDINO_DB y esquema CAFE_ANDINO_ESQUEMA.
- Seguridad y acceso: Se incluye la creacion del rol CAFE_LECTOR con privilegios USAGE y SELECT (tanto para objetos actuales como futuros). Cumple con el principio de menor privilegio y doble proteccion de solo lectura.

### 02_ventas_csv.sql
- Tipos de datos: Se definen tipos adecuados (INTEGER, DATE, VARCHAR, NUMBER) compatibles con el esquema de ventas fisicas.
- Formato de archivo: CSV_FORMAT omite cabecera (SKIP_HEADER = 1), usa codificacion UTF-8 y maneja nulos adecuadamente.
- Deteccion y gestion de errores:
  - VALIDATION_MODE = RETURN_ERRORS identifica que en la fila 7 la columna cantidad contiene la cadena de texto 'dos', incompatible con INTEGER.
  - La directiva ON_ERROR = CONTINUE permite que el proceso de ingesta no se interrumpa, logrando cargar las 9 filas validas y aislando la fila 7 para saneamiento.
- Verificacion: Se incluye consulta a INFORMATION_SCHEMA.COPY_HISTORY para auditar filas leidas, cargadas y rechazadas.

### 03_pedidos_json.sql
- Ingesta semiestructurada: La tabla PEDIDOS_RAW almacena el objeto completo en una columna de tipo VARIANT.
- Trazabilidad: Se capturan exitosamente METADATA$FILENAME y CURRENT_TIMESTAMP() mediante una subconsulta SELECT dentro de COPY INTO.
- Transformacion relacional: La vista PEDIDOS_DETALLE utiliza LATERAL FLATTEN sobre DATOS:items, desagregando cada producto en una fila individual tipificada (PEDIDO_ID, CIUDAD, PRODUCTO, CANTIDAD).

### 04_snowpipe.sql
- Configuracion de ingesta continua: Al utilizarse un stage interno (PEDIDOS_PIPE_STAGE), no se cuenta con integracion por eventos en la nube; por tanto, AUTO_INGEST debe ser FALSE.
- Mecanismo de sincronizacion: Se especifica la sentencia ALTER PIPE PEDIDOS_PIPE REFRESH para procesar pedidos_2.json.
- Integridad: Se asegura que pedidos_1.json no se vuelva a cargar, manteniendo un total consolidado de 5 pedidos sin duplicaciones.
- Monitoreo: Se incluyen sentencias para consultar SYSTEM$PIPE_STATUS y el historial de COPY_HISTORY.

### 05_consultas.sql
- Consulta 1 (Ventas netas por tienda): Calcula correctamente SUM(CANTIDAD * PRECIO_UNIT) agrupando por TIENDA y ordenando de forma descendente. Opera unicamente sobre las filas validas que fueron aceptadas en la tabla VENTAS.
- Consulta 2 (Producto mas pedido online por ciudad): Aplica una expresion de tabla comun (WITH) con la funcion de ventana ROW_NUMBER() particionada por CIUDAD y ordenada por suma de cantidad descendente, filtrando el primer lugar (POSICION = 1).

## Conclusion de calidad
Los scripts cumplen rigurosamente con los requisitos: utilizan SQL basico, no incluyen procedimientos almacenados ni tareas complejas, y los nombres de objetos estan en mayusculas y en espanol.
