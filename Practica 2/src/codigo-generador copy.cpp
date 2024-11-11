#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <iostream>
#include <iomanip>
#include <chrono>

using namespace std;

int veces;  // Número de veces que se ejecuta el bucle

//generador por tablas de busqueda para la parte 2 de P2. Usa una tabla con dos campos, el indice (valor de la variable) y la probabilidad acumulada

struct Celda{ //para la tabla de busqueda
    int indice;
    float prob;
};

// Generación de un número uniformemente distribuido en [0, 1)]
double uniforme(){
    int t = rand();
    double f = ((double)RAND_MAX+1.0);
    return (double)t/f;
}

// *****************************************************************************
// *** FUNCIONES PARA CONSTRUIR LA TABLA DE BÚSQUEDA
// *****************************************************************************

// Construcción de la tabla de búsqueda de tamaño n para la distribución de probabilidad de la 2 parte de la práctica 2
Celda* construye_tabla(int n){
    int i, max;
    Celda* temp;
    if ((temp = (Celda*) malloc(n*sizeof(Celda))) == NULL)
    {
        fputs("Error reservando memoria para generador\n",stderr);
        exit(1);
    }
    max = n*(n+1)/2;
    temp[0].prob = 1.0/max;
    temp[0].indice = 1;
    for (i=1;i<n;i++) {
        temp[i].prob = temp[i-1].prob+(double)(i+1)/max;
        temp[i].indice = i+1;   
    }
    return temp;
}

/**
 * @brief Función que construye la tabla de búsqueda de tamaño n para la distribución de probabilidad
 *        En este caso construye la tabla de búsqueda reordenando los valores de la tabla de búsqueda
 *        de forma que las primeras celdas tengan una probabilidad mayor
 * @param n Tamaño de la tabla
 * @return Tabla de búsqueda
 */
Celda* construye_tabla_reordenada(int n){
    int i, max;
    Celda* temp;
    if ((temp = (Celda*) malloc(n*sizeof(Celda))) == NULL)
    {
        fputs("Error reservando memoria para generador\n",stderr);
        exit(1);
    }
    max = n*(n+1)/2;
    temp[0].prob = (float)n/max;
    temp[0].indice = n;
    for (i=1;i<n;i++) {
        temp[i].prob = (float)(n-i)/max;
        temp[i].indice = n-i;   
    }
    // Calcular probabilidades acumuladas
    for (i = 1; i < n; i++)
    {
        temp[i].prob += temp[i-1].prob;
    }
    // Truncar la probabilidad acumulada del último valor
    temp[n-1].prob = 1.0f;
    return temp;
}

/**
 * @brief Función que muestra la tabla de búsqueda por pantalla
 * @param tabla Tabla de búsqueda
 * @param tama Tamaño de la tabla
 * @post La tabla de búsqueda se muestra por pantalla
 */
void mostrar_tabla(Celda* tabla, int tama){
    for (int i = 0; i < tama; i++)
    {
        cout << "Indice: " << tabla[i].indice << " Probabilidad: " << tabla[i].prob << endl;
    }
}

// *****************************************************************************
// *** FUNCIONES PARA GENERAR VALORES: BÚSQUEDA SECUENCIAL Y BÚSQUEDA BINARIA
// *****************************************************************************

// Genera un valor de la distribución codificada en tabla, 
// por el método de tablas de búsqueda. tama es el tamaño de la tabla
int genera_valor(Celda* tabla, int tama){
    int i;
    double u = uniforme();
    i = 0;
    while((i<tama) && (u>=tabla[i].prob))
        i++;
    return tabla[i].indice;
}

/**
 * @brief Función que genera un valor de la distribución codificada en la tabla,
 *        por el método de búsqueda binaria en la tabla. 
 * @param tabla Tabla de búsqueda
 * @param tama Tamaño de la tabla
 * @return Valor generado
 */
int genera_valor_busqueda_binaria(Celda* tabla, int tama){
    int i = 0;
    int j = tama-1;
    int k;
    double u = uniforme();
    while(i<j){
        k = (i+j)/2;
        if (u<tabla[k].prob)
            j = k;
        else
            i = k+1;
    }
    return tabla[i].indice;
}

// *****************************************************************************
// *** FUNCIONES PARA GENERAR EL PEOR CASO
// ***************************************************************************** 

/**
 * @brief Función para generar valores de la tabla de búsqueda con el peor caso
 *        para el algoritmo de búsqueda secuencial
 * @param tabla Tabla de búsqueda
 * @param tama Tamaño de la tabla
 * @param u_fijo Valor de u fijo
 * @return Valor generado
 */
int genera_valor_peor_caso(Celda* tabla, int tama, float u_fijo){
    int i = 0;
    // cout << "\tfunc: u_fijo: " << u_fijo << endl;
    while((i<tama) && (u_fijo>=tabla[i].prob))
        i++;
    
    cout << "\tfunc: i: " << i << " | prob: " << tabla[i].prob << " | tam: " << tama << endl;

    // cout << "\tfunc: i: " << i << endl;
    return tabla[i].indice;
}

/**
 * @brief Función para generar valores de la tabla de búsqueda con el peor caso
 *        para el algoritmo de búsqueda binaria
 * @param tabla Tabla de búsqueda
 * @param tama Tamaño de la tabla
 * @param u_fijo Valor de u fijo
 * @return Valor generado
 */
int genera_valor_peor_caso_busqueda_binaria(Celda* tabla, int tama, float u_fijo){
    int i = 0;
    int j = tama-1;
    int k;
    while(i<j){
        k = (i+j)/2;
        if (u_fijo<tabla[k].prob)
            j = k;
        else
            i = k+1;
    }
    return tabla[i].indice;
}

// *****************************************************************************
// *** MAIN
// *****************************************************************************

int main(int argc, char* argv[]){
 
    int valor;  // Valor generado
    int tama;   // Número de valores (tamaño de la tabla del generador), inicialmente darle valor 1000 
    int veces;  // Número de veces valores que se generan
    int tipo_generador; // Tipo de generador
    bool medir_tiempo;  // Modo de tiempo
    int semilla;    // Semilla para el generador de números aleatorios
    Celda* tabla_busqueda;  // Tabla de búsqueda
    float u_fijo = -1; // Valor de u fijo para el peor caso
    bool peor_caso = false; // Modo peor caso

    // Formato: ./generador <tamano_tabla> <veces> [<tipo_generador> <medir_tiempo> <semilla>]
    // Tipo de generador:
    //      0: generador por búsqueda secuencial
    //      1: generador por búsqueda binaria
    //      2: generador por búsqueda secuencial con tabla reordenada
    if (argc < 3)
    {
        cout << "Error en los parámetros de entrada" << endl;
        cout << "Formato: ./generador <tamano_tabla> <veces> [<tipo_generador> <medir_tiempo> <peor_caso> <semilla>]" << endl;
        exit(-1);
    }
    if (argc >= 3)
    {
        tama = atoi(argv[1]);
        veces = atoi(argv[2]);
        tipo_generador = 0;
        medir_tiempo = false;
        semilla = -1;
        if (argc > 3 && argc != 7)
        {
            cout << "Error en los parámetros de entrada" << endl;
            cout << "Formato: ./generador <tamano_tabla> <veces> [<tipo_generador> <medir_tiempo> <peor_caso> <semilla>]" << endl;
            exit(-1);
        }
        if (argc == 7)
        {
            tipo_generador = atoi(argv[3]);
            medir_tiempo = atoi(argv[4]);
            peor_caso = atoi(argv[5]);
            semilla = atoi(argv[6]);
        }
    }

    // Inicializar la semilla para comparar resultados
    if (semilla != -1)
        srandom(semilla); // Inicialización del generador de números aleatorios con una semilla fija
    else srand(time(NULL)); // Inicialización del generador de números aleatorios

    // Función a utilizar para generar un valor de la tabla
    //      tipos 0 y 2: por búsqueda secuencial
    //      tipo 1: por búsqueda binaria
    int (*generar_valor)(Celda*, int) = genera_valor;
    if (tipo_generador == 1)
        generar_valor = genera_valor_busqueda_binaria;
    // Función a utilizar para construir la tabla
    //      tipos 0 y 1: tabla normal
    //      tipo 2: tabla reordenada
    Celda* (*construir_tabla)(int) = construye_tabla;
    if (tipo_generador == 2)
        construir_tabla = construye_tabla_reordenada;

    // Establecer el valor de u fijo para el peor caso dependiendo del tipo de generador
    int (*generar_peor_caso)(Celda*, int, float) = genera_valor_peor_caso;
    if (medir_tiempo && peor_caso) {
        // Tabla de búsqueda creciente o decreciente y búsqueda secuencial
        if (tipo_generador == 0 || tipo_generador == 2)
            u_fijo = (float)RAND_MAX/(float)(RAND_MAX+1.0);
        // Tabla de búsqueda creciente y búsqueda binaria
        else if (tipo_generador == 1) {  
            u_fijo = 0.25;
            generar_peor_caso = genera_valor_peor_caso_busqueda_binaria;
        }
    }

    // Tiempo de ejecución
    auto start = std::chrono::high_resolution_clock::now();

    // Construcción de la tabla
    tabla_busqueda = construir_tabla(tama);
    
    // Generar valores
    if (!medir_tiempo) {
        for (int i = 0; i < veces; i++) {
            //Cuando se necesite generar un valor, hacer:
            valor = generar_valor(tabla_busqueda, tama);    // Generar un valor esta vez
            cout << valor << endl;
        }
    }
    else {
        if (peor_caso) {
            for (int i = 0; i < veces; i++) {
                valor = generar_peor_caso(tabla_busqueda, tama, u_fijo); 
                cout << valor << endl;   
            }    
        } else {
            for (int i = 0; i < veces; i++) {
                valor = generar_valor(tabla_busqueda, tama);    
            }
        }
    }
    
    // Tiempo de ejecución
    auto end = std::chrono::high_resolution_clock::now();
    double time = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/1000.0;

    // Mostrar tiempo de ejecución
    if (medir_tiempo)
        cout << tipo_generador << "\t" << tama << "\t" << veces << "\t" << time << endl;

    // Mostrar tabla de búsqueda
    // mostrar_tabla(tabla_busqueda, tama);
    cout << fixed << setprecision(10);
    cout << "u_fijo: " << u_fijo << endl;
    cout << "ultimo valor: " << tabla_busqueda[tama-1].prob << endl;
    cout << ((u_fijo >= tabla_busqueda[tama-1].prob) ? "Correcto" : "Incorrecto") << endl;
    free(tabla_busqueda);   // Liberar memoria de la tabla de búsqueda
    return(0);
   
}
