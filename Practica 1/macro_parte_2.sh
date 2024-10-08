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

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"

# Ejecución

# SIMULACIÓN
echo -e "Realizando simulación con $M experimentos..."
resultado_desviacion="$carpeta/resultados-desviacion-$1.dat"
columna=2
for n in ${NS[@]}; do
    echo -e "\t- $n simulaciones"
    resultados="$carpeta/resultados-$1_$n.dat"
    $BIN $n $M >> $resultados 2>> $errores
    # Calcular la desviación típica de las llamadas perdidas
    n_lineas=$(awk -v col=$columna '{suma += $col; count++} END {print count}' "$resultados")
    media=$(awk -v col=$columna '{suma += $col; count++} END {print suma/count}' "$resultados")
    suma=$(awk -v col=$columna -v media=$media '{suma += ($col - media)^2} END {print suma}' "$resultados")
    varianza=$(echo "$suma / ($n_lineas - 1)" | bc -l)
    desviacion=$(echo "sqrt($varianza)" | bc -l)
    echo -e "$n\t$desviacion" >> $resultado_desviacion
done
echo -e "Simulación realizada\n"

# Generación de gráficas
./macro_graficas_parte_2.sh $1

rm $BIN

