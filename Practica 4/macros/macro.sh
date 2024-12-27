#! /bin/bash
# EJECUCIÓN
# ./macro.sh nombre_carpeta_de_datos

# Obtener la ruta del script actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cambiar al directorio del script
cd "$SCRIPT_DIR"

# Obtener los parámetros
source params.txt

# Compilación
SRC="./../src/modelo.cpp"
BIN="./../bin/modelo"
g++ -O2 $SRC -o $BIN

# Comprobar si existe la carpeta de ejecuciones
if [ ! -d "../ejecuciones" ]; then
    mkdir "../ejecuciones"
fi

# Variables
carpeta=../ejecuciones/$1
errores="$carpeta/errores-$1.txt"

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 4. Modelo de Lotka-Volterra"
echo -e "-------------------------------------------------------------"

# Punto 2. a) Valores iniciales de parámetros
echo -e "Punto 2. a) Valores iniciales de parámetros con Runge-Kutta"
fic_iniciales="$carpeta/iniciales.dat"
eval $INICIAL
$BIN $RK $a11 $a12 $a21 $a22 $tinic $tfin $dt $x0 $y0 > $fic_iniciales 2> $errores

# Punto 2. b) Valores alejados de los parámetros iniciales
echo -e "Punto 2. b) Valores alejados de los parámetros iniciales con Runge-Kutta"
fic_alejados_1="$carpeta/alejados_1.dat"
eval $ALEJADOS_1
$BIN $RK $a11 $a12 $a21 $a22 $tinic $tfin $dt $x0 $y0 > $fic_alejados_1 2>> $errores
fic_alejados_2="$carpeta/alejados_2.dat"
eval $ALEJADOS_2
$BIN $RK $a11 $a12 $a21 $a22 $tinic $tfin $dt $x0 $y0 > $fic_alejados_2 2>> $errores
fic_alejados_3="$carpeta/alejados_3.dat"
eval $ALEJADOS_3
$BIN $RK $a11 $a12 $a21 $a22 $tinic $tfin $dt $x0 $y0 > $fic_alejados_3 2>> $errores

# Punto 5. Comparación de métodos
echo -e "Punto 5. Comparación de métodos"
eval $COMPARACION
h=0.1
fic_euler="$carpeta/comp_euler_$h.dat"
$BIN $EULER $a11 $a12 $a21 $a22 $tinic $tfin $h $x0 $y0 > $fic_euler 2>> $errores
fic_rk="$carpeta/comp_rk_$h.dat"
$BIN $RK $a11 $a12 $a21 $a22 $tinic $tfin $h $x0 $y0 > $fic_rk 2>> $errores
h=0.05
fic_euler="$carpeta/comp_euler_$h.dat"
$BIN $EULER $a11 $a12 $a21 $a22 $tinic $tfin $h $x0 $y0 > $fic_euler 2>> $errores
fic_rk="$carpeta/comp_rk_$h.dat"
$BIN $RK $a11 $a12 $a21 $a22 $tinic $tfin $h $x0 $y0 > $fic_rk 2>> $errores
h=0.01
fic_euler="$carpeta/comp_euler_$h.dat"
$BIN $EULER $a11 $a12 $a21 $a22 $tinic $tfin $h $x0 $y0 > $fic_euler 2>> $errores
fic_rk="$carpeta/comp_rk_$h.dat"
$BIN $RK $a11 $a12 $a21 $a22 $tinic $tfin $h $x0 $y0 > $fic_rk 2>> $errores

# Gráficos
./macro_graficas.sh $carpeta

echo -e "-------------------------------------------------------------"

