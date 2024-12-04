#! /bin/bash
# EJECUCIÓN
# ./macro_graficas_parte_2.sh nombre_carpeta_de_datos

# Obtener la ruta del script actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cambiar al directorio del script
cd "$SCRIPT_DIR"

# Obtener los parámetros
source params_parte2.txt

# Variables
carpeta=../ejecuciones/$1-parte2
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

# Generar la gráfica de búsqueda de número de simulaciones necesarias
fichero_config1="$carpeta/config1.dat"
fichero_config2="$carpeta/config2.dat"
fichero_config3="$carpeta/config3.dat"
gnuplot -e "reset; \
    set term png; \
    set output '$carpeta/img/busqueda_num_sim.png'; \
    set title 'Búsqueda número simulaciones adecuado' font 'arial,16' enhanced; \
    set xlabel 'Número de simulaciones'; \
    set ylabel 'Número medio de clientes perdidos'; \
    set ytics nomirror; \
    set xtics nomirror; \
    set yrange [0:]; \
    set key out bottom; \
    set style line 1 lt 1 lc rgb 'red' lw 3 pt 7 ps 1.5; \
    set style line 2 lt 1 lc rgb 'blue' lw 3 pt 7 ps 1.5; \
    set style line 3 lt 1 lc rgb 'green' lw 3 pt 7 ps 1.5; \
    plot '$fichero_config1' u 2:3 w l ls 1 t 'Configuración 1', \
    '$fichero_config2' u 2:3 w l ls 2 t 'Configuración 2', \
    '$fichero_config3' u 2:3 w l ls 3 t 'Configuración 3';" >> $errores 2>&1