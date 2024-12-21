#! /bin/bash
# EJECUCIÓN
# ./macro_comparacion_parte_3.sh nombre_carpeta_de_datos

# Obtener la ruta del script actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cambiar al directorio del script
cd "$SCRIPT_DIR"

# Obtener los parámetros
source params_parte3.txt

# Compilación
SRC_a2c="./../src/atendiendo_comparaciones.cpp"
BIN_a2c="./../bin/atendiendo_comparaciones"
rm -f $BIN_a2c
g++ -O2 $SRC_a2c -o $BIN_a2c
SRC_comp="./../src/comparacion_simultanea.cpp"
BIN_comp="./../bin/comparacion_simultanea"
rm -f $BIN_comp
g++ -O2 $SRC_comp -o $BIN_comp

# Variables
carpeta=../ejecuciones/$1-parte3
errores="$carpeta/errores-comparacion-$1.txt"

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 3. Capítulo 3. Comparación simultánea"

# 1. Obtener los resultados con 20 simulaciones
eval $CONFIG
fichero_sa_comp="$carpeta/sistema_a_comp.dat"
$BIN_a2c $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $A $TPARADA 20 $SEED_ET1 > $fichero_sa_comp 2>> $errores
fichero_sb_comp="$carpeta/sistema_b_comp.dat"
$BIN_a2c $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $B $TPARADA 20 $SEED_ET1 > $fichero_sb_comp 2>> $errores
fichero_sc_comp="$carpeta/sistema_c_comp.dat"
$BIN_a2c $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $C $TPARADA 20 $SEED_ET1 > $fichero_sc_comp 2>> $errores
fichero_sd_comp="$carpeta/sistema_d_comp.dat"
$BIN_a2c $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $D $TPARADA 20 $SEED_ET1 > $fichero_sd_comp 2>> $errores

# 2. Procesar datos de primeras 20 simulaciones
#       Almacenar estadísticos en fichero_resultados y los valores de Ni en fichero_N
fichero_resultados="$carpeta/seleccion_mejor_sistema.dat"
fichero_N="$carpeta/N.dat"
$BIN_comp 1 $fichero_resultados $fichero_N $fichero_sa_comp $fichero_sb_comp $fichero_sc_comp $fichero_sd_comp >> $errores 2>&1 

# 3. Realizar las simulaciones restantes con cada sistema
source $fichero_N # Na Nb Nc Nd
$BIN_a2c $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $A $TPARADA $(($Na-20)) $SEED_ET2 > $fichero_sa_comp 2>> $errores
$BIN_a2c $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $B $TPARADA $(($Nb-20)) $SEED_ET2 > $fichero_sb_comp 2>> $errores
$BIN_a2c $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $C $TPARADA $(($Nc-20)) $SEED_ET2 > $fichero_sc_comp 2>> $errores
$BIN_a2c $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $D $TPARADA $(($Nd-20)) $SEED_ET2 > $fichero_sd_comp 2>> $errores

# 4. Procesar los datos de las simulaciones restantes
$BIN_comp 2 $fichero_resultados $fichero_N $fichero_sa_comp $fichero_sb_comp $fichero_sc_comp $fichero_sd_comp >> $errores 2>&1

# Mostrar los resultados
echo -e "-------------------------------------------------------------"
echo -e " RESULTADOS"
echo -e "-------------------------------------------------------------"
cat $fichero_resultados