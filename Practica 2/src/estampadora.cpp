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

double **tabla_estados;
const int NUM_ESTADOS = 5;
const int ESTADO_INICIAL = 0;
const double COSTE_AJUSTE = 10.0;
const int FACTOR_COSTE_PARES = 4;
const int NUM_PARES[NUM_ESTADOS] = {0, 1, 2, 2, 3};

int estado_actual = ESTADO_INICIAL;
double coste = 0.0;
int max_estampaciones;

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
            fscanf(f, "%lf", &tabla_estados[i][j]);
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
 * @brief Función que actualiza el coste de las estampaciones en función del
 *        estado actual de la máquina y del número de pares desajustados
 * @post La variable 'coste' contiene el coste actualizado
 */
void actualizar_coste(void)
{
    coste += NUM_PARES[estado_actual] * FACTOR_COSTE_PARES;
}

/**
 * @brief Función para aplicar el mantenimiento de la máquina
 */
void mantenimiento(void)
{
    
}

// ****************************************************************************

int main (int argc, char *argv[])
{

    if (argc != 3)
    {
        printf("Uso: %s <fichero_tabla_estados> <max_estampaciones> \n", argv[0]);
        exit(-1);
    }

    srand(time(NULL));

    construir_tabla_estados(argv[1]);
    max_estampaciones = atoi(argv[2]);

    // Mostrar tabla de estados
    mostrar_tabla_estados();

    // Simulación de la máquina estampadora
    for (int i = 0; i < max_estampaciones; i++)
    {
        estado_actual = siguiente_estado();
        actualizar_coste();
        // cout << "Estado actual: " << estado_actual+1 << endl;
        // cout << "Coste actual: " << coste << endl;
    }

    // Mostrar resultado final
    cout << "Coste final: " << coste << endl;

    liberar_tabla_estados();
    return 0;
}