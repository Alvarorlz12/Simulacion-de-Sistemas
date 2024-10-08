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
echo -e "Generando gráficas...\n"
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
echo -e "Gráficas generadas\n"