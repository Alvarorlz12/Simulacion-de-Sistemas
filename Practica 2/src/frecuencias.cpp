/**
 * @file frecuencias.cpp
 * @brief Programa auxiliar para calcular la frecuencia relativa de los valores
 *       generados por un generador de números aleatorios
 * @note Este programa se ha generado para la práctica 2 de Simulación de Sistemas
 */

#include <iostream>
#include <time.h>
#include <fstream>
#include <vector>
#include <string>

/**
 * @brief Función que calcula la frecuencia relativa de los valores generados
 *        por un generador de números aleatorios
 * @param filename Nombre del fichero que contiene los valores generados
 * @param tama Tamaño de la tabla
 */
void calcularFrecuenciaRelativa(const std::string &filename, int tama) {
    std::vector<int> frecuencia(tama, 0);
    std::ifstream file(filename);
    int valor;
    // Calcular el número de valores en el fichero
    int num_valores = 0;

    if (!file.is_open()) {
        std::cerr << "Error al abrir el fichero " << filename << std::endl;
        exit(-1);
    }

    while (file >> valor) {
        if (valor > 0 && valor <= tama) {
            frecuencia[valor]++;
            num_valores++;
        }
    }

    for (int i = 0; i < tama; ++i) {
        std::cout  << i+1 << "\t" << static_cast<double>(frecuencia[i]) / num_valores << std::endl;
    }
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        std::cerr << "Error en los parámetros de entrada" << std::endl;
        std::cerr << "Formato: ./frequency_calculator <fichero_valores> <tamano_tabla>" << std::endl;
        return -1;
    }

    int tama = std::stoi(argv[2]);
    calcularFrecuenciaRelativa(argv[1], tama);

    return 0;
}
