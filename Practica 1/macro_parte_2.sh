#! /bin/bash
# EJECUCION
# ./macro_parte_2.sh nombre_carpeta_salida

# Obtener los parámetros
source params_parte2.txt

# Compilación
SRC="./src/llamadas-mod.cpp"
BIN="./bin/llamadas-mod"
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
carpeta=ejecuciones/$1-llamadas
errores="$carpeta/errores-$1.txt"
columna=2   # Columna del porcentaje de llamadas perdidas en el fichero de resultados
NL_OPTIMO=0 # Número de líneas óptimo

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"

# Función para calcular la desviación típica de un archivo (pasado como primer argumento) 
# en una columna (segundo argumento)
function desviacion_tipica {
    n_lineas=$(awk -v col=$2 '{suma += $col; count++} END {print count}' "$1")
    media=$(awk -v col=$2 '{suma += $col; count++} END {print suma/count}' "$1")
    suma=$(awk -v col=$2 -v media=$media '{suma += ($col - media)^2} END {print suma}' "$1")
    varianza=$(echo "$suma / ($n_lineas - 1)" | bc -l)
    desviacion=$(echo "sqrt($varianza)" | bc -l)
    echo $desviacion
}

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 1. Capítulo 2. Llamadas telefónicas (M.S. Discreto)"

# SIMULACIÓN
# echo -e "Realizando simulación con $M experimentos..."
# resultado_desviacion="$carpeta/resultados-desviacion-$1.dat"
# for n in ${NS[@]}; do
#     echo -e "\t- $n simulaciones"
#     resultados="$carpeta/resultados-$1_$n.dat"
#     $BIN $n $M >> $resultados 2>> $errores
#     # Calcular la desviación típica de las llamadas perdidas
#     desviacion=$(desviacion_tipica $resultados $columna)
#     echo -e "$n\t$desviacion" >> $resultado_desviacion
# done
# echo -e "Simulación realizada\n"

# ESTUDIO DE PARÁMETROS
echo -e "Realizando estudio de parámetros..."
echo -e "\n\tBuscando el número de líneas óptimo para tener una frecuencia menor a $FREQ"
echo -e "\tde porcentaje de llamadas perdidas mayor a $UMBRAL usando $SIM simulaciones:\n"
# Buscar de 1 en 1 desde 50 el número de líneas óptimo, generando un fichero con los resultados
# de cada simulación y tras calcular la desviación típica de las llamadas perdidas eliminarlo
# si no cumple la frecuencia máxima de llamadas perdidas con un umbral de $UMBRAL o
# detenerse si lo encuentra
fichero_optimo="$carpeta/resultados-optimo-$1.dat"
fichero_pruebas="$carpeta/resultados-pruebas-$1.dat"
for nl in $(seq 51 1 100); do
    resultados="$carpeta/resultados-optimo-$1_$nl.dat"
    # PRUEBAS
    # 1 1000
    # 1 100
    # 10 100
    $BIN $SIM $REP $nl >> $resultados 2>> $errores
    # Comprobar cuantas veces se supera el umbral de llamadas perdidas
    supera=$(awk -v umbral=$UMBRAL -v col=$columna '{if ($col > umbral) count++} END {print count}' "$resultados")
    n_lineas=$(awk -v col=$columna '{suma += $col; count++} END {print count}' "$resultados")
    # Si supera es nulo se iguala a 0
    if [ -z "$supera" ]; then
        supera=0
    fi
    frecuencia=$(echo "($supera / $n_lineas) * 100" | bc -l)
    # Si la frecuencia es nula se iguala a 0
    if [ -z "$frecuencia" ]; then
        frecuencia=0
    fi
    # Guardar los resultados en un fichero de pruebas
    echo -e "$nl\t$frecuencia" >> $fichero_pruebas
    echo -e "\t- $nl líneas -> frecuencia de llamadas perdidas superiores al umbral: $frecuencia%"
    # Comprobar si la frecuencia obtenida es menor que la deseada
    if (( $(echo "$frecuencia < ($FREQ * 100)" | bc -l) )); then
        echo -e "\t* Número de líneas óptimo: $nl"
        NL_OPTIMO=$nl
        cat $resultados > $fichero_optimo
        rm $resultados
        break
    fi
    rm $resultados
done

# Generación de gráficas
./macro_graficas_parte_2.sh $1

rm $BIN

echo -e "-------------------------------------------------------------"