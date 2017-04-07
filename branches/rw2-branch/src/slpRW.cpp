#include <Rcpp.h>
using namespace Rcpp;

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp 
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

// [[Rcpp::export]]
List slpRWcalc(List st, NumericMatrix tr, bool xtdo = false) {
  
  List final;
  NumericVector initw = as<NumericVector>(st["w"]);
  int lr = as<int>(st["lr"]); //-SS lr is being returned as a zero rather than as it's actual value
  int colskip = as<int>(st["colskip"]);
  int i,j, items = tr.nrow(), numw = initw.size();
  double lambda,suma;
  NumericVector w = (clone(initw));
  NumericVector arow,inputs,out(items);
  NumericMatrix xout(items,numw);

  Rcout << "lr" << lr << std::endl;
  Rcout << "colskip" << colskip << std::endl;
  Rcout << "w" << w << std::endl;
  Rcout << "1-------------------------------"  << std::endl;
  
  for(i = 0; i < items; i++) {
      arow = tr(i,_);
      if( tr(i,0) == 1 ) {              // Reset network to initial state //-SS this line causes errors; linked to initw issue above
        w = NumericVector(clone(initw));
      }
      lambda = tr(i,'t');
      inputs = tr[(colskip + 1), colskip + numw]; //Extract inputs    // Warning due to using these variables being used in a different scope
      for(j=0;j<inputs.size();j++){
        inputs(j) = inputs(j) * w(j);
      }
      suma = sum(inputs);     //-SS this caused r to crash when comments removed
      double delta = lr * (lambda - suma);      // Warning due to using these variables being used in a different scope
      if( tr(i,0)  > 1 ) {              // Unless weights are frozen.
        for(j=0;j<w.size();j++){
          w(j) = w(j) + (delta * inputs(j));         // update weights.
        }
      }
      out(i) = suma; // NumericVecor being assigned to List
      if(xtdo == true){
        for(j=0;j<numw;j++){
        xout(i,j) = w(j);
        }
      }
  }
  
  Rcout << "2-------------------------------"  << std::endl;
  
  //Return appropriate list
  if(xtdo == true){
    return Rcpp::List::create(Rcpp::Named("suma") = out,
                              Rcpp::Named("w") = w,         //-SS this needs to be changed to final weights rather than returning 'st' list
                              Rcpp::Named("xout") = xout);
  }else{
    return Rcpp::List::create(Rcpp::Named("suma") = out,
                              Rcpp::Named("w") = w);        //-SS this needs to be changed to final weights rather than returning 'st' list
  }
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically 
// run after the compilation.
//

