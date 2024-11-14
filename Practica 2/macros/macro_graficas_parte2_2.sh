#! /bin/bash
# EJECUCION
# ./macro_graficas_parte2_2.sh nombre_carpeta_de_datos

# Obtener los parámetros
source params_parte2.txt

# Variables
carpeta=../ejecuciones/$1-generador_continuo
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

# Macro para comprobar generaciones
datos_inversion="$carpeta/resultados-$1_gen_cont_inv.dat"
datos_rechazo="$carpeta/resultados-$1_gen_cont_rechazo.dat"
datos_composicion="$carpeta/resultados-$1_gen_cont_composicion.dat"
img_inversion="$carpeta/img/inversion.png"
img_rechazo="$carpeta/img/rechazo.png"
img_composicion="$carpeta/img/composicion.png"

echo -e "Generando gráficas de Generadores de Datos Continuos (Capítulo 2.2)...\n"

gnuplot -e "reset; \
    n=10; \
    a=$A; \
    max=1.0; \
    min=0.0; \
    width=(max-min)/n; \
    hist(x,width)=width*floor(x/width)+width/2.0; \
    set term png; \
    set output '$img_inversion'; \
    set xrange [min:max]; \
    set yrange [0:]; \
    set xtics min,(max-min)/10,max; \
    set boxwidth width*0.9; \
    set style fill solid 0.5; \
    set tics out nomirror; \
    set xlabel 'valores del generador'; \
    set ylabel 'Frecuencias normalizadas'; \
    f(x)= a+2*(1-a)*x; \
    plot '$datos_inversion' u (hist(\$1,width)):(1.0) smooth fnormal w boxes lc rgb'grey' notitle, \
    f(x)*width lc rgb'black' notitle"

gnuplot -e "reset; \
    n=10; \
    a=$A; \
    max=1.0; \
    min=0.0; \
    width=(max-min)/n; \
    hist(x,width)=width*floor(x/width)+width/2.0; \
    set term png; \
    set output '$img_rechazo'; \
    set xrange [min:max]; \
    set yrange [0:]; \
    set xtics min,(max-min)/10,max; \
    set boxwidth width*0.9; \
    set style fill solid 0.5; \
    set tics out nomirror; \
    set xlabel 'valores del generador'; \
    set ylabel 'Frecuencias normalizadas'; \
    f(x)= a+2*(1-a)*x; \
    plot '$datos_rechazo' u (hist(\$1,width)):(1.0) smooth fnormal w boxes lc rgb'grey' notitle, \
    f(x)*width lc rgb'black' notitle"

gnuplot -e "reset; \
    n=10; \
    a=$A; \
    max=1.0; \
    min=0.0; \
    width=(max-min)/n; \
    hist(x,width)=width*floor(x/width)+width/2.0; \
    set term png; \
    set output '$img_composicion'; \
    set xrange [min:max]; \
    set yrange [0:]; \
    set xtics min,(max-min)/10,max; \
    set boxwidth width*0.9; \
    set style fill solid 0.5; \
    set tics out nomirror; \
    set xlabel 'valores del generador'; \
    set ylabel 'Frecuencias normalizadas'; \
    f(x)= a+2*(1-a)*x; \
    plot '$datos_composicion' u (hist(\$1,width)):(1.0) smooth fnormal w boxes lc rgb'grey' notitle, \
    f(x)*width lc rgb'black' notitle"

echo -e "Generando gráfica de tiempos en función del número de valores..."
img_tiempo_valores="$carpeta/img/tiempo_valores-$1.jpeg"
tiempos_inversion="$carpeta/tiempos-$1_gen_cont_inv.dat"
tiempos_rechazo="$carpeta/tiempos-$1_gen_cont_rechazo.dat"
tiempos_composicion="$carpeta/tiempos-$1_gen_cont_composicion.dat"

gnuplot -e "set terminal jpeg; \
            set output '$img_tiempo_valores'; \
            set title 'Tiempo de ejecución en función del número de valores'; \
            set xlabel 'Número de valores'; \
            set ylabel 'Tiempo (ms)'; \
            set key inside right top; \
            plot '$tiempos_inversion' using 3:4 title 'Inversión' with lines, \
                 '$tiempos_rechazo' using 3:4 title 'Rechazo' with lines, \
                 '$tiempos_composicion' using 3:4 title 'Composición' with lines;" >> $errores 2>&1

echo -e "Generando gráfica de tiempos en función de a..."
img_tiempo_a="$carpeta/img/tiempo_a-$1.jpeg"
tiempos_inversion_a="$carpeta/tiempos-$1_gen_cont_inv_a.dat"
tiempos_rechazo_a="$carpeta/tiempos-$1_gen_cont_rechazo_a.dat"
tiempos_composicion_a="$carpeta/tiempos-$1_gen_cont_composicion_a.dat"

gnuplot -e "set terminal jpeg; \
            set output '$img_tiempo_a'; \
            set title 'Tiempo de ejecución en función de a'; \
            set xlabel 'a'; \
            set ylabel 'Tiempo (ms)'; \
            set key inside right top; \
            plot '$tiempos_inversion_a' using 2:4 title 'Inversión' with lines, \
                 '$tiempos_rechazo_a' using 2:4 title 'Rechazo' with lines, \
                 '$tiempos_composicion_a' using 2:4 title 'Composición' with lines;" >> $errores 2>&1

echo -e "Gráficas de Generadores de Datos Continuos generadas (Capítulo 2.2)\n"