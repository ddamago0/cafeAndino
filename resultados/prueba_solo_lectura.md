# Prueba de permisos de solo lectura

## Objetivo
Demostrar que la carpeta datos/ y sus archivos cuentan con permisos de solo lectura, permitiendo consultar los datos de entrada sin riesgo de alteracion accidental o no autorizada.

## Configuracion aplicada
Se aplicaron permisos de solo lectura a la carpeta datos/ y a todos sus archivos mediante el comando:
```bash
chmod -R a-w datos/
```

Estado de permisos:
```text
dr-xr-xr-x datos
-r--r--r-- datos/pedidos_1.json
-r--r--r-- datos/pedidos_2.json
-r--r--r-- datos/ventas_1.csv
```

## Prueba de lectura
Comando ejecutado:
```bash
head -n 5 datos/ventas_1.csv
```

Resultado:
```text
id_venta,fecha,tienda,producto,cantidad,precio_unit
1,2026-11-02,Bogotá,Café americano,3,6500
2,2026-11-02,Bogotá,Croissant,2,8000
3,2026-11-02,Medellín,Café americano,5,6500
4,2026-11-03,Medellín,Capuchino,2,9000
```
Diagnostico: La lectura se realiza de forma exitosa.

## Prueba de escritura
Comandos ejecutados:
```bash
echo "prueba" >> datos/ventas_1.csv
touch datos/nuevo.txt
```

Resultado:
```text
bash: line 1: datos/ventas_1.csv: Permission denied
touch: cannot touch 'datos/nuevo.txt': Permission denied
```
Diagnostico: El sistema operativo bloquea la modificacion y creacion de archivos con "Permission denied".

## Segunda fuente de solo lectura en Snowflake
Como medida adicional en Snowflake, en el script 01_entorno.sql se define el rol CAFE_LECTOR, el cual unicamente recibe privilegios USAGE y SELECT sobre la base de datos, esquema, tablas y vistas.
