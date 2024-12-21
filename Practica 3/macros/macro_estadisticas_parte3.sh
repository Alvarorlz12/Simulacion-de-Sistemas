#! /bin/bash
# EJECUCIÓN
# ./macro_estadisticas_parte_3.sh nombre_carpeta_de_datos

# Obtener la ruta del script actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cambiar al directorio del script
cd "$SCRIPT_DIR"

# Obtener los parámetros
source params_parte3.txt

# Compilación
SRC="./../src/calcula_intervalos.cpp"
BIN="./../bin/calcula_intervalos"
g++ -O2 $SRC -o $BIN

# Variables
carpeta=../ejecuciones/$1-parte3
errores="$carpeta/errores-$1.txt"

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 3. Capítulo 3. Cálculo de estadísticas"

# Simulación para realizar comparaciones entre sistemas
# params: <tlleg1 tlleg2 tserv1 tserv2 maxcola1 maxcola2 tipodecision 
#          tparada numero_simulaciones>
fichero_stats_a_b="$carpeta/estadisticas_a_b.dat"
for sim in ${SIMULACIONES[@]}; do
    fichero_sistema_a="$carpeta/sistema_a_$sim.dat"
    fichero_sistema_b="$carpeta/sistema_b_$sim.dat"
    echo -e "====================================================================" >> $fichero_stats_a_b
    echo -e "INTERVALOS DE CONFIANZA CON $sim SIMULACIONES" >> $fichero_stats_a_b
    echo -e "====================================================================\n" >> $fichero_stats_a_b
    $BIN $fichero_sistema_a $fichero_sistema_b >> $fichero_stats_a_b 2>> $errores
done