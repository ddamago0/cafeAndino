# Contexto de negocio - Cafe Andino

## Descripcion de la empresa
Cafe Andino es una cadena de cafeteria ficticia en Colombia. Cuenta con tres puntos de venta fisicos y un canal de comercio electronico:
- Tienda Bogota
- Tienda Medellin
- Tienda Cali
- Tienda online

## Canales de venta y formatos de datos
1. Tiendas fisicas: Reportan sus ventas diarias en archivos de texto plano con formato CSV (ejemplo: `ventas_1.csv`). Contienen ventas individuales con identificador, fecha, tienda, producto, cantidad vendida y precio unitario.
2. Tienda online: Envia sus transacciones en archivos semiestructurados con formato JSON (ejemplo: `pedidos_1.json` y `pedidos_2.json`). Cada linea representa un pedido con cliente, ciudad de entrega y una lista de productos pedidos con sus cantidades.

## Necesidad de la gerencia
La gerencia requiere una plataforma analitica centralizada en Snowflake para responder dos preguntas de negocio principales:
1. Conocer las ventas netas por tienda fisica, ordenadas de mayor a menor, considerando unicamente transacciones validas.
2. Identificar el producto mas pedido online en cada ciudad para optimizar el inventario y la logistica.
