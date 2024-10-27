
# PRÁCTICA 1
#### Autores: José Pineda Serrano y Álvaro Ruiz López

Para esta práctica, se han resuelto cada uno de los tres cápitulos de manera individual. La idea es la misma para todos: un script de *bash* para generar los datos necesarios, otro script para generar las gráficas a partir de los resultados, y un fichero de texto con los parámetros necesarios para las ejecuciones y las gráficas. 

El script de gráficas se ejecuta automáticamente al ejecutar el de datos. Los parámetros son modificables.

## Capítulo 1 - Modelo de MonteCarlo

- **Script general (datos y gráficas):** `./macro_parte_1.sh nombre_carpeta_salida`\
    Genera los datos en la carpeta `nombre_carpeta_salida` y las gráficas en `nombre_carpeta_salida/img`.
- **Script para gráficas únicamente:** `./macro_graficas_parte_1.sh nombre_carpeta_salida`\
    Genera las gráficas en la carpeta `nombre_carpeta_salida/img`. Deben existir los ficheros de datos necesarios en `nombre_carpeta_salida`.
- **Fichero de parámetros:** `params_parte1.txt`. Contiene los parámetros que se usarán en las ejecuciones del programa.

### Capítulo 1 - Lista de parámetros
A continuación se especifican los parámetros utilizados en esta parte:

- `R`. Número de veces que se ejecuta el modelo.
- `PL`. Precio de lanzamiento de moneda.
- `PF`. Premio por ganar.
- `P`. Probabilidad de obtener cara al lanzar la moneda.
- `K`. Número de caras seguidas necesarias para ganar.
- `ITER`. Número de veces a repetir la ejecución.
- `PLS`. Lista de precios de lanzamientos (para comparar en función de precio lanzamiento y premio).
- `PFS`. Lista de premios (para comparar en función de precio lanzamiento y premio).
- `PS`. Lista de probabilidades de obtener cara en los lanzamientos.
- `PS3D`. Lista de probabilidades de obtener cara en los lanzamientos (para la gráfica 3D comparativa de p y k).
- `KS`. Lista de número de veces seguidas que debe salir cara para ganar.
- `RS`. Lista de repeticiones del modelo.
---

## Capítulo 2 - Modelo de Simulación Discreto

> [!WARNING]
> La ejecución de esta parte puede conllevar un tiempo elevado (~15 minutos)

- **Script general (datos y gráficas):** `./macro_parte_2.sh nombre_carpeta_salida`\
    Genera los datos en la carpeta `nombre_carpeta_salida` y las gráficas en `nombre_carpeta_salida/img`.
- **Script para gráficas únicamente:** `./macro_graficas_parte_2.sh nombre_carpeta_salida`\
    Genera las gráficas en la carpeta `nombre_carpeta_salida/img`. Deben existir los ficheros de datos necesarios en `nombre_carpeta_salida`.
- **Fichero de parámetros:** `params_parte2.txt`. Contiene los parámetros que se usarán en las ejecuciones del programa.

### Capítulo 2 - Lista de parámetros
A continuación se especifican los parámetros utilizados en esta parte:

- `M`. Número de experimentos a realizar (repeticiones de la simulación completa).
- `NS`. Lista que contiene el número de simulaciones de las que constará cada experimento (ejecución única de la simulación/programa).
- Para el estudio del número de líneas óptimo:
    - `SIM`. Número de simulaciones a emplear.
    - `REP`. Número de repeticiones/experimentos a realizar.
    - `UMBRAL`. Umbral del porcentaje de llamadas perdidas que debe haber en cada repetición.
    - `FREQ`. Frecuencia de experimentos que no pueden superar el `UMBRAL` de porcentaje de llamadas perdidas.
- `NL`. Número de líneas por defecto. *No es necesario ya que se establece en el propio código del programa*.
- Estudio de efectos de frecuencia de llamadas y duración de llamadas:
    - `TLLAMADAS`. Lista de frecuencias de llamadas a usar para simular una mayor o menor población. 
    - `DURACIONES`. Lista de duraciones (en minutos) a usar para el estudio.
---

## Capítulo 3 - Modelo de Simulación Contínuo

- **Script general (datos y gráficas):** `./macro_parte_3.sh nombre_carpeta_salida`\
    Genera los datos en la carpeta `nombre_carpeta_salida` y las gráficas en `nombre_carpeta_salida/img`.
- **Script para gráficas únicamente:** `./macro_graficas_parte_3.sh nombre_carpeta_salida`\
    Genera las gráficas en la carpeta `nombre_carpeta_salida/img`. Deben existir los ficheros de datos necesarios en `nombre_carpeta_salida`.
- **Fichero de parámetros:** `params_parte3.txt`. Contiene los parámetros que se usarán en las ejecuciones del programa.

### Capítulo 3 - Lista de parámetros
A continuación se especifican los parámetros utilizados en esta parte:

- `DURACION`. Duración de la simulación (en días).
- `P_PEQ`. Lista de número de peces pequeños iniciales en la simulación.
- `P_GRAN`. Lista de número de peces grandes iniciales en la simulación.
- `F_INICIAL`. Voracidad de los peces grandes. Este valor es con el que se comienzan las simulaciones, dado por el guión. Se fija su valor a `5.0`.
- Estudio efectos campaña de pesca sobre peces grandes cuando está en equilibrio:
    - `PP_INI_PESCA`. Población inicial de peces pequeños.
    - `PG_INI_PESCA`. Población inicial de peces grandes.
    - `FECHA_PESCA`. Número de días que deben pasar para que tenga efecto la campaña de pesca.
    - `PESCA_PG_SOLO`. Porcentaje de peces grandes que se pescan en la campaña.
- Estudio de políticas de pesca. A los parámetros siguientes se suman las poblaciones iniciales de peces de las dos especies expuestos arriba.
    - `L_DIAS`. Lista de valores de días entre cada campaña de pesca.
    - `F_MOD`. Voracidad de los peces grandes modificada. Valor fijado a `4.0` tal y como se menciona en el guión.
    - `PORCENTAJE_PESCA`. Lista de porcentajes de pesca que se probarán en las campañas de pesca.