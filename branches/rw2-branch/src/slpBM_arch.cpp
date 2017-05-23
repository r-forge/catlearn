//

#include <Rcpp.h>
#include <cstdio>
using namespace Rcpp;
using namespace std;


/* Function is defined here
 * function is called within the code
 * with the function name, a pair of parenthesis and a semicolon to end the line */
// Update weights

// Freeze learning

// [[Rcpp::export]]
List slpBM (List st, NumericMatrix tr,
            bool xtdo = false) {
// declare everything that will not change by trial
double wm = as<double>(st["w"]);            //initial weights
double lr = as<double>(st["lr"]);           //the product of learning rate and stimuli salience
int colskip = as<int>(st["colskip"]);       //optional coloumns (e.g block and trial number)
int i , j,k, nrow = tr.nrow(), ncol = tr.ncol();
NumericMatrix OUT;
NumericMatrix xOUT;

for (i = 0; i <= tr.nrow(); ++i)
{
    for ( j = colskip; j < ncol; ++j)
    {
        double lambda = i["t"]; lambda = tr(i,'t');            // Extract teaching signal
        // Reset weight at each participants
        if (i["ctrl"] == 1)
        {
        wm = st["w"];
        }
        double delta;
        delta = lr * (lambda - j);
        for(k=0;k<5;k++){
          delta += lr *(lambda - wm(k))
        }
        wm += delta + wm;
    }
    /* Record output
    - Have to write a function that stores the output?
    - Have to write function to update weights? */
}
// Extended output to console
if(xtdo){
  for(k=0;k<wm.size();k++){
  XOUT(i,k) = wm(k);
  }
  //Rcpp::Rcout << ;
}
// Run next trial and list the outputs
return Rcpp::List::create(Rccp::Named("delta") = delta,
                        Rccp::Named("wm") = wm);
}

// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.

/*** R
timesTwo(42)
*/
