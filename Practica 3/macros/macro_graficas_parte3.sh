#! /bin/bash
# EJECUCIÓN
# ./macro_graficas_parte_3.sh nombre_carpeta_de_datos

# Obtener la ruta del script actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cambiar al directorio del script
cd "$SCRIPT_DIR"

# Obtener los parámetros
source params_parte3.txt

# Variables
carpeta=../ejecuciones/$1-parte3
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

# Crear carpetas de imágenes si no existen
if [ ! -d "$carpeta/img" ]; then
    mkdir "$carpeta/img"
fi

# Generar la gráfica de comparativa de sismtemas A y B
fichero_comparacion_a_b="$carpeta/comparacion_a_b.dat"
gnuplot -e "\
    set terminal pngcairo size 800,600 enhanced font 'Arial,14'; \
    set output '$carpeta/img/grafica_comparativa_sistemas_a_b.png'; \
    set title 'Comparativa de sistemas A y B' enhanced font 'Arial,16'; \
    set xlabel 'Número de simulaciones'; \
    set ylabel 'Veces que es mejor A que B'; \
    set style line 1 lt 1 lc rgb 'blue' lw 3 pt 7 ps 1.5; \
    set grid ytics; \
    plot '$fichero_comparacion_a_b' using 1:2 w l ls 1 title '';" >> $errores 2>&1
fichero_comparacion_c_d="$carpeta/comparacion_c_d.dat"
gnuplot -e "\
    set terminal pngcairo size 800,600 enhanced font 'Arial,14'; \
    set output '$carpeta/img/grafica_comparativa_sistemas_c_d.png'; \
    set title 'Comparativa de sistemas C y D' enhanced font 'Arial,16'; \
    set xlabel 'Número de simulaciones'; \
    set ylabel 'Veces que es mejor C que D'; \
    set style line 1 lt 1 lc rgb 'blue' lw 3 pt 7 ps 1.5; \
    set grid ytics; \
    plot '$fichero_comparacion_c_d' using 1:2 w l ls 1 title '';" >> $errores 2>&1
