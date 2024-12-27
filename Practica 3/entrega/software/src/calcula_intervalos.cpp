/**
 * @file calcula_intervalos.cpp
 * @brief Programa para calcular los intervalos de confianza de las salidas de un sistema de colas
 */


#ifdef _MSC_VER
#  pragma warning(disable: 4512) // assignment operator could not be generated.
#  pragma warning(disable: 4510) // default constructor could not be generated.
#  pragma warning(disable: 4610) // can never be instantiated - user defined constructor required.
#endif

#include <iostream>
#include <iomanip>
#include <boost/math/distributions/students_t.hpp>
#include <vector>
#include <fstream>

using namespace std;
using namespace boost::math;

// Needed includes:
void confidence_limits_on_mean(double Sm, double Sd, unsigned Sn)
{
   //
   // Sm = Sample Mean.
   // Sd = Sample Standard Deviation.
   // Sn = Sample Size.
   //
   // Calculate confidence intervals for the mean.
   // For example if we set the confidence limit to
   // 0.95, we know that if we repeat the sampling
   // 100 times, then we expect that the true mean
   // will be between out limits on 95 occations.
   // Note: this is not the same as saying a 95%
   // confidence interval means that there is a 95%
   // probability that the interval contains the true mean.
   // The interval computed from a given sample either
   // contains the true mean or it does not.
   // See http://www.itl.nist.gov/div898/handbook/eda/section3/eda352.htm

   

   // Print out general info:
   cout <<
      "__________________________________\n"
      "2-Sided Confidence Limits For Mean\n"
      "__________________________________\n\n";
   cout << setprecision(7);
   cout << setw(40) << left << "Number of Observations" << "=  " << Sn << "\n";
   cout << setw(40) << left << "Mean" << "=  " << Sm << "\n";
   cout << setw(40) << left << "Standard Deviation" << "=  " << Sd << "\n";
   //
   // Define a table of significance/risk levels:
   //
   double alpha[] = { 0.5, 0.25, 0.1, 0.05, 0.01, 0.001, 0.0001, 0.00001 };
   //
   // Start by declaring the distribution we'll need:
   //
   students_t dist(Sn - 1);
   //
   // Print table header:
   //
   cout << "\n\n"
           "___________________________________________________________________\n"
           "Confidence       T           Interval          Lower          Upper\n"
           " Value (%)     Value          Width            Limit          Limit\n"
           "___________________________________________________________________\n";
   //
   // Now print out the data for the table rows.
   //
   for(unsigned i = 0; i < sizeof(alpha)/sizeof(alpha[0]); ++i)
   {
      // Confidence value:
      cout << fixed << setprecision(3) << setw(10) << right << 100 * (1-alpha[i]);
      // calculate T:
      double T = quantile(complement(dist, alpha[i] / 2));
      // Print T:
      cout << fixed << setprecision(3) << setw(10) << right << T;
      // Calculate width of interval (one sided):
      double w = T * Sd / sqrt(double(Sn));
      // Print width:
      if(w < 0.01)
         cout << scientific << setprecision(3) << setw(17) << right << w;
      else
         cout << fixed << setprecision(3) << setw(17) << right << w;
      // Print Limits:
      cout << fixed << setprecision(5) << setw(15) << right << Sm - w;
      cout << fixed << setprecision(5) << setw(15) << right << Sm + w << endl;
   }
   cout << endl;
}

double mean(const vector<double>& data) {
    double sum = 0.0;
    for (double x : data) {
        sum += x;
    }
    return sum / data.size();
}

double varianceCalc(const vector<double>& data, double mean) {
    double sum = 0.0;
    for (double x : data) {
        sum += (x - mean) * (x - mean);
    }
    return sum / (data.size() - 1);
}


int main(int argc, char **argv)
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
    vector<double> pct_1, pct_2, result;

    while (getline(f1, linea1) && getline(f2, linea2))
    {
        pct_1.push_back(stod(linea1.substr(linea1.find_last_of("\t"), linea1.size())));
        pct_2.push_back(stod(linea2.substr(linea2.find_last_of("\t"), linea2.size())));
    }
    
    for(int i=0; i<pct_1.size(); i++)
    {
        result.push_back(pct_1[i]-pct_2[i]);
    }

    double mean_1=mean(result);
    double var_1=varianceCalc(result,mean_1);

    confidence_limits_on_mean(mean_1,sqrt(var_1),result.size());

    f1.close();
    f2.close();
}



