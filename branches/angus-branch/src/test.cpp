// This script contain the functions for the COVIS list processor of the 
// CATLEARN package
// It is written in C++, using templates from the Rcpp package in R 
#include <Rcpp.h>
#include <iostream>
//#include <vector>
using namespace Rcpp;

// [[Rcpp::export]]
int rchoose(NumericVector exprules, double stocon){
  int i,rsec;
  // Calculate probabilities
  NumericVector storules = exprules;
  for(i=0;i < exprules.size(); i++) {
    storules[i] = pow(exprules[i],stocon);}
  for(i=0;i < exprules.size(); i++) {
    exprules[i] = storules[i]/sum(storules);}
  
  // Select a rule
  NumericVector selrules = exprules;
  NumericVector res(selrules.size());
  std::partial_sum(selrules.begin(), selrules.end(), res.begin());
  double val = (double)rand() / RAND_MAX;
  for(i=0;i < res.size();i++){
    if (res[i] > val) {rsec = i;break;}
    else {rsec = -1;}
  }
  
  return rsec;
}

