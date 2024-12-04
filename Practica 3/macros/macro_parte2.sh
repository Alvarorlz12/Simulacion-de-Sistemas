#! /bin/bash
# EJECUCIÓN
# ./macro_parte_2.sh nombre_carpeta_de_datos

# Obtener la ruta del script actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cambiar al directorio del script
cd "$SCRIPT_DIR"

# Obtener los parámetros
source params_parte2.txt

# Compilación
SRC="./../src/atendiendo2colas.cpp"
BIN="./../bin/atendiendo2colas"
g++ -O2 $SRC -o $BIN

# Comprobar si existe la carpeta de ejecuciones
if [ ! -d "../ejecuciones" ]; then
    mkdir "../ejecuciones"
fi

# Variables
carpeta=../ejecuciones/$1-parte2
errores="$carpeta/errores-$1.txt"

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 3. Capítulo 2. Atendiendo 2 colas"

# Simulación para estimar el número de simulaciones necesarias para obtener
# una estimación fiable de la media de clientes perdidos independientemente
# de los parámetros de entrada.
# params: <tlleg1 tlleg2 tserv1 tserv2 maxcola1 maxcola2 tipodecision 
#          tparada numero_simulaciones>
fichero_config1="$carpeta/config1.dat"
fichero_config2="$carpeta/config2.dat"
fichero_config3="$carpeta/config3.dat"

# Configuración 1
eval $CONFIG1
for i in $(seq 1 $INCREMENTO $MAXSIM); do
    $BIN $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $TDEC $TPARADA $i >> $fichero_config1 2>> $errores
done
# Configuración 2
eval $CONFIG2
for i in $(seq 1 $INCREMENTO $MAXSIM); do
    $BIN $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $TDEC $TPARADA $i >> $fichero_config2 2>> $errores
done
# Configuración 3
eval $CONFIG3
for i in $(seq 1 $INCREMENTO $MAXSIM); do
    $BIN $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $TDEC $TPARADA $i >> $fichero_config3 2>> $errores
done

# Generar gráficas
./macro_graficas_parte2.sh $1