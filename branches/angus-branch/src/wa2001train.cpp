#include <Rcpp.h>
using namespace Rcpp;

// Function to generate a matrix containing initial synapse strength 
// stims - Number of sensory cortex units
// cats - Number of striatal units
// Checked: AI 27/09/2016
// Checked: AW 28/09/2016

// [[Rcpp::export]]
NumericMatrix symat(int stims,int cats){
  int i,j;
  double U;
  NumericMatrix symat(stims,cats);
  for(i=0;i < cats;i++){
    for(j=0;j < stims;j++){
      U = (double)rand() / RAND_MAX;
      symat(j,i) = 0.001 + (0.0025 * U);
    }
  }
  return symat;
}

// Function to get striatal cortical unit values from 
// training matrix or from randomly sampled triplets
// Contains options for either giving the units exact
// stimulus values or sampling randomly

// stims: Number of sensory cortex units 
// dims: Dimensionality of stimulus space

// Checked: AI 27/09/2016
// Not really checked that much : AW 28/09/2016

// [[Rcpp::export]]
NumericMatrix scumat(int stims, int dims, int colskip, int complex, NumericMatrix tr){
  int i,j;
  NumericVector vals(dims);
  NumericMatrix valmat(stims,dims);
  if (complex == 0)
  {
    valmat = tr(Range(0,(stims-1)),Range(colskip,(colskip+dims)));
  }
  else
  {
    for(i=0;i < dims;i++){
      for(j=0;j < stims;j++){
        double X = (double)rand() / RAND_MAX;
        valmat(j,i) = X;
      }
    }
  }
  return valmat;
}
