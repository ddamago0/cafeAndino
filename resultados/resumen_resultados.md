# Resumen de resultados para gerencia - Cafe Andino

## Proposito del informe
Presentar a la gerencia el balance consolidado de las ventas en tiendas fisicas y el comportamiento del canal de pedidos online.

> [!NOTE]
> Estado actual de las cifras: **Pendiente de verificar**. Los valores presentados corresponden a los calculos manuales de control realizados sobre los datos fuente (`ventas_1.csv`, `pedidos_1.json` y `pedidos_2.json`). Quedaran confirmados definitivamente una vez que el usuario pegue los resultados obtenidos de la ejecucion en Snowflake.

---

## 1. Ventas netas por tienda fisica

### Criterio
Total facturado (`SUM(CANTIDAD * PRECIO_UNIT)`) por cada punto de venta presencial, considerando unicamente las transacciones validas cargadas en la tabla VENTAS.

### Cifras calculadas a mano (esperadas)
| Posicion | Tienda | Venta neta esperada | Estado |
|---|---|---|---|
| 1 | Cali | $80.000 | Pendiente de verificar con Snowflake |
| 2 | Medellin | $74.500 | Pendiente de verificar con Snowflake |
| 3 | Bogota | $61.500 | Pendiente de verificar con Snowflake |
| **Total** | **Todas las tiendas** | **$216.000** | **Pendiente de verificar con Snowflake** |

### Calidad de datos e incidentes
- Filas procesadas en CSV: 10
- Filas validas aceptadas: 9
- Filas rechazadas: 1 (Fila id_venta = 7 de Bogota: contiene el texto 'dos' en cantidad en lugar de un valor entero, descartada para proteger la integridad financiera).

---

## 2. Producto mas pedido online por ciudad

### Criterio
Producto con mayor cantidad agregada solicitada a traves de la tienda online (`pedidos_1.json` y `pedidos_2.json`) para cada una de las ciudades atendidas.

### Cifras calculadas a mano (esperadas)
| Ciudad | Producto lider | Cantidad total solicitada | Otros productos pedidos en la ciudad | Estado |
|---|---|---|---|---|
| Bogota | Capuchino | 5 unidades | Croissant (1 unidad) | Pendiente de verificar con Snowflake |
| Cali | Cafe americano | 4 unidades | Croissant (2 unidades) | Pendiente de verificar con Snowflake |
| Medellin | Croissant | 4 unidades | Capuchino (1 unidad) | Pendiente de verificar con Snowflake |

### Balance del canal online
- Total de pedidos ingresados: 5 pedidos (101 al 105).
- Total de items desagregados: 8 lineas de detalle.
- Registros duplicados detectados: 0.

---

## 3. Plantilla para comparacion con Snowflake
Una vez ejecutado el script `05_consultas.sql` en Snowflake, pegue aqui las salidas para confrontar los valores esperados con los reales:

### Salida esperada de Consulta 1 (Ventas netas)
```text
TIENDA      VENTA_NETA
Cali        80000.00
Medellin    74500.00
Bogota      61500.00
```
*Salida real de Snowflake:* [Pegar aqui los resultados de Consulta 1]

### Salida esperada de Consulta 2 (Producto online lider)
```text
CIUDAD      PRODUCTO         CANTIDAD_TOTAL
Bogota      Capuchino        5
Cali        Cafe americano   4
Medellin    Croissant        4
```
*Salida real de Snowflake:* [Pegar aqui los resultados de Consulta 2]
