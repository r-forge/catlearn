// This script contain the functions for the COVIS list processor of the 
// CATLEARN package
// It is written in C++, using templates from the Rcpp package in R 
#include <Rcpp.h>
#include <iostream>
#include <vector>
using namespace Rcpp;

// Utility functions
int factorial(int n)
{
  // Checking: AW 2016-08-16
  // This first function is merely a factorial calculator, written as
  // Rcpp does not have one built in.
  return (n == 1 || n == 0) ? 1 : factorial(n - 1) * n;
}

// [[Rcpp::export]]
NumericVector rules(int stimdim, double initsal, bool incl){
  int prules;
  if (incl == TRUE)
  { prules = 2*stimdim + (4*(factorial(stimdim)/
                             (factorial(2)*(factorial(stimdim-2)))));  }
  else 
  { prules = 2*stimdim;  }
  NumericVector exprules(prules,initsal);
  return exprules;
}


