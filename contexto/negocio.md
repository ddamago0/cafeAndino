# Contexto de negocio - Café Andino

## Descripción de la empresa
Café Andino es una cadena de cafetería ficticia en Colombia. Cuenta con tres puntos de venta físicos y un canal de comercio electrónico:
- Tienda Bogotá
- Tienda Medellín
- Tienda Cali
- Tienda online

## Canales de venta y formatos de datos
1. Tiendas físicas: Reportan sus ventas diarias en archivos de texto plano con formato CSV (ejemplo: `ventas_1.csv`). Contienen ventas individuales con identificador, fecha, tienda, producto, cantidad vendida y precio unitario.
2. Tienda online: Envía sus transacciones en archivos semiestructurados con formato JSON (ejemplo: `pedidos_1.json` y `pedidos_2.json`). Cada línea representa un pedido con cliente, ciudad de entrega y una lista de productos pedidos con sus cantidades.

## Necesidad de la gerencia
La gerencia requiere una plataforma analítica centralizada en Snowflake para responder dos preguntas de negocio principales:
1. Conocer las ventas netas por tienda física, ordenadas de mayor a menor, considerando únicamente transacciones válidas.
2. Identificar el producto más pedido online en cada ciudad para optimizar el inventario y la logística.
