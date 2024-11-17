
# PRÁCTICA 2: Modelos de MonteCarlo. Generadores de datos.
#### Jose Pineda Serrano y Álvaro Ruiz López

Práctica sobre desarrollo de modelos de MonteCarlo y generadores de datos discretos y continuos.

El código fuente de la práctica se encuentra por partes. Se puede ejecutar todo o cada una de las partes por individual.

## Ejecución

```bash
./macro.sh <nombre_carpeta_salida>
```
Esto genera como resultado:

1. `ejecuciones/nombre_carpeta_salida-estampadora`. Resultados del código del Capítulo 1: Modelo de MonteCarlo para Máquina de Estampados.
2. `ejecuciones/nombre_carpeta_salida-generador`. Resultados del código del Capítulo 2 (Parte 1): Generadores de datos discretos.
3. `ejecuciones/nombre_carpeta_salida-generador-continuo`. Resultados del código del Capítulo 2 (Parte 2): Generadores de datos continuos.

\
A continuación se detallan los códigos y parámetros de cada parte. 

## Capítulo 1. Modelo de MonteCarlo para Máquina Estampadora

- Código fuente: `src/estampadora.cpp`. Programa principal de esta parte. Requiere los siguientes parámetros:
    - `fichero_tabla_estados`: ruta al fichero donde se encuentra la tabla de probabilidades.
    - `veces`: número de simulaciones a realizar.
    - `max_estampaciones`: número de estampados a realizar en cada simulación.
    - `estado_regla`: estado en que debe estar la máquina para aplicar mantenimiento. Valor en [1, número de estados] o -1 para no utilizarlo.
    - `estampaciones_regla`: número de estampaciones que se deben haber realizado para aplicar mantenimiento. Valor en [1, max_estampaciones] o -1 para no utilizarlo.
 

### Ejecución

```bash
cd macros
./macro_parte1.sh <nombre_carpeta_salida>
```
Resultado: `ejecuciones/nombre_carpeta_salida-estampadora` datos y errores y dentro de `img` las gráficas.

### Parámetros: `params_parte1.txt`

- `TABLA_ESTADOS`: ruta de la tabla de estados por defecto.
- `NUM_VECES`: número de simulaciones a realizar. Establecido en 100.
- `NUM_ESTAMPACIONES`: número de estampados a realizar en cada simulación. Establecido en 1000000.
- `NO_ESTADO`: número establecido para indicar que no se tenga en cuenta el estado para mantener. Valor -1.
- `NO_NUM_EST`: número establecido para indicar que no se tenga en cuenta el número de estampaciones para mantener. Valor -1.
- `REGLAS_ESTADO`: lista de pares `estado estampaciones` a emplear para aplicar mantenimiento en función del estado. Por ello, varía `estado` y `estampaciones=-1`.
- `REGLAS_ESTAMP`: lista de pares `estado estampaciones` a emplear para aplicar mantenimiento en función del número de estamapciones. Por ello, varía `estampaciones` y `estado=-1`.
## Capítulo 2. Generadores de datos.
### Sección 2.1. Generadores de datos discretos.

Generador de datos discretos empleando una tabla de búsqueda y diferentes formas de construcción y búsqueda sobre la misma.

- Código fuente: `src/codigo-generador.cpp`. Programa principal que genera los datos discretos con los siguientes parámetros:
    - `tamano_tabla`: tamaño de la tabla a utilizar.
    - `veces`: número de valores aleatorios a generar.
    - `tipo_generador`: tipo de generador a utilizar: 
        - `0`: tabla creciente con búsqueda	secuencial.
        - `1`: tabla creciente con búsqueda binaria.
        - `2`: tabla decreciente con búsqueda secuencial.
    - `medir_tiempo`: *bool* para activar o desactivar la medición de tiempos.
    - `peor_caso`: *bool* para activar o desactivar el empleo del peor caso en cada tipo de búsqueda.
    - `semilla`: semilla a usar. No se emplea si el valor es -1.
- Código fuente de programa auxiliar: `src/frecuencias.cpp`. Se emplea dentro de la ejecución para obtener las frecuencias de los valores generados.

#### Ejecución

```bash
cd macros
./macro_parte2_1.sh <nombre_carpeta_salida>
```
Resultado: `ejecuciones/nombre_carpeta_salida-generador` datos y errores y dentro de `img` las gráficas.

#### Parámetros: `params_parte2.txt`
De los parámetros, en esta sección se emplean:

- `TAM`: tamaño de la tabla. Establecido en 1000.
- `NUM_GEN`: número de valores aleatorios a generar. Establecido en 1000000. 
- `NUM_GEN_TIEMPOS`: número de valores a generar para medir tiempos. Establecido en 10000000.
- Parámetros para comparativa de eficiencia en función del número de valores aleatorios a generar:
    - `INI_VALS`: número inicial de valores. Valor: 100000.
    - `FIN_VALS`: número final de valores. Valor: 1000000.
    - `INC_VALS`: incremento de valores. Establecido en 100000.
- Parámetros para comparativa de eficiencia en función del tamaño de la tabla de búsqueda:
    - `INI_TAM`: tamaño inicial de la tabla. Valor: 10000.
    - `FIN_TAM`: tamaño final de la tabla. Valor: 1000000.
    - `INC_TAM`: incremento de tamaño. Valor: 10000.
- `NUM_VAL_PEOR_CASO`: número de valores aleatorios a generar cuando se especifica el peor caso. Establecido en 1000000.
- `SEED`: semilla para poder utilizar establecida a 12345.

### Sección 2.2. Generadores de datos continuos.

Generadores de datos continuos basados en una función de densidad y diferentes métodos de generación: inversión, rechazo y composición.

- Código fuente: `src/generador_continuo.cpp`. Programa principal que genera los datos continuos con los siguientes parámetros:

    - `valores`: número de valores aleatorios a generar.
    - `a`: valor del parámetro `a` de la función de densidad.
    - `modo`: modo de generación de datos.
        - `0`: inversión.
        - `1`: rechazo.
        - `2`: composición.
    - `medir_tiempo`: *bool* para activar o desactivar la medición de tiempos.
    - `semilla`: semilla para inicializar la generación. El valor -1 indica que no se emplea ninguna.

#### Ejecución

```bash
cd macros
./macro_parte2_2.sh <nombre_carpeta_salida>
```
Resultado: `ejecuciones/nombre_carpeta_salida-generador_continuo` datos y errores y dentro de `img` las gráficas.

#### Parámetros: `params_parte2.txt`
De los parámetros, en esta sección se emplean:

- `A`: valor del parámetro `a` de la función de densidad a emplear. Establecido en 0.4.
- `AS`: lista de valores de `a` para comparativa de eficiencia de los generadores en función de este parámetro.
- `CONTINUO_INI`: número inicial de valores a generar para comparativa de eficiencia en función del número de datos a generar.
- `CONTINUO_FIN`: número final de valores a generar para comparativa de eficiencia en función del número de datos a generar.
- `VAL_EMPIRICO`: número de valores aleatorios a generar para la obtención de la distribución de forma empírica. Establecido en 100000.
- `VAL_CONT`: número de valores aleatorios a generar para la comparativa en función de `a`. Establecido en 1000000.
## Notas

> **Asegurarse de que se tienen permisos de ejecución sobre los scripts.**

