#! /bin/bash
# EJECUCIÓN
# ./macro_parte_1.sh nombre_carpeta_de_datos

# Obtener la ruta del script actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cambiar al directorio del script
cd "$SCRIPT_DIR"

# Obtener los parámetros
source params_parte1.txt

# Compilación
SRC_F="./../src/cola_incremento_fijo.cpp"
BIN_F="./../bin/cola_incremento_fijo"
g++ -O2 $SRC_F -o $BIN_F
SRC_V="./../src/cola_incremento_variable.cpp"
BIN_V="./../bin/cola_incremento_variable"
g++ -O2 $SRC_V -o $BIN_V

# Comprobar que existe la carpeta bin
if [ ! -d "../bin" ]; then
    mkdir "../bin"
fi

# Comprobar si existe la carpeta de ejecuciones
if [ ! -d "../ejecuciones" ]; then
    mkdir "../ejecuciones"
fi

# Variables
carpeta=../ejecuciones/$1-parte1
errores="$carpeta/errores-$1.txt"

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 3. Capítulo 1. MSD con incrementos fijo y variable"

# Simulación para la estimación del número medio de clientes en cola (Q) y 
# del porcentaje de tiempo de ocio del servidor (PTO) en función del número
# de clientes en el sistema (n) y de los tiempos de servicio y llegada.
echo -e "Realizando estimación de Q y PTO..."
echo -e "\t - Generando datos para Q y PTO con incremento fijo"
for inc in $(seq 0 $(($NUM_INC - 1))); do
    fichero_inc_fijo="$carpeta/inc_fijo_${NOMBRE_INC[inc]}.dat"
    $BIN_F $NUM_ITER ${INC_TLLEGADA[inc]} ${INC_TSERVICIO[inc]} > $fichero_inc_fijo 2>> $errores
done
echo -e "\t - Generando datos para Q y PTO con incremento variable"
fichero_inc_variable="$carpeta/inc_variable.dat"
$BIN_V 1000000 720 540 > $fichero_inc_variable 2>> $errores
echo -e "Estimación de Q y PTO finalizada."

# Generación de gráficas
./macro_graficas_parte1.sh $1