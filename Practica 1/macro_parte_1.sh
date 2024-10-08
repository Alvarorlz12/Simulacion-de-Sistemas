#! /bin/bash
# EJECUCION
# ./macro_parte_1.sh nombre_carpeta_salida

# Obtener los parámetros
source params_parte1.txt

# Compilación
SOURCE="./src/lanzamonedas-mod.cpp"
BIN="./bin/lanzamonedas-mod"
g++ -O2 $SOURCE -o $BIN

# Comprobar que existe la carpeta bin
if [ ! -d "bin" ]; then
    mkdir "bin"
fi

# Comprobar si existe la carpeta de ejecuciones
if [ ! -d "ejecuciones" ]; then
    mkdir "ejecuciones"
fi

# Variables
carpeta=ejecuciones/$1
errores="$carpeta/errores-$1.txt"

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"

# Ejecución

# SIMULACIÓN ESTÁNDAR
echo -e "Realizando simulación..."
echo -e "\t$PL€ coste tirada, $PF€ premio, probabilidad $P, $K seguidos, $ITER iteraciones"
for i in ${RS[@]}; do
    resultados="$carpeta/resultados-$1_$i.dat"
    $BIN $i $PL $PF $P $K $ITER >> $resultados 2>> $errores
done
echo -e "Simulación realizada\n"

# ESTUDIO DE PARÁMETROS PRECIO DE LANZAMIENTO Y PREMIO
echo -e "Realizando estudio de parámetros precio de lanzamiento y premio..."
for pf in ${PFS[@]}; do
    resultados="$carpeta/resultados-pls-pf$pf.dat"
    for pl in ${PLS[@]}; do
        $BIN 100000 $pl $pf $P $K 1 >> $resultados 2>> $errores
    done
done
echo -e "Estudio de parámetros precio de lanzamiento y premio realizado\n"

# ESTUDIO DE PARÁMETROS P Y K
echo -e "Realizando estudio de parámetros p y k..."
echo -e "\t- Fijado p=$P, variando k"
fichero_mod_k="$carpeta/resultados_p$P-k-var.dat"
for k in ${KS[@]}; do
    $BIN 100000 $PL $PF $P $k 1 >> $fichero_mod_k 2>> $errores
done
echo -e "\t- Fijado k=$K, variando p"
fichero_mod_p="$carpeta/resultados_k$K-p-var.dat"
for p in ${PS[@]}; do
    $BIN 100000 $PL $PF $p $K 1 >> $fichero_mod_p 2>> $errores
done
echo -e "\t- Variando p y k"
fichero_mod="$carpeta/resultados_p-k-var.dat"
for pi in ${PS3D[@]}; do
    for ki in ${KS[@]}; do
        $BIN 100000 $PL $PF $pi $ki 1 >> $fichero_mod 2>> $errores
    done
    echo -e "" >> $fichero_mod # Para insertar una línea blanca entre cada x
done
echo -e "Estudio de parámetros p y k realizado\n"

# Generación de gráficas
./macro_graficas_parte_1.sh $1

rm $BIN

