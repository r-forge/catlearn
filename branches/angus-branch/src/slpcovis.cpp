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





// First is the functions fot the implementation of the explicit (rule-based) system

// This first function is merely a factorial calculator, written as Rcpp does
// not have one built in.
int factorial(int n)
{
  return (n == 1 || n == 0) ? 1 : factorial(n - 1) * n;
}

//This function is to choose a rule based on the probabilities of those rules
// [[Rcpp::export]]
int rchoose(NumericVector rules, int stimdim){
double val = (double)rand() / RAND_MAX;
int random;
double sum_of_elems = sum(rules);
rules = rules/sum_of_elems;
if (stimdim == 1)
{
  random = 0;
  return random;
}
if (stimdim == 2)
{
  if (val < rules[1])
  {random = 0;}
  else
  {random = 1;}
  return random;
}
if (stimdim == 3)
{
  if (val < rules[1])
  {random = 0;}
  else if (val < rules[1] + rules[2])
  {random = 1;}
  else
  {random = 2;}
  return random;
}
if (stimdim == 4)
  {
    if (val < rules[1])
    {random = 0;}
    else if (val < rules[1] + rules[2])
    {random = 1;}
    else if (val < rules[1] + rules[2] + rules[3])
    {random = 2;}
    else
    {random = 3;}
    return random;
  }
if (stimdim == 5)
{
  if (val < rules[1])
  {random = 0;}
  else if (val < rules[1] + rules[2])
  {random = 1;}
  else if (val < rules[1] + rules[2] + rules[3])
  {random = 2;}
  else if (val < rules[1] + rules[2] + rules[3] + rules[4])
  {random = 3;}
  else
  {random = 4;}
  return random;
}
if (stimdim == 6)
{
  if (val < rules[1])
  {random = 0;}
  else if (val < rules[1] + rules[2])
  {random = 1;}
  else if (val < rules[1] + rules[2] + rules[3])
  {random = 2;}
  else if (val < rules[1] + rules[2] + rules[3] + rules[4])
  {random = 3;}
  else if (val < rules[1] + rules[2] + rules[3] + rules[4] + rules[5])
  {random = 4;}
  else
  {random = 5;}
  return random;
}
return random;
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
  { prules = stimdim;  }
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

// [[Rcpp::export]]  
// Response rule for explicit system
// This response rule exists in the explicit system to decide whether to 
// respond with A or B, referencing two categories as is the norm.
// Epsilon is a normally distributed variable
std::string expres(double disval, double nvar){
  double epsilon = R::dnorm(0.0,0.0,nvar,FALSE);
  std::string Response;
  if (disval < epsilon)
  {Response = 'A';}
  else
  {Response = 'B';}
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
  
// [[Rcpp::export]]
// Function to calculate the weights of the rule used on the current trial,
// another rule from the list of possible rules at random, and all other
// rules based on the current saliences of those rules.
NumericVector weightcalc(double crule,double rrule,double perscon,
                         double selecpar){
  double crulew = crule + perscon;
  double X = R::dpois(selecpar,0.0,0.0);
  double rrulew = rrule + X;
  NumericVector updweight = NumericVector::create(crulew,rrulew);
  return updweight;
}

// [[Rcpp::export]]
// Function to check accuracy of predicted response against actual response
int acccheck(std::string resp, NumericMatrix tr, int i){
  int acc;
  if (resp == tr(i-1,4))
  {acc = 1;}
  else
  {acc = 0;}  
  return acc;
}



// Next is the functions for implementation of the procedural (implicit) system

// [[Rcpp::export]]
// Function to calculate sensory unit activation on a trial
double scuact(double sconst,double prefco,double presco){
  double act;
  act = pow(M_E,-(pow(abs(prefco-presco),2)/sconst));
  return act;
}

// [[Rcpp::export]]
// Function to calculate noise
double noise(double mean,double var){
  double noise = R::dnorm(0.0,mean,var,FALSE);
  return noise;
}

// [[Rcpp::export]]
// Function to generate a matrix containing initial synapse strength and cortical unit input
NumericMatrix stmat(int stims){
  NumericMatrix
}


// [[Rcpp::export]]
// Function to calculate striatal unit activation, needs a 2x2 matrix as input with
// a column for strength of the synapse between the cortical unit and the striatal
// cell and a column for the input from the cortical unit

double stract(NumericMatrix cells){
  double e = noise(0,0);
  
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














