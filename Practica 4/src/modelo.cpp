// Modelo del ecosistema de Lotka-Volterra
//

#include <iostream>
#include <iomanip>
#include <cmath>
#include <algorithm>
#include <numeric>

using namespace std;

const int numeq = 2;
double a11, a12, a21, a22;
double tinic, tfin, dt, t;
double estado[numeq], oldestado[numeq], f[numeq];
double k[numeq][4];

void fijar_parametros() {
    // Aquí se deben fijar los valores de a11, a12, a21, a22, tinic, tfin, dt y estado inicial
    a11 = 5; a12 = 0.05; a21 = 0.0004; a22 = 0.2;
    tinic = 0.0; tfin = 100.0; dt = 0.1;
    // estado[0] = 450; estado[1] = 90;
    // estado[0] = 100; estado[1] = 20;
    estado[0] = a22/a21; estado[1] = a11/a12;
}

void derivacion(const double est[], double f[], double tt) {
    f[0] = a11 * est[0] - a12 * est[0] * est[1];
    f[1] = a21 * est[0] * est[1] - a22 * est[1];
}

void one_step_euler(const double inp[], double out[], double tt, double hh) {
    derivacion(inp, f, tt);
    for (int i = 0; i < numeq; i++) {
        out[i] = inp[i] + (hh * f[i]);
    }
}

void one_step_runge_kutta(const double inp[], double out[], double tt, double hh) {
    for (int i = 0; i < numeq; i++) out[i] = inp[i];
    double time = tt;
    for (int j = 0; j < 4; j++) {
        derivacion(out, f, time);
        double incr;
        for (int i = 0; i < numeq; i++) k[i][j] = f[i];
        if (j < 2) incr = hh/2;
        else incr = hh;
        for (int i = 0; i < numeq; i++) out[i] = inp[i] + k[i][j] * incr;
        time = tt + incr;
    }
    for (int i = 0; i < numeq; i++)
        out[i] = inp[i] + hh / 6 * (k[i][0] + 2 * k[i][1] + 2 * k[i][2] + k[i][3]);
}

void salida() {
    // Aquí se debe definir cómo se realiza la salida de los datos
    // cout << fixed << setprecision(4) << "t: " << tinic << " estado: [" << estado[0] << ", " << estado[1] << "]" << endl;
    cout << fixed << setprecision(4) << t << "\t" << estado[0] << "\t" << estado[1] << endl;
}

void integracion(int metodo) {
    do {
        salida();
        for (int i = 0; i < numeq; i++) oldestado[i] = estado[i];
        if (metodo == 0) one_step_runge_kutta(oldestado, estado, t, dt); // o one_step_euler
        else one_step_euler(oldestado, estado, t, dt); // o one_step_euler
        // one_step_runge_kutta(oldestado, estado, t, dt); // o one_step_euler
        // one_step_euler(oldestado, estado, t, dt); // o one_step_euler
        t += dt;
    } while (t < tfin);
}

int main(int argc, char *argv[]) {

    // Comprobar el número de argumentos
    if (argc != 11) {
        cout << "Uso: " << argv[0] << " <metodo> <a11> <a12> <a21> <a22> <tinic> <tfin> <dt> <x0> <y0>" << endl;
        cout << "Donde <metodo> es 0 para Runge-Kutta y 1 para Euler" << endl;
        return 1;
    }
    // Parámetros
    int metodo = atoi(argv[1]);
    a11 = atof(argv[2]); 
    a12 = atof(argv[3]); 
    a21 = atof(argv[4]); 
    a22 = atof(argv[5]);
    tinic = atof(argv[6]);
    tfin = atof(argv[7]);
    dt = atof(argv[8]);
    estado[0] = atof(argv[9]);
    estado[1] = atof(argv[10]);
    t = tinic;

    // fijar_parametros();
    
    integracion(metodo);
    return 0;
}
