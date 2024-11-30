// *****************************************************************************
// *****************************************************************************
// *** MODELO DE SIMULACIÓN DISCRETO CON INCREMENTO FIJO
// *****************************************************************************
// *****************************************************************************

#include <iostream>
#include <cmath>
#include <cstdlib>
#include <ctime>

using namespace std;

// *****************************************************************************
// *** Variables y constantes globales
// *****************************************************************************

const double infinito = 10e30;
const int total_a_atender = 10000; 
double tlleg = 0.2; 
double tserv = 0.15;
int atendidos = 0;
int encola = 0;
double inicio_ocio = 0.0;
double acum_cola = 0.0;
double reloj = 0.0;
bool servidor_libre = true;
double tiempo_llegada;
double tiempo_salida = infinito;
double ocio = 0.0;
double tultsuc = 0.0;

// *****************************************************************************
// *** Funciones
// *****************************************************************************

/**
 * @brief Genera un número aleatorio con distribución exponencial.
 * @param tlleg Tiempo medio de llegada.
 * @return Número aleatorio con distribución exponencial.
 */
double generallegada(double tlleg) {
    double u = static_cast<double>(rand()) / (RAND_MAX + 1.0);
    return -tlleg * log(1 - u);
}

/**
 * @brief Genera un número aleatorio con distribución exponencial.
 * @param tserv Tiempo medio de servicio.
 * @return Número aleatorio con distribución exponencial.
 */
double generaservicio(double tserv) {
    double u = static_cast<double>(rand()) / (RAND_MAX + 1.0);
    return -tlleg * log(1 - u);
}

/**
 * @brief Función para iniciar las variables de estado (globales)
 * @return void
 */
void inicializar() {
    atendidos = 0;
    encola = 0;
    inicio_ocio = 0.0;
    acum_cola = 0.0;
    reloj = 0.0;
    servidor_libre = true;
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

    // Comprobamos que el número de argumentos sea correcto
    if (argc != 4) {
        cout << "Error: número de argumentos incorrecto." << endl;
        cout << "Uso: " << argv[0] << " <num_simulaciones> <tlleg> <tserv>" << endl;
        return 1;
    }

    // Obtenemos el número de simulaciones
    const int num_simulaciones = atoi(argv[1]);
    tlleg=atof(argv[2]); 
    tserv=atof(argv[3]);

    // Realizamos las simulaciones
    for (int i = 0; i < num_simulaciones; i++) {
        // Inicializamos las variables de estado
        inicializar();

        // Realizamos la simulación
        // Generamos llegada del primer cliente
        tiempo_llegada = reloj + generallegada(tlleg);

        while (atendidos < total_a_atender)
        {
            reloj = min(tiempo_llegada,tiempo_salida); //una función que calcula el mínimo
            if (reloj == tiempo_llegada)
            {
                tiempo_llegada = reloj + generallegada(tlleg);

                if (servidor_libre)
                {
                    servidor_libre = false;
                    tiempo_salida = reloj + generaservicio(tserv);
                    ocio += reloj - inicio_ocio;
                }
                else 
                {
                    acum_cola += (reloj - tultsuc) * encola;
                    tultsuc = reloj;
                    encola++;
                }
            }
            if (reloj == tiempo_salida)
            {
                atendidos++;
                if (encola > 0)
                {
                    acum_cola += (reloj - tultsuc) * encola;
                    tultsuc = reloj;
                    encola--;
                    tiempo_salida = reloj + generaservicio(tserv);
                }
                else 
                {
                    servidor_libre = true;
                    inicio_ocio = reloj;
                    tiempo_salida = infinito;
                }
            }
        }

        double porcent_ocio = ocio * 100 / reloj;
        double media_encola = acum_cola / reloj;
        cout << i << "\t" << media_encola << "\t" << porcent_ocio << endl;
    }


    return 0;
}