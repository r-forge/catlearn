// This script contain the functions for the COVIS list processor of the 
// CATLEARN package
// It is written in C++, using templates from the Rcpp package in R 
#include <Rcpp.h>
#include <iostream>
//#include <vector>
using namespace Rcpp;

double poisvar(double lambda){
  // Concpet checked: AW 2016-08-24
  // Operation checked: AI 2016-09-07
  // This function is to generate the random variable for Equ 6. in
  // E&W2016. It is generated from a poisson distribution.
  double poisvar = R::rpois(lambda);
  return poisvar;
}

// [[Rcpp::export]]
int rchoose(NumericVector exprules, double stocon){
  // Explicit system
  
  //This function is to choose a rule based on the probabilities of
  //those rules (probabilities come from EW2016, Eq.8)
  
  // exprules - The rule weights
  // stocon - parameter a
  
  // Operation Checked: AI 07/09/2016
  int i,rsec;

  // Calculate probabilities
  NumericVector storules = exprules;
  for(i=0;i < exprules.size(); i++) {
    storules[i] = pow(exprules[i],stocon);}
  for(i=0;i < exprules.size(); i++) {
    exprules[i] = storules[i]/sum(storules);}

  // Select a rule
  NumericVector res(exprules.size());
  std::partial_sum(exprules.begin(), exprules.end(), res.begin());
  double val = (double)rand() / RAND_MAX;
  for(i=0;i < res.size();i++){
    if (res[i] > val) {rsec = i;break;}
    else {rsec = -1;}
  }
  
  return rsec;
}
