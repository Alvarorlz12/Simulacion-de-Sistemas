#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <iostream>

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
    temp[0].prob = (double)n/max;
    temp[0].indice = n;
    for (i=1;i<n;i++) {
        temp[i].prob = (double)(n-i)/max;
        temp[i].indice = n-i;   
    }
    // Calcular probabilidades acumuladas
    for (i = n-1; i > 0; i--)
    {
        temp[i-1].prob += temp[i].prob;
    }
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

int main(int argc, char* argv[]){
 
    // Inicializar la semilla para comparar resultados
    srandom(12345); // Inicialización del generador de números aleatorios con una semilla fija
    // srand(time(NULL)); // Inicialización del generador de números aleatorios
    int valor;
    int tama = 1000;  // Número de valores (tamaño de la tabla del generador), inicialmente darle valor 1000 
    veces = atoi(argv[1]);


    // Construcción de la tabla
    Celda* tabla_busqueda;
    // darle valor a tama
    // tabla_busqueda = construye_tabla(tama);
    tabla_busqueda = construye_tabla_reordenada(tama);
    
    // for (int i = 0; i < veces; i++) {
    //     //Cuando se necesite generar un valor, hacer:
    //     // valor = genera_valor(tabla_busqueda, tama);    // Generar un valor esta vez
    //     valor = genera_valor_busqueda_binaria(tabla_busqueda, tama);    // Generar un valor esta vez
    //     cout << "Valor: " << valor << endl;
    // }
    //Cuando se necesite generar un valor, hacer:
    // valor = genera_valor(tabla_busqueda, tama);    // Generar un valor esta vez
    // valor = genera_valor_busqueda_binaria(tabla_busqueda, tama);    // Generar un valor esta vez
    
    mostrar_tabla(tabla_busqueda, tama);
    // cout << "Valor generado: " << valor << endl;
    
    free(tabla_busqueda);
    return(0);
   
}
