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
fichero_config_pruebas="$carpeta/config_pruebas.dat"
gnuplot -e "reset; \
    set term png; \
    set output '$carpeta/img/busqueda_num_sim.png'; \
    set title 'Búsqueda número simulaciones adecuado' font 'arial,16' enhanced; \
    set xlabel 'Número de simulaciones'; \
    set ylabel 'Porcentaje medio de clientes perdidos'; \
    set ytics nomirror; \
    set xtics nomirror rotate by -45; \
    set yrange [0:]; \
    set key out bottom; \
    set style line 1 lt 1 lc rgb 'red' lw 3 pt 7 ps 1.5; \
    set style line 2 lt 1 lc rgb 'blue' lw 3 pt 7 ps 1.5; \
    set style line 3 lt 1 lc rgb 'green' lw 3 pt 7 ps 1.5; \
    set style line 4 lt 1 lc rgb 'purple' lw 3 pt 7 ps 1.5; \
    plot '$fichero_config1' u 2:3 w l ls 1 t 'Configuración 1', \
    '$fichero_config2' u 2:3 w l ls 2 t 'Configuración 2', \
    '$fichero_config3' u 2:3 w l ls 3 t 'Configuración 3',
    '$fichero_config_pruebas' u 2:3 w l ls 4 t 'Configuración Guión';" >> $errores 2>&1

# Generar la gráfica de comparativa de reglas de decisión básicas
fichero_reg_dec_config1="$carpeta/reglas_decision_config1.dat"
fichero_reg_dec_config2="$carpeta/reglas_decision_config2.dat"
fichero_reg_dec_config3="$carpeta/reglas_decision_config3.dat"
fichero_reg_dec_config_pruebas="$carpeta/reglas_decision_config_pruebas.dat"
gnuplot -e "\
    set terminal pngcairo size 800,600 enhanced font 'Arial,14'; \
    set output '$carpeta/img/grafica_comparativa_reglas_basicas.png'; \
    set title 'Comparativa de reglas de decisión básicas con 300 simulaciones' enhanced font 'Arial,16'; \
    set xlabel 'Regla de decisión'; \
    set ylabel 'Porcentaje medio de clientes perdidos'; \
    set style data histograms; \
    set style histogram cluster gap 1; \
    set style fill solid 0.9 border -1; \
    set boxwidth 0.9; \
    set key top right; \
    set grid ytics; \
    plot '${fichero_reg_dec_config1}' every ::0::1 using 3:xtic(1) title 'Configuración 1',
    '${fichero_reg_dec_config2}' every ::0::1 using 3:xtic(1) title 'Configuración 2',
    '${fichero_reg_dec_config3}' every ::0::1 using 3:xtic(1) title 'Configuración 3',
    '${fichero_reg_dec_config_pruebas}' every ::0::1 using 3:xtic(1) title 'Configuración Guión';" >> $errores 2>&1
gnuplot -e "\
    set terminal pngcairo size 800,600 enhanced font 'Arial,14'; \
    set output '$carpeta/img/grafica_comparativa_reglas.png'; \
    set title 'Comparativa de reglas de decisión con 300 simulaciones' enhanced font 'Arial,16'; \
    set xlabel 'Regla de decisión'; \
    set ylabel 'Porcentaje medio de clientes perdidos'; \
    set style data histograms; \
    set style histogram cluster gap 1; \
    set style fill solid 0.9 border -1; \
    set boxwidth 0.9; \
    set key top right; \
    set grid ytics; \
    plot '${fichero_reg_dec_config1}' every ::0::2 using 3:xtic(1) title 'Configuración 1',
    '${fichero_reg_dec_config2}' every ::0::2 using 3:xtic(1) title 'Configuración 2',
    '${fichero_reg_dec_config3}' every ::0::2 using 3:xtic(1) title 'Configuración 3',
    '${fichero_reg_dec_config_pruebas}' every ::0::2 using 3:xtic(1) title 'Configuración Guión';" >> $errores 2>&1
gnuplot -e "\
    set terminal pngcairo size 800,600 enhanced font 'Arial,14'; \
    set output '$carpeta/img/grafica_comparativa_reglas_completa.png'; \
    set title 'Comparativa completa de reglas de decisión con 300 simulaciones' enhanced font 'Arial,16'; \
    set xlabel 'Regla de decisión'; \
    set ylabel 'Porcentaje medio de clientes perdidos'; \
    set style data histograms; \
    set style histogram cluster gap 1; \
    set style fill solid 0.9 border -1; \
    set boxwidth 0.9; \
    set key top right; \
    set grid ytics; \
    plot '${fichero_reg_dec_config1}' using 3:xtic(1) title 'Configuración 1',
    '${fichero_reg_dec_config2}' using 3:xtic(1) title 'Configuración 2',
    '${fichero_reg_dec_config3}' using 3:xtic(1) title 'Configuración 3',
    '${fichero_reg_dec_config_pruebas}' using 3:xtic(1) title 'Configuración Guión';" >> $errores 2>&1