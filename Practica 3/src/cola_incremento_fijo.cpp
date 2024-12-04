// *****************************************************************************
// *****************************************************************************
// *** MODELO DE SIMULACIÓN DISCRETO CON INCREMENTO FIJO
// *****************************************************************************
// *****************************************************************************

#include <iostream>
#include <cmath>
#include <cstdlib>
#include <ctime>
#include <chrono>
#include <iomanip>

using namespace std;

// *****************************************************************************
// *** Variables y constantes globales
// *****************************************************************************

const double infinito = 10e30;
int atendidos = 0;
double inicio_ocio = 0.0;
double acum_cola = 0.0;
double reloj = 0.0;
bool servidor_libre = true;
int encola = 0;
double tiempo_llegada;
double tiempo_salida = infinito;
double ocio = 0.0;
double tultsuc = 0.0;
const int total_a_atender = 100000; 
double tlleg = 0.2; 
double tserv = 0.15;

// *****************************************************************************
// *** Funciones
// *****************************************************************************

/**
 * @brief Genera un número aleatorio con distribución exponencial.
 * @param tlleg Tiempo medio de llegada.
 * @return Número aleatorio con distribución exponencial.
 */
int generallegada(double tlleg) {
    double u = static_cast<double>(rand()) / (RAND_MAX + 1.0);
    int x = (int)round(-tlleg * log(1 - u));
    if (x == 0) {
        x = 1;
    }
    return x;
}

/**
 * @brief Genera un número aleatorio con distribución exponencial.
 * @param tserv Tiempo medio de servicio.
 * @return Número aleatorio con distribución exponencial.
 */
int generaservicio(double tserv) {
    double u = static_cast<double>(rand()) / (RAND_MAX + 1.0);
    int x = (int)round(-tserv * log(1 - u));
    if (x == 0) {
        x = 1;
    }
    return x;
}

/**
 * @brief Inicializa las variables de estado.
 * @return void
 */
void inicializar() {
    atendidos = 0;
    inicio_ocio = 0.0;
    acum_cola = 0.0;
    reloj = 0.0;
    servidor_libre = true;
    encola = 0;
    tiempo_llegada = 0.0;
    tiempo_salida = infinito;
    ocio = 0.0;
    tultsuc = 0.0;
}

// *****************************************************************************
// *** Función principal
// *****************************************************************************

int main(int argc, char *argv[]) {

    srand(time(NULL));  // Inicializamos el generador de números aleatorios

    // Comprobamos los argumentos
    if (argc != 4) {
        cout << "Error: número de argumentos incorrecto." << endl;
        cout << "Uso: " << argv[0] << " <num_simulaciones> <tlleg> <tserv>" << endl;
        return 1;
    }

    // Obtenemos los argumentos
    const int num_simulaciones = atoi(argv[1]);
    tlleg=atof(argv[2]); 
    tserv=atof(argv[3]);

    // Realizamos las simulaciones
    for (int i = 0; i < num_simulaciones; i++) {
        // Inicializamos las variables de estado
        inicializar();

        // Tomar el tiempo de inicio
        auto start = chrono::high_resolution_clock::now();

        // Realizamos la simulación
        // Generamos llegada del primer cliente
        tiempo_llegada = reloj + generallegada(tlleg);

        while (atendidos < total_a_atender) {
            if (reloj == tiempo_llegada) {
                tiempo_llegada = reloj + generallegada(tlleg);
                if (servidor_libre) {
                    servidor_libre = false;
                    tiempo_salida = reloj + generaservicio(tserv);
                    ocio += reloj - inicio_ocio;
                } else {
                    acum_cola += (reloj - tultsuc) * encola;
                    tultsuc = reloj;
                    encola++;
                }
            }
            if (reloj == tiempo_salida) {
                atendidos++;
                if (encola > 0) {
                    acum_cola += (reloj - tultsuc) * encola;
                    tultsuc = reloj;
                    encola--;
                    tiempo_salida = reloj + generaservicio(tserv);
                } else {
                    servidor_libre = true;
                    inicio_ocio = reloj;
                    tiempo_salida = infinito;
                }
            }
            reloj++;
        }

        // Tomar el tiempo de fin
        auto end = chrono::high_resolution_clock::now();
        auto duration = chrono::duration_cast<chrono::milliseconds>(end - start).count()/1000.0;

        double porcent_ocio = ocio * 100 / reloj;
        double media_encola = acum_cola / reloj;
        cout << i << "\t" << media_encola << "\t" << porcent_ocio << "\t"
             << setprecision(10) << duration << endl;
    }

    return 0;
}