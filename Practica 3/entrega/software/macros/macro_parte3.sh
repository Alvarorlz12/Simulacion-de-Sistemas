#! /bin/bash
# EJECUCIÓN
# ./macro_parte_3.sh nombre_carpeta_de_datos

# Obtener la ruta del script actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cambiar al directorio del script
cd "$SCRIPT_DIR"

# Obtener los parámetros
source params_parte3.txt

# Compilación
SRC="./../src/atendiendo2colas_sinseed.cpp"
BIN="./../bin/atendiendo2colas_sinseed"
g++ -O2 $SRC -o $BIN

# Comprobar si existe la carpeta de ejecuciones
if [ ! -d "../ejecuciones" ]; then
    mkdir "../ejecuciones"
fi

# Variables
carpeta=../ejecuciones/$1-parte3
errores="$carpeta/errores-$1.txt"

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 3. Capítulo 3. Comparando sistemas de 2 colas"

# Simulación para realizar comparaciones entre sistemas
# params: <tlleg1 tlleg2 tserv1 tserv2 maxcola1 maxcola2 tipodecision 
#          tparada numero_simulaciones>
eval $CONFIG
for sim in ${SIMULACIONES[@]}; do
    fichero_sistema_a="$carpeta/sistema_a_$sim.dat"
    $BIN $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $A $TPARADA $sim $VECES >> $fichero_sistema_a 2>> $errores
    fichero_sistema_b="$carpeta/sistema_b_$sim.dat"
    $BIN $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $B $TPARADA $sim $VECES >> $fichero_sistema_b 2>> $errores
    fichero_sistema_c="$carpeta/sistema_c_$sim.dat"
    $BIN $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $C $TPARADA $sim $VECES >> $fichero_sistema_c 2>> $errores
    fichero_sistema_d="$carpeta/sistema_d_$sim.dat"
    $BIN $tlleg1 $tlleg2 $tserv1 $tserv2 $maxcola1 $maxcola2 $D $TPARADA $sim $VECES >> $fichero_sistema_d 2>> $errores
done

# Procesar los datos: obtener las veces que el sistema A es mejor que el B
# Para ello tomamos los ficheros de salida y comparamos los valores de la
# columna 3 (clientes perdidos) para cada fila. Si el valor de la columna 3
# del sistema A es menor que el del sistema B, sumamos 1 a la variable
# "mejor_a_que_b". Si es igual o mayor no hacemos nada. El resultado final se
# almacena en un fichero de salida con el formato:
# <simulaciones> <mejor_a_que_b>
SRC_aux="./../src/comparador.cpp"
BIN_aux="./../bin/comparador"
g++ -O2 $SRC_aux -o $BIN_aux
fichero_comparacion_a_b="$carpeta/comparacion_a_b.dat"
fichero_comparacion_c_d="$carpeta/comparacion_c_d.dat"
for sim in ${SIMULACIONES[@]}; do
    fichero_sistema_a="$carpeta/sistema_a_$sim.dat"
    fichero_sistema_b="$carpeta/sistema_b_$sim.dat"
    fichero_sistema_c="$carpeta/sistema_c_$sim.dat"
    fichero_sistema_d="$carpeta/sistema_d_$sim.dat"
    mejor_a_que_b=$($BIN_aux $fichero_sistema_a $fichero_sistema_b)
    mejor_c_que_d=$($BIN_aux $fichero_sistema_c $fichero_sistema_d)
    echo -e "$sim\t$mejor_a_que_b" >> $fichero_comparacion_a_b
    echo -e "$sim\t$mejor_c_que_d" >> $fichero_comparacion_c_d
done

# Generar estadísticas
./macro_estadisticas_parte3.sh $1

# Generar comparaciones
./macro_comparacion_parte3.sh $1

# Generar gráficas
./macro_graficas_parte3.sh $1