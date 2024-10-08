#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <list>
#include <iostream>
#include "llamadas.h"

using namespace std;

bool compare(const suc &s1, const suc &s2)
{ return s1.tiempo < s2.tiempo; }


/* Inserta de forma ordenada un elemento en la lista de sucesos */
void insertar_lsuc(suc n)
{
  lsuc.push_back(n);

  // Mantener ordenada la lista por el tiempo de los sucesos
  lsuc.sort(compare);
}


/* Procedimiento inicializacion */
void inicializacion()
{

  // inicializacion de variables de estado
  reloj = 0.0;
  lineas_libres = num_lineas;

  // inicializacion de contadores estadisticos
  /* Contadores estadisticos */
  tdus_ocupadas = 0.0;
  num_llamadas_perdidas = 0;
  num_lineas_ocupadas = 0;
  num_intentos = 0;
  acum_lineas_ocupadas = 0;

  // inicializacion de la lista de sucesos
  while(!lsuc.empty()) {lsuc.pop_front();}
    
  nodo.suceso = SUCESO_FIN_SIMULACION;
  nodo.tiempo = reloj+tparada;
  insertar_lsuc(nodo);
  nodo.suceso = SUCESO_LLEGADA_LLAMADA_AB;
  nodo.tiempo = reloj+genera_tllamadaAB(tllamadaA);
  insertar_lsuc(nodo);
  nodo.suceso = SUCESO_LLEGADA_LLAMADA_BA;
  nodo.tiempo = reloj+genera_tllamadaBA(tllamadaB);
  insertar_lsuc(nodo);
    
  parar=false;
}


/* Procedimiento temporizacion */
void temporizacion()
{
  nodo = lsuc.front();
  lsuc.pop_front();
  reloj = nodo.tiempo;
}


/* Procedimiento suceso */
void suceso()
{
  switch(nodo.suceso)
  	{
	case SUCESO_LLEGADA_LLAMADA_AB: llegada_llamadaAB(); break;
	case SUCESO_LLEGADA_LLAMADA_BA: llegada_llamadaBA(); break;
	case SUCESO_FIN_LLAMADA: fin_llamada(); break;
	case SUCESO_FIN_SIMULACION: fin_simulacion(); break;
	}
}

/* Procedimiento fin de simulacion */
void fin_simulacion()
{
  int i;
  acum_lineas_ocupadas += (reloj-tdus_ocupadas)*num_lineas_ocupadas;
  tdus_ocupadas = reloj;
    
  parar=true;

  informe[cont_simu][0] = ((float)acum_lineas_ocupadas /reloj);
  informe[cont_simu][1] = (((float)acum_lineas_ocupadas /reloj) / num_lineas)*100.0;
  informe[cont_simu][2] = num_intentos;
  informe[cont_simu][3] = num_llamadas_perdidas;
  informe[cont_simu][4] = ((float)num_llamadas_perdidas/(float)num_intentos)*100.0;
}

void fin_llamada()
{
  // Actualizamos estadísticas
  acum_lineas_ocupadas += (reloj-tdus_ocupadas)*num_lineas_ocupadas;
  tdus_ocupadas = reloj;
  num_lineas_ocupadas--;
  lineas_libres++;
    
}

void llegada_llamadaAB()
{
  num_intentos++;
  //Veamos si hay líneas libres
  if (lineas_libres > 0)
  {
    // Actualizamos estadísticas
    acum_lineas_ocupadas += (reloj-tdus_ocupadas)*num_lineas_ocupadas;
    tdus_ocupadas = reloj;
    num_lineas_ocupadas++;
    lineas_libres--;

    // Generamos evento fin llamada
    suc nodo;
    nodo.suceso = SUCESO_FIN_LLAMADA;
    nodo.tiempo = reloj + genera_dllamada(duracion_llamada);
    insertar_lsuc(nodo);
  }
  else
  {
    // Actualizamos estadísticas
    num_llamadas_perdidas++;
  }

  // Generamos evento para la siguiente llamada BA
  suc nodo;
  nodo.suceso = SUCESO_LLEGADA_LLAMADA_AB;
  nodo.tiempo = reloj + genera_tllamadaAB(tllamadaA);
  insertar_lsuc(nodo);
}

void llegada_llamadaBA()
{
  //Veamos si hay líneas libres
  num_intentos++;
  if (lineas_libres > 0)
  {
    // Actualizamos estadísticas
    acum_lineas_ocupadas += (reloj-tdus_ocupadas)*num_lineas_ocupadas;
    tdus_ocupadas = reloj;
    num_lineas_ocupadas++;
    lineas_libres--;

    // Generamos evento fin llamada
    suc nodo;
    nodo.suceso = SUCESO_FIN_LLAMADA;
    nodo.tiempo = reloj + genera_dllamada(duracion_llamada);
    insertar_lsuc(nodo);
  }
  else
  {
    // Actualizamos estadísticas
    num_llamadas_perdidas++;
  }

  // Generamos evento para la siguiente llamada BA
  suc nodo;
  nodo.suceso = SUCESO_LLEGADA_LLAMADA_BA;
  nodo.tiempo = reloj + genera_tllamadaBA(tllamadaB);
  insertar_lsuc(nodo);
}


/* El generador de informes se encarga de calcular la media y desviacion tipica de los valores obtenidos */
void generador_informes(int simulaciones)
{
  float media[5], dt[5];
  int i,j;
  
  for(j=0; j<5; j++)
  	{
  	media[j] = 0;
  	for(i=0; i<simulaciones; i++)
  		media[j] += informe[i][j];
  	media[j] /= simulaciones;

  	dt[j] = 0;
  	for(i=0; i<simulaciones; i++)
		dt[j] += informe[i][j] * informe[i][j];
  	dt[j] = sqrt((dt[j]-simulaciones*media[j]*media[j]) / (simulaciones-1.0));
	}
	
  printf("\n\nINFORME ->");
  printf("\nNumero de líneas ocupadas media(%f), dt(%f)",media[0],dt[0]);
  printf("\nNumero de líneas ocupadas media en porcentaje(%f)%%, dt(%f)%%",media[1],dt[1]);
  printf("\nNumero de intentos de llamada: media(%f), dt(%f)",media[2],dt[2]);
  printf("\nNumero de llamadas perdidas: media(%f), dt(%f)",media[3],dt[3]);
  printf("\nNumero de llamadas perdidas en porcentaje: media(%f)%%, dt(%f)%%",media[4],dt[4]);
  printf("\n\n");
}


/* Generadores de datos */
// Generador de tiempos entre llegadas de trabajos
float genera_tllamadaAB(float tllamadaA)
{ return generador_exponencial(tllamadaA); }

float genera_tllamadaBA(float tllamadaB)
{ return generador_exponencial(tllamadaB); }

// Generador de tiempos de descarga
float genera_dllamada(float duracion_llamada)
{
  return generador_exponencial(duracion_llamada);
}

float generador_exponencial(float media)
{
  float u;
  u = (float) random();
  u = (float) (u/(RAND_MAX+1.0));
  return(-media*log(1-u));
}


/* Programa principal */
int main(int argc, char *argv[])
{
  int i, simulaciones;
  
  if(argc != 2)
  	{
	printf("\n\nFormato Argumentos -> <numero_simulaciones>\n\n");
	exit(1);
	}
	
  sscanf(argv[1],"%d",&simulaciones);

  informe = (float **) malloc (simulaciones*sizeof(float *));
  for(i=0; i<simulaciones; i++)
  	informe[i] = (float *) malloc (5*sizeof(float));

  srandom(time(NULL));
  //srandom(123456);
  for(cont_simu=0; cont_simu<simulaciones; cont_simu++)
  	{
	printf("\nSimulacion %d ...",cont_simu);
  	inicializacion();
  	while(parar==false){
		temporizacion();
		suceso();
		}
	}
  generador_informes(simulaciones);
	
  for(i=0; i<simulaciones; i++)
  	free(informe[i]);
  free(informe);
}
