# Documentación del modelo de datos - Café Andino

Este documento detalla las tablas y vistas implementadas en el esquema CAFE_ANDINO_ESQUEMA dentro de Snowflake.

## Tabla: VENTAS

### Propósito
Almacena el histórico de transacciones registradas en las tiendas físicas de Café Andino (Bogotá, Medellín y Cali). Contiene únicamente registros que superaron la validación de tipos de datos.

### Columnas
| Columna | Tipo de dato | Descripción |
|---|---|---|
| ID_VENTA | INTEGER | Identificador único correlativo de la venta física |
| FECHA | DATE | Fecha en la que ocurrió la transacción (formato YYYY-MM-DD) |
| TIENDA | VARCHAR(50) | Nombre de la ciudad o tienda donde se realizó la venta |
| PRODUCTO | VARCHAR(50) | Descripción del producto vendido |
| CANTIDAD | INTEGER | Cantidad de unidades vendidas |
| PRECIO_UNIT | NUMBER(10, 2) | Precio unitario del producto en pesos colombianos |

### Notas de carga y calidad
- Creada en `scripts/02_objetos.sql`.
- Origen: Archivo `ventas_1.csv` cargado a través del stage interno `VENTAS_STAGE` mediante `scripts/03_ventas_csv.sql`.
- Regla de calidad: Las filas con errores de tipo (como 'dos' en cantidad) se omiten con `ON_ERROR = CONTINUE`.
- Decisión de diseño: Se cargan las filas válidas y la inválida queda en VENTAS_RECHAZADAS para corregirla en origen.

---

## Tabla: VENTAS_RECHAZADAS

### Propósito
Tabla de auditoría generada automáticamente a partir de la función `TABLE(VALIDATE(VENTAS, JOB_ID => '_last'))` en `scripts/03_ventas_csv.sql`. Registra el detalle técnico de cada fila rechazada durante el comando `COPY INTO`.

### Estructura
Generada con el esquema estándar de la función `VALIDATE` de Snowflake:
| Columna principal | Tipo de dato | Descripción |
|---|---|---|
| ERROR | VARCHAR | Mensaje descriptivo del error de conversión o formato |
| FILE | VARCHAR | Nombre del archivo de origen donde ocurrió el error |
| LINE | INTEGER | Número de línea física del archivo con inconsistencia (línea 8 contando cabecera) |
| CHARACTER | INTEGER | Posición de carácter donde inició el fallo |
| COLUMN_NAME | VARCHAR | Nombre de la columna afectada (CANTIDAD) |
| REJECTED_RECORD | VARCHAR | Contenido textual íntegro de la línea rechazada |

---

## Tabla: PEDIDOS_RAW

### Propósito
Tabla de almacenamiento en bruto (capa Raw) para los pedidos generados en la tienda online. Almacena el documento JSON completo junto con metadatos de auditoría del archivo y momento de ingesta.

### Columnas
| Columna | Tipo de dato | Descripción |
|---|---|---|
| DATOS | VARIANT | Documento JSON original del pedido con la estructura completa |
| NOMBRE_ARCHIVO | VARCHAR(255) | Nombre del archivo de origen en el stage (METADATA$FILENAME) |
| FECHA_CARGA | TIMESTAMP_NTZ | Fecha y hora en la que el registro ingresó a la tabla |

### Notas de carga
- Creada en `scripts/02_objetos.sql`.
- Origen inicial: Archivo `pedidos_1.json` mediante comando directo `COPY INTO` desde `PEDIDOS_STAGE` (`scripts/04_pedidos_json.sql`).
- Origen continuo: Archivo `pedidos_2.json` mediante la canalización `PEDIDOS_PIPE` desde `PEDIDOS_PIPE_STAGE` (`scripts/05_snowpipe.sql`).

---

## Vista: PEDIDOS_DETALLE

### Propósito
Vista relacional que descompone los arreglos anidados de artículos (`items`) contenidos en la columna semiestructurada `DATOS` de `PEDIDOS_RAW`, facilitando consultas analíticas directas por producto, pedido y ciudad.

### Columnas
| Columna | Tipo de dato | Descripción |
|---|---|---|
| PEDIDO_ID | INTEGER | Número identificador del pedido online |
| CIUDAD | VARCHAR(50) | Ciudad de entrega del pedido del cliente |
| PRODUCTO | VARCHAR(50) | Nombre del producto comprado |
| CANTIDAD | INTEGER | Número de unidades adquiridas de ese producto |

### Método de transformación
- Creada en `scripts/04_pedidos_json.sql`.
- Utiliza la función `LATERAL FLATTEN(input => DATOS:items)` para generar una fila independiente por cada elemento del arreglo de productos.
- Mantiene sincronización automática con cualquier nuevo registro que ingrese a `PEDIDOS_RAW` a través de Snowpipe.
