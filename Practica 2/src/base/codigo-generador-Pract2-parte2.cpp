#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <iostream>

using namespace std;

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

int main(int argc, char* argv[]){
 
   srand(time(NULL)); // Inicialización del generador de números aleatorios
   int valor;
   int tama;  // Número de valores (tamaño de la tabla del generador), inicialmente darle valor 1000 
   veces = atoi(argv[1]);


   // Construcción de la tabla
   Celda* tabla_busqueda;
   // darle valor a tama
   tabla_busqueda = construye_tabla(tama);
   
//Cuando se necesite generar un valor, hacer:
   valor = genera_valor(tabla_busqueda, tama);    // Generar un valor esta vez
   
 

   
   free(tabla_busqueda);
   return(0);
   
}
