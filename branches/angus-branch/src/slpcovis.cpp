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


int acccheck(int resp, NumericVector tr,int colskip, int stimdim, int feedback){
  // TICK: AW 2016-08-16
  
  // Explicit system
  
  // Function to check accuracy of predicted response against actual
  // response
  
  // Required to decide whether Equ. 3 or 4 is in force
  // Edmunds & Wills (2016)
  
  int acc;
  acc = 0;
  if (feedback == 1){
    if ((resp == 1) & (tr[colskip+stimdim] == 1)) acc = 1;
    if ((resp == 2) & (tr[colskip+stimdim] == -1)) acc = 1;}
  else {acc = -1;}
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

// Next is the functions for implementation of the procedural (implicit) system

// First are the activation equations

// Utility Function to calculate sensory unit activation on a trial 
// Part of Equ. 9 in E&W2016
// sconst: alpha
// diff: distance
// Checked: AI 19/09/2016
// Checked: AW 28/09/2016

// [[Rcpp::export]]
double scuact(double sconst,double diff){
  double act,super,e;
  super = -(pow(diff,2)/sconst);
  e = 2.718282;
  act = pow(e,super);
  return act;
}


// Function to calculate the activation of sensory cortex units.
// Equ.9

// scumat: Co-ordinates of the sensory cortex units in psychological space.
// cstim: Co-ordinates of the presented stimulus.
// sconst: alpha (Equ.9)

// Checked: AI 27/09/2016
// Checked: AW 28/09/2016

// [[Rcpp::export]]
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


// Function to calculate the activation of striatal units,
// Equ 10 in E&W2016. Also generates a response based on the
// summed activation.
// wkj: sensory-striatal link strengths
// ik: Activation of sensory cortical units
// noisecon: Normally distributed noise (variance constant)

// NOTE: Does activation calcs but does not return them, returns 
// decision. This may not be the right thing to do, as activations
// probably needed for learning rule.
// Split into activation and decision components. 

// Also, don't need intermediate matrix cortact, just sum.

// Checked: AI 27/09/2016

// [[Rcpp::export]]
NumericVector stract(NumericMatrix wkj,NumericVector ik,double noisecon){
  int i,j,nrow = wkj.nrow(), ncol = wkj.ncol();
  double act,noise,largeact;
  NumericVector sumact(ncol);
  for(i=0;i < ncol;i++){
    noise = epsilon(noisecon);
    for(j=0;j < nrow;j++){
      sumact(i) = sumact(i) + (wkj(j,i) * ik(j));
    }
    sumact(i) = sumact(i) + noise;
  }
  return sumact;
}

// Function for decision based on summed activations
int decact(NumericVector sumact){
int i,act,ncol = sumact.size();
double largeact;
largeact = max(sumact);
for(i=0;i < ncol;i++){
  if (sumact(i) == largeact){act = i + 1;}
  }
return act;
}

// Next are the learning equations

// First are the equations necessary to specify the dopamine
// released on each trial


// Function to calculate obtained reward.
// Part of Eq. 13
// How is no feedback represented in the input training array?
// Normally, it'd be something like [0,0] where normal
// feedback trials are [1,-1] and [-1,1]

// Checked: AI 27/09/2016
// Not checked AW, too simple. 

// [[Rcpp::export]]
double obtrew(int acc){
  double rew;
  if (acc == 1){rew = 1;}
  if (acc == 0){rew = -1;}
  if (acc == -1){rew = 0;}
  return rew;
}


// Function to calculate predicted reward.
// Eq. 14

// Checked: AI 27/09/2016

// [[Rcpp::export]]
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
  if (b1 < 0){b1 = 0;}
  else {b1 = b1;}
  c1 = dn -dbase;
  if (c1 < 0){c1 = 0;}
  else {c1 = c1;}
  d1 = wmax - systr;
  if (d1 < 0){d1 = 0;}
  else {d1 = d1;}
  out1 = a1*b1*c1*d1;
  a2 = beta * act;
  b2 = sum - nmda;
  if (b2 < 0){b2 = 0;}
  else {b2 = b2;}
  c2 = dbase - dn;
  if (c2 < 0){c2 = 0;}
  else {c2 = c2;}
  d2 = systr;
  out2 = a2*b2*c2*d2;
  a3 = gamma * act;
  b3 = nmda - sum;
  if (b3 < 0){b3 = 0;}
  else {b3 = b3;}
  c3 = b3 - ampa;
  if (c3 < 0){c3 = 0;}
  else {c3 = c3;}
  d3 = systr;
  out3 = a3*c3*d3;
  out = systr + out1 - out2 - out3;
  return out;
}






// Function for running one trial through the COVIS system
// [[Rcpp::export]]
List covistrial(NumericVector tr,NumericVector nextrules,int colskip,int stimdim,
                double corcon,double errcon,double perscon,double decsto, 
                double decbound,double lambda,double nvar,int crule,int feedback){
                //NumericMatrix initsy,NumericMatrix scuval,double prep,double prer,
                //double alpha,double beta,double gamma,double nmda,double wmax,
                //double ampa, double dbase)
int i,j,cdim=0,rrule,expresp,impresp,cb,expacc,impacc,nextrule;
// int nrow = initsy.nrow(), ncol = initsy.ncol();
double hvx;//orew,prew,dn; 
NumericVector updrules;//,dists;
// NumericMatrix updsy;
// Generate a response from the Explicit system
cb = 2;
for(i=0;i<stimdim;i++){
  for(j=(cb*i);j<(cb*(j+1));j++){
    if(j == crule){cdim = tr[colskip+i];}
  }
}
hvx = disfunc(cdim,decbound);
Rcout<< "hvx = " << hvx <<"\n";
expresp = expres(hvx,nvar,crule);
Rcout<< "expresp = " << expresp <<"\n";
// Generate a repsonse from the Implicit system
// dists = distcalc(scuval,cdim,nvar);
// impresp =stract(initsy,dists,nvar);
// Make a decision which system response to use based on the Decision Mechanism
// Update Explicit system rules based on accuracy (of ES's response)
expacc = acccheck(expresp,tr,colskip,stimdim,feedback);
Rcout<< "tr[colskip+stimdim] = " << tr[colskip+stimdim] <<"\n";
Rcout<< "expacc = " << expacc <<"\n";
updrules = nextrules;
updrules[crule]  = updsal(corcon, errcon, updrules[crule], expacc);
if (expacc == 1){nextrule = crule;}
else{rrule = rand() % updrules.size();
     updrules[crule] = prerule(updrules[crule],perscon);
     updrules[rrule] = ranrule(updrules[rrule],lambda);
     nextrule = rchoose(Rcpp::clone(updrules),decsto);}
Rcout<< "nextrule = " << nextrule <<"\n";

// Update Implicit system based on accuracy
// impacc = acccheck(impresp,tr,colskip,stimdim);
// orew = obtrew(impacc);
// prew = prerew(prep,prer);
// dn = doprel(orew,prew);
// updsy = initsy;
// for(i=0;i<nrow;i++){
//   for(j=0;j<ncol;j++){
//     updsy(i,j) = nsystr(updsy(i,j),dists(i),alpha,beta,gamma,
//            sum(updsy(_,j)),nmda,dn,dbase,wmax,ampa);
//   }
// }
//
return Rcpp::List::create(Rcpp::Named("nextr") = nextrule,
                          Rcpp::Named("newrules") = updrules
                          //Rcpp::Named("updsy") = updrules//
                          );
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
















// Rcout<< "crule = " << crule <<"\n";

