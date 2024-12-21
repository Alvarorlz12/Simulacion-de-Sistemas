/**
 * @file comparador.cpp
 * @brief Programa para comparar las salidas de dos sistemas de colas
 */

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        cout << "Uso: " << argv[0] << " <fichero1> <fichero2>" << endl;
        return 1;
    }

    ifstream f1(argv[1]);
    ifstream f2(argv[2]);

    if (!f1.is_open() || !f2.is_open())
    {
        cout << "Error al abrir los ficheros" << endl;
        return 1;
    }

    string linea1, linea2;
    int veces_1_mejor_2 = 0;
    float pct_1, pct_2;
    while (getline(f1, linea1) && getline(f2, linea2))
    {
        pct_1 = stof(linea1.substr(linea1.find_last_of("\t"), linea1.size()));
        pct_2 = stof(linea2.substr(linea2.find_last_of("\t"), linea2.size()));

        if (pct_1 < pct_2)
        {
            veces_1_mejor_2++;
        }
    }

    cout << veces_1_mejor_2 << endl;

    f1.close();
    f2.close();

    return 0;
}