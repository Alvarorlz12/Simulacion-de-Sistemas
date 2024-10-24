#! /bin/bash
# EJECUCIÓN
# ./macro_graficas_parte_2.sh nombre_carpeta_de_datos

# Obtener los parámetros
source params_parte3.txt

# Variables
carpeta=ejecuciones/$1-lago
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

for pp in ${P_PEQ[@]}; do
    for pg in ${P_GRAN[@]}; do
        img_lago="$carpeta/img/lago-$1_$pp-$pg.jpeg"
        datos_lago="$carpeta/resultados-$1_$pp-$pg.dat"

        echo -e "\t- Gráfica de búsqueda de equilibrio ($pp peces pequeños, $pg peces grandes)"
        gnuplot -e "set term jpeg size 800,600; \
                    set title 'Búsqueda de equilibrio para $pp peces pequeños y $pg peces grandes' font 'arial,14'; \
                    set key outside center bot horizontal font 'arial,12'; \
                    set key box lt rgb 'gray' lw 1; \
                    set xlabel 'Día' font 'arial,14' enhanced; \
                    set xtics font 'arial,9'; \
                    set yrange [0:]; \
                    set ylabel 'Número de peces pequeños' font 'arial,14' enhanced; \
                    set ytics font 'arial,9' nomirror; \
                    set y2tics font 'arial,9'; \
                    set y2range [0:]; \
                    set y2label 'Número de peces grandes' font 'arial,14' enhanced; \
                    set output '$img_lago'; \
                    plot '$datos_lago' using 1:2 axes x1y1 w lp lc 1 pt 7 ps 1 lw 1 t 'Peces pequeños', \
                         '$datos_lago' using 1:3 axes x1y2 w lp lc 2 pt 7 ps 1 lw 1 t 'Peces grandes'; \
                    " >> $errores 2>&1
    done
done

echo -e "\nGráfica de campaña de pesca sobre peces grandes a los $FECHA_PESCA días con F=$F_INICIAL"
for pgs in ${PESCA_PG_SOLO[@]}; do
    img_lago_pesca="$carpeta/img/lago-$1_pesca_${F_INICIAL}_$pgs.jpeg"
    datos_lago_pesca="$carpeta/resultados-$1_pesca_${F_INICIAL}_$pgs.dat"
    porcentaje=$(echo "scale=2; $pgs * 100" | bc -l)

    echo -e "\t- Gráfica de campaña de pesca ($pp peces pequeños, $pg peces grandes, $porcentaje% peces grandes pescados)"
    gnuplot -e "set term jpeg size 800,600; \
                set title 'Campaña de pesca a los $FECHA_PESCA días sobre $porcentaje% de peces grandes' font 'arial,14'; \
                set key outside center bot horizontal font 'arial,12'; \
                set key box lt rgb 'gray' lw 1; \
                set xlabel 'Día' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [0:]; \
                set ylabel 'Número de peces pequeños' font 'arial,14' enhanced; \
                set ytics font 'arial,9' nomirror; \
                set y2tics font 'arial,9'; \
                set y2range [0:]; \
                set y2label 'Número de peces grandes' font 'arial,14' enhanced; \
                set output '$img_lago_pesca'; \
                plot '$datos_lago_pesca' using 1:2 axes x1y1 w lp lc 1 pt 7 ps 1 lw 1 t 'Peces pequeños', \
                        '$datos_lago_pesca' using 1:3 axes x1y2 w lp lc 2 pt 7 ps 1 lw 1 t 'Peces grandes'; \
                " >> $errores 2>&1
done
echo -e "\nGráfica de campaña de pesca sobre peces grandes a los $FECHA_PESCA días con F=$F_MOD"
for pgs in ${PESCA_PG_SOLO[@]}; do
    img_lago_pesca="$carpeta/img/lago-$1_pesca_${F_MOD}_$pgs.jpeg"
    datos_lago_pesca="$carpeta/resultados-$1_pesca_${F_MOD}_$pgs.dat"
    porcentaje=$(echo "scale=2; $pgs * 100" | bc -l)

    echo -e "\t- Gráfica de campaña de pesca ($pp peces pequeños, $pg peces grandes, $porcentaje% peces grandes pescados)"
    gnuplot -e "set term jpeg size 800,600; \
                set title 'Campaña de pesca a los $FECHA_PESCA días sobre $porcentaje% de peces grandes' font 'arial,14'; \
                set key outside center bot horizontal font 'arial,12'; \
                set key box lt rgb 'gray' lw 1; \
                set xlabel 'Día' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [0:]; \
                set ylabel 'Número de peces pequeños' font 'arial,14' enhanced; \
                set ytics font 'arial,9' nomirror; \
                set y2tics font 'arial,9'; \
                set y2range [0:]; \
                set y2label 'Número de peces grandes' font 'arial,14' enhanced; \
                set output '$img_lago_pesca'; \
                plot '$datos_lago_pesca' using 1:2 axes x1y1 w lp lc 1 pt 7 ps 1 lw 1 t 'Peces pequeños', \
                        '$datos_lago_pesca' using 1:3 axes x1y2 w lp lc 2 pt 7 ps 1 lw 1 t 'Peces grandes'; \
                " >> $errores 2>&1
done

echo -e "\nGráfica de política de pesca sobre peces grandes"

img_lago_politica_grandes_f_ini="$carpeta/img/lago-$1_pesca_grandes_f${F_INICIAL}.jpeg"
datos_lago_politica_grandes_f_ini="$carpeta/resultados-$1_pesca_grandes_f${F_INICIAL}.dat"
echo -e "\t- Gráfica de política de pesca (F=$F_INICIAL)"
# Obtener el punto con el valor máximo en la columna 3
max_point=$(awk 'BEGIN {max = -inf} {if ($3 > max) {max = $3; x=$1; y=$2}} END {print x, y, max}' $datos_lago_politica_grandes_f_ini)
# Crear un archivo temporal para el punto máximo
echo $max_point > max_point.dat
# Separar las coordenadas del punto máximo
x_max=$(echo $max_point | awk '{print $1}')
y_max=$(echo $max_point | awk '{print $2}')
z_max=$(echo $max_point | awk '{print $3}')
gnuplot -e "set term pngcairo size 1280,960 enhanced font 'arial,14'; \
            set title 'Política de pesca sobre peces grandes con F=$F_INICIAL' font 'arial,24'; \
            set key off; \
            set xlabel 'Días entre campañas de pesca' font 'arial,14' rotate by 33; \
            set ylabel 'Porcentaje de peces grandes pescados' font 'arial,14' rotate parallel; \
            set zlabel 'Total de capturas' font 'arial,14' rotate parallel offset -1,0; \
            set xrange [0:]; \
            set yrange [0:]; \
            set zrange [0:]; \
            set xtics font 'arial,12' offset -0.5,+0; \
            set ytics font 'arial,12' offset -1.0,-0.25; \
            set ztics font 'arial,12'; \
            set grid xtics ytics ztics; \
            set view 60, 120, 1, 1; \
            set pm3d at s; \
            set palette defined (0 'blue', 50 'yellow', 100 'red'); \
            set hidden3d front; \
            set style line 1 lc rgb 'purple' lw 1.5 pt 7 ps 1.5; \
            set style line 2 lc rgb 'red' lw 3 pt 7 ps 2.5; \
            set style line 3 lc rgb 'black' lw 3 pt 1 ps 3; \
            set label sprintf('Max: días=%.2f, porcentaje=%.2f, capturas=%.2f', $x_max, $y_max, $z_max) at $x_max, $y_max, $z_max front offset char 1,1 tc rgb 'black' font 'arial,14'; \
            set output '$img_lago_politica_grandes_f_ini'; \
            splot '$datos_lago_politica_grandes_f_ini' using 1:2:3 with linespoints ls 1 lw 1 pt 7 ps 1 lc 'grey' title '', '' using 1:2:3 with pm3d, \
                  'max_point.dat' using 1:2:3 with points ls 3 title 'Punto máximo'; \
            " >> $errores 2>&1
# Limpiar el archivo temporal
rm max_point.dat

img_lago_politica_grandes_f_mod="$carpeta/img/lago-$1_pesca_grandes_f${F_MOD}.jpeg"
datos_lago_politica_grandes_f_mod="$carpeta/resultados-$1_pesca_grandes_f${F_MOD}.dat"
echo -e "\t- Gráfica de política de pesca (F=$F_MOD)"
# Obtener el punto con el valor máximo en la columna 3
max_point=$(awk 'BEGIN {max = -inf} {if ($3 > max) {max = $3; x=$1; y=$2}} END {print x, y, max}' $datos_lago_politica_grandes_f_mod)
# Crear un archivo temporal para el punto máximo
echo $max_point > max_point.dat
# Separar las coordenadas del punto máximo
x_max=$(echo $max_point | awk '{print $1}')
y_max=$(echo $max_point | awk '{print $2}')
z_max=$(echo $max_point | awk '{print $3}')
gnuplot -e "set term pngcairo size 1280,960 enhanced font 'arial,14'; \
            set title 'Política de pesca sobre peces grandes con F=$F_MOD' font 'arial,24'; \
            set key off; \
            set xlabel 'Días entre campañas de pesca' font 'arial,14' rotate by 33; \
            set ylabel 'Porcentaje de peces grandes pescados' font 'arial,14' rotate parallel; \
            set zlabel 'Total de capturas' font 'arial,14' rotate parallel offset -1,0; \
            set xrange [0:]; \
            set yrange [0:]; \
            set zrange [0:]; \
            set xtics font 'arial,12' offset -0.5,+0; \
            set ytics font 'arial,12' offset -1.0,-0.25; \
            set ztics font 'arial,12'; \
            set grid xtics ytics ztics; \
            set view 60, 120, 1, 1; \
            set pm3d at s; \
            set palette defined (0 'blue', 50 'yellow', 100 'red'); \
            set hidden3d front; \
            set style line 1 lc rgb 'purple' lw 1.5 pt 7 ps 1.5; \
            set style line 2 lc rgb 'red' lw 3 pt 7 ps 2.5; \
            set style line 3 lc rgb 'black' lw 3 pt 1 ps 3; \
            set label sprintf('Max: días=%.2f, porcentaje=%.2f, capturas=%.2f', $x_max, $y_max, $z_max) at $x_max, $y_max, $z_max front offset char 1,1 tc rgb 'black' font 'arial,14'; \
            set output '$img_lago_politica_grandes_f_mod'; \
            splot '$datos_lago_politica_grandes_f_mod' using 1:2:3 with linespoints ls 1 lw 1 pt 7 ps 1 lc 'grey' title '', '' using 1:2:3 with pm3d, \
                  'max_point.dat' using 1:2:3 with points ls 3 title 'Punto máximo'; \
            " >> $errores 2>&1
# Limpiar el archivo temporal
rm max_point.dat

echo -e "Gráficas de política de pesca sobre peces grandes generadas\n"

echo -e "Gráfica de política de pesca sobre peces grandes que afecta a peces pequeños"
img_lago_politica_ambos_f_ini="$carpeta/img/lago-$1_pesca_ambos_f${F_INICIAL}.jpeg"
datos_lago_politica_ambos_f_ini="$carpeta/resultados-$1_pesca_ambos_f${F_INICIAL}.dat"
echo -e "\t- Gráfica de política de pesca (F=$F_INICIAL)"
# Obtener el punto con el valor máximo en la columna 3
max_point=$(awk 'BEGIN {max = -inf} {if ($3 > max) {max = $3; x=$1; y=$2}} END {print x, y, max}' $datos_lago_politica_ambos_f_ini)
# Crear un archivo temporal para el punto máximo
echo $max_point > max_point.dat
# Separar las coordenadas del punto máximo
x_max=$(echo $max_point | awk '{print $1}')
y_max=$(echo $max_point | awk '{print $2}')
z_max=$(echo $max_point | awk '{print $3}')
gnuplot -e "set term pngcairo size 1280,960 enhanced font 'arial,14'; \
            set title 'Política de pesca sobre peces grandes y pequeños con F=$F_INICIAL' font 'arial,24'; \
            set key off; \
            set xlabel 'Días entre campañas de pesca' font 'arial,14' rotate by 33; \
            set ylabel 'Porcentaje de peces grandes pescados' font 'arial,14' rotate parallel; \
            set zlabel 'Total de capturas' font 'arial,14' rotate parallel offset -1,0; \
            set xrange [0:]; \
            set yrange [0:]; \
            set zrange [0:]; \
            set xtics font 'arial,12' offset -0.5,+0; \
            set ytics font 'arial,12' offset -1.0,-0.25; \
            set ztics font 'arial,12'; \
            set grid xtics ytics ztics; \
            set view 60, 120, 1, 1; \
            set pm3d at s; \
            set palette defined (0 'blue', 50 'yellow', 100 'red'); \
            set hidden3d front; \
            set style line 1 lc rgb 'purple' lw 1.5 pt 7 ps 1.5; \
            set style line 2 lc rgb 'red' lw 3 pt 7 ps 2.5; \
            set style line 3 lc rgb 'black' lw 3 pt 1 ps 3; \
            set label sprintf('Max: días=%.2f, porcentaje=%.2f, capturas=%.2f', $x_max, $y_max, $z_max) at $x_max, $y_max, $z_max front offset char 1,1 tc rgb 'black' font 'arial,14'; \
            set output '$img_lago_politica_ambos_f_ini'; \
            splot '$datos_lago_politica_ambos_f_ini' using 1:2:3 with linespoints ls 1 lw 1 pt 7 ps 1 lc 'grey' title '', '' using 1:2:3 with pm3d, \
                  'max_point.dat' using 1:2:3 with points ls 3 title 'Punto máximo'; \
            " >> $errores 2>&1
# Limpiar el archivo temporal
rm max_point.dat

img_lago_politica_ambos_f_mod="$carpeta/img/lago-$1_pesca_ambos_f${F_MOD}.jpeg"
datos_lago_politica_ambos_f_mod="$carpeta/resultados-$1_pesca_ambos_f${F_MOD}.dat"
echo -e "\t- Gráfica de política de pesca (F=$F_MOD)"
# Obtener el punto con el valor máximo en la columna 3
max_point=$(awk 'BEGIN {max = -inf} {if ($3 > max) {max = $3; x=$1; y=$2}} END {print x, y, max}' $datos_lago_politica_ambos_f_mod)
# Crear un archivo temporal para el punto máximo
echo $max_point > max_point.dat
# Separar las coordenadas del punto máximo
x_max=$(echo $max_point | awk '{print $1}')
y_max=$(echo $max_point | awk '{print $2}')
z_max=$(echo $max_point | awk '{print $3}')
gnuplot -e "set term pngcairo size 1280,960 enhanced font 'arial,14'; \
            set title 'Política de pesca sobre peces grandes y pequeños con F=$F_MOD' font 'arial,24'; \
            set key off; \
            set xlabel 'Días entre campañas de pesca' font 'arial,14' rotate by 33; \
            set ylabel 'Porcentaje de peces grandes pescados' font 'arial,14' rotate parallel; \
            set zlabel 'Total de capturas' font 'arial,14' rotate parallel offset -1,0; \
            set xrange [0:]; \
            set yrange [0:]; \
            set zrange [0:]; \
            set xtics font 'arial,12' offset -0.5,+0; \
            set ytics font 'arial,12' offset -1.0,-0.25; \
            set ztics font 'arial,12'; \
            set grid xtics ytics ztics; \
            set view 60, 120, 1, 1; \
            set pm3d at s; \
            set palette defined (0 'blue', 50 'yellow', 100 'red'); \
            set hidden3d front; \
            set style line 1 lc rgb 'purple' lw 1.5 pt 7 ps 1.5; \
            set style line 2 lc rgb 'red' lw 3 pt 7 ps 2.5; \
            set style line 3 lc rgb 'black' lw 3 pt 1 ps 3; \
            set label sprintf('Max: días=%.2f, porcentaje=%.2f, capturas=%.2f', $x_max, $y_max, $z_max) at $x_max, $y_max, $z_max front offset char 1,1 tc rgb 'black' font 'arial,14'; \
            set output '$img_lago_politica_ambos_f_mod'; \
            splot '$datos_lago_politica_ambos_f_mod' using 1:2:3 with linespoints ls 1 lw 1 pt 7 ps 1 lc 'grey' title '', '' using 1:2:3 with pm3d, \
                  'max_point.dat' using 1:2:3 with points ls 3 title 'Punto máximo'; \
            " >> $errores 2>&1
# Limpiar el archivo temporal
rm max_point.dat

echo -e "Gráfica de política de pesca sobre peces grandes que afecta a peces pequeños generada\n"

echo -e "Gráficas generadas\n"