#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
// #include <list>

using namespace std;

// calcula por montecarlo el beneficio esperado y el numero medio de lanzamientos de una moneda necesarios para obtener x caras o x cruces seguidas, cuando se paga y euros por cada lanzamiento y al terminar se reciben z euros
// para x=2 y p=0.5 la media te�rica del numero de lanzamientos es 3

//OJO: si las variables acumuladoras se declaran float en vez de doubles, cuando se simula muchas veces, p.e. 100 millones, se producen problemas, salen resultados incoherentes

float prob; //probabilidad de obtener cara
int necesarios; //numero de caras o cruces seguidas para detener el juego
int seguidos; // numero de lanzamientos seguidos saliendo lo mismo (siempre cara o siempre cruz)
int lanzamientos; //lanzamientos de moneda realizados
double esperado; //beneficio obtenido
int resultado, ultimoresultado, iteraciones;
long veces; //numero de repeticiones del juego
float pagoporlanzamiento,pagoalfinalizar;
double mediaesperado, medialanzamientos;
double mediaesperado2, medialanzamientos2;
bool fin;


// RAND_MAX es igual a 2^31-1 = 2147483647
int lanza(){
double u;
  u = (double) rand();
  u = u/(double)(RAND_MAX+1.0);
  if (u<prob)
   return 0;
  else return 1;
}


/* Programa principal */
int main(int argc, char *argv[])
{
  
  if(argc == 1)
   {
    veces=100000;
    pagoporlanzamiento=10.0;
    pagoalfinalizar=50.0;
    prob=0.5;
    necesarios = 2;
   }
   else if(argc == 4)
   {
    sscanf(argv[1],"%ld",&veces);
    sscanf(argv[2],"%f",&pagoporlanzamiento);
    sscanf(argv[3],"%f",&pagoalfinalizar);
    prob=0.5;
    necesarios = 2;
   }
   else if(argc != 7)
	{
         printf("\nFormato Argumentos -> <numero de iteraciones> <pago por lanzamiento> <pago al finalizar> <probabilidad de cara> <caras o cruces seguidas necesarias>\n");
	 exit(1);
	}
       else
          {
           sscanf(argv[1],"%ld",&veces);
           sscanf(argv[2],"%f",&pagoporlanzamiento);
           sscanf(argv[3],"%f",&pagoalfinalizar);
           sscanf(argv[4],"%f",&prob);
           sscanf(argv[5],"%d",&necesarios);
           sscanf(argv[6],"%d",&iteraciones);
	  }

//srandom(123456);
srand(time(NULL));
mediaesperado=0.0; mediaesperado2=0.0;
medialanzamientos=0.0; medialanzamientos2=0.0;

for (int i=0; i <iteraciones; i++)
{
  for (long vez=0; vez<veces; vez++) {
    ultimoresultado = lanza();
    lanzamientos = 1;
    seguidos = 1;
    fin=false;
    while (!fin) {
      resultado = lanza();
      lanzamientos ++;
      if (ultimoresultado == resultado) {
        seguidos ++;
        if (seguidos == necesarios) fin = true;
      }
      else {
        ultimoresultado = resultado;
        seguidos = 1;
      }
  }
  esperado = pagoalfinalizar-lanzamientos*pagoporlanzamiento;
  mediaesperado += esperado;
  mediaesperado2 += esperado*esperado;
  medialanzamientos += lanzamientos;
  medialanzamientos2 += lanzamientos*lanzamientos;
  }
  mediaesperado=mediaesperado/veces;
  medialanzamientos = medialanzamientos/veces;
  printf("%d\t%ld\t%f\t%f\t%f\t%d\t%f\t%f\n", i, veces, pagoporlanzamiento, pagoalfinalizar, 
         prob, necesarios, mediaesperado, medialanzamientos);
  // printf("\nNumero de partidas: %ld ",veces);
  // printf("\nProbabilidad de cara: %f ",prob);
  // printf("\ncaras o cruces seguidas necesarias: %d ",necesarios);
  // printf("\nPago por lanzamiento: %f ",pagoporlanzamiento);
  // printf("\nPago al finalizar: %f ",pagoalfinalizar);
  // printf("\n");

  // printf("\nBeneficio esperado: %f ",mediaesperado);
  // printf("\ndesviacion tipica del beneficio esperado: %f ",sqrt((mediaesperado2-veces*mediaesperado*mediaesperado)/(veces-1)));
  // //printf("\n");
  // printf("\nNumero medio de lanzamientos: %f ",medialanzamientos);
  // printf("\ndesviacion tipica del numero medio de lanzamientos: %f ",sqrt((medialanzamientos2-veces*medialanzamientos*medialanzamientos)/(veces-1)));
  // printf("\n");
} 
}
