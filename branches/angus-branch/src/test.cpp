// This script contain the functions for the COVIS list processor of the 
// CATLEARN package
// It is written in C++, using templates from the Rcpp package in R 
#include <Rcpp.h>
#include <iostream>
//#include <vector>
using namespace Rcpp;

// [[Rcpp::export]]
double scuact(double sconst,double diff){
  double act,super,e;
  super = -(pow(diff,2)/sconst);
  e = 2.718282;
  act = pow(e,super);
  return act;
}

// [[Rcpp::export]]
NumericVector distcalc(NumericMatrix scumat, NumericVector cstim, double sconst){
  int i,j,nrow = scumat.nrow(), ncol = scumat.ncol();
  NumericVector dists(nrow);
  Rcout << "--------0------- " << "\n";
  for(i=0;i < nrow;i++){
    NumericVector diffs(ncol);
    for(j=0;j < ncol;j++){
      diffs(j) = (scumat(i,j) - cstim(j));
      diffs(j) = pow(diffs(j),2);
    }
    dists(i) = sqrt(sum(diffs));
  }
  Rcout << "---------1------ " << "\n";
  for(i=0;i < nrow;i++){
    dists(i) = scuact(sconst,dists(i));
  }
  return dists;
}


