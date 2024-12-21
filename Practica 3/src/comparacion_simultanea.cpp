/**
 * @file comparacion_simultanea.cpp
 * @brief Programa para comparar simultáneamente las salidas de k sistemas
 */

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iomanip>
#include <cmath>
#include <algorithm>
#include <math.h>
#include <numeric>

using namespace std;

typedef struct {
    int id;
    float media_primera_etapa = 0.0;
    float varianza_primera_etapa = 0.0;
    int num_simulaciones_totales = 0;
    float media_segunda_etapa = 0.0;
    float w1 = 0.0;
    float w2 = 0.0;
    float media_ponderada = 0.0;
} sistema;

vector<sistema> sistemas;
int k = 0;
const double h = 2.583;
double D_ast = 0.0;
const int N0 = 20;

// /////////////////////////////////////////////////////////////////////////////
// Funciones auxiliares
// /////////////////////////////////////////////////////////////////////////////

double mean(const vector<double>& data) {
    double sum = 0.0;
    for (double x : data) {
        sum += x;
    }
    return sum / data.size();
}

double variance(const vector<double>& data, double mean) {
    double sum = 0.0;
    for (double x : data) {
        sum += (x - mean) * (x - mean);
    }
    return sum / (data.size() - 1);
}

void cargar_resultados(string fichero, int k)
{
    ifstream f1(fichero);
    string linea;
    for (int i = 0; i < k; i++) {
        getline(f1, linea);
        stringstream ss(linea);
        sistema sistema;
        ss >> sistema.id
           >> sistema.media_primera_etapa
           >> sistema.varianza_primera_etapa
           >> sistema.num_simulaciones_totales;
        sistemas.push_back(sistema);
    }
    getline(f1, linea); // línea con d*
    D_ast = stod(linea);

    f1.close();
}

// /////////////////////////////////////////////////////////////////////////////
// PRIMERA ETAPA: Cálculo de estadísticos sobre N0 iteraciones
// /////////////////////////////////////////////////////////////////////////////

void calcular_d_ast()
{
    // Obtener las dos medias más pequeñas
    // vector<double> medias;
    // for (int i = 0; i < sistemas.size(); i++)
    // {
    //     medias.push_back(sistemas[i].media_primera_etapa);
    // }

    // sort(medias.begin(), medias.end());

    // D_ast = (medias[0] - medias[1])/2;
    D_ast = 1.0;
}

void calcular_num_simulaciones()
{
    int n1, n2;
    for (int i = 0; i < sistemas.size(); i++)
    {
        n1 = N0 + 1;
        n2 = (ceil)((pow(h,2) * sistemas[i].varianza_primera_etapa) / pow(D_ast, 2));
        sistemas[i].num_simulaciones_totales = max(n1, n2);
    }
}

void mostrar_primera_etapa(string fichero) {
    ofstream f1(fichero);
    f1 << setprecision(3) << fixed;
    // cout << setw(6) << " i " << setw(16) << " Media etapa 1 " << setw(16) << " Varianza etapa 1 " << setw(9) << "  Ni  "<< endl;
    for (int i = 0; i < sistemas.size(); i++)
    {
        f1 << setw(6) << sistemas[i].id << setw(16) << sistemas[i].media_primera_etapa << setw(16) << sistemas[i].varianza_primera_etapa << setw(9) << sistemas[i].num_simulaciones_totales << endl;
    }
    f1 << D_ast << endl;    // Guardamos el valor de d*
}

void almacenar_n(string fichero)
{
    ofstream f1(fichero);
    char sid = 'a';
    for (int i = 0; i < sistemas.size(); i++)
    {
        f1 << "N" << sid << "=" << sistemas[i].num_simulaciones_totales << endl;
        sid++;
    }
    f1.close();
}

void primera_etapa(string fichero)
{
    ifstream f1(fichero);

    string linea;
    double media, varianza;

    getline(f1, linea); 
    stringstream ss(linea);

    // Obtenemos la media y la varianza
    ss >> media >> varianza;
    varianza = pow(varianza, 2); // El valor que se obtiene es la desviación típica

    k++;    // Incrementamos el número de sistemas

    // Creamos un sistema con los datos obtenidos
    sistema s;
    s.id = k;
    s.media_primera_etapa = media;
    s.varianza_primera_etapa = varianza;

    sistemas.push_back(s);  // Añadimos el sistema al vector

    f1.close();
    // ifstream f1(fichero);

    // string linea;
    // vector<double> pct;

    // // Obtenemos los porcentajes de cada iteración
    // while (getline(f1, linea))
    // {
    //     pct.push_back(stod(linea.substr(linea.find_last_of("\t"), linea.size())));
    // }

    // // Calculamos la media y la varianza
    // double media = mean(pct);
    // double varianza = variance(pct, media);

    // k++;    // Incrementamos el número de sistemas

    // // Creamos un sistema con los datos obtenidos
    // sistema s;
    // s.id = k;
    // s.media_primera_etapa = media;
    // s.varianza_primera_etapa = varianza;

    // sistemas.push_back(s);  // Añadimos el sistema al vector

    // f1.close();
}

// /////////////////////////////////////////////////////////////////////////////
// SEGUNDA ETAPA: Cálculo de estadísticos sobre Ni iteraciones
// /////////////////////////////////////////////////////////////////////////////

void segunda_etapa(string fichero, int idx)
{
    ifstream f1(fichero);

    string linea;
    double media, varianza;
    
    getline(f1, linea);
    stringstream ss(linea);

    // Obtenemos la media y la varianza
    ss >> media >> varianza;
    varianza = pow(varianza, 2); // El valor que se obtiene es la desviación típica

    // Actualizamos el sistema con los datos obtenidos
    sistemas[idx].media_segunda_etapa = media;
    sistemas[idx].varianza_primera_etapa = varianza;

    f1.close();
    // ifstream f1(fichero);

    // string linea;
    // vector<double> pct;

    // // Obtenemos los porcentajes de cada iteración restante
    // for (int i = 0; i < N0; i++) {
    //     getline(f1, linea);
    // }
    // while (getline(f1, linea))
    // {
    //     pct.push_back(stod(linea.substr(linea.find_last_of("\t"), linea.size())));
    // }

    // // Calculamos la media y la varianza
    // double media = mean(pct);
    // double varianza = variance(pct, media);

    // // Actualizamos el sistema con los datos obtenidos
    // sistemas[idx].media_segunda_etapa = media;
    // sistemas[idx].varianza_primera_etapa = varianza;

    // f1.close();
}


pair<double,double> calcular_pesos(sistema s)
{
    double termino_corchetes=(1-((s.num_simulaciones_totales-N0)*pow(D_ast,2))/(pow(h,2)*s.varianza_primera_etapa));
    s.w1=(N0/s.num_simulaciones_totales)*(1+pow(1-(s.num_simulaciones_totales/N0)*termino_corchetes, 1/2));
    s.w2=1-s.w1;
    return make_pair(s.w1,s.w2);
}

void mostrar_segunda_etapa(string fichero)
{
    ofstream f1(fichero);
    f1 << setprecision(3) << fixed;

    // Encabezado de la tabla
    f1 << "┌──────┬────────────────┬────────────────┬─────────┬────────────────┬───────┬───────┬───────────────────┐" << endl;
    f1 << "│  ID  │  Media etapa 1 │  Var. etapa 1  │   Ni    │  Media etapa 2 │  W1   │  W2   │ Media Ponderada   │" << endl;
    f1 << "├──────┼────────────────┼────────────────┼─────────┼────────────────┼───────┼───────┼───────────────────┤" << endl;

    // Datos de los sistemas
    for (int i = 0; i < sistemas.size(); i++)
    {
        f1 << "│" << setw(6) << sistemas[i].id 
           << "│" << setw(16) << sistemas[i].media_primera_etapa 
           << "│" << setw(16) << sistemas[i].varianza_primera_etapa 
           << "│" << setw(9) << sistemas[i].num_simulaciones_totales 
           << "│" << setw(16) << sistemas[i].media_segunda_etapa 
           << "│" << setw(7) << sistemas[i].w1 
           << "│" << setw(7) << sistemas[i].w2 
           << "│" << setw(19) << sistemas[i].media_ponderada 
           << "│" << endl;
    }

    // Elegimos el sistema con la media ponderada más pequeña
    double min = sistemas[0].media_ponderada;
    int id = 0;
    for (int i = 1; i < sistemas.size(); i++)
    {
        if (sistemas[i].media_ponderada < min)
        {
            min = sistemas[i].media_ponderada;
            id = i;
        }
    }

    f1 << "└──────┴────────────────┴────────────────┴─────────┴────────────────┴───────┴───────┴───────────────────┘" << endl;
    f1 << "El sistema con la menor media muestral ponderada es " << sistemas[id].id << endl;

    f1.close();
}
// void mostrar_segunda_etapa(string fichero)
// {
//     ofstream f1(fichero);
//     f1 << setprecision(3) << fixed;
//     f1 << setw(6) << " i " << setw(16) << " Media etapa 1 " 
//        << setw(16) << " Varianza etapa 1 " << setw(9) << "  Ni  "
//        << setw(16) << " Media etapa 2 " << setw(7) << "  W1  " << setw(7) << "  W2  " 
//        << setw(18) << " M. Muestral Pond " << endl;
//     for (int i = 0; i < sistemas.size(); i++)
//     {
//         f1 << setw(6) << sistemas[i].id << setw(16) << sistemas[i].media_primera_etapa 
//            << setw(16) << sistemas[i].varianza_primera_etapa << setw(9) << sistemas[i].num_simulaciones_totales 
//            << setw(16) << sistemas[i].media_segunda_etapa << setw(7) << sistemas[i].w1 << setw(7) << sistemas[i].w2 
//            << setw(18) << sistemas[i].media_ponderada << endl;
//     }

//     // Elegimos el sistema con la media ponderada más pequeña
//     double min = sistemas[0].media_ponderada;
//     int id = 0;
//     for (int i = 1; i < sistemas.size(); i++)
//     {
//         if (sistemas[i].media_ponderada < min)
//         {
//             min = sistemas[i].media_ponderada;
//             id = i;
//         }
//     }

//     f1 << "--------------------------------------------------------------------------------" << endl;
//     f1 << "El sistema con la menor media muestral ponderada es " << sistemas[id].id << endl;

//     f1.close();
// }

void calculo_segunda_parte()
{
    for(int i=0 ; i<sistemas.size();i++)
    {   
        // Calculamos los pesos
        pair<double,double> pesos = calcular_pesos(sistemas[i]);
        sistemas[i].w1 = pesos.first;
        sistemas[i].w2 = pesos.second;

        // Calculamos la media ponderada
        sistemas[i].media_ponderada = sistemas[i].w1 * sistemas[i].media_primera_etapa 
                                    + sistemas[i].w2 * sistemas[i].media_segunda_etapa;        
    }
}

// /////////////////////////////////////////////////////////////////////////////
// MAIN
// /////////////////////////////////////////////////////////////////////////////

int main(int argc, char *argv[])
{
    int etapa = atoi(argv[1]);
    string fichero_resultados = argv[2];
    string fichero_n = argv[3];

    cout << "Etapa: " << etapa << endl;

    if (etapa == 1)
    {
        cout << "Primera etapa" << endl;
        // mientras haya ficheros en la entrada
        for (int i = 4; i < argc; i++)
        {
            primera_etapa(argv[i]);
        }

        calcular_d_ast();

        calcular_num_simulaciones();

        almacenar_n(fichero_n);

        mostrar_primera_etapa(fichero_resultados);
    } else {
        // Obtenemos los resultados anteriores
        cargar_resultados(fichero_resultados, argc-4);
        
        //1º medias muestrales de la segunda etapa
        for (int i = 4; i < argc; i++)
        {
            segunda_etapa(argv[i], i-4);
        }

        // 2º Pesos para la segunda etapa de cada uno de los sistemas
        //3º calculo de las medias ponderadas (primera/segunda etapa)
        calculo_segunda_parte();
        //4º Elegir menor media muestral ponderada
        mostrar_segunda_etapa(fichero_resultados);
    }    

    return 0;
}