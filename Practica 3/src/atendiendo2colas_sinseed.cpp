#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <list>
#include <iostream>

using namespace std;

#define suceso_llegada1 0
#define suceso_llegada2 1
#define suceso_fin_atencion 2
#define suceso_elige_cola 3
#define suceso_finsimulacion 4

typedef struct {
    int suceso;
    float tiempo;
} suc;
list<suc> lsuc;
suc nodo;

float tparada;
float tlleg1, tlleg2;
float tserv1, tserv2;
int maxcola1, maxcola2; //tama�os maximos de las colas
int tipodecision; //regla de decision que se va a usar
int elige; //cola elegida por el servidor
float reloj;
bool libre;
int encola1, encola2;
float llegados, llegados1, llegados2;
float rechazados, rechazados1, rechazados2;
bool parar;
int simulaciones;
//para acumular para varias simulaciones
float acum_rechazados, acum_rechazados1, acum_rechazados2;
float acum_llegados;
float acum_porcrechazados, acum_porcrechazados1, acum_porcrechazados2; //porcentajes
float acum2_rechazados, acum2_rechazados1, acum2_rechazados2;
float acum2_porcrechazados, acum2_porcrechazados1, acum2_porcrechazados2;

const int x1 = 5;
const int x2 = 5;
const float prob = 0.3;


bool compare(const suc &s1, const suc &s2)
{ 
    return s1.tiempo < s2.tiempo; 
}


/* Inserta de forma ordenada un elemento en la lista de sucesos */
void insertar_lsuc(suc n)
{
    lsuc.push_back(n);
    // Mantener ordenada la lista por el tiempo de los sucesos
    lsuc.sort(compare);
}

/* Generadores de datos */
double uniforme() //Genera un n�mero uniformemente distribuido en el intervalo 
                  //[0,1) a partir de uno de los generadores disponibles en C.
{
    int t = rand();
    double f = ((double)RAND_MAX+1.0);
    return (double)t/f;
}
float generador_exponencial(float media)
{
    double u = uniforme();
    return(-media*log(1-u));
}

// Generador de tiempos entre llegadas (exponencial)
float generallegada(float media)
{ 
    return generador_exponencial(media); 
}

// Generador de tiempos de servicio (exponencial)
float generaservicio(float media)
{ 
    return generador_exponencial(media); 
}

/* Procedimiento inicializacion */
void inicializacion()
{
    //srand(time(NULL)); //se saca fuera para repetir las simulaciones
    while(!lsuc.empty()) {lsuc.pop_front();} //vacia la lista de sucesos de ejecuciones anteriores
    reloj = 0.0;
    libre = true;
    encola1 = 0; encola2 = 0;
    rechazados1 = 0; rechazados2 = 0;
    llegados = 0; llegados1 = 0; llegados2 = 0;
    nodo.suceso = suceso_llegada1;
    nodo.tiempo = reloj+generallegada(tlleg1);
    insertar_lsuc(nodo);
    nodo.suceso = suceso_llegada2;
    nodo.tiempo = reloj+generallegada(tlleg2);
    insertar_lsuc(nodo);
    nodo.suceso = suceso_finsimulacion;
    nodo.tiempo = reloj+tparada;
    insertar_lsuc(nodo); //tparada es un par�metro de entrada al programa
    parar = false;
}

/* Procedimiento temporizacion */
void temporizacion()
{
    nodo = lsuc.front();
    lsuc.pop_front();
    reloj = nodo.tiempo;
}

int regla_decision_larga(){
    //elegir cola m�s larga
    float prob = 0.5;
    if (encola1 < encola2) elige = 2;
    else if (encola2 < encola1) elige = 1;
        else {
            float u = uniforme();
            if (u < prob) elige = 1;
            else elige = 2;
        }
    return elige;
}

int regla_decision_al_azar(){
    //elegir al azar
    float prob = 0.5;
    float u = uniforme();
    if (u < prob) elige = 1;
    else elige = 2;
    return elige;
}

/**
 * @brief Relga de decision: Tiempo de espera mayor
 * Se escoge la cola en la que el cliente lleva más tiempo esperando
 */
int regla_decision_tiempo_espera_mayor()
{
    float t_lleg_1, t_lleg_2;
    list<suc>::iterator it=lsuc.begin();

    while(it->suceso!=suceso_llegada1)
        it++;

    t_lleg_1=reloj-it->tiempo;

    it=lsuc.begin();

     while(it->suceso!=suceso_llegada2)
        it++;

    t_lleg_2=reloj-it->tiempo;

    if(t_lleg_2<t_lleg_1)
        return 1;
    else
        return 2;
}

/**
 * @brief Regla de decisión: Elegir la cola más corta
 */
int regla_decision_cola_menor(){
    float prob = 0.5;
    if (encola1 < encola2) elige = 1;
    else if (encola2 < encola1) elige = 2;
    else 
    {
        float u = uniforme();
        if (u < prob) elige = 1;
        else elige = 2;
    }
    return elige;
}

/**
 * @brief Regla de decisión: Alternar entre colas
 */
int regla_decision_alternar(){
    if (elige == 1) elige = 2;
    else elige = 1;
    return elige;
}

/**
 * @brief Regla de decisión: Seguir con la misma cola x1 y x2 veces seguidas
 */
int regla_decision_seguir(){
    static int cont1 = 0;
    static int cont2 = 0;

    if (cont1 < x1) {
        elige = 1;
        cont1++;
    }
    else if (cont2 < x2) {
        elige = 2;
        cont2++;
    }

    if (cont1 == x1) cont2 = 0;
    if (cont2 == x2) cont1 = 0;

    return elige;
}

/**
 * @brief Regla de decisión: Elegir la cola que esté más llena en función de la capacidad
 * máxima de cada cola
 */
int regla_decision_llena(){
    float prob = 0.5;
    if ((float)encola1/maxcola1 < (float)encola2/maxcola2) elige = 1;
    else if ((float)encola2/maxcola2 < (float)encola1/maxcola1) elige = 2;
    else {
        float u = uniforme();
        if (u < prob) elige = 1;
        else elige = 2;
    }
    return elige;
}

/**
 * @brief Regla de decisión: Elegir la cola al azar con probabilidad distinta
 */
int regla_decision_probabilidad(){
    float prob = (float)(tlleg1)/(tlleg1+tlleg2);
    float u = uniforme();
    if (u < prob) elige = 1;
    else elige = 2;
    return elige;
}

int regla_decision(int tipo){
  
    switch(tipo)
        {
            case 1: elige = regla_decision_larga(); break;
            case 2: elige = regla_decision_al_azar(); break;
            case 3: elige = regla_decision_tiempo_espera_mayor(); break;
            case 4: elige = regla_decision_cola_menor(); break;
            case 5: elige = regla_decision_alternar(); break;
            case 6: elige = regla_decision_seguir(); break;
            case 7: elige = regla_decision_llena(); break;
            case 8: elige = regla_decision_probabilidad(); break;
        }
    return elige;
}

void llegada1()
{
    llegados1 ++;
    nodo.suceso = suceso_llegada1;
    nodo.tiempo = reloj+generallegada(tlleg1);
    insertar_lsuc(nodo);
    if (libre) {
        nodo.suceso = suceso_fin_atencion;
        nodo.tiempo = reloj+generaservicio(tserv1);
        insertar_lsuc(nodo);
        libre = false;
    }
    else if ((1+encola1) < maxcola1)
        encola1 ++;
    else rechazados1 ++;
}
     
void llegada2()
{
    llegados2 ++;
    nodo.suceso = suceso_llegada2;
    nodo.tiempo = reloj+generallegada(tlleg2);
    insertar_lsuc(nodo);
    if (libre) {
        nodo.suceso = suceso_fin_atencion;
        nodo.tiempo = reloj+generaservicio(tserv2);
        insertar_lsuc(nodo);
        libre = false;
    }
    else if ((1+encola2) < maxcola2)
        encola2 ++;
    else rechazados2 ++;
}

void fin_atencion()
{
    libre = true;
    nodo.suceso = suceso_elige_cola;
    nodo.tiempo = reloj;
    insertar_lsuc(nodo);
}

void elige_cola()
{
    if (encola1 == 0 && encola2 == 0) elige = 0; //no hace nada
    else if (encola1 == 0) elige = 2; //si solo hay gente en cola2 elige esa
        else if (encola2 == 0) elige = 1; //si solo hay gente en cola1 elige esa
            else elige = regla_decision(tipodecision); //si hay gente en las dos colas hay que decidir
    if (elige == 0) {}
    else if (elige == 1) {
        libre = false;
        encola1 --;
        nodo.suceso = suceso_fin_atencion;
        nodo.tiempo = reloj+generaservicio(tserv1);
        insertar_lsuc(nodo);
    }
    else { //elige=2
        libre = false;
        encola2 --;
        nodo.suceso = suceso_fin_atencion;
        nodo.tiempo = reloj+generaservicio(tserv2);
        insertar_lsuc(nodo);
    }
}

void fin()
{
    parar = true; //para detener la simulaci�n
    llegados = llegados1+llegados2;
    rechazados = rechazados1+rechazados2;
    /*
    printf("\nTotal llegados = %.3f",llegados);
    printf("\nTotal de rechazados = %.3f",rechazados);
    printf("\nRechazados en cola 1 = %.3f",rechazados1);
    printf("\nRechazados en cola 2 = %.3f",rechazados2);

    printf("\nPorcentaje total de rechazados = %.3f",(float)(rechazados)/llegados*100);
    printf("\nPorcentaje de rechazados en cola 1 = %.3f",(float)(rechazados1)/llegados1*100);
    printf("\nPorcentaje de rechazados en cola 2 = %.3f",(float)(rechazados2)/llegados2*100);
    printf("\n");
    */

    acum_llegados += llegados;
    acum_rechazados += rechazados;
    acum_rechazados1 += rechazados1;
    acum_rechazados2 += rechazados2;

    acum2_rechazados += rechazados*rechazados;
    acum2_rechazados1 += rechazados1*rechazados1;
    acum2_rechazados2 += rechazados2*rechazados2;

    acum_porcrechazados += (float)(rechazados)/llegados*100;
    acum_porcrechazados1 += (float)(rechazados1)/llegados1*100;
    acum_porcrechazados2 += (float)(rechazados2)/llegados2*100;

    acum2_porcrechazados += (float)(rechazados)/llegados*100 * (float)(rechazados)/llegados*100;
    acum2_porcrechazados1 += (float)(rechazados1)/llegados1*100 * (float)(rechazados1)/llegados1*100;
    acum2_porcrechazados2 += (float)(rechazados2)/llegados2*100 * (float)(rechazados2)/llegados2*100;
}

void reiniciar_sistema(){
    acum_rechazados = 0;
    acum_rechazados1 = 0;
    acum_rechazados2 = 0;
    acum_llegados = 0;
    acum_porcrechazados = 0;
    acum_porcrechazados1 = 0;
    acum_porcrechazados2 = 0;
    acum2_rechazados = 0;
    acum2_rechazados1 = 0;
    acum2_rechazados2 = 0;
    acum2_porcrechazados = 0;
    acum2_porcrechazados1 = 0;
    acum2_porcrechazados2 = 0;
    // limpiar sucesos
    lsuc.clear();
}


/* Procedimiento suceso */
void suceso()
{
    switch(nodo.suceso)
    {
        case suceso_llegada1: llegada1(); break;
        case suceso_llegada2: llegada2(); break;
        case suceso_fin_atencion: fin_atencion(); break;
        case suceso_elige_cola: elige_cola(); break;
        case suceso_finsimulacion: fin(); break;
    }
}

/* Procedimiento de informe final */
void informe()
/* se encarga de calcular la media y desviacion tipica de los valores obtenidos en las diferentes simulaciones */
{
    switch(tipodecision)
    {
        case 1: printf("\n\nRegla de decision usada: elegir la cola mas larga"); break;
        case 2: printf("\n\nRegla de decision usada: elegir la cola al azar"); break;
    }
    
    printf("\n\nValores medios y desviaciones tipicas de las medidas de rendimiento");
    printf("\nNumero de simulaciones = %d",simulaciones);

    printf("\n\nNumero medio de llegados = %.3f",acum_llegados/simulaciones);
    printf("\n\nNumero medio de rechazados = %.3f,  %.3f",acum_rechazados/simulaciones,sqrt(fabs(acum2_rechazados - acum_rechazados*acum_rechazados/simulaciones)/(simulaciones-1)));
    printf("\n\nNumero medio de rechazados en cola1 = %.3f,  %.3f",acum_rechazados1/simulaciones,sqrt(fabs(acum2_rechazados1 - acum_rechazados1*acum_rechazados1/simulaciones)/(simulaciones-1)));
    printf("\n\nNumero medio de rechazados en cola2 = %.3f,  %.3f",acum_rechazados2/simulaciones,sqrt(fabs(acum2_rechazados2 - acum_rechazados2*acum_rechazados2/simulaciones)/(simulaciones-1)));

    printf("\n\nPorcentaje medio de rechazados = %.3f,  %.3f",acum_porcrechazados/simulaciones,sqrt(fabs(acum2_porcrechazados - acum_porcrechazados*acum_porcrechazados/simulaciones)/(simulaciones-1)));
    printf("\n\nPorcentaje medio de rechazados en cola1 = %.3f,  %.3f",acum_porcrechazados1/simulaciones,sqrt(fabs(acum2_porcrechazados1 - acum_porcrechazados1*acum_porcrechazados1/simulaciones)/(simulaciones-1)));
    printf("\n\nPorcentaje medio de rechazados en cola2 = %.3f,  %.3f",acum_porcrechazados2/simulaciones,sqrt(fabs(acum2_porcrechazados2 - acum_porcrechazados2*acum_porcrechazados2/simulaciones)/(simulaciones-1)));
    printf("\n");
}

void informe_analisis()
{
    printf("%d\t%d\t%.3f\n", tipodecision, simulaciones, acum_porcrechazados/simulaciones);
}

int main(int argc, char *argv[])
{
    int i;
    int veces;

    if (argc != 11)
    {
        printf("\nFormato Argumentos -> <tlleg1 tlleg2 tserv1 tserv2 maxcola1 maxcola2 tipodecision tparada numero_simulaciones> <veces>");
        printf("\n\ntipodecision: 1 cola mas larga; 2 cola al azar\n\n");
        exit(1);
    }
    sscanf(argv[1],"%f",&tlleg1);
    sscanf(argv[2],"%f",&tlleg2);
    sscanf(argv[3],"%f",&tserv1);
    sscanf(argv[4],"%f",&tserv2);
    sscanf(argv[5],"%d",&maxcola1);
    sscanf(argv[6],"%d",&maxcola2);
    sscanf(argv[7],"%d",&tipodecision);
    sscanf(argv[8],"%f",&tparada);
    sscanf(argv[9],"%d",&simulaciones);
    sscanf(argv[10], "%d", &veces);
    
    // srand(time(NULL));
    srand(123456);
    for (int v = 0; v < veces; v++) 
    {
        for (i=0; i<simulaciones; i++)
        {
            inicializacion();
            while (!parar)
            {
                temporizacion();
                suceso();
            }
        }
        informe_analisis();
        reiniciar_sistema();
    }
    // informe();
}
