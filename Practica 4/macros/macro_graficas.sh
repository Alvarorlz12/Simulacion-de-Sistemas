#! /bin/bash
# EJECUCIÓN
# ./macro_graficas.sh nombre_carpeta_de_datos

# Obtener la ruta del script actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cambiar al directorio del script
cd "$SCRIPT_DIR"

# Obtener los parámetros
source params.txt

# Variables
carpeta=../ejecuciones/$1
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

echo -e "Generando gráficas..."

# Gráficas

# Iniciales
eval $INICIAL
x_ini=$x0
y_ini=$y0
datos_iniciales="$carpeta/iniciales.dat"
img_tiempo_ini="$carpeta/img/tiempo_iniciales.png"
img_versus_ini="$carpeta/img/versus_iniciales.png"

echo -e "Generando gráficas iniciales..."

gnuplot -e "\
    set terminal png; \
    set output '$img_tiempo_ini'; \
    set title 'Tiempo vs Poblaciones (x0=$x0 - y0=$y0)'; \
    set xlabel 'Tiempo'; \
    set ylabel 'Población'; \
    set style line 1 lc rgb '#0060ad' lt 1 lw 3 pt 7 ps 1; \
    set style line 2 lc rgb '#dd181f' lt 1 lw 3 pt 5 ps 1; \
    set style line 3 lc rgb '#00ad00' lt 1 lw 2 pt 9 ps 1; \
    set style line 4 lc rgb '#ad00ad' lt 1 lw 2 pt 11 ps 1; \
    plot '$datos_iniciales' using 1:2 title 'Presas RK' with lines linestyle 1, \
         '$datos_iniciales' using 1:3 title 'Depredadores RK' with lines linestyle 2;"
gnuplot -e "\
    set terminal png; \
    set output '$img_versus_ini'; \
    set title 'Presas vs Depredadores (x0=$x0 - y0=$y0)'; \
    set xlabel 'Presas'; \
    set ylabel 'Depredadores'; \
    set style line 1 lc rgb '#0060ad' lt 1 lw 3 pt 7 ps 1; \
    set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1; \
    set style line 3 lc rgb '#00ad00' lt 1 lw 2 pt 9 ps 1; \
    set style line 4 lc rgb '#ad00ad' lt 1 lw 2 pt 11 ps 1; \
    plot '$datos_iniciales' using 2:3 title '' with lines linestyle 1"

# Alejados 1
eval $ALEJADOS_1
x_a1=$x0
y_a1=$y0
datos_alejados_1="$carpeta/alejados_1.dat"
img_tiempo_ale_1="$carpeta/img/tiempo_alejados_1.png"
img_versus_ale_1="$carpeta/img/versus_alejados_1.png"

echo -e "Generando gráficas alejados 1..."

gnuplot -e "\
    set terminal png; \
    set output '$img_tiempo_ale_1'; \
    set title 'Tiempo vs Poblaciones (x0=$x0 - y0=$y0)'; \
    set xlabel 'Tiempo'; \
    set ylabel 'Población'; \
    set style line 1 lc rgb '#0060ad' lt 1 lw 3 pt 7 ps 1; \
    set style line 2 lc rgb '#dd181f' lt 1 lw 3 pt 5 ps 1; \
    plot '$datos_alejados_1' using 1:2 title 'Presas RK' with lines linestyle 1, \
         '$datos_alejados_1' using 1:3 title 'Depredadores RK' with lines linestyle 2;"
gnuplot -e "\
    set terminal png; \
    set output '$img_versus_ale_1'; \
    set title 'Presas vs Depredadores (x0=$x0 - y0=$y0)'; \
    set xlabel 'Presas'; \
    set ylabel 'Depredadores'; \
    set style line 1 lc rgb '#dd181f' lt 1 lw 3 pt 7 ps 1; \
    plot '$datos_alejados_1' using 2:3 title '' with lines linestyle 1"

# Alejados 2
eval $ALEJADOS_2
x_a2=$x0
y_a2=$y0
datos_alejados_2="$carpeta/alejados_2.dat"
img_tiempo_ale_2="$carpeta/img/tiempo_alejados_2.png"
img_versus_ale_2="$carpeta/img/versus_alejados_2.png"

echo -e "Generando gráficas alejados 2..."

gnuplot -e "\
    set terminal png; \
    set output '$img_tiempo_ale_2'; \
    set title 'Tiempo vs Poblaciones (x0=$x0 - y0=$y0)'; \
    set xlabel 'Tiempo'; \
    set ylabel 'Población'; \
    set style line 1 lc rgb '#0060ad' lt 1 lw 3 pt 7 ps 1; \
    set style line 2 lc rgb '#dd181f' lt 1 lw 3 pt 5 ps 1; \
    plot '$datos_alejados_2' using 1:2 title 'Presas RK' with lines linestyle 1, \
         '$datos_alejados_2' using 1:3 title 'Depredadores RK' with lines linestyle 2;"
gnuplot -e "\
    set terminal png; \
    set output '$img_versus_ale_2'; \
    set title 'Presas vs Depredadores (x0=$x0 - y0=$y0)'; \
    set xlabel 'Presas'; \
    set ylabel 'Depredadores'; \
    set style line 1 lc rgb '#00ad00' lt 1 lw 3 pt 7 ps 1; \
    plot '$datos_alejados_2' using 2:3 title '' with lines linestyle 1"

# Alejados 3
eval $ALEJADOS_3
x_a3=$x0
y_a3=$y0
datos_alejados_3="$carpeta/alejados_3.dat"
img_tiempo_ale_3="$carpeta/img/tiempo_alejados_3.png"
img_versus_ale_3="$carpeta/img/versus_alejados_3.png"

echo -e "Generando gráficas alejados 3..."

gnuplot -e "\
    set terminal png; \
    set output '$img_tiempo_ale_3'; \
    set title 'Tiempo vs Poblaciones (x0=$x0 - y0=$y0)'; \
    set xlabel 'Tiempo'; \
    set ylabel 'Población'; \
    set style line 1 lc rgb '#0060ad' lt 1 lw 3 pt 7 ps 1; \
    set style line 2 lc rgb '#dd181f' lt 1 lw 3 pt 5 ps 1; \
    plot '$datos_alejados_3' using 1:2 title 'Presas RK' with lines linestyle 1, \
         '$datos_alejados_3' using 1:3 title 'Depredadores RK' with lines linestyle 2;"
gnuplot -e "\
    set terminal png; \
    set output '$img_versus_ale_3'; \
    set title 'Presas vs Depredadores (x0=$x0 - y0=$y0)'; \
    set xlabel 'Presas'; \
    set ylabel 'Depredadores'; \
    set style line 1 lc rgb '#ad00ad' lt 1 lw 3 pt 7 ps 1; \
    plot '$datos_alejados_3' using 2:3 title '' with lines linestyle 1"

# Comparación entre valores de x0 e y0
img_versus="$carpeta/img/versus.png"

gnuplot -e "\
    set terminal png; \
    set output '$img_versus'; \
    set title 'Presas vs Depredadores'; \
    set xlabel 'Presas'; \
    set ylabel 'Depredadores'; \
    set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1; \
    set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1; \
    set style line 3 lc rgb '#00ad00' lt 1 lw 2 pt 9 ps 1; \
    set style line 4 lc rgb '#ad00ad' lt 1 lw 2 pt 11 ps 1; \
    plot '$datos_iniciales' using 2:3 title 'x=$x_ini, y=$y_ini' with lines linestyle 1,
         '$datos_alejados_1' using 2:3 title 'x=$x_a1, y=$y_a1' with lines linestyle 2,
         '$datos_alejados_2' using 2:3 title 'x=$x_a2, y=$y_a2' with lines linestyle 3,
         '$datos_alejados_3' using 2:3 title 'x=$x_a3, y=$y_a3' with lines linestyle 4;"