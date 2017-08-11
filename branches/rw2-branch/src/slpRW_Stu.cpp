#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List slpRWs (List st, NumericMatrix tr,
            bool xtdo = false) {
  int i, j, k, nrow = tr.nrow(), ncol = tr.ncol();
  NumericVector w = as<NumericVector>(st["w"]);             // Initial weights of stimuli
  int initw = w.size();
  NumericVector wm; wm = (clone(w));
  double lr = as<double>(st["lr"]);                         // The product of learning rate and stimuli salience
  int colskip = as<int>(st["colskip"]);                     // Optional coloumns (e.g block and trial number)
  NumericVector lambda = tr( _, ncol-1);                    // Subset Asymptote of learning
  NumericVector inputs(initw), activ(initw), delta(initw);  // Initialise vectors for stimuli activation, activated stimuli's weights, and change in associative strength respectively
  NumericVector arow, sumET(nrow);                          // Initialise vector for subsetting current trial and for summed error terms
  NumericMatrix xOUT(nrow, initw);                          // Create matrix for extended output
  
  for (i = 0; i < tr.nrow(); ++i) {
    arow = tr(i, _);                                        // Extract current trial
    if (i["ctrl"] == 1)                                     // Reset weights at each participant
    {
      wm = st["w"];
    }
    for (k = 0; k < initw; ++k) {
      inputs[k] = arow[colskip+k];                        // Subset stimuli activations from current trial
      activ[k] = inputs[k] * wm[k];                       // Current stimuli weights according to activations
    }
    sumET[i] = sum(activ);                               // Record output (uses summed error value even though BM uses a seperable error term)
    for (k = 0; k < initw; ++k) {
      delta[k] = lr * (lambda[i] - sumET[i]);                 // Calculate the change in associative strength
    }
    if (i["ctrl"] != 2 ) {                                  // Unless weights are frozen
      for (k = 0; k < initw; ++k) {
        wm[k] += delta[k] * inputs[k];                        // Update weights
      }
    }
    if (xtdo) {
      xOUT(i, _) = wm;                                    // If xtdo true, record updated weights to the row corresponding the current trial
    }
  }
  
  if (xtdo) {
    return Rcpp::List::create(Rcpp::Named("Summed error terms") = sumET,
                              Rcpp::Named("Extended Output, where rows represent trials and coloumns stimuli weights") = xOUT,
                              Rcpp::Named("Last state of the model") = wm);
  } else {
    return Rcpp::List::create(Rcpp::Named("Summed error terms") = sumET,
                              Rcpp::Named("The last state of the model") = wm);
  }
}
