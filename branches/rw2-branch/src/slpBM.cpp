#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List slpBM (List st, NumericMatrix tr,
            bool xtdo = false) {
int i, j, k, nrow = tr.nrow(), ncol = tr.ncol();
NumericVector w = as<NumericVector>(st["w"]); // Set initial weights.
int initw = w.size();
NumericVector wm; wm = (clone(w));
double lr = as<double>(st["lr"]);       // Learning rate (alpha*beta).
int colskip = as<int>(st["colskip"]);   // Number of optional columns to skip.
NumericVector lambda = tr( _, ncol-1);  // Subset asymptote of learning.
NumericVector inputs(initw), activ(initw), delta(initw); // Initialise vectors for
                                                         // main loop.
NumericVector arow, sumET(nrow);        // Initialise vector for subsetting current
                                        // trial and for summed error terms.
NumericMatrix xOUT(nrow, initw);        // Create matrix for extended output.

for (i = 0; i < tr.nrow(); ++i) {
  arow = tr(i, _);                      // Extract current trial.
  if (i["ctrl"] == 1)                   // Reset weights if new participant.
  {
    wm = st["w"];
  }
      for (k = 0; k < initw; ++k) {
      inputs[k] = arow[colskip+k];      // Subset stimuli activations at current trial.
      activ[k] = inputs[k] * wm[k];     // Generate current stimuli weights.
      delta[k] = lr * (lambda[i] - activ[k]); // Calc change in associative strength.
      }
      sumET[i] = sum(activ);            // Record output (as summed term although BM
                                        // calculates delta from seperable term).
  if (i["ctrl"] != 2 ) {                // Unless weights are frozen...
    for (k = 0; k < initw; ++k) {
    wm[k] += delta[k] * inputs[k];      // ...update weights.
    }
  }
  if (xtdo) {
      xOUT(i, _) = wm;                   // If xtdo = true, record updated weights to
                                         // relevant row (i.e. trial).
  }
}

if (xtdo) {
  return Rcpp::List::create(Rcpp::Named("suma") = sumET,
                            Rcpp::Named("xout") = xOUT,
                            Rcpp::Named("st") = wm);
} else {
  return Rcpp::List::create(Rcpp::Named("suma") = sumET,
                            Rcpp::Named("st") = wm);
}
}
