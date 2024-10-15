#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <list>

using namespace std;

#define SUCESO_LLEGADA_LLAMADA_AB 0
#define SUCESO_LLEGADA_LLAMADA_BA 1
#define SUCESO_FIN_LLAMADA 2
#define SUCESO_FIN_SIMULACION 3


/* Variables de estado */
float reloj;
int lineas_libres;
float tdus_ocupadas;

typedef struct {
	int suceso;
	float tiempo;
	} suc;
list<suc> lsuc;
bool parar;
suc nodo;

/* Contadores estadisticos */
int num_llamadas_perdidas;
int num_lineas_ocupadas;
int num_intentos;
float acum_lineas_ocupadas;

float **informe;
int cont_simu;

/* Parametros de entrada */
int num_lineas = 50;
int N_LINEAS = num_lineas;
float duracion_llamada = 60*4;	// 4 minutos
float tllamadaA = 12;
float tllamadaB = 10;
float tparada = 12*3600; // 12 horas

/* Funciones y procedimientos */
void inicializacion();
void temporizacion();
void suceso();
void llegada_llamadaAB();
void llegada_llamadaBA();
void fin_llamada();
void fin_simulacion();
float genera_tllamadaAB(float tllamadaA);
float genera_tllamadaBA(float tllamadaB);
float genera_dllamada(float duracion_llamada);
float generador_exponencial(float media);
bool compare(const suc &s1, const suc &s2);
void insertar_lsuc(suc n);
bool busca_suceso(int tipo);
void generador_informes(int simulaciones);
