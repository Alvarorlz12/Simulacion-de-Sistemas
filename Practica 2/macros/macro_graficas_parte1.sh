#! /bin/bash
# EJECUCIÓN
# ./macro_graficas_parte_1.sh nombre_carpeta_de_datos

# Obtener los parámetros
source params_parte1.txt

# Variables
carpeta=../ejecuciones/$1-estampadora
sabiendo_estado="$carpeta/sabiendo_estado"
sin_saber_estado="$carpeta/sin_saber_estado"
errores="$carpeta/errores-$1.txt"

# Comprobar que existe la carpeta
if [ ! -d "$carpeta" ]; then
    echo -e "No existe la carpeta $carpeta"
    exit 1
fi

# Comprobar que existen las carpetas de datos
if [ ! -d "$sabiendo_estado" ] || [ ! -d "$sin_saber_estado" ]; then
    echo -e "No existen las carpetas de datos $sabiendo_estado o $sin_saber_estado"
    exit 1
fi

# Eliminar archivos antiguos si existen (imagenes)
if [ -d "$sabiendo_estado/img" ]; then
    rm -r "$sabiendo_estado/img"
    mkdir "$sabiendo_estado/img"
fi
if [ -d "$sin_saber_estado/img" ]; then
    rm -r "$sin_saber_estado/img"
    mkdir "$sin_saber_estado/img"
fi

# Crear carpetas de imágenes si no existen
if [ ! -d "$sabiendo_estado/img" ]; then
    mkdir "$sabiendo_estado/img"
fi
if [ ! -d "$sin_saber_estado/img" ]; then
    mkdir "$sin_saber_estado/img"
fi

# Generación de gráficas
echo -e "Generando gráficas...\n"
counter=0
for r in "${REGLAS_ESTADO[@]}"; do
    counter=$((counter + 1))
    img_coste="$sabiendo_estado/img/coste_sim-$1_regla$counter.jpeg"
    img_med_est="$sabiendo_estado/img/media_estampaciones-$1_regla$counter.jpeg"
    img_freq_est="$sabiendo_estado/img/frecuencia_estados-$1_regla$counter.jpeg"

    datos="$sabiendo_estado/resultados-$1_regla$counter.dat"
    # El archivo de datos tiene la siguiente estructura:
    # Líneas hasta la penúltima: iteración, coste, media estampaciones, num. mantenimientos
    # Penúltima línea: medias de coste, estampaciones y mantenimientos
    # Última línea: frecuencia de estados
    # Extraer los datos siguiendo la estructura anterior:
    # Almacenar los datos en un archivo temporal (todo menos las últimas dos líneas)
    head -n -2 $datos > "$sabiendo_estado/datos.dat"
    # Extraer las medias de coste, estampaciones y mantenimientos
    medias=$(tail -n 2 $datos | head -n 1)
    echo $medias > "$sabiendo_estado/medias.dat"
    # Extraer la frecuencia de estados
    estados=$(tail -n 1 $datos)
    # Transformar las frecuencias de estados a formato de 5 filas y 2 columnas
    echo "$estados" | awk '{for(i=1; i<=NF; i++) print i, $i}' > "$sabiendo_estado/estados.dat"

    # Gráfica de iteración vs. coste
    echo -e "\t- Gráfica de iteración vs. coste (regla $counter)"
    media_coste=$(awk '{print $2}' $sabiendo_estado/medias.dat)
    gnuplot -e "set term jpeg; \
                set title 'Coste medio por estampación con regla $counter' font 'arial,16' enhanced; \
                set key on; \
                set key box lt 1 lw 1 lc rgb 'black'; \
                set key opaque; \
                set xrange [0:]; \
                set xlabel 'Iteración' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [:]; \
                set ylabel 'Coste medio (€)' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set label 1 'Media del coste: $media_coste' at graph 0.02, graph 0.95; \
                set output '$img_coste'; \
                plot '$sabiendo_estado/datos.dat' using 1:2 w lp lc 1 pt 7 ps 1 lw 1 t 'Coste', \
                     $media_coste with lines lc rgb 'red' lw 2 dt 2 t 'Media del coste'; \
                " >> $errores 2>&1

    # Gráfica de iteración vs. media estampaciones
    echo -e "\t- Gráfica de iteración vs. media estampaciones (regla $counter)"
    media_estampaciones=$(awk '{print $3}' $sabiendo_estado/medias.dat)
    gnuplot -e "set term jpeg; \
                set key off; \
                set xrange [0:]; \
                set xlabel 'Iteración' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [:]; \
                set ylabel 'Media de estampaciones' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set output '$img_med_est'; \
                plot '$sabiendo_estado/datos.dat' using 1:3 w lp lc 1 pt 7 ps 1 lw 1 t 'Media estampaciones', \
                     $media_estampaciones w l lc rgb 'red' lw 2 t 'Media'; \
                " >> $errores 2>&1
            
    # Gráfica de frecuencia de estados (gráfica de barras)
    echo -e "\t- Gráfica de frecuencia de estados (regla $counter)"
    gnuplot -e "set term jpeg; \
                set style data histogram; \
                set auto x; \
                set title 'Frecuencia de estados con regla $counter' font 'arial,14' enhanced; \
                set style histogram cluster gap 1; \
                set style fill solid border -1; \
                set boxwidth 0.9; \
                set yrange [0:1]; \
                set ylabel 'Frecuencia' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set xlabel 'Estados' font 'arial,14' enhanced; \
                set output '$img_freq_est'; \
                plot '$sabiendo_estado/estados.dat' using 2:xtic(1) title ''; \
                " >> $errores 2>&1
done
# Eliminar archivos temporales
rm $sabiendo_estado/datos.dat $sabiendo_estado/medias.dat $sabiendo_estado/estados.dat

# Gráficas sin saber el estado
counter=0
for r in "${REGLAS_ESTAMP[@]}"; do
    counter=$((counter + 1))
    img_coste="$sin_saber_estado/img/coste_sim-$1_regla$counter.jpeg"
    img_med_est="$sin_saber_estado/img/media_estampaciones-$1_regla$counter.jpeg"
    img_freq_est="$sin_saber_estado/img/frecuencia_estados-$1_regla$counter.jpeg"

    datos="$sin_saber_estado/resultados-$1_regla$counter.dat"
    # El archivo de datos tiene la siguiente estructura:
    # Líneas hasta la penúltima: iteración, coste, media estampaciones, num. mantenimientos
    # Penúltima línea: medias de coste, estampaciones y mantenimientos
    # Última línea: frecuencia de estados
    # Extraer los datos siguiendo la estructura anterior:
    # Almacenar los datos en un archivo temporal (todo menos las últimas dos líneas)
    head -n -2 $datos > "$sin_saber_estado/datos.dat"
    # Extraer las medias de coste, estampaciones y mantenimientos
    medias=$(tail -n 2 $datos | head -n 1)
    echo $medias > "$sin_saber_estado/medias.dat"
    # Extraer la frecuencia de estados
    estados=$(tail -n 1 $datos)
    # Transformar las frecuencias de estados a formato de 5 filas y 2 columnas
    echo "$estados" | awk '{for(i=1; i<=NF; i++) print i, $i}' > "$sin_saber_estado/estados.dat"

    # Gráfica de iteración vs. coste
    echo -e "\t- Gráfica de iteración vs. coste (regla $counter)"
    media_coste=$(awk '{print $2}' $sin_saber_estado/medias.dat)
    gnuplot -e "set term jpeg; \
                set title 'Coste medio por estampación con regla $counter' font 'arial,16' enhanced; \
                set key on; \
                set key box lt 1 lw 1 lc rgb 'black'; \
                set key opaque; \
                set xrange [0:]; \
                set xlabel 'Iteración' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [:]; \
                set ylabel 'Coste medio (€)' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set label 1 'Media del coste: $media_coste' at graph 0.02, graph 0.95; \
                set output '$img_coste'; \
                plot '$sin_saber_estado/datos.dat' using 1:2 w lp lc 1 pt 7 ps 1 lw 1 t 'Coste', \
                     $media_coste with lines lc rgb 'red' lw 2 dt 2 t 'Media del coste'; \
                " >> $errores 2>&1

    # Gráfica de iteración vs. media estampaciones
    echo -e "\t- Gráfica de iteración vs. media estampaciones (regla $counter)"
    media_estampaciones=$(awk '{print $3}' $sin_saber_estado/medias.dat)
    gnuplot -e "set term jpeg; \
                set key off; \
                set xrange [0:]; \
                set xlabel 'Iteración' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [:]; \
                set ylabel 'Media de estampaciones' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set output '$img_med_est'; \
                plot '$sin_saber_estado/datos.dat' using 1:3 w lp lc 1 pt 7 ps 1 lw 1 t 'Media estampaciones', \
                     $media_estampaciones w l lc rgb 'red' lw 2 t 'Media'; \
                " >> $errores 2>&1
            
    # Gráfica de frecuencia de estados (gráfica de barras)
    echo -e "\t- Gráfica de frecuencia de estados (regla $counter)"
    gnuplot -e "set term jpeg; \
                set style data histogram; \
                set auto x; \
                set title 'Frecuencia de estados con regla $counter' font 'arial,14' enhanced; \
                set style histogram cluster gap 1; \
                set style fill solid border -1; \
                set boxwidth 0.9; \
                set yrange [0:1]; \
                set ylabel 'Frecuencia' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set xlabel 'Estados' font 'arial,14' enhanced; \
                set output '$img_freq_est'; \
                plot '$sin_saber_estado/estados.dat' using 2:xtic(1) title ''; \
                " >> $errores 2>&1
done
# Eliminar archivos temporales
rm $sin_saber_estado/datos.dat $sin_saber_estado/medias.dat $sin_saber_estado/estados.dat

# Generar gráfica de media de coste en función del número de estampaciones que se
# realizan hasta llevar a cabo un mantenimiento
echo -e "Generando gráfica de media de coste en función del número de estampaciones..."
img_coste_estampaciones="$sin_saber_estado/img/coste_segun_estampaciones_para_mantener-$1.png"
datos_coste_estampaciones="$sin_saber_estado/resultados-$1_iterando_nest.dat"

# Generar gráfica de media de coste en función del número de estampaciones
min_coste=$(awk 'NR==1 || $2 < min {min=$2; x=$1} END {print x, min}' $datos_coste_estampaciones)
min_x=$(echo $min_coste | awk '{print $1}')
min_y=$(echo $min_coste | awk '{print $2}')

gnuplot -e "set term pngcairo dashed; \
            set title 'Coste medio en función del nº de estampaciones para mantenimiento' font 'arial,14' enhanced; \
            set key on; \
            set key box lt 1 lw 1 lc rgb 'black'; \
            set key opaque; \
            set xrange [0:]; \
            set xlabel 'Número de estampaciones' font 'arial,14' enhanced; \
            set xtics font 'arial,9' nomirror; \
            set yrange [:]; \
            set ylabel 'Coste medio (€)' font 'arial,14' enhanced; \
            set ytics font 'arial,9' nomirror; \
            set output '$img_coste_estampaciones'; \
            set arrow from $min_x,graph 0.28 to $min_x,($min_y+0.1) head lw 2 lc rgb 'red'; \
            set label 1 'Mínimo: ($min_x, $min_y)' at ($min_x+1.2),graph 0.32 center; \
            plot '$datos_coste_estampaciones' using 1:2 w lp lc rgb 'magenta' pt 7 ps 1 lw 2 dt '-' t 'Coste medio'; \
            " >> $errores 2>&1

echo -e "Gráficas generadas\n"



