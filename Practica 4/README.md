# PRÁCTICA 4
## Jose Pineda Serrano y Álvaro Ruiz López

El código de la práctica se puede ejecutar mediante la macro (en `macros/`) siguiente:

- `macro.sh <nombre_carpeta_salida>`: ejecuta el código correspondiente para
la práctica, generando los datos de todas las ejecuciones en la carpeta `ejecuciones/<nombre_carpeta_salida>`. A su vez ejecuta la siguiente macro (que se encarga de generar las gráficas):

    - `macro_graficas.sh <nombre_carpeta_salida>`: genera las gráficas de la práctica, tanto de evolución de las poblaciones a lo largo de la simulación (`tiempo*.png`) como de las comparativas entre
    presas y depredadores (`versus*.png`) y entre el método de Euler y el de Runge-Kutta (`comparacion*.png`), en la carpeta `ejecuciones/<nombre_carpeta_salida>/img`.

    Toman los parámetros de `params.txt`, donde se encuentran especificados los parámetros de cada ejecución (valores poblacionales iniciales, a_ij, parámetros de comparativas...).