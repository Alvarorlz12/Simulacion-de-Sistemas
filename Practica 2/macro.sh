#! /bin/bash
# EJECUCION
# ./macro.sh nombre_carpeta_salida
# Ejecuta todas las partes de la práctica 2 usando las macros de cada parte
# ubicadas en la carpeta 'macros' con sus correspondientes parámetros
# y guarda los resultados en la carpeta de salida

# Cambiar a la carpeta de macros
cd macros

# Ejecutar las partes de la práctica
./macro_parte1.sh $1
./macro_parte2_1.sh $1
./macro_parte2_2.sh $1