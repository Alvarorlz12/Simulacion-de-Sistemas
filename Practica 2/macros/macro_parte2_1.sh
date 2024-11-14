#! /bin/bash
# EJECUCION
# ./macro_parte2_1.sh nombre_carpeta_salida

# Obtener los parámetros
source params_parte2.txt

# Compilación
SRC="../src/codigo-generador.cpp"
BIN="../bin/generador"
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
carpeta=../ejecuciones/$1-generador
errores="$carpeta/errores-$1.txt"

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 2. Capítulo 2. Generadores de datos (discretos)"

# Generación de datos
echo -e "Generando datos..."
echo -e "\t - Generando $NUM_GEN valores usando tabla de búsqueda creciente de tamaño $TAM y búsqueda secuencial"
$BIN $TAM $NUM_GEN 0 0 0 -1 >> $carpeta/resultados-$1_gen_tabla_crec_sec.dat 2>> $errores
echo -e "\t - Generando $NUM_GEN valores usando tabla de búsqueda creciente de tamaño $TAM y búsqueda binaria"
$BIN $TAM $NUM_GEN 1 0 0 -1 >> $carpeta/resultados-$1_gen_tabla_crec_bin.dat 2>> $errores
echo -e "\t - Generando $NUM_GEN valores usando tabla de búsqueda decreciente de tamaño $TAM y búsqueda secuencial"
$BIN $TAM $NUM_GEN 2 0 0 -1 >> $carpeta/resultados-$1_gen_tabla_decr_sec.dat 2>> $errores

# Compilación y ejecución de programa auxiliar para calcular las frecuencias relativas
g++ -O2 ./../src/frecuencias.cpp -o ./../bin/frecuencias
./../bin/frecuencias $carpeta/resultados-$1_gen_tabla_crec_sec.dat $TAM > $carpeta/freq_tabla_crec_sec.dat
./../bin/frecuencias $carpeta/resultados-$1_gen_tabla_crec_bin.dat $TAM > $carpeta/freq_tabla_crec_bin.dat
./../bin/frecuencias $carpeta/resultados-$1_gen_tabla_decr_sec.dat $TAM > $carpeta/freq_tabla_decr_sec.dat
rm ./../bin/frecuencias

# Generación de datos de tiempo de ejecución: en función del número de valores
echo -e "Generando datos de tiempo de ejecución..."
echo -e "\t - Generando $NUM_GEN_TIEMPOS valores usando tabla de búsqueda creciente de tamaño $TAM y búsqueda secuencial"
$BIN $TAM $NUM_GEN_TIEMPOS 0 1 0 -1 >> $carpeta/resultados-$1_tiempo_valores_fijo.dat 2>> $errores
echo -e "\t - Generando $NUM_GEN_TIEMPOS valores usando tabla de búsqueda creciente de tamaño $TAM y búsqueda binaria"
$BIN $TAM $NUM_GEN_TIEMPOS 1 1 0 -1 >> $carpeta/resultados-$1_tiempo_valores_fijo.dat 2>> $errores
echo -e "\t - Generando $NUM_GEN_TIEMPOS valores usando tabla de búsqueda decreciente de tamaño $TAM y búsqueda secuencial"
$BIN $TAM $NUM_GEN_TIEMPOS 2 1 0 -1 >> $carpeta/resultados-$1_tiempo_valores_fijo.dat 2>> $errores
echo -e "\t - Generando datos variando el número de valores generados"
for i in $(seq $INI_VALS $INC_VALS $FIN_VALS); do
    $BIN $TAM $i 0 1 0 -1 >> $carpeta/resultados-$1_tiempo_valores_cs.dat 2>> $errores
    $BIN $TAM $i 1 1 0 -1 >> $carpeta/resultados-$1_tiempo_valores_cb.dat 2>> $errores
    $BIN $TAM $i 2 1 0 -1 >> $carpeta/resultados-$1_tiempo_valores_ds.dat 2>> $errores
done
echo -e "Datos de tiempo de ejecución generados"

# Generación de datos de tiempo de ejecución: peor caso variando tamaño de tabla
tiempos_tabla_crec_sec="$carpeta/tiempos_tabla_crec_sec.dat"
tiempos_tabla_crec_bin="$carpeta/tiempos_tabla_crec_bin.dat"
tiempos_tabla_decr_sec="$carpeta/tiempos_tabla_decr_sec.dat"
echo -e "Generando datos de tiempo de ejecución..."
for i in $(seq $INI_TAM $INC_TAM $FIN_TAM); do
    $BIN $i $NUM_VAL_PEOR_CASO 0 1 1 -1 >> $tiempos_tabla_crec_sec 2>> $errores
    $BIN $i $NUM_VAL_PEOR_CASO 1 1 1 -1 >> $tiempos_tabla_crec_bin 2>> $errores
    $BIN $i $NUM_VAL_PEOR_CASO 2 1 1 -1 >> $tiempos_tabla_decr_sec 2>> $errores
done
echo -e "Datos de tiempo de ejecución generados"

echo -e "Datos generados"

# Generación de gráficas
./macro_graficas_parte2_1.sh $1

# Eliminación de archivos ejecutables
rm $BIN

echo -e "-------------------------------------------------------------"
