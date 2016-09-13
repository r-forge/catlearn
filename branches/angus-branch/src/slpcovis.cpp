// This script contain the functions for the COVIS list processor of the 
// CATLEARN package
// It is written in C++, using templates from the Rcpp package in R 
#include <Rcpp.h>
#include <iostream>
//#include <vector>
using namespace Rcpp;

// There are three parts to implementing COVIS
// A model of the explicit system, a model of the implicit system 
// and an algorithm to monitor the output of the systems and select
// a response on each trial

// Utility functions

double poisvar(double lambda){
  // Concpet checked: AW 2016-08-24
  // Operation checked: AI 2016-09-07
  // This function is to generate the random variable for Equ 6. in
  // E&W2016. It is generated from a poisson distribution.
  double poisvar = R::rpois(lambda);
  return poisvar;
}

// Epsilon from Equation 2 (random normal variate)
// TICK - AW - 2016-09-09
double epsilon(double nvar){
  double epsilon = R::rnorm(0,nvar);
  return epsilon;
}
  
// First is the functions for the implementation of the explicit (rule-based) system

// Explicit
// Creates rule-set at initial salience
// TICKED! - AW 2016-09-09

// Notes: (1) Edmunds & Wills also have CJ of DJ
// Notes: (2) Are CJ and DJ always in practice equivalent?
// (they are for SHJ61).

// AI checked: 2016-08-24, up to 6 dimensions.
// AW checked: 2016-08-24, seems OK for single dimension rules
// Not sure I understand how the number of others is determined.

// AI : 06/09/2016. rechecked and made it easier to understand,
// handle up to 6 dimensions and handle differential initial
// saliencies for different types of rules. 
// Operation checked: AI 2016-09-07

// stimdim - Number of stimulus dimensions
// udsal - Initial salience for unidimensional rules
// cjsal - Initial salience for conjunctive rules
// djofcjsal - Initial salience for disjunction of conjunction rules
// incl - 0: single dimension only, 1: SD, CJ, DJ.


NumericVector rules(int stimdim, double udsal, double cjsal, double djofcjsal, int incl){
  int prules,i;
  NumericVector exprules;
  if (incl == 1)
  { int ud = 2*stimdim;
    int cj = 4 * (((stimdim-1)*stimdim)/2);
    int dj = cj;
    int djofcj = stimdim*(stimdim-1);
    prules = ud + cj + dj + djofcj;
    NumericVector exprules(prules);
    
    for(i=0;i < ud; i++) {
      exprules[i] = udsal;}
    
    for(i=ud;i < (ud+cj); i++) {
      exprules[i] = cjsal;}
    
    for(i=(ud+cj);i < (ud+cj+dj); i++) {
      exprules[i] = cjsal;}
    
    for(i=(ud+cj+dj);i < (ud+cj+dj+djofcj); i++) {
      exprules[i] = djofcjsal;}
    return exprules;
  }
  else 
  {prules = 2*stimdim;  
    NumericVector exprules(prules,udsal);
    return exprules;}
  return exprules;
}


// Function to calculate the discrimant value used in the Response rule.
// Operation checked : AI 07/09/2016
// TICK - AW - 2016-09-09
double disfunc(double stimval,double deccrit){
  double disval = stimval - deccrit;
  return disval;
}


int expres(double disval, double nvar,int crule){
  // TICK: AW 2016-08-16
  
  // Response rule for explicit system 
  
  // This response rule exists in the explicit system to decide
  // whether to respond with A or B, referencing two categories as is
  // the norm.  Epsilon is a normally distributed variable
  
  // Edmunds & Wills (2016, Equ. 2)
  // disval - discriminant value (h_v)
  // nvar - noise (sigma_v)
  // double epsilon = R::rnorm(0.0,nvar);
  int Response;
  double eps = epsilon(nvar);
  if(crule%2 == 0){
    if(disval < eps)
    {Response = 1;}
    else
    {Response = 2;}
  }
  else{
    if(disval < eps)
    {Response = 2;}
    else
    {Response = 1;}
  }
  return Response;
}


int acccheck(int resp, NumericVector tr,int colskip, int stimdim){
  // TICK: AW 2016-08-16
  
  // Explicit system
  
  // Function to check accuracy of predicted response against actual
  // response
  
  // Required to decide whether Equ. 3 or 4 is in force
  // Edmunds & Wills (2016)
  
  int acc;
  acc = 0;
  if ((resp == 1) & (tr[colskip+stimdim] == 1)) acc = 1;
  if ((resp == 2) & (tr[colskip+stimdim] == -1)) acc = 1;
  
  return acc;
}


// Function to update rule saliency based on accuracy of response. Either
// increments salience positively based on a constant if correct, and
// negatively based on a different constant if incorrect.

// TICK - AW - 2016-09-09
// Operation checked: AI 07/09/2016

// Equ. 3,4
// corcon - delta C
// errcon - delta E
// psal - Z
// acc = 1 if correct, 0 if incorrect

double updsal(double corcon, double errcon, double psal, int acc){
  double tsal;
  if (acc == 1){
    tsal = psal + corcon;
  }
  else{
    tsal = psal - errcon;
  }
  return tsal;
} 


double prerule(double rulsal,double perscon){
  // Explicit system
  // TICK - AW - 2016-09-09
  // This is the first of the functions to transform the saliencies of the rules
  // to weights, Equ 5. in E&W2016. Used for the rule used on the previous trial.
  
  // Operation Checked: AI 07/09/2016 
  double rulweight = rulsal + perscon;
  return rulweight;
}

 
double ranrule(double rulsal,double lambda){
  // Explicit system
  
  // This is the second of the functions to transform the saliences of the rules
  // to weights, Equ 6. in E&W2016. Used  for another rule from the set chosen at random.
  
  // Operation Checked: AI 07/09/2016
  // TICK - AW - 2016-09-09
  double pois = poisvar(lambda);
  double rulweight = rulsal + pois;
  return rulweight;
}

int rchoose(NumericVector exprules, double stocon){
  // Explicit system
  
  //This function is to choose a rule based on the probabilities of
  //those rules (probabilities come from EW2016, Eq.8)
  
  // exprules - The rule weights
  // stocon - parameter a
  
  // Operation Checked: AI 07/09/2016
  // AW - OK, except this changes exprules back in R, 
  // which might cause problems later. 
  int i,rsec;
  double sumsto;
  NumericVector selrules,storules,res;
  // Calculate probabilities
  selrules = exprules;
  storules = exprules;
  for(i=0;i < storules.size(); i++) {
    storules[i] = pow(storules[i],stocon);}
  sumsto = sum(storules);
  for(i=0;i < storules.size(); i++) {
    selrules[i] = storules[i]/sumsto;}
  
  // Select a rule
  res = selrules;
  std::partial_sum(selrules.begin(), selrules.end(), res.begin());
  double val = (double)rand() / RAND_MAX;
  for(i=0;i < res.size();i++){
    if (res[i] > val) {rsec = i;break;}
    else {rsec = -1;}
  }
  return rsec;
}







// Function for running one trial through the COVIS system
// [[Rcpp::export]]
List covistrial(NumericVector tr, NumericVector nextrules, int colskip,int stimdim,
                double corcon, double errcon, double perscon, double decsto, 
                double decbound, double lambda, double nvar, int crule){
int i, j, cdim, rrule, resp,cb,acc,nextrule;
double hvx; 
NumericVector updrules;
// Generate a response from the Explicit system
Rcout<< "crule = " << crule <<"\n";
cdim = 0;
cb = 2;
for(i=0;i<stimdim;i++){
  for(j=(cb*i);j<(cb*(j+1));j++){
    if(j == crule){cdim = tr[colskip+j];}
  }
}
hvx = disfunc(cdim,decbound);
Rcout<< "hvx = " << hvx <<"\n";
resp = expres(hvx,nvar,crule);
Rcout<< "resp = " << resp <<"\n";
// Generate a repsonse from the Implicit system
// Make a decision which system response to use based on the Decision Mechanism
// Update Explicit system rules based on accuracy (of ES's response)
acc = acccheck(resp,tr,colskip,stimdim);
Rcout<< "acc = " << acc <<"\n";
updrules = nextrules;
Rcout<< "updrules = " << updrules <<"\n";
updrules[crule]  = updsal(corcon, errcon, updrules[crule], acc);
Rcout<< "updrules = " << updrules <<"\n";

rrule = rand() % updrules.size();
Rcout<< "rrule = " << rrule <<"\n";
updrules[crule] = prerule(updrules[crule],perscon);
Rcout<< "updrules = " << updrules <<"\n";
updrules[rrule] = ranrule(updrules[rrule],lambda);
Rcout<< "updrules = " << updrules <<"\n";

nextrule = rchoose(Rcpp::clone(updrules),decsto);
Rcout<< "updrules = " << updrules <<"\n";

// Update Implicit system based on accuracy

return Rcpp::List::create(Rcpp::Named("nextr") = nextrule,
                          Rcpp::Named("newrules") = updrules);
}










// Finally this is the complete function for the COVIS model 
// incorporating all of the explicit, implicit and decision mechanisms.

//// [[Rcpp::export]]
//List covislp(List st,
//             NumericMatrix tr,
//             std::string explic,
//             int stimdim){
   

// Denote the set of possible explicit rules
//  double corcon = as<double>(st["c"]);
//  double perscon = as<double>(st["p"]);
//  double errcon = as<double>(st["e"]);
//  double s = as<double>(st["s"]);
//  double udsal = as<double>(st["ud"]);
//  double cjsal = as<double>(st["cj"]);
//  double djofcjsal = as<double>(st["dc"]);
//  int colskip = as<int>(st["colskip"]);
//  double decsto = as<double>(st["dec"]);
//  double decbound = as<double>(st["dbou"]);
//  double lambda = as<double>(st["lamb"]);
//  double nvar = as<double>(st["nvar"]);
//NumericVector rset = rules(stimdim, udsal, cjsal, djofcjsal, 0);


// Run through the training list
//int i, trial,items = tr.nrow(), nin;
//NumericVector x(stimdim);
//List covout;

//for(trial = 0; trial < items; trial++) {
//if( tr(trial,0) == 1 ) { 
// Reset network to initial state
//     }

//  Load stimulus dimensions

//for(i = colskip; i < stimdim+colskip; i++) {
//x[i-colskip] = tr(trial,i);
//}

//  Run one trial of COVIS



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
// NumericVector stmat(int stims){
//  NumericVector stmat (stims)
//  for(i=0;i < R::length(stmat)){
//    double U = R::rnorm(1)
//    stmat[i] = 0.001 + (0.0025 * U)
//  }
// }

// // [[Rcpp::export]]
// Implicit system

// Function to calculate striatal unit activation, needs a 2x2 matrix as input with
// a column for strength of the synapse between the cortical unit and the striatal
// cell and a column for the input from the cortical unit. Equ. 10 in E&W2016

//double stract(NumericMatrix cells, double ){
//  double e = noise(1,0);


//}






