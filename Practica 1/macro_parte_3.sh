#! /bin/bash
# EJECUCION
# ./macro_parte_3.sh nombre_carpeta_salida

# Obtener los parámetros
source params_parte3.txt

# Compilación
SRC="./src/Simulacion_lago2-mod.C"
BIN="./bin/lago-mod"
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
carpeta=ejecuciones/$1-lago
errores="$carpeta/errores-$1.txt"

# Borrado de archivos antiguos
if [ -d "$carpeta" ]; then
    rm -r "$carpeta"
fi

# Creación de la carpeta
mkdir "$carpeta"

# Ejecución

echo -e "-------------------------------------------------------------"
echo -e " PRÁCTICA 1. Capítulo 3. Peces en el lago (M.S. Contínuo)"

# SIMULACIÓN

echo -e "Realizando simulación de búsqueda de equilibrio..."
for pp in ${P_PEQ[@]}; do
    for pg in ${P_GRAN[@]}; do
        echo -e "\t- $pp peces pequeños iniciales, $pg peces grandes iniciales, $DURACION duración"
        resultados_busqueda_equilibrio="$carpeta/resultados-$1_$pp-$pg.dat"
        $BIN $DURACION $pp $pg $F_INICIAL >> $resultados_busqueda_equilibrio 2>> $errores
    done
done
echo -e "Simulación realizada\n"
# echo -e "Realizando simulación de búsqueda de equilibrio..."
# for pg in $(seq 440 0.1 460); do
#     echo -e "\t- 1000 peces pequeños iniciales, $pg peces grandes iniciales, $DURACION duración"
#     resultados_busqueda_equilibrio="$carpeta/resultados-$1_1000-$pg.dat"
#     $BIN $DURACION 33500 $pg >> $resultados_busqueda_equilibrio 2>> $errores
#     # tail -n 1 $resultados_busqueda_equilibrio
#     # echo -e ""

#     # Obtener la última línea del archivo
#     ultima_linea=$(tail -n 1 $resultados_busqueda_equilibrio)

#     # Mostrar la última línea
#     echo "$ultima_linea"
#     echo -e ""

#     # Verificar si el valor de la columna 2 es 0
#     valor_columna_2=$(echo "$ultima_linea" | awk '{print $2}')
#     if [[ "$valor_columna_2" == "0" ]]; then
#         echo "Se ha detectado un valor 0 en la columna 2. Deteniendo simulación."
#         rm $resultados_busqueda_equilibrio
#         break
#     fi
#     rm $resultados_busqueda_equilibrio
# done
# echo -e "Simulación realizada\n"

echo -e "Estudio de campañas de pesca en el lago..."
echo -e "Simulación de campaña de pesca a los $FECHA_PESCA días con F=$F_INICIAL..."
for pgs in ${PESCA_PG_SOLO[@]} ; do
    porcentaje=$(echo "scale=2; $pgs * 100" | bc -l)
    echo -e "\t- $pp peces pequeños iniciales, $pg peces grandes iniciales, $DURACION duración, $porcentaje% peces grandes a pescar"
    resultados_pesca_grandes_f_ini="$carpeta/resultados-$1_pesca_${F_INICIAL}_$pgs.dat"
    $BIN $DURACION $PP_INI_PESCA $PG_INI_PESCA $F_INICIAL $FECHA_PESCA 0.0 $pgs >> $resultados_pesca_grandes_f_ini 2>> $errores
done
echo -e "Simulación de campaña de pesca a los $FECHA_PESCA días con F=$F_MOD..."
for pgs in ${PESCA_PG_SOLO[@]} ; do
    porcentaje=$(echo "scale=2; $pgs * 100" | bc -l)
    echo -e "\t- $pp peces pequeños iniciales, $pg peces grandes iniciales, $DURACION duración, $porcentaje% peces grandes a pescar"
    resultados_pesca_grandes_f_mod="$carpeta/resultados-$1_pesca_${F_MOD}_$pgs.dat"
    $BIN $DURACION $PP_INI_PESCA $PG_INI_PESCA $F_MOD $FECHA_PESCA 0.0 $pgs >> $resultados_pesca_grandes_f_mod 2>> $errores
done
echo -e "Estudio de campañas de pesca realizado\n"

echo -e "Estudio de políticas de pesca que afectan a peces grandes solo en el lago..."
resultados_politica_pesca_grandes_f_ini="$carpeta/resultados-$1_pesca_grandes_f${F_INICIAL}.dat"
for ld in ${L_DIAS[@]} ; do
    for prg in ${PORCENTAJE_PESCA[@]} ; do
        porcentaje=$(echo "scale=2; $prg * 100" | bc -l)
        echo -e "\t- pescando $porcentaje% de peces grandes a los $ld días y F=$F_INICIAL"
        res_politica_pesca_grandes_parcial="$carpeta/resultados-$1_pesca_grandes_$prg_$ld_f${F_INICIAL}.dat"
        $BIN $DURACION $PP_INI_PESCA $PG_INI_PESCA $F_INICIAL $ld 0.0 $prg > $res_politica_pesca_grandes_parcial 2>> $errores
        ultima_linea=$(tail -n 1 $res_politica_pesca_grandes_parcial)
        capturas=$(echo "$ultima_linea" | awk '{print $4}')
        # Asignar 0 a capturas si el valor es NaN
        if [ -z "$capturas" ]; then
            capturas=0
        fi
        echo -e "$ld $prg $capturas" >> $resultados_politica_pesca_grandes_f_ini
        rm $res_politica_pesca_grandes_parcial
    done
    echo -e "" >> $resultados_politica_pesca_grandes_f_ini
done
resultados_politica_pesca_grandes_f_mod="$carpeta/resultados-$1_pesca_grandes_f${F_MOD}.dat"
for ld in ${L_DIAS[@]} ; do
    for prg in ${PORCENTAJE_PESCA[@]} ; do
        porcentaje=$(echo "scale=2; $prg * 100" | bc -l)
        echo -e "\t- pescando $porcentaje% de peces grandes a los $ld días y F=$F_MOD"
        res_politica_pesca_grandes_parcial="$carpeta/resultados-$1_pesca_grandes_$prg_$ld_f${F_MOD}.dat"
        $BIN $DURACION $PP_INI_PESCA $PG_INI_PESCA $F_MOD $ld 0.0 $prg > $res_politica_pesca_grandes_parcial 2>> $errores
        ultima_linea=$(tail -n 1 $res_politica_pesca_grandes_parcial)
        capturas=$(echo "$ultima_linea" | awk '{print $4}')
        # Asignar 0 a capturas si el valor es NaN
        if [ -z "$capturas" ]; then
            capturas=0
        fi
        echo -e "$ld $prg $capturas" >> $resultados_politica_pesca_grandes_f_mod
        rm $res_politica_pesca_grandes_parcial
    done
    echo -e "" >> $resultados_politica_pesca_grandes_f_mod
done
echo -e "Estudio de políticas de pesca que afectan a peces grandes solo en el lago realizado\n"

echo -e "Estudio de políticas de pesca que afectan a peces grandes y pequeños en el lago..."
echo -e "\t* suponemos que las redes empleadas capturan tanto peces grandes como pequeños en la misma proporción"
resultados_politica_pesca_ambos_f_ini="$carpeta/resultados-$1_pesca_ambos_f${F_INICIAL}.dat"
for ld in ${L_DIAS[@]} ; do
    for prg in ${PORCENTAJE_PESCA[@]} ; do
        porcentaje=$(echo "scale=2; $prg * 100" | bc -l)
        echo -e "\t- pescando $porcentaje% de peces grandes y pequeños a los $ld días y F=$F_INICIAL"
        res_politica_pesca_ambos_parcial="$carpeta/resultados-$1_pesca_ambos_$prg_$ld_f${F_INICIAL}.dat"
        $BIN $DURACION $PP_INI_PESCA $PG_INI_PESCA $F_INICIAL $ld $prg $prg > $res_politica_pesca_ambos_parcial 2>> $errores
        ultima_linea=$(tail -n 1 $res_politica_pesca_ambos_parcial)
        capturas=$(echo "$ultima_linea" | awk '{print $4}')
        # Asignar 0 a capturas si el valor es NaN
        if [ -z "$capturas" ]; then
            capturas=0
        fi
        echo -e "$ld $prg $capturas" >> $resultados_politica_pesca_ambos_f_ini
        rm $res_politica_pesca_ambos_parcial
    done
    echo -e "" >> $resultados_politica_pesca_ambos_f_ini
done
resultados_politica_pesca_ambos_f_mod="$carpeta/resultados-$1_pesca_ambos_f${F_MOD}.dat"
for ld in ${L_DIAS[@]} ; do
    for prg in ${PORCENTAJE_PESCA[@]} ; do
        porcentaje=$(echo "scale=2; $prg * 100" | bc -l)
        echo -e "\t- pescando $porcentaje% de peces grandes y pequeños a los $ld días y F=$F_MOD"
        res_politica_pesca_ambos_parcial="$carpeta/resultados-$1_pesca_ambos_$prg_$ld_f${F_MOD}.dat"
        $BIN $DURACION $PP_INI_PESCA $PG_INI_PESCA $F_MOD $ld $prg $prg > $res_politica_pesca_ambos_parcial 2>> $errores
        ultima_linea=$(tail -n 1 $res_politica_pesca_ambos_parcial)
        capturas=$(echo "$ultima_linea" | awk '{print $4}')
        # Asignar 0 a capturas si el valor es NaN
        if [ -z "$capturas" ]; then
            capturas=0
        fi
        echo -e "$ld $prg $capturas" >> $resultados_politica_pesca_ambos_f_mod
        rm $res_politica_pesca_ambos_parcial
    done
    echo -e "" >> $resultados_politica_pesca_ambos_f_mod
done
echo -e "Estudio de políticas de pesca que afectan a peces grandes y pequeños en el lago realizado\n"

# Generación de gráficas
./macro_graficas_parte_3.sh $1

rm $BIN

echo -e "-------------------------------------------------------------"