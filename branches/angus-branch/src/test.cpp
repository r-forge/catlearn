// This script contain the functions for the COVIS list processor of the 
// CATLEARN package
// It is written in C++, using templates from the Rcpp package in R 
#include <Rcpp.h>
#include <iostream>
//#include <vector>
using namespace Rcpp;

// Next is the functions for implementation of the procedural (implicit) system

// First are the activation equations

// [[Rcpp::export]]
// Function to calculate sensory unit activation on a trial Equ. 9 in E&W2016
// Checked: AI 19/09/2016
double scuact(double sconst,double diff){
  double act,super,e;
  super = -(pow(diff,2)/sconst);
  e = exp(1);
  act = pow(e,super);
  return act;
}

// [[Rcpp::export]]
// Function to generate a matrix containing initial synapse strength 
// Checked: AI 27/09/2016
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

// [[Rcpp::export]]
// Function to get striatal cortical unit values from 
// training matrix or from randomly sampled triplets
// Contains options for either giving the units exact
// stimulus values or sampling randomly
// Checked: AI 27/09/2016
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

// [[Rcpp::export]]
// Function to calculate the difference between the presented
// stimulus and each of the scu values, as well as calculating
// the activation for each cortical unit using the scuact function.
// Checked: AI 27/09/2016
NumericVector distcalc(NumericMatrix scumat, NumericVector cstim, double sconst){
  int i,j,nrow = scumat.nrow(), ncol = scumat.ncol();
  NumericVector dists(nrow);
  for(i=0;i < nrow;i++){
    NumericVector diffs(ncol);
    for(j=0;j < ncol;j++){
      diffs(j) = (scumat(i,j) - cstim(j));
      diffs(j) = pow(diffs(j),2);
    }
    dists(i) = sqrt(sum(diffs));
  }
  for(i=0;i < nrow;i++){
    dists(i) = scuact(sconst,dists(i));
  }
  return dists;
}

// [[Rcpp::export]]
// Function to calculate the activation of striatal units,
// Equ 10 in E&W2016. Also generates a response based on the
// summed activation.
// Checked: AI 27/09/2016
int stract(NumericMatrix wkj,NumericVector ik,double noisecon){
  int i,j,nrow = wkj.nrow(), ncol = wkj.ncol();
  double act,noise,largeact;
  NumericVector sumact(ncol);
  NumericMatrix cortact(nrow,ncol);  
  for(i=0;i < ncol;i++){
    for(j=0;j < nrow;j++){
      cortact(j,i) =(wkj(j,i) * ik(j));
    }
  }
  for(i=0;i < ncol;i++){
    noise = epsilon(noisecon);
    sumact(i) = sum(cortact(_,i)) + noise;
  }
  largeact = max(sumact);
  for(i=0;i < ncol;i++){
    if (sumact(i) == largeact){
      act = i + 1;
    }
  }
  return act;
}


// Next are the learning equations

// First are the equations necessary to specify the dopamine
// released on each trial

// [[Rcpp::export]]
// Function to calculate obtained reward.
// Checked: AI 27/09/2016
double obtrew(int acc){
  double rew;
  if (acc == 1){rew = 1;}
  if (acc == 0){rew = -1;}
  if (acc == -1){rew = 0;}
  return rew;
}

// [[Rcpp::export]]
// Function to calculate predicted reward.
// Checked: AI 27/09/2016
double prerew(double prep,double prer){
  double rew,add;
  add = 0.025*(prer-prep);
  rew = prep + add;
  return rew;
}

// [[Rcpp::export]]
// Function to calculate dopamine release.
// Checked: AI 27/09/2016
double doprel(double obtrew, double prerew){
  double rpe,dn;
  rpe = obtrew - prerew;
  if (rpe > 1){dn = 1;}
  if ((1 >= rpe) and (rpe > -0.25)){dn = (0.8*rpe)+0.2;}
  if (rpe <= -0.25){dn = 0;}
  return dn;
}

// [[Rcpp::export]]
// Next is the large equation for adjusting synapse strength
// Function to calculate equation 12 of E&W2016
// Checked: AI 27/09/2016
double nsystr(double systr,double act,double alpha,double beta,
              double gamma,double sum,double nmda,double dn,
              double dbase,double wmax,double ampa){
  double a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,out,out1,out2,out3;
  a1 = act * alpha;
  b1 = sum - nmda;
  c1 = dn -dbase;
  d1 = wmax - systr;
  out1 = a1*(b1+c1+d1);
  a2 = beta * act;
  b2 = sum - nmda;
  c2 = dbase - dn;
  d2 = systr;
  out2 = a2*(b2+c2+d2);
  a3 = gamma * act;
  b3 = nmda - sum;
  c3 = ampa;
  d3 = systr;
  out3 = a3*((b3-c3)+d3);
  out = systr + out1 - out2 - out3;
  return out;
}




