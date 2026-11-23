# Prueba de permisos de solo lectura

Este documento describe los dos mecanismos de solo lectura implementados para garantizar la integridad y confidencialidad de la información en el proyecto Café Andino: el sistema de archivos local y el control de accesos en Snowflake.

---

## Mecanismo 1: Permisos del sistema de archivos local (Probado)

### Estado
**Probado y verificado localmente por el agente.**

### Configuración aplicada
Se aplicaron permisos de solo lectura recursivos sobre la carpeta `datos/` y todos sus archivos:
```bash
chmod -R a-w datos/
```

Inspección de permisos en el sistema operativo:
```text
dr-xr-xr-x 1 dmgx dmgx  80 datos
-r--r--r-- 1 dmgx dmgx 476 datos/pedidos_1.json
-r--r--r-- 1 dmgx dmgx 303 datos/pedidos_2.json
-r--r--r-- 1 dmgx dmgx 456 datos/ventas_1.csv
```

### Prueba de lectura
Comando ejecutado:
```bash
head -n 5 datos/ventas_1.csv
```

Salida real obtenida:
```text
id_venta,fecha,tienda,producto,cantidad,precio_unit
1,2026-11-02,Bogotá,Café americano,3,6500
2,2026-11-02,Bogotá,Croissant,2,8000
3,2026-11-02,Medellín,Café americano,5,6500
4,2026-11-03,Medellín,Capuchino,2,9000
```
Diagnóstico: La lectura de datos se realiza con normalidad.

### Prueba de escritura
Comandos ejecutados:
```bash
echo "prueba" >> datos/ventas_1.csv
touch datos/nuevo.txt
```

Salida real obtenida:
```text
bash: line 1: datos/ventas_1.csv: Permission denied
touch: cannot touch 'datos/nuevo.txt': Permission denied
```
Diagnóstico: El sistema operativo bloquea de forma estricta cualquier intento de modificación o adición de archivos con el error `Permission denied`.

---

## Mecanismo 2: Rol de solo lectura en Snowflake (Por ejecutar en la nube)

### Estado
**Diseñado en scripts SQL; pendiente de ejecución y validación por el usuario en Snowflake.**

### Configuración diseñada
1. En `scripts/01_entorno.sql`, el rol `ACCOUNTADMIN` crea el rol `CAFE_LECTOR`:
   - Concede permisos `USAGE` sobre el warehouse `CAFE_ANDINO_WH`, base de datos `CAFE_ANDINO_DB` y esquema `CAFE_ANDINO_ESQUEMA`.
   - Concede permisos `SELECT` exclusivos sobre todas las tablas y vistas actuales y futuras del esquema.
   - Concede el rol al perfil administrador: `GRANT ROLE CAFE_LECTOR TO ROLE SYSADMIN;`.
   - Deja disponible la asignación al usuario ejecutor: `-- GRANT ROLE CAFE_LECTOR TO USER <TU_USUARIO>;`.

2. En `scripts/07_prueba_lector.sql`, se valida el comportamiento del rol:
   - Ejecuta `USE ROLE CAFE_LECTOR;`.
   - Realiza consultas `SELECT` sobre `VENTAS` y `PEDIDOS_DETALLE` (deben ejecutarse con éxito).
   - Intenta ejecutar una sentencia `INSERT INTO VENTAS` (debe fallar con error de compilación por falta de privilegios `INSERT`).
   - Restablece el contexto con `USE ROLE SYSADMIN;`.

### Instrucción para el usuario
El usuario debe ejecutar el script `scripts/07_prueba_lector.sql` en su consola de Snowflake y registrar el resultado en `resultados/lista_verificacion.md` confirmando que las consultas de lectura funcionaron y que la inserción fue bloqueada.
