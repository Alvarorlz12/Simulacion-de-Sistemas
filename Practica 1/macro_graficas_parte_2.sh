#! /bin/bash
# EJECUCIÓN
# ./macro_graficas_parte_2.sh nombre_carpeta_de_datos

# Obtener los parámetros
source params_parte2.txt

# Variables
carpeta=ejecuciones/$1-llamadas
errores="$carpeta/errores-$1.txt"

# Comprobar que existe la carpeta
if [ ! -d "$carpeta" ]; then
    echo -e "No existe la carpeta $carpeta"
    exit 1
fi

# Eliminar archivos antiguos si existen (imagenes)
if [ -d "$carpeta/img" ]; then
    rm -r "$carpeta/img"
    mkdir "$carpeta/img"
fi

# Crear carpeta de imagenes si no existe
if [ ! -d "$carpeta/img" ]; then
    mkdir "$carpeta/img"
fi

# Generación de gráficas
echo -e "\nGenerando gráficas...\n"
for n in ${NS[@]}; do
    img_llamadas="$carpeta/img/llamadas-$1_$n.jpeg"
    datos="$carpeta/resultados-$1_$n.dat"

    echo -e "\t- Gráfica de llamadas perdidas (%) ($n simulaciones)"
    gnuplot -e "set term jpeg; \
                set title 'Porcentaje medio de llamadas perdidas para $n simulaciones' font 'arial,14'; \
                set key off; \
                set xrange [0:]; \
                set xlabel 'Iteración' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [2:7]; \
                set ylabel 'Porcentaje medio de llamadas perdidas' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set output '$img_llamadas'; \
                plot '$datos' using 1:2 w lp lc 1 pt 7 ps 1 lw 1 t '' ; \
                " >> $errores 2>&1
done
echo -e "\t- Gráfica usando desviación típica\n"
img_desviacion="$carpeta/img/desviacion-$1.jpeg"
datos_desviacion="$carpeta/resultados-desviacion-$1.dat"
gnuplot -e "set term jpeg; \
            set title 'Desviación típica en función de las simulaciones' font 'arial,14' enhanced; \
            set key off; \
            set xrange [0:]; \
            set xlabel 'Número de simulaciones' font 'arial,14' enhanced; \
            set xtics font 'arial,9'; \
            set yrange [0:]; \
            set ylabel 'Desviación típica' font 'arial,14' enhanced; \
            set ytics font 'arial,9'; \
            set output '$img_desviacion'; \
            plot '$datos_desviacion' using 1:2 w lp lc 1 pt 7 ps 1 lw 1.5 t '' ; \
            " >> $errores 2>&1

# Gráfica de porcentaje de llamadas perdidas 
echo -e "\t- Gráfica de frecuencia de llamadas perdidas por encima de $UMBRAL\n"
img_umbral="$carpeta/img/umbral-$1.jpeg"
datos_umbral="$carpeta/resultados-pruebas-$1.dat"
gnuplot -e "set term jpeg; \
            set title 'Frecuencia de llamadas perdidas por encima de $UMBRAL%' font 'arial,14' enhanced; \
            set key off; \
            set xrange [:]; \
            set xlabel 'Número de líneas' font 'arial,14' enhanced; \
            set xtics font 'arial,9'; \
            set yrange [0:]; \
            set ylabel 'Frecuencia (%)' font 'arial,14' enhanced; \
            set ytics font 'arial,9'; \
            set output '$img_umbral'; \
            plot '$datos_umbral' using 1:2 w lp lc 1 pt 7 ps 1 lw 1.5 t '' ; \
            " >> $errores 2>&1

# Gráfica de porcentaje de llamadas perdidas en función de la duración de las llamadas
# y de la frecuencia de las mismas
echo -e "\t- Gráfica de porcentaje de llamadas perdidas en función de la duración de las llamadas y de la frecuencia de las mismas\n"
img_var_d_t="$carpeta/img/variable-duracion-tiempo-$1.jpeg"
datos_var_d_t="$carpeta/resultados-estudio-d-f-$1.dat"
gnuplot -e "set term pngcairo size 1280,960 enhanced font 'arial,14'; \
            set title 'Porcentaje de llamadas perdidas en función de la duración y frecuencia' font 'arial,24'; \
            set key off; \
            set xlabel 'Duración de las llamadas (min)' font 'arial,14' rotate by 33; \
            set ylabel 'Frecuencia de las llamadas (s)' font 'arial,14' rotate parallel; \
            set zlabel 'Porcentaje de llamadas perdidas (%)' font 'arial,14' rotate parallel; \
            set xrange [2:6]; \
            set yrange [1:12]; \
            set zrange [0:100]; \
            set xtics font 'arial,12' offset -0.5,+0; \
            set ytics font 'arial,12' offset -1.0,-0.25; \
            set ztics font 'arial,12'; \
            set grid xtics ytics ztics; \
            set view 60, 120, 1, 1; \
            set pm3d at s; \
            set palette defined (0 'blue', 50 'yellow', 100 'red'); \
            set hidden3d front; \
            set style line 1 lc rgb 'purple' lw 1.5 pt 7 ps 1.5; \
            set output '$img_var_d_t'; \
            splot '$datos_var_d_t' using 1:2:3 with linespoints ls 1 lw 1 pt 7 ps 1 lc 'grey' title '', '' using 1:2:3 with pm3d; \
            " >> $errores 2>&1

echo -e "Gráficas generadas\n"