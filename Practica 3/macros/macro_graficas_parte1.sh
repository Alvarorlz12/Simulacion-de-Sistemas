#! /bin/bash
# EJECUCIÓN
# ./macro_graficas_parte_1.sh nombre_carpeta_de_datos

# Obtener la ruta del script actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cambiar al directorio del script
cd "$SCRIPT_DIR"

# Obtener los parámetros
source params_parte1.txt

# Variables
carpeta=../ejecuciones/$1-parte1
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

# Generar la gráfica de la estimación de clientes en cola (Q) y del porcentaje 
# de tiempo de ocio del servidor (PTO)
base="$carpeta/inc_fijo_"
gnuplot -e "reset; \
    set term png; \
    set output '$carpeta/img/estimacion_q_fijo_vs_variable.png'; \
    set title 'Estimación de Q' font 'arial,16' enhanced; \
    set xlabel 'Iteración'; \
    set ylabel 'Q'; \
    set ytics nomirror; \
    set xtics nomirror; \
    set yrange [0:]; \
    set key out bottom; \
    set style line 1 lt 1 lc rgb 'red' lw 3 pt 7 ps 1.5; \
    set style line 2 lt 1 lc rgb 'blue' lw 3 pt 7 ps 1.5; \
    set style line 3 lt 1 lc rgb 'green' lw 3 pt 7 ps 1.5; \
    set style line 4 lt 1 lc rgb 'orange' lw 3 pt 7 ps 1.5; \
    set style line 5 lt 1 lc rgb 'purple' lw 3 pt 7 ps 1.5; \
    set style line 6 lt 1 lc rgb 'brown' lw 3 pt 7 ps 1.5; \
    set style line 7 lt 1 lc rgb 'pink' lw 3 pt 7 ps 1.5; \
    set style line 8 lt 1 lc rgb 'black' lw 3 pt 7 ps 1.5; \
    plot '$base${NOMBRE_INC[0]}.dat' u 1:2 w l ls 1 t '${NOMBRE_INC[0]}', \
    '$base${NOMBRE_INC[1]}.dat' u 1:2 w l ls 2 t '${NOMBRE_INC[1]}', \
    '$base${NOMBRE_INC[2]}.dat' u 1:2 w l ls 3 t '${NOMBRE_INC[2]}', \
    '$base${NOMBRE_INC[3]}.dat' u 1:2 w l ls 4 t '${NOMBRE_INC[3]}', \
    '$base${NOMBRE_INC[4]}.dat' u 1:2 w l ls 5 t '${NOMBRE_INC[4]}', \
    '$base${NOMBRE_INC[5]}.dat' u 1:2 w l ls 6 t '${NOMBRE_INC[5]}', \
    '$base${NOMBRE_INC[6]}.dat' u 1:2 w l ls 7 t '${NOMBRE_INC[6]}', \
    '$carpeta/inc_variable.dat' u 1:2 w l ls 8 t 'variable';" >> $errores 2>&1
