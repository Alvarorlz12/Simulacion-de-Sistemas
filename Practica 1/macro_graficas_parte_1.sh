#! /bin/bash
# EJECUCIÓN
# ./macro_graficas.sh nombre_carpeta_de_datos

# Obtener los parámetros
source params_parte1.txt

# Variables
carpeta=ejecuciones/$1
errores="$carpeta/errores-$1.txt"
repeticiones=(10 500 10000)

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
for i in ${RS[@]}; do
    img_beneficios="$carpeta/img/beneficios-$1_$i.jpeg"
    img_lanzamientos="$carpeta/img/lanzamientos-$1_$i.jpeg"

    datos="$carpeta/resultados-$1_$i.dat"

    echo -e "\t- Gráfica de iteración vs. beneficios ($i repeticiones)"
    gnuplot -e "set term jpeg; \
                set key off; \
                set xrange [0:]; \
                set xlabel 'Iteración' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [:]; \
                set ylabel 'Beneficio medio (€)' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set output '$img_beneficios'; \
                plot '$datos' using 1:7 w lp lc 1 pt 7 ps 1 lw 1 t 'Beneficio' ; \
                " >> $errores 2>&1
    echo -e "\t- Gráfica de iteración vs. lanzamientos ($i repeticiones)\n"
    gnuplot -e "set term jpeg; \
                set key off; \
                set xrange [0:]; \
                set xlabel 'Iteración' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [0:]; \
                set ylabel 'Lanzamientos medios' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set output '$img_lanzamientos'; \
                plot '$datos' using 1:8 w lp lc 1 pt 7 ps 1 lw 1 t 'Lanzamientos' ; \
                " >> $errores 2>&1
done
echo -e "Gráficas generadas\n"

# ESTUDIO DE PARÁMETROS PRECIO DE LANZAMIENTO Y PREMIO
echo -e "Generando gráficas de estudio de parámetros precio de lanzamiento y premio..."
for pf in ${PFS[@]}; do
    fichero_precios="$carpeta/resultados-pls-pf$pf.dat"
    img_precios="$carpeta/img/precios-pls-pf$pf.jpeg"
    echo -e "\t- Con premio=$pf€ y precio de lanzamiento variable"
    for pl in ${PLS[@]}; do
        gnuplot -e "set term jpeg; \
                    set title 'Lanzamientos y beneficios medios para premio=$pf€' font 'arial,14'; \
                    set key font 'arial,13' bot center; \
                    set xrange [0:]; \
                    set xlabel 'Precio de lanzamiento (€)' font 'arial,14' enhanced; \
                    set xtics font 'arial,9'; \
                    set yrange [:]; \
                    set ylabel 'Beneficio medio (€)' font 'arial,14' enhanced; \
                    set ytics font 'arial,9'; \
                    set y2range [0:]; \
                    set y2label 'Lanzamientos medios' font 'arial,14' enhanced; \
                    set y2tics font 'arial,9'; \
                    set output '$img_precios'; \
                    plot '$fichero_precios' using 3:7 w lp lc 7 pt 7 ps 1 lw 1 t 'Beneficio medio', 
                    '$fichero_precios' using 3:8  w lp lc 8 pt 7 ps 1 lw 1 t 'Lanzamientos medios' \
                    " >> $errores 2>&1
    done
done
echo -e "Gráficas de estudio de parámetros precio de lanzamiento y premio generadas\n"

# ESTUDIO DE PARÁMETROS P Y K
fichero_mod_p="$carpeta/resultados_k$K-p-var.dat"
fichero_mod_k="$carpeta/resultados_p$P-k-var.dat"
fichero_mod="$carpeta/resultados_p-k-var.dat"

echo -e "\nGenerando gráficas de estudio de parámetros p y k..."
echo -e "\t- Fijado p=$P, variando k"
img_k_var="$carpeta/img/k-var.jpeg"
gnuplot -e "set term jpeg; \
                set title 'Lanzamientos medios para p=$P variando k' font 'arial,14'; \
                set key off; \
                set xrange [0:]; \
                set xlabel 'k' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [:]; \
                set ylabel 'Lanzamientos medios' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set output '$img_k_var'; \
                plot '$fichero_mod_k' using 6:8 w lp lc 1 pt 7 ps 1 lw 1 ; \
                " >> $errores 2>&1
echo -e "\t- Fijado k=$K, variando p"
img_p_var="$carpeta/img/p-var.jpeg"
gnuplot -e "set term jpeg; \
                set title 'Lanzamientos medios para k=$K variando p' font 'arial,14'; \
                set key off; \
                set xrange [0:]; \
                set xlabel 'p' font 'arial,14' enhanced; \
                set xtics font 'arial,9'; \
                set yrange [:]; \
                set ylabel 'Lanzamientos medios' font 'arial,14' enhanced; \
                set ytics font 'arial,9'; \
                set output '$img_p_var'; \
                plot '$fichero_mod_p' using 5:8 w lp lc 1 pt 7 ps 1 lw 1 ; \
                " >> $errores 2>&1
echo -e "\t- Variando p y k"
img_p_k_var_full="$carpeta/img/p_k-var-full.jpeg"
img_p_k_var_100="$carpeta/img/p_k-var-100.jpeg"
img_p_k_var_1000="$carpeta/img/p_k-var-1000.jpeg"
gnuplot -e "set term jpeg; \
                set title 'Lanzamientos medios variando p y k' font 'arial,14'; \
                set key off; \
                set xrange [0:]; \
                set xlabel 'p' font 'arial,14' enhanced offset -1.0; \
                set xtics font 'arial,9'; \
                set yrange [:]; \
                set ylabel 'k' font 'arial,14' enhanced offset +1.0; \
                set ytics font 'arial,9'; \
                set zrange [0:]; \
                set zlabel 'Lanzamientos medios' font 'arial,14' enhanced rotate parallel; \
                set ztics font 'arial,9'; \
                set style data pm3d; \
                set isosample 40,40; \
                set view 60,30; \
                set pm3d at s; \
                set colorbox vertical; \
                set output '$img_p_k_var_full'; \
                splot '$fichero_mod' using 5:6:8 with pm3d ; \
                set zrange [0:100]; \
                set output '$img_p_k_var_100'; \
                replot ; \
                set zrange [0:1000]; \
                set output '$img_p_k_var_1000'; \
                replot ; \
                " >> $errores 2>&1
echo -e "Gráficas de comparativa k y p generadas\n"