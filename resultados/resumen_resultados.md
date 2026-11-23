# Resumen de resultados para gerencia - Café Andino

## Propósito del informe
Presentar a la gerencia el balance consolidado de las ventas en tiendas físicas y el comportamiento del canal de pedidos online.

> [!NOTE]
> Estado actual de las cifras: **Pendiente de verificar**. Los valores presentados corresponden a los cálculos manuales de control realizados sobre los datos fuente (`ventas_1.csv`, `pedidos_1.json` y `pedidos_2.json`). Quedarán confirmados definitivamente una vez que el usuario pegue los resultados obtenidos de la ejecución en Snowflake.

---

## 1. Ventas netas por tienda física

### Criterio
Total facturado (`SUM(CANTIDAD * PRECIO_UNIT)`) por cada punto de venta presencial, considerando únicamente las transacciones válidas cargadas en la tabla VENTAS.

### Cifras calculadas a mano (esperadas)
| Posición | Tienda | Venta neta esperada | Estado |
|---|---|---|---|
| 1 | Cali | $80.000 | Pendiente de verificar con Snowflake |
| 2 | Medellín | $74.500 | Pendiente de verificar con Snowflake |
| 3 | Bogotá | $61.500 | Pendiente de verificar con Snowflake |
| **Total** | **Todas las tiendas** | **$216.000** | **Pendiente de verificar con Snowflake** |

### Calidad de datos e incidentes
- Filas procesadas en CSV: 10
- Filas válidas aceptadas en VENTAS: 9
- Filas rechazadas en VENTAS_RECHAZADAS: 1 (Fila id_venta = 7 de Bogotá: contiene el texto 'dos' en cantidad en lugar de un valor entero).

---

## 2. Advertencia sobre la fila rechazada

> [!IMPORTANT]
> Si la fila con `id_venta = 7` (Bogotá, Capuchino, valor 'dos', precio 9000) se corrigiera en el sistema de origen asignándole una cantidad de 2 unidades:
> - Bogotá sumaría $18.000 adicionales (2 * 9000).
> - La venta neta de Bogotá subiría de $61.500 a $79.500.
> - Bogotá pasaría al segundo lugar comercial, superando a Medellín ($74.500).
> - El nuevo ranking quedaría: Cali ($80.000), Bogotá ($79.500) y Medellín ($74.500).
> 
> En consecuencia, el orden del ranking entre Bogotá y Medellín depende de la decisión de saneamiento que tome la gerencia sobre esta transacción.

---

## 3. Producto más pedido online por ciudad

### Criterio
Producto con mayor cantidad agregada solicitada a través de la tienda online (`pedidos_1.json` y `pedidos_2.json`) para cada una de las ciudades atendidas.

### Cifras calculadas a mano (esperadas)
| Ciudad | Producto líder | Cantidad total solicitada | Otros productos pedidos en la ciudad | Estado |
|---|---|---|---|---|
| Bogotá | Capuchino | 5 unidades | Croissant (1 unidad) | Pendiente de verificar con Snowflake |
| Cali | Café americano | 4 unidades | Croissant (2 unidades) | Pendiente de verificar con Snowflake |
| Medellín | Croissant | 4 unidades | Capuchino (1 unidad) | Pendiente de verificar con Snowflake |

### Balance del canal online
- Total de pedidos ingresados: 5 pedidos (101 al 105).
- Total de ítems desagregados: 8 líneas de detalle.
- Registros duplicados detectados: 0.

---

## 4. Plantilla para comparación con Snowflake
Una vez ejecutado el script `scripts/06_consultas.sql` en Snowflake, pegue aquí las salidas para confrontar los valores esperados con los reales:

### Salida esperada de Consulta 1 (Ventas netas)
```text
TIENDA      VENTA_NETA
Cali        80000.00
Medellín    74500.00
Bogotá      61500.00
```
*Salida real de Snowflake:* [Pegar aquí los resultados de Consulta 1]

### Salida esperada de Consulta 2 (Producto online líder)
```text
CIUDAD      PRODUCTO         CANTIDAD_TOTAL
Bogotá      Capuchino        5
Cali        Café americano   4
Medellín    Croissant        4
```
*Salida real de Snowflake:* [Pegar aquí los resultados de Consulta 2]
