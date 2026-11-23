# Glosario de términos - Café Andino

## Términos del negocio
- Venta neta: Monto total facturado por ítem, resultante de multiplicar la cantidad vendida por el precio unitario (`CANTIDAD * PRECIO_UNIT`).
- Pedido: Registro de compra realizado a través de la tienda online, compuesto por un identificador (`pedido_id`), fecha, datos del cliente y un arreglo de artículos (`items`).
- Tienda física: Sede presencial de Café Andino (Bogotá, Medellín, Cali).
- Tienda online: Plataforma digital de ventas que despacha a las tres ciudades.

## Términos técnicos de Snowflake
- Stage interno: Directorio de almacenamiento temporal dentro de la infraestructura de Snowflake utilizado para recibir archivos locales mediante PUT o Snowsight.
- Stage externo: Ubicación de almacenamiento en nube (AWS S3, Azure Blob o Google Cloud Storage) referenciada desde Snowflake.
- VARIANT: Tipo de dato especializado de Snowflake para almacenar estructuras semiestructuradas (JSON) de hasta 16 MB.
- LATERAL FLATTEN: Función de tabla que toma un arreglo JSON dentro de una columna VARIANT y lo descompone en múltiples filas relacionales.
- Snowpipe: Mecanismo de Snowflake para la ingesta continua y automatizada de archivos hacia tablas de destino.
- AUTO_INGEST: Configuración de Snowpipe que escucha eventos de notificación en stages externos. Para stages internos debe establecerse en FALSE.
- COPY INTO: Sentencia SQL utilizada para transferir datos desde un stage hacia una tabla relacional o semiestructurada.
- VALIDATION_MODE: Modo de validación de COPY INTO que verifica posibles errores de formato o tipos sin insertar registros en la tabla.
- ON_ERROR: Cláusula de COPY INTO que define la acción a tomar al encontrar una fila corrupta (por ejemplo, CONTINUE para cargar las filas válidas y descartar las fallidas).
- VALIDATE: Función de tabla que permite consultar los errores de carga generados en la última ejecución de COPY INTO (`JOB_ID => '_last'`).
- Warehouse: Recurso de cómputo virtual en Snowflake encargado de procesar consultas y cargas de datos.
- Rol: Objeto de seguridad que agrupa privilegios sobre bases de datos, esquemas y warehouses en Snowflake.
