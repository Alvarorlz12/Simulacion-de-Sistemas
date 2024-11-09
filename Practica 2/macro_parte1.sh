#! /bin/bash
# EJECUCION
# ./macro_parte_1.sh nombre_carpeta_salida

# Obtener los parámetros
source params_parte1.txt

# Compilación
SRC="./src/estampadora.cpp"
BIN="./bin/estampadora"
g++ -O2 $SRC -o $BIN

# Comprobar que existe la carpeta bin
if [ ! -d "bin" ]; then
    mkdir "bin"
fi

# Comprobar si existe la carpeta de ejecuciones
if [ ! -d "ejecuciones" ]; then
    mkdir "ejecuciones"
fi

# Variables
carpeta=ejecuciones/$1-estampadora
sabiendo_estado="$carpeta/sabiendo_estado"
sin_saber_estado="$carpeta/sin_saber_estado"
errores_se="$sabiendo_estado/errores-$1.txt"
errores_sse="$sin_saber_estado/errores-$1.txt"

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"
mkdir "$sabiendo_estado"
mkdir "$sin_saber_estado"

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 2. Capítulo 1. Segundo Modelo de MonteCarlo"

# Simulación para búsqueda de regla de mantenimiento óptima minimizando el coste
# promedio pudiendo observar el estado de la máquina en cada paso
echo -e "Realizando simulación..."
echo -e "\tBúsqueda de regla de mantenimiento óptima minimizando el coste promedio"
counter=0   # Contador de reglas
for r in "${REGLAS_ESTADO[@]}"; do
    counter=$((counter + 1))
    res_estado="$sabiendo_estado/resultados-$1_regla$counter.dat"
    echo -e "\t - Procesando regla de mantenimiento $counter: $r"
    $BIN $TABLA_ESTADOS $NUM_VECES $NUM_ESTAMPACIONES $r >> $res_estado 2>> $errores_se
done
counter=0   # Contador de reglas
for r in "${REGLAS_ESTAMP[@]}"; do
    counter=$((counter + 1))
    res_estado="$sin_saber_estado/resultados-$1_regla$counter.dat"
    echo -e "\t - Procesando regla de mantenimiento $counter: $r"
    $BIN $TABLA_ESTADOS $NUM_VECES $NUM_ESTAMPACIONES $r >> $res_estado 2>> $errores_sse
done
echo -e "Simulación realizada\n"

# Generación de gráficas
./macro_graficas_parte1.sh $1

# Eliminación de ejecutables
rm $BIN

# Fin
echo -e "-------------------------------------------------------------"