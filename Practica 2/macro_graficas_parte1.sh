#! /bin/bash
# EJECUCIÓN
# ./macro_graficas_parte_1.sh nombre_carpeta_de_datos

# Obtener los parámetros
source params_parte1.txt

# Variables
carpeta=ejecuciones/$1-estampadora
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
counter=0
for r in "${REGLAS_ESTADO[@]}"; do
    counter=$((counter + 1))
    img_coste="$carpeta/img/coste_sim-$1_regla$counter.jpeg"
    img_med_est="$carpeta/img/media_estampaciones-$1_regla$counter.jpeg"
    img_freq_est="$carpeta/img/frecuencia_estados-$1_regla$counter.jpeg"

    datos="$carpeta/resultados-$1_regla$counter.dat"
    # El archivo de datos tiene la siguiente estructura:
    # Líneas hasta la penúltima: iteración, coste, media estampaciones, num. mantenimientos
    # Penúltima línea: medias de coste, estampaciones y mantenimientos
    # Última línea: frecuencia de estados
    # Extraer los datos siguiendo la estructura anterior:
    # Almacenar los datos en un archivo temporal (todo menos las últimas dos líneas)
    head -n -2 $datos > "$carpeta/datos.dat"
    # Extraer las medias de coste, estampaciones y mantenimientos
    medias=$(tail -n 2 $datos | head -n 1)
    echo $medias > "$carpeta/medias.dat"
    # Extraer la frecuencia de estados
    estados=$(tail -n 1 $datos)
    # Transformar las frecuencias de estados a formato de 5 filas y 2 columnas
    echo "$estados" | awk '{for(i=1; i<=NF; i++) print i-1, $i}' > "$carpeta/estados.dat"

    # Gráfica de iteración vs. coste
    echo -e "\t- Gráfica de iteración vs. coste (regla $counter)"
    media_coste=$(awk '{print $2}' $carpeta/medias.dat)
    gnuplot -e "set term jpeg; \
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
                plot '$carpeta/datos.dat' using 1:2 w lp lc 1 pt 7 ps 1 lw 1 t 'Coste', \
                     $media_coste with lines lc rgb 'red' lw 2 dt 2 t 'Media del coste'; \
                " >> $errores 2>&1

    # Gráfica de iteración vs. media estampaciones
    echo -e "\t- Gráfica de iteración vs. media estampaciones (regla $counter)"
    media_estampaciones=$(awk '{print $3}' $carpeta/medias.dat)
    gnuplot -e "set term jpeg; \
                set key off; \
                set xrange [0:]; \
                set xlabel 'Iteración' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [:]; \
                set ylabel 'Media de estampaciones' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set output '$img_med_est'; \
                plot '$carpeta/datos.dat' using 1:3 w lp lc 1 pt 7 ps 1 lw 1 t 'Media estampaciones', \
                     $media_estampaciones w l lc rgb 'red' lw 2 t 'Media'; \
                " >> $errores 2>&1
            
    # Gráfica de frecuencia de estados (gráfica de barras)
    echo -e "\t- Gráfica de frecuencia de estados (regla $counter)"
    gnuplot -e "set term jpeg; \
                set style data histogram; \
                set auto x; \
                set style histogram cluster gap 1; \
                set style fill solid border -1; \
                set boxwidth 0.9; \
                set yrange [0:1]; \
                set ylabel 'Frecuencia' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set xtics ('Estado 0' 0, 'Estado 1' 1, 'Estado 2' 2, 'Estado 3' 3, 'Estado 4' 4) font 'arial,9'; \
                set xlabel 'Estados' font 'arial,14' enhanced; \
                set output '$img_freq_est'; \
                plot '$carpeta/estados.dat' using 2:xtic(1) title ''; \
                " >> $errores 2>&1
done
echo -e "Gráficas generadas\n"

# Eliminar archivos temporales
rm $carpeta/datos.dat $carpeta/medias.dat $carpeta/estados.dat