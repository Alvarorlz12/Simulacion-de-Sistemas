//  ***************************************************************************
//  ***************************************************************************
//  ***
//  ***  PROBLEMA: MÁQUINA ESTAMPADORA
//  ***
//  ***  @author Jose Pineda (josepise@correo.ugr.es)
//  ***  @author Álvaro Ruiz (alvaroruiz27@correo.ugr.es)
//  ***************************************************************************
//  ***************************************************************************

#include <stdio.h>
#include <iostream>
#include <math.h>
#include <stdlib.h>
#include <time.h>

using namespace std;

// ****************************************************************************

const int NUM_ESTADOS = 5;
const int ESTADO_INICIAL = 0;
const double COSTE_AJUSTE = 10.0;
const int FACTOR_COSTE_PARES = 4;
const int NUM_PARES[NUM_ESTADOS] = {0, 1, 2, 2, 3};

int veces;  // Número de veces que se ejecuta el bucle
int max_estampaciones;  // Número de estampaciones que se van a realizar
double **tabla_estados; // Tabla de estados de la máquina estampadora
int *frecuencia_estados; // Frecuencia de los estados de la máquina
int estado_actual = ESTADO_INICIAL;
double coste = 0.0;
double media_coste = 0.0;
double media_est_mantenimiento = 0.0;
double media_est_man_total = 0.0;
int num_mantenimientos = 0;
int num_mantenimientos_total = 0;
int ultima_estampacion = 0;

/**
 * @brief Estructura de datos que representa una regla de mantenimiento
 *       de la máquina estampadora
 */
struct ReglaMantenimiento {
    int estado = -1;    // Estado en el que se aplica la regla
    int estampaciones_realizadas = -1;   // Número de estampaciones realizadas
};

/**
 * @brief Función que genera un número aleatorio entre 0 y 1 siguiendo una 
 *        distribución uniforme
 * @return Número aleatorio en el intervalo [0, 1)
 */
double uniforme(void)
{
    double u;
    u = (double) rand();
    u = u/(double)(RAND_MAX+1.0);
    return u;
}

/**
 * @brief Función para construir la tabla de estados de la máquina estampadora
 * @param fichero Nombre del fichero que contiene la tabla de estados
 * @post La variable 'tabla_estados' contiene la tabla de estados
 */
void construir_tabla_estados(char *fichero)
{
    FILE *f;
    int i, j;

    f = fopen(fichero, "r");
    if (f == NULL)
    {
        printf("Error al abrir el fichero %s\n", fichero);
        exit(-1);
    }

    tabla_estados = (double **) malloc(NUM_ESTADOS * sizeof(double *));
    for (i = 0; i < NUM_ESTADOS; i++)
    {
        tabla_estados[i] = (double *) malloc(NUM_ESTADOS * sizeof(double));
        for (j = 0; j < NUM_ESTADOS; j++)
        {
            if (fscanf(f, "%lf", &tabla_estados[i][j]) != 1) {
                printf("Error al leer el fichero %s\n", fichero);
                exit(-1);
            }
        }
    }

    // Actualizamos la tabla para que las probabilidades sean acumuladas
    // El nuevo valor de cada casilla será su valor sumado al de la casilla anterior
    for (i = 0; i < NUM_ESTADOS; i++)
    {
        for (j = 1; j < NUM_ESTADOS; j++)
        {
            tabla_estados[i][j] += tabla_estados[i][j - 1];
        }
    }

    fclose(f);

    // Inicializar frecuencia de estados
    frecuencia_estados = (int *) malloc(NUM_ESTADOS * sizeof(int));
    for (i = 0; i < NUM_ESTADOS; i++)
    {
        frecuencia_estados[i] = 0;
    }
}

/**
 * @brief Función que libera la memoria de la tabla de estados
 */
void liberar_tabla_estados(void)
{
    for (int i = 0; i < NUM_ESTADOS; i++)
    {
        free(tabla_estados[i]);
    }
    free(tabla_estados);
    free(frecuencia_estados);
}

/**
 * @brief Función que muestra la tabla de estados por pantalla
 */
void mostrar_tabla_estados(void)
{
    cout << "Tabla de estados:" << endl;
    for (int i = 0; i < NUM_ESTADOS; i++)
    {
        for (int j = 0; j < NUM_ESTADOS; j++)
        {
            printf("%lf ", tabla_estados[i][j]);
        }
        printf("\n");
    }
}

/**
 * @brief Función que simula el siguiente estado de la máquina estampadora
 *        El siguiente estado se calcula en función del estado actual y de un
 *        número aleatorio. Puede ser el mismo estado en el que se encuentra.
 *        El conjunto de estados posibles de transición se encuentra en la 
 *        variable 'tabla_estados'.
 * @return Siguiente estado de la máquina
 */
int siguiente_estado(void)
{
    double u = uniforme();
    int i = 0;

    while (u > tabla_estados[estado_actual][i])
    {
        i++;
    }

    return i;
}

/**
 * @brief Función que simula un estampado. Actualiza el coste de las estampaciones 
 *        en función del estado actual de la máquina y del número de pares desajustados
 * @post La variable 'coste' contiene el coste actualizado
 */
void estampar(void)
{
    coste += NUM_PARES[estado_actual] * FACTOR_COSTE_PARES;
}

/**
 * @brief Función para aplicar el mantenimiento de la máquina
 * @param regla Regla de mantenimiento a aplicar
 * @param estampaciones_realizadas Número de estampaciones realizadas
 * @post La máquina se encuentra en el estado de inicio
 *      El coste se incrementa en el coste de ajuste
 */
void mantenimiento(const ReglaMantenimiento &regla, const int &estampaciones_realizadas)
{
    bool mantenimiento = false;
    // Si se cumple la regla de mantenimiento (cuando se puede ver el estado, estado!=-1)
    if (regla.estado != -1 && estado_actual >= regla.estado)
    {
        estado_actual = ESTADO_INICIAL;
        coste += COSTE_AJUSTE;
        mantenimiento = true;
    }
    // Si se cumple la regla de mantenimiento (cuando no se puede ver el estado, estado==-1)
    else if (regla.estampaciones_realizadas != -1 && 
        estampaciones_realizadas % regla.estampaciones_realizadas == 0)
    {
        estado_actual = ESTADO_INICIAL;
        coste += COSTE_AJUSTE;
        mantenimiento = true;
    }
    // Si se ha realizado mantenimiento
    if (mantenimiento)
    {
        num_mantenimientos++;
        media_est_mantenimiento += estampaciones_realizadas - ultima_estampacion;
        ultima_estampacion = estampaciones_realizadas;
    }
}

// ****************************************************************************

int main (int argc, char *argv[])
{
    if (argc != 6)
    {
        printf("Uso: %s <fichero_tabla_estados> <veces> <max_estampaciones> <estado_regla> <estampaciones_regla>\n", argv[0]);
        exit(-1);
    }

    // srand(time(NULL));
    srandom(123456789);

    construir_tabla_estados(argv[1]);
    veces = atoi(argv[2]);
    max_estampaciones = atoi(argv[3]);
    // Crear regla de mantenimiento
    ReglaMantenimiento regla;
    int estado_regla = atoi(argv[4]);
    // Si estado_regla es -1 no se aplica la regla
    // Si estado_regla está entre [1,5] se establece en el estado
    //    y por la forma en la que se ha introducido el estado, se resta 1
    if (estado_regla >= 1 && estado_regla <= NUM_ESTADOS)
    {
        regla.estado = estado_regla - 1;
    } else if (estado_regla != -1){
        cout << "El estado de la regla de mantenimiento no es válido" << endl;
        exit(-1);
    }
    // Si estampaciones_regla está entre [0,1] se establece en el porcentaje de estampaciones
    // Si estampaciones_regla es mayor que 1 se establece en el número de estampaciones
    double estampaciones_regla = atof(argv[5]);
    if (estampaciones_regla >= 0 && estampaciones_regla < 1)
    {
        regla.estampaciones_realizadas = max_estampaciones * estampaciones_regla;
    }
    else if (estampaciones_regla >= 1)
    {
        regla.estampaciones_realizadas = (int)estampaciones_regla;
        if (regla.estampaciones_realizadas > max_estampaciones)
        {
            cout << "El número de estampaciones de la regla de mantenimiento no \
                     puede ser mayor que el número de estampaciones" << endl;
            exit(-1);
        }
    } else if (estampaciones_regla != -1){
        cout << "El número de estampaciones de la regla de mantenimiento no es válido" << endl;
        exit(-1);
    }

    // Verificar que veces es un número positivo
    if (veces <= 0)
    {
        cout << "El número de veces debe ser un número positivo" << endl;
        exit(-1);
    }
    // Verificar que max_estampaciones es un número positivo
    if (max_estampaciones <= 0)
    {
        cout << "El número de estampaciones debe ser un número positivo" << endl;
        exit(-1);
    }

    cout << regla.estampaciones_realizadas << endl;

    // Mostrar tabla de estados
    // mostrar_tabla_estados();

    // Simulación de la máquina estampadora
    for (int i = 0; i < veces; i++)
    {
        estado_actual = ESTADO_INICIAL;
        coste = 0.0;
        num_mantenimientos = 0;
        ultima_estampacion = 0;
        media_est_mantenimiento = 0.0;
        for (int j = 0; j < max_estampaciones; j++)
        {
            // 1. Comprobar si se aplica mantenimiento
            mantenimiento(regla, j+1);
            // 2. Estampar
            estampar();
            // 3. Actualizar frecuencia de estados
            frecuencia_estados[estado_actual]++;
            // 4. Calcular siguiente estado
            estado_actual = siguiente_estado();
        }
        double coste_simulacion = coste / max_estampaciones;
        double media_est_mantenimiento_simulacion = media_est_mantenimiento / num_mantenimientos;
        media_coste += coste_simulacion;
        num_mantenimientos_total += num_mantenimientos;
        media_est_man_total += media_est_mantenimiento_simulacion;
        cout << i << "\t" << coste_simulacion << "\t" 
             << media_est_mantenimiento_simulacion << "\t" << num_mantenimientos << endl;
    }

    // Calcular media de coste, media de estampaciones entre mantenimientos y número de mantenimientos
    media_coste /= veces;
    media_est_man_total /= veces;
    double media_mantenimientos = (double)num_mantenimientos_total / veces;

    // Mostrar resultado final
    cout << "Med: " << "\t" << media_coste << "\t" << media_est_man_total
         << "\t" << media_mantenimientos << endl; 

    // Mostrar frecuencia de estados
    for (int i = 0; i < NUM_ESTADOS-1; i++)
    {
        cout << (double)frecuencia_estados[i]/(veces*max_estampaciones) << "\t";
    }
    cout << (double)frecuencia_estados[NUM_ESTADOS-1]/(veces*max_estampaciones) << endl;

    liberar_tabla_estados();
    return 0;
}