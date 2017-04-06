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
  
  List out, xout, final;
  NumericVector initw = as<NumericVector>(st["w"]);
  int lr = as<int>(st["lr"]); //-SS lr is being returned as a zero rather than as it's actual value
  int colskip = as<int>(st["colskip"]);
  //int lambda = as<int>(st["t"]); // initialize lambda from tr rather than st //-SS defined in loop below so looks like duplicate
  int i, items = tr.nrow(), numw = initw.size(); 
  NumericVector w(numw);
  // NumericVector w(clone(numw)); 
  w = initw;  //-SS this looks circular as initw defined as 'w' from list 'st' above. This appears to be for
                //-SS conditional statement for resetting 'w' to st["w"] if number in tr matrix ctrl column = 1.
  
  Rcout << "lr" << lr << std::endl;
  Rcout << "colskip" << colskip << std::endl;
  Rcout << "w" << w << std::endl;
  Rcout << "1-------------------------------"  << std::endl;
  
  for(i = 0; i < items; i++) {
    //for(j = 0; j < items; j++){
      //NumericMatrix arow = as<NumericMatrix>(tr[i,j]);
      //if( tr(i,1) == 1 ) {              // Reset network to initial state //-SS this line causes errors; linked to initw issue above
        w = initw;
        // w = NumericMatrix(clone(initw))
      //}
      //lambda = tr(i,10); // lambda rather than 10, also lambda is an int rather than a matrix //-SS this line causes error
      NumericMatrix inputs = tr[(colskip + 1), colskip + numw]; //Extract inputs    // Warning due to using these variables being used in a different scope
      //NumericVector suma = suma[sum(inputs*w)];     //-SS this caused r to crash when comments removed
      //double delta = lr * (lambda -suma[i,0]);      // Warning due to using these variables being used in a different scope
      //if( tr(i,1) != 2 ) {              // Unless weights are frozen.
        //w = w + delta * inputs;         // update weights.
      //}
      //out = suma; // NumericVecor being assigned to List
      if(xtdo == true){
        //xout = w;
      }
    //}
  }
  
  Rcout << "2-------------------------------"  << std::endl;
  
  //Return appropriate list
  if(xtdo == true){
    return Rcpp::List::create(Rcpp::Named("suma") = out,
                              Rcpp::Named("st") = st,         //-SS this needs to be changed to final weights rather than returning 'st' list
                              Rcpp::Named("xout") = xout);
  }else{
    return Rcpp::List::create(Rcpp::Named("suma") = out,
                              Rcpp::Named("st") = st);        //-SS this needs to be changed to final weights rather than returning 'st' list
  }
  return 1;
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically 
// run after the compilation.
//

