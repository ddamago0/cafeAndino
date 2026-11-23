# Glosario de terminos - Cafe Andino

## Terminos del negocio
- Venta neta: Monto total facturado por item, resultante de multiplicar la cantidad vendida por el precio unitario (`CANTIDAD * PRECIO_UNIT`).
- Pedido: Registro de compra realizado a traves de la tienda online, compuesto por un identificador (`pedido_id`), fecha, datos del cliente y un arreglo de articulos (`items`).
- Tienda fisica: Sede presencial de Cafe Andino (Bogota, Medellin, Cali).
- Tienda online: Plataforma digital de ventas que despacha a las tres ciudades.

## Terminos tecnicos de Snowflake
- Stage interno: Directorio de almacenamiento temporal dentro de la infraestructura de Snowflake utilizado para recibir archivos locales mediante PUT.
- Stage externo: Ubicacion de almacenamiento en nube (AWS S3, Azure Blob o Google Cloud Storage) referenciada desde Snowflake.
- VARIANT: Tipo de dato especializado de Snowflake para almacenar estructuras semiestructuradas (JSON) de hasta 16 MB.
- LATERAL FLATTEN: Funcion de tabla que toma un arreglo JSON dentro de una columna VARIANT y lo descompone en multiples filas relacionales.
- Snowpipe: Mecanismo de Snowflake para la ingesta continua de archivos hacia tablas de destino.
- AUTO_INGEST: Configuracion de Snowpipe que escucha eventos de notificacion en stages externos. Para stages internos debe establecerse en FALSE.
- COPY INTO: Sentencia SQL utilizada para transferir datos desde un stage hacia una tabla relacional o semiestructurada.
- VALIDATION_MODE: Modo de validacion de COPY INTO que verifica posibles errores de formato o tipos sin insertar registros en la tabla.
- ON_ERROR: Clausula de COPY INTO que define la accion a tomar al encontrar una fila corrupta (por ejemplo, CONTINUE para cargar las filas validas y descartar las fallidas).
- Warehouse: Recurso de computo virtual en Snowflake encargado de procesar consultas y cargas de datos.
- Rol: Objeto de seguridad que agrupa privilegios sobre bases de datos, esquemas y warehouses en Snowflake.
