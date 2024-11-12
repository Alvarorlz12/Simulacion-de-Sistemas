/**
 * @file generador_continuo.cpp
 * @brief Fichero con generadores de datos continuos
 */

#include <iostream>
#include <iomanip>
#include <chrono>
#include <cmath>

using namespace std;

// *****************************************************************************
// *** VARIABLES
// *****************************************************************************

double a; // Parámetro a de la distribución

// *****************************************************************************
// *** GENERADORES
// *** Generadores para la función de distribución:
// ***
// *** f(x) = a + 2(1-a)x, 0 <= x <= 1 ; 0 en otro caso
// ***
// *****************************************************************************

/**
 * @brief Generador de valor uniforme en [0, 1)
 * @return Valor generado
 */
double uniforme(){
    int t = rand();
    double f = ((double)RAND_MAX+1.0);
    return (double)t/f;
}

/**
 * @brief GENERADOR DE DATOS CONTINUOS POR MÉTODO DE INVERSIÓN
 * @return Valor generado
 */
double generador_continuo_inversion(void) {
    double u = uniforme();
    return (-a + sqrt( a*a + 4*u*(1-a) ))/( 2*(1-a) );
}

/**
 * @brief GENERADOR DE DATOS CONTINUOS POR MÉTODO DE ACEPTACIÓN-RECHAZO
 * @return Valor generado
 */
double generador_continuo_aceptacion_rechazo(void) {
    double u2, x, y;
    const double c = 2-a;
    do {
        x = uniforme();
        u2 = uniforme();
        y = c * u2;
    } while (y > (a + 2*(1-a)*x));
    return x;
}

/**
 * @brief GENERADOR DE DATOS CONTINUOS POR MÉTODO DE COMPOSICIÓN
 *        f(x) = a*f1(x) + (1-a)*f2(x)
 *        f1(x) = (1/a) * a => F1(x) = x
 *        f2(x) = (1/(1-a)) * 2(1-a)x => F2(x) = x^2
 * @return Valor generado
 */
double generador_continuo_composicion(void) {
    double u1, u2;
    double x;
    u1 = uniforme();
    u2 = uniforme();
    if (u1 < a) {
        x = u2;
    } else {
        x = sqrt(u2);
    }
    return x;
}


// *****************************************************************************
// *** MAIN
// *****************************************************************************

int main(int argc, char *argv[]) {

    int valores; // Número de valores a generar
    int modo; // Modo de generación
    int semilla; // Semilla para el generador de números aleatorios
    bool medir_tiempo; // Determina si se mide el tiempo de ejecución 
    // Flujo de string para almacenar los valores generados
    stringstream ss;

    // Comprobar los parámetros de entrada
    if (argc != 6) {
        cout << "Error en los parámetros de entrada" << endl;
        cout << "Formato: ./generador_continuo <valores> <a> <modo> <medir_tiempo> <semilla>" << endl;
        cout << "Modo: 0 -> Inversión, 1 -> Aceptación-Rechazo" << endl;
        exit(-1);
    }

    // Obtener los parámetros de entrada
    valores = atoi(argv[1]);
    a = atof(argv[2]);
    modo = atoi(argv[3]);
    medir_tiempo = atoi(argv[4]);
    semilla = atoi(argv[5]);

    // Inicializar la semilla para comparar resultados
    if (semilla != -1)
        srandom(semilla);
    else srand(time(NULL));

    auto start = chrono::high_resolution_clock::now();

    // Generar valores
    if (modo == 0) {
        for (int i = 0; i < valores; i++) {
            double valor = generador_continuo_inversion();
            ss << valor << endl;
        }
    } else if (modo == 1) {
        for (int i = 0; i < valores; i++) {
            double valor = generador_continuo_aceptacion_rechazo();
            ss << valor << endl;
        }
    } else if (modo == 2) {
        for (int i = 0; i < valores; i++) {
            double valor = generador_continuo_composicion();
            ss << valor << endl;
        }
    } else {
        cout << "Modo no válido" << endl;
        exit(-1);
    }

    auto end = chrono::high_resolution_clock::now();
    double time = chrono::duration_cast<chrono::milliseconds>(end - start).count()/1000.0;

    // Mostrar tiempo de ejecución
    if (medir_tiempo)
        cout << modo << "\t" << a << "\t" << valores << "\t" << time << endl;
    else
        cout << ss.str();

    return 0;
}
