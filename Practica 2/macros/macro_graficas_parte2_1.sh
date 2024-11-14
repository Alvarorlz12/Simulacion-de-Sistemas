#! /bin/bash
# EJECUCIÓN
# ./macro_graficas_parte2_1.sh nombre_carpeta_de_datos

# Obtener los parámetros
source params_parte2.txt

# Variables
carpeta=../ejecuciones/$1-generador
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

# Generación de gráficas
echo -e "Generando gráficas de Generadores de Datos Discretos (Capítulo 2.1)...\n"
img_tabla_crec_sec="$carpeta/img/tabla_crec_sec-$1.jpeg"
img_tabla_crec_bin="$carpeta/img/tabla_crec_bin-$1.jpeg"
img_tabla_decr_sec="$carpeta/img/tabla_decr_sec-$1.jpeg"

datos_tabla_crec_sec="$carpeta/freq_tabla_crec_sec.dat"
datos_tabla_crec_bin="$carpeta/freq_tabla_crec_bin.dat"
datos_tabla_decr_sec="$carpeta/freq_tabla_decr_sec.dat"

# Generar gráfica para tabla_crec_sec
if [ -s "$datos_tabla_crec_sec" ]; then
    gnuplot -e "set terminal jpeg; \
                set output '$img_tabla_crec_sec'; \
                set title 'Tabla Creciente | Búsqueda Secuencial'; \
                set xlabel 'Valores'; \
                set ylabel 'Frecuencia Relativa'; \
                set style data histogram; \
                set style fill solid 1.00 border -1; \
                set boxwidth 0.9; \
                set key off; \
                set xrange [1:1000]; \
                unset xtics; \
                set xtics ('1' 1, '1000' 1000) nomirror scale 0; \
                plot '$datos_tabla_crec_sec' using 2 title 'Frecuencia Relativa';" >> $errores 2>&1
else
    echo "El archivo $datos_tabla_crec_sec no existe, está vacío o no tiene suficientes datos."
fi

# Generar gráfica para tabla_crec_bin
if [ -s "$datos_tabla_crec_bin" ]; then
    gnuplot -e "set terminal jpeg; \
                set output '$img_tabla_crec_bin'; \
                set title 'Tabla Creciente | Búsqueda Binaria'; \
                set xlabel 'Valores'; \
                set ylabel 'Frecuencia Relativa'; \
                set style data histogram; \
                set style fill solid 1.00 border -1; \
                set boxwidth 0.9; \
                set key off; \
                set xrange [1:1000]; \
                unset xtics; \
                set xtics ('1' 1, '1000' 1000) nomirror scale 0; \
                plot '$datos_tabla_crec_bin' using 2 title 'Frecuencia Relativa';" >> $errores 2>&1
else
    echo "El archivo $datos_tabla_crec_bin no existe, está vacío o no tiene suficientes datos."
fi

# Generar gráfica para tabla_decr_sec
if [ -s "$datos_tabla_decr_sec" ]; then
    gnuplot -e "set terminal jpeg; \
                set output '$img_tabla_decr_sec'; \
                set title 'Tabla Decreciente | Búsqueda Secuencial'; \
                set xlabel 'Valores'; \
                set ylabel 'Frecuencia Relativa'; \
                set style data histogram; \
                set style fill solid 1.00 border -1; \
                set boxwidth 0.9; \
                set key off; \
                set xrange [1:1000]; \
                unset xtics; \
                set xtics ('1' 1, '1000' 1000) nomirror scale 0; \
                plot '$datos_tabla_decr_sec' using 2 title 'Frecuencia Relativa';" >> $errores 2>&1
else
    echo "El archivo $datos_tabla_decr_sec no existe, está vacío o no tiene suficientes datos."
fi

# Gráfica de tiempo de ejecución en función de número de valores (barras)
img_tiempo_valor_fijo="$carpeta/img/tiempo_valores-$1.jpeg"
datos_tiempo_valores="$carpeta/resultados-$1_tiempo_valores_fijo.dat"

# Transformar el archivo de datos de tiempo de ejecución en función del número de valores
# para que se pueda representar en una gráfica de barras. Se obtendrá la última columna
# de cada fila del archivo de datos y se guardará en un archivo temporal.
temp_datos_tiempo_valores="$carpeta/temp_resultados-$1_tiempo_valores.dat"
awk '{print $4}' "$datos_tiempo_valores" | paste -sd ' ' - > "$temp_datos_tiempo_valores"

if [ -s "$temp_datos_tiempo_valores" ]; then
    gnuplot -e "set terminal jpeg; \
                set output '$img_tiempo_valor_fijo'; \
                set title 'Tiempo de ejecución en función del número de valores'; \
                set ylabel 'Tiempo (ms)'; \
                unset xlabel; \
                set key outside right center; \
                set style data histogram; \
                set style histogram clustered gap 4; \
                set style fill solid 1.00 border -1; \
                set boxwidth 1; \
                unset xtics; \
                set yrange [0:]; \
                plot '$temp_datos_tiempo_valores' using 1 title 'T. Crec. | B. Sec.' linecolor rgb '#1f77b4', \
                     '' using 2 title 'T. Crec. | B. Bin.' linecolor rgb '#ff7f0e', \
                     '' using 3 title 'T. Dec. | B. Sec.' linecolor rgb '#2ca02c';" >> $errores 2>&1
else
    echo "El archivo $temp_datos_tiempo_valores no existe, está vacío o no tiene suficientes datos."
fi

# Eliminar archivos temporales
rm "$temp_datos_tiempo_valores"

# Gráfica de tiempo de ejecución en función del número de valores generados (líneas)
img_tiempo_valores="$carpeta/img/tiempos_en_funcion_valores-$1.jpeg"
datos_tiempos_cs="$carpeta/resultados-$1_tiempo_valores_cs.dat"
datos_tiempos_cb="$carpeta/resultados-$1_tiempo_valores_cb.dat"
datos_tiempos_ds="$carpeta/resultados-$1_tiempo_valores_ds.dat"

# Generar gráfica de tiempo de ejecución en función del tamaño de la tabla
if [ -s "$datos_tiempos_cs" ] && [ -s "$datos_tiempos_cb" ] && [ -s "$datos_tiempos_ds" ]; then
    gnuplot -e "reset; \
                set terminal jpeg; \
                set output '$img_tiempo_valores'; \
                set title 'Tiempo de ejecución en función del número de valores' font 'Arial, 16'; \
                set xlabel 'Número de valores aleatorios generados'; \
                set ylabel 'Tiempo (s)'; \
                set key left top; \
                set style data lines; \
                set xtics ('100000' 100000, '1000000' 1000000) nomirror; \
                set ytics nomirror; \
                set style line 1 lc rgb '#1f77b4' lt 1 lw 2; \
                set style line 2 lc rgb '#d62728' lt 1 lw 2; \
                set style line 3 lc rgb '#2ca02c' lt 1 lw 2; \
                plot '$datos_tiempos_cs' using 3:4 title 'T. Crec. | B. Sec.' ls 1, \
                     '$datos_tiempos_cb' using 3:4 title 'T. Crec. | B. Bin.' ls 2, \
                     '$datos_tiempos_ds' using 3:4 title 'T. Dec. | B. Sec.' ls 3;" >> $errores 2>&1
else
    echo "Uno o más archivos de datos de tiempo de ejecución no existen, están vacíos o no tienen suficientes datos."
fi

# Gráfica de tiempo de ejecución en función del tamaño de la tabla
img_tiempo_tabla="$carpeta/img/tiempo_tabla-$1.jpeg"
datos_tiempo_tabla_crec_sec="$carpeta/tiempos_tabla_crec_sec.dat"
datos_tiempo_tabla_crec_bin="$carpeta/tiempos_tabla_crec_bin.dat"
datos_tiempo_tabla_decr_sec="$carpeta/tiempos_tabla_decr_sec.dat"

# Generar gráfica de tiempo de ejecución en función del tamaño de la tabla
if [ -s "$datos_tiempo_tabla_crec_sec" ] && [ -s "$datos_tiempo_tabla_crec_bin" ] && [ -s "$datos_tiempo_tabla_decr_sec" ]; then
    gnuplot -e "set terminal jpeg; \
                set output '$img_tiempo_tabla'; \
                set title 'Tiempo de ejecución en función del tamaño de la tabla'; \
                set xlabel 'Tamaño de la tabla'; \
                set ylabel 'Tiempo (s)'; \
                set key outside right top; \
                set style data linespoints; \
                set xtics rotate by -45; \
                set style line 1 lc rgb '#1f77b4' lt 1 lw 2 pt 7 ps 1; \
                set style line 2 lc rgb '#d62728' lt 1 lw 2 pt 5 ps 1; \
                set style line 3 lc rgb '#2ca02c' lt 1 lw 2 pt 9 ps 1; \
                plot '$datos_tiempo_tabla_crec_sec' using 2:4 title 'T. Crec. | B. Sec.' ls 1, \
                     '$datos_tiempo_tabla_crec_bin' using 2:4 title 'T. Crec. | B. Bin.' ls 2, \
                     '$datos_tiempo_tabla_decr_sec' using 2:4 title 'T. Dec. | B. Sec.' ls 3;" >> $errores 2>&1
else
    echo "Uno o más archivos de datos de tiempo de ejecución no existen, están vacíos o no tienen suficientes datos."
fi

echo -e "Gráficas de Generadores de Datos Discretos generadas (Capítulo 2.1)\n"