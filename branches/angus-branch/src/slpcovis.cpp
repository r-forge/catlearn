// This script contain the functions for the COVIS list processor of the 
// CATLEARN package
// It is written in C++, using templates from the Rcpp package in R 
#include <Rcpp.h>
#include <iostream>
#include <vector>
using namespace Rcpp;

// There are three parts to implementing COVIS
// A model of the explicit system, a model of the implicit system 
// and an algorithm to monitor the output of the systems and select
// a response on each trial


// Utility functions

int factorial(int n)
{
  // Checking: AW 2016-08-16
  // This first function is merely a factorial calculator, written as
  // Rcpp does not have one built in.
  return (n == 1 || n == 0) ? 1 : factorial(n - 1) * n;
}

double poisvar(double mean){
  // This function is to generate the random variable for Equ 6. in
  // E&W2016. It is generated from a poisson distribution.
  poisvar = R::rpois(1,mean);
  return poisvar;
}


// First is the functions for the implementation of the explicit (rule-based) system

// [[Rcpp::export]]
double rchoose(NumericVector exprules, double stocon){
  // Explicit system
  
  //This function is to choose a rule based on the probabilities of
  //those rules (probabilities come from EW2016, Eq.8)
  newrules = (exprules^stocon)/sum(exprules)^stocon;
  newrules = R::cumsum(newrules);
  double val = (double)rand() / RAND_MAX;
  for(i=0;i < R::length(newrules)){
    if (newrules[i] > val) rsec = i
  }
  return rsec
}



// [[Rcpp::export]] 
double prerule(double rulsal,double perscon){
  // Explicit system
  
  // This is the first of the functions to transform the saliencies of the rules
  // to weights, Equ 5. in E&W2016. Used for the rule used on the previous trial.
  double rulweight = rulsal + perscon;
  return rulweight;
}

// [[Rcpp::export]]  
double ranrule(double rulsal,double poisvar){
  // Explicit system
  
  // This is the second of the functions to transform the saliences of the rules
  // to weights, Equ 6. in E&W2016. Used  for another rule from the set chosen at random.
  double rulweight = rulsal + poisvar
  return rulweight;
}

// [[Rcpp::export]]  
NumericVector resrule(NumericVector rulsal){
  // Explicit system
  
  // This is the third of the functions to transform the saliencies of the rules
  // to weights, Equ 7. in E&W2016. Used for the rest of the rules after the other two equations.
  rulweight = rulsal;
  return rulweight;
}

// [[Rcpp::export]]
// Denote the number of all possible explicit rules
// This function calculates the number of possible rules given the number
// of stimulus dimensions. In reality this is unlikely to go as high as 6,
// but it has been tested to work up til then. One of the parameters sets 
// whether or not to include all of single dimension, conjunctive and 
// disjunctive rules.
NumericVector rules(int stimdim, double initsal, bool incl){
  int prules;
  if (incl == TRUE)
  { prules = stimdim + (4*(factorial(stimdim)/
                             (factorial(2)*(factorial(stimdim-2)))));  }
  else 
  { prules = 2*stimdim;  }
  NumericVector exprules(prules,initsal);
  return exprules;
}

// Setup a vector for the coordinates of the stimuli based on the number of
// stimulus dimensions
// [[Rcpp::export]]
NumericVector stimco(int stimdim, NumericMatrix ma ,int i){
  NumericVector initco;
  if (stimdim == 1)
  {NumericVector initco = NumericVector::create(ma(i,5)) ;}
  else if (stimdim == 2)
  {NumericVector initco = NumericVector::create(ma(i,5),ma(i,6)) ;}
  else if (stimdim == 3)
  {NumericVector initco = NumericVector::create(ma(i,5),ma(i,6),ma(i,7)) ;}
  else if (stimdim == 4)
  {NumericVector initco = NumericVector::create(ma(i,5),ma(i,6),ma(i,7),
                                                ma(i,8)) ;}
  else if (stimdim == 5)
  {NumericVector initco = NumericVector::create(ma(i,5),ma(i,6),ma(i,7),
                                                ma(i,8),ma(i,9)) ;}
  else if (stimdim == 6)
  {NumericVector initco = NumericVector::create(ma(i,5),ma(i,6),ma(i,7),
                                                ma(i,8),ma(i,9),ma(i,10)) ;}
  return initco;
}


int expres(double disval, double nvar){
  // Checking: AW 2016-08-16
  
  // Response rule for explicit system 
  
  // This response rule exists in the explicit system to decide
  // whether to respond with A or B, referencing two categories as is
  // the norm.  Epsilon is a normally distributed variable
  
  // Edmunds & Wills (2016, Equ. 2)
  // disval - discriminant value (h_v)
  // nvar - noise (sigma_v)
  // double epsilon = R::rnorm(0.0,nvar);
  
  double epsilon = R::rnorm(0,nvar);
  int Response;
  if (disval < epsilon)
  {Response = 1;}
  else
  {Response = 2;}
  return Response;
}

// [[Rcpp::export]]
// Function to calculate the discrimant value used in the Response rule.
double disfunc(double stimval,double deccrit){
  double disval = stimval - deccrit;
  return disval;
}

// [[Rcpp::export]]
// Function to update rule saliency based on accuracy of response. Either
// increments salience positively based on a constant if correct, and
// negatively based on a different constant if incorrect.
double updsal(double corcon, double errcon, double psal, int acc){
  double tsal;
  if (acc == TRUE){
    tsal = psal + corcon;
  }
  else{
    tsal = psal - errcon;
  }
  return tsal;
} 


int acccheck(int resp, NumericVector tr){
  // Checking: AW 2016-08-16
  
  // Explicit system
  
  // Function to check accuracy of predicted response against actual
  // response
  
  // Required to decide whether Equ. 3 or 4 is in force
  // Edmunds & Wills (2016)
  
  int acc;
  acc = 0;
  if (resp == 1 & tr[0] == 1) acc = 1;
  if (resp == 2 & tr[1] == 1) acc = 1;
  
  return acc;
}

// Next is the functions for implementation of the procedural (implicit) system

// [[Rcpp::export]]
// Function to calculate sensory unit activation on a trial Equ. 9 in E&W2016
double scuact(double sconst,double prefco,double presco){
  double act;
  act = pow(M_E,-(pow(abs(prefco-presco),2)/sconst));
  return act;
}

// [[Rcpp::export]]
// Function to calculate noise
double noise(double var){
  double noise = R::rnorm(1,var);
  return noise;
}

// Function to generate a matrix containing initial synapse strength and cortical unit input
/NumericVector stmat(int stims){
  NumericVector stmat (stims)
  for(i=0;i < R::length(stmat)){
    double U = R::rnorm(1)
    stmat[i] = 0.001 + (0.0025 * U)
  }
 }

// [[Rcpp::export]]
// Implicit system

// Function to calculate striatal unit activation, needs a 2x2 matrix as input with
// a column for strength of the synapse between the cortical unit and the striatal
// cell and a column for the input from the cortical unit. Equ. 10 in E&W2016

double stract(NumericMatrix cells, double ){
  double e = noise(1,0);
  
  
}




// Finally this is the complete function for the COVIS model 
// incorporating all of the explicit, implicit and decision mechanisms.

// // [[Rcpp::export]]

// NumericMatrix covislp(NumericMatrix tr,
//                       double corcon,
//                       double errcon,
//                       int perscon,
//                       int selecpar,
//                       double initsal,
//                       std::string explic,
//                       int stimdim,
//                       double nvar)
//                       
// NumericVector rset = rules(stimdim,initsal,incl = FALSE);
// NumericVector sdim = stimco(stimdim,tr);
// int acc = 0;
// int random = 0;
// for (int i = 0; i < tr.nrow(); i++){
//  if (acc == 1)
//  {
//  double disval = disfunc(sdim[nrule],)
//  std::string resp = expres(disval,nvar)
//  int acc = acccheck(resp,tr,i)
//  rset[nrule] = updsal(corcon,errcon,rset[nrule],acc)
//  }
//  else
//  {
//  int nrule = rchoose(rset,stimdim);
//  double disval = disfunc(sdim[nrule],)
//  std::string resp = expres(disval,nvar)
//  int acc = acccheck(resp,tr,i)
//  rset[nrule] = updsal(corcon,errcon,rset[nrule],acc)
//  }
// }                    














