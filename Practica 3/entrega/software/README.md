# PRÁCTICA 3
## Jose Pineda Serrano y Álvaro Ruiz López

El código de la práctica se puede ejecutar mediante las macros (`macros/`) siguientes:

- `macro_parte1.sh <nombre_carpeta_salida>`: ejecuta el código correspondiente para
la parte 1 de la práctica, tomando los parámetros necesarios de `params_parte1.txt` y 
ejecutando al final `macro_graficas_parte1.sh <nombre_carpeta_salida>` para generar
las gráficas necesarias.
- `macro_parte2.sh <nombre_carpeta_salida>`: ejecuta el código correspondiente para
la parte 2 de la práctica, tomando los parámetros necesarios de `params_parte2.txt` y 
ejecutando al final `macro_graficas_parte2.sh <nombre_carpeta_salida>` para generar
las gráficas necesarias.
- `macro_parte3.sh <nombre_carpeta_salida>`: ejecuta el código correspondiente a la parte 3 de la práctica. A su vez ejecuta:

    - `macro_estadisticas_parte3.sh <nombre_carpeta_salida>`: macro para calcular las estadísticas de esta parte (intervalos de confianza sobre diferencia de medias).
    - `macro_comparacion_parte3.sh <nombre_carpeta_salida>`: macro para realizar la comparación entre los k sistemas a comparar. Genera los resultados en `ejecuciones/<nombre_carpeta_salida>/seleccion_mejor_sistema.dat` además de mostrarlos en pantalla.
    - `macro_graficas_parte3.sh <nombre_carpeta_salida>`: genera las gráficas de esta parte.

    Toman los parámetros de `params_parte3.txt`.