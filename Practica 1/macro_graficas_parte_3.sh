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




echo -e "Gráficas generadas\n"