# Documentacion del modelo de datos - Cafe Andino

Este documento detalla las tablas y vistas implementadas en el esquema CAFE_ANDINO_ESQUEMA dentro de Snowflake.

## Tabla: VENTAS

### Proposito
Almacena el historico de transacciones registradas en las tiendas fisicas de Cafe Andino (Bogota, Medellin y Cali). Contiene unicamente registros que superaron la validacion de tipos de datos.

### Columnas
| Columna | Tipo de dato | Descripcion |
|---|---|---|
| ID_VENTA | INTEGER | Identificador unico correlativo de la venta fisica |
| FECHA | DATE | Fecha en la que ocurrio la transaccion (formato YYYY-MM-DD) |
| TIENDA | VARCHAR(50) | Nombre de la ciudad o tienda donde se realizo la venta |
| PRODUCTO | VARCHAR(50) | Descripcion del producto vendido |
| CANTIDAD | INTEGER | Cantidad de unidades vendidas |
| PRECIO_UNIT | NUMBER(10, 2) | Precio unitario del producto en pesos colombianos |

### Notas de carga
- Origen: Archivo `ventas_1.csv` cargado a traves del stage interno `VENTAS_STAGE`.
- Regla de calidad: Las filas con errores de casteo (ejemplo: valor no numerico en cantidad) son omitidas mediante `ON_ERROR = CONTINUE` para revision posterior.

---

## Tabla: PEDIDOS_RAW

### Proposito
Tabla de almacenamiento en bruto (capa Raw) para los pedidos generados en la tienda online. Almacena el documento JSON completo junto con metadatos de auditoria del archivo y momento de ingesta.

### Columnas
| Columna | Tipo de dato | Descripcion |
|---|---|---|
| DATOS | VARIANT | Documento JSON original del pedido con la estructura completa |
| NOMBRE_ARCHIVO | VARCHAR(255) | Nombre del archivo de origen en el stage (METADATA$FILENAME) |
| FECHA_CARGA | TIMESTAMP_NTZ | Fecha y hora en la que el registro ingreso a la tabla |

### Notas de carga
- Origen inicial: Archivo `pedidos_1.json` mediante comando directo `COPY INTO` desde `PEDIDOS_STAGE`.
- Origen continuo: Archivo `pedidos_2.json` mediante la canalizacion `PEDIDOS_PIPE` desde `PEDIDOS_PIPE_STAGE`.

---

## Vista: PEDIDOS_DETALLE

### Proposito
Vista relacional que descompone los arreglos anidados de articulos (`items`) contenidos en la columna semiestructurada `DATOS` de `PEDIDOS_RAW`, facilitando consultas analiticas directas por producto, pedido y ciudad.

### Columnas
| Columna | Tipo de dato | Descripcion |
|---|---|---|
| PEDIDO_ID | INTEGER | Numero identificador del pedido online |
| CIUDAD | VARCHAR(50) | Ciudad de entrega del pedido del cliente |
| PRODUCTO | VARCHAR(50) | Nombre del producto comprado |
| CANTIDAD | INTEGER | Numero de unidades adquiridas de ese producto |

### Metodo de transformacion
- Utiliza la funcion `LATERAL FLATTEN(input => DATOS:items)` para generar una fila independiente por cada elemento del arreglo de productos.
- Mantiene sincronizacion automatica con cualquier nuevo registro que ingrese a `PEDIDOS_RAW`.
