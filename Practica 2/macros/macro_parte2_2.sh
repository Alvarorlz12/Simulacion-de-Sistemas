#! /bin/bash
# EJECUCION
# ./macro_parte2_2.sh nombre_carpeta_salida

# Obtener los parámetros
source params_parte2.txt

# Compilación
SRC="../src/generador_continuo.cpp"
BIN="../bin/generador_continuo"
g++ -O2 $SRC -o $BIN

# Comprobar que existe la carpeta bin
if [ ! -d "../bin" ]; then
    mkdir "../bin"
fi

# Comprobar si existe la carpeta de ejecuciones
if [ ! -d "../ejecuciones" ]; then
    mkdir "../ejecuciones"
fi

# Variables
carpeta=../ejecuciones/$1-generador_continuo
errores="$carpeta/errores-$1.txt"

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 2. Capítulo 2. Generadores de datos (continuos)"

# Generación de datos
echo -e "Generando datos..."
echo -e "\t Realizando comprobación empírica:"
echo -e "\t - Generando $VAL_CONT con generador continuo por método de inversión"
$BIN $VAL_CONT $A 0 0 -1 >> $carpeta/resultados-$1_gen_cont_inv.dat 2>> $errores
echo -e "\t - Generando $VAL_CONT con generador continuo por método de rechazo"
$BIN $VAL_CONT $A 1 0 -1 >> $carpeta/resultados-$1_gen_cont_rechazo.dat 2>> $errores
echo -e "\t - Generando $VAL_CONT con generador continuo por composición"
$BIN $VAL_CONT $A 2 0 -1 >> $carpeta/resultados-$1_gen_cont_composicion.dat 2>> $errores

echo -e "\t Realizando comprobación de tiempos en función del número de valores:"
tiempos_inversion="$carpeta/tiempos-$1_gen_cont_inv.dat"
tiempos_rechazo="$carpeta/tiempos-$1_gen_cont_rechazo.dat"
tiempos_composicion="$carpeta/tiempos-$1_gen_cont_composicion.dat"
for i in $(seq $CONTINUO_INI $CONTINUO_INI $CONTINUO_FIN); do
    echo -e "\t - Generando $i valores con generador continuo por método de inversión"
    $BIN $i $A 0 1 -1 >> $tiempos_inversion 2>> $errores
    echo -e "\t - Generando $i valores con generador continuo por método de rechazo"
    $BIN $i $A 1 1 -1 >> $tiempos_rechazo 2>> $errores
    echo -e "\t - Generando $i valores con generador continuo por composición"
    $BIN $i $A 2 1 -1 >> $tiempos_composicion 2>> $errores
done

echo -e "\t Realizando comprobación de tiempos en función de a:"
tiempos_inversion_a="$carpeta/tiempos-$1_gen_cont_inv_a.dat"
tiempos_rechazo_a="$carpeta/tiempos-$1_gen_cont_rechazo_a.dat"
tiempos_composicion_a="$carpeta/tiempos-$1_gen_cont_composicion_a.dat"
for a in ${AS[@]}; do
    echo -e "\t - Generando $VAL_CONT valores con generador continuo por método de inversión con a=$a"
    $BIN $VAL_CONT $a 0 1 $SEED >> $tiempos_inversion_a 2>> $errores
    echo -e "\t - Generando $VAL_CONT valores con generador continuo por método de rechazo con a=$a"
    $BIN $VAL_CONT $a 1 1 $SEED >> $tiempos_rechazo_a 2>> $errores
    echo -e "\t - Generando $VAL_CONT valores con generador continuo por composición con a=$a"
    $BIN $VAL_CONT $a 2 1 $SEED >> $tiempos_composicion_a 2>> $errores
done
echo -e "Datos generados"

# Generar gráficas
./macro_graficas_parte2_2.sh $1

echo -e "-------------------------------------------------------------"