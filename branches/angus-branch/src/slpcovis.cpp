// This script contain the functions for the COVIS list
// processor of the CATLEARN package.
// It is written in C++, using templates from the Rcpp
// package in R.
// Plugin for enabling C++11
// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include <iostream>
using namespace Rcpp;



// There are three parts to implementing COVIS
// A model of the explicit system, a model of the implicit
// system and an algorithm to monitor the output of the 
// systems and select a response on each trial

// Utility functions

double poisvar(double lambda){
  // Concpet checked: AW 2016-08-24
  // Operation checked: AI 2016-09-07
  // This function is to generate the random variable for
  // Equ 6. in E&W2016. It is generated from a poisson
  // distribution.
  double poisvar = R::rpois(lambda);
  return poisvar;
}

// Epsilon from Equation 2 (random normal variate)
// TICK - AW - 2016-09-09
double epsilon(double nvar){
  double epsilon = R::rnorm(0,nvar);
  return epsilon;
}
  
// First is the functions for the implementation of the
// explicit (rule-based) system

// Explicit
// Creates rule-set at initial salience
// TICKED! - AW 2016-09-09

// Notes: (1) Edmunds & Wills also have CJ of DJ
// Notes: (2) Are CJ and DJ always in practice equivalent?
// (they are for SHJ61).

// AI checked: 2016-08-24, up to 6 dimensions.
// AW checked: 2016-08-24, seems OK for single dimension
// rules. Not sure I understand how the number of others 
// is determined.

// AI : 06/09/2016. rechecked and made it easier to
// understand, handle up to 6 dimensions and handle
// differential initialsaliencies for different types of
// rules. 
// Operation checked: AI 2016-09-07

// stimdim - Number of stimulus dimensions
// udsal - Initial salience for unidimensional rules
// cjsal - Initial salience for conjunctive rules
// djofcjsal - Initial salience for disjunction of
// conjunction rules
// incl - 0: single dimension only, 1: SD, CJ, DJ.


NumericVector rules(int stimdim, double udsal, double cjsal,
                    double djofcjsal, int incl){
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
  {prules = stimdim*2;
    NumericVector exprules(prules,udsal);
    return exprules;}
  return exprules;
}


// Function to calculate the discrimant value used in the 
// Response rule.
// Operation checked : AI 07/09/2016
// TICK - AW - 2016-09-09
double disfunc(double stimval,double deccrit){
  double disval = stimval - deccrit;
  return disval;
}


int expres(double disval, double nvar,int crule){
  // TICK: AW 2016-08-16
  
  // Response rule for explicit system 
  
  // This response rule exists in the explicit system to 
  // decide whether to respond with A or B, referencing two
  // categories as is the norm. Epsilon is a normally
  // distributed variable
  
  // Edmunds & Wills (2016, Equ. 2)
  // disval - discriminant value (h_v)
  // nvar - noise (sigma_v)
  // double epsilon = R::rnorm(0.0,nvar);
  int Response;
  double eps = epsilon(nvar);
  //if(crule%2 == 0){
    if(disval < eps)
    {Response = 1;}
    else
    {Response = 2;}
  //}
  //else{
  //  if(disval < eps) // These need to be commented back 
  //  in later
  //  {Response = 2;}
  //  else
  //  {Response = 1;}
  //}
  return Response;
}


int acccheck(int resp, NumericVector tr,int colskip,
             int stimdim){
  // TICK: AW 2016-08-16
  
  // Explicit system
  
  // Function to check accuracy of predicted response
  // against actual response
  
  // Required to decide whether Equ. 3 or 4 is in force
  // Edmunds & Wills (2016)
  
  int acc;
  acc = 0;
  if ((resp == 1) & (tr[colskip+stimdim] == 1)) acc = 1;
  if ((resp == 2) & (tr[colskip+stimdim] == -1)) acc = 1;
  return acc;
}


// Function to update rule saliency based on accuracy of
// response. Either increments salience positively based on
// a constant if correct, and negatively based on a 
// different constant if incorrect.

// TICK - AW - 2016-09-09
// Operation checked: AI 07/09/2016

// Equ. 3,4
// corcon - delta C
// errcon - delta E
// psal - Z
// acc = 1 if correct, 0 if incorrect

double updsal(double corcon, double errcon, double psal,
              int acc){
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
  // This is the first of the functions to transform the
  // saliencies of the rulesto weights, Equ 5. in E&W2016.
  // Used for the rule used on the previous trial.
  
  // Operation Checked: AI 07/09/2016 
  double rulweight = rulsal + perscon;
  return rulweight;
}

 
double ranrule(double rulsal,double lambda){
  // Explicit system
  
  // This is the second of the functions to transform the 
  // saliences of the rules to weights, Equ 6. in E&W2016.
  // Used  for another rule from the set chosen at random.
  
  // Operation Checked: AI 07/09/2016
  // TICK - AW - 2016-09-09
  double pois = poisvar(lambda);
  double rulweight = rulsal + pois;
  return rulweight;
}

int rchoose(NumericVector exprules, double stocon){
  // Explicit system
  
  // This function is to choose a rule based on the
  // probabilities of those rules (probabilities come from 
  // EW2016, Eq.8)
  
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
  std::partial_sum(selrules.begin(), selrules.end(),
                   res.begin());
  double val = (double)rand() / RAND_MAX;
  for(i=0;i < res.size();i++){
    if (res[i] > val) {rsec = i;break;}
    else {rsec = -1;}
  }
  return rsec;
}

// Next is the functions for implementation of the
// procedural (implicit) system

// First are the activation equations

// Utility Function to calculate sensory unit activation on 
// a trial. 
// Part of Equ. 9 in E&W2016
// sconst: alpha
// diff: distance
// Checked: AI 19/09/2016
// Checked: AW 28/09/2016

double scuact(double sconst,double diff){
  double act,super,e;
  super = -(pow(diff,2)/sconst);
  e = 2.718282;
  act = pow(e,super);
  return act;
}


// Function to calculate the activation of sensory cortex 
// units. Equ.9

// scumat: Co-ordinates of the sensory cortex units in 
// psychological space.
// cstim: Co-ordinates of the presented stimulus.
// sconst: alpha (Equ.9)

// Checked: AI 27/09/2016
// Checked: AW 28/09/2016

NumericVector actcalc(NumericMatrix scumat,
                      NumericVector cstim, double sconst){
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

// NOTE: Does activation calcs but does not return them, 
// returns decision. This may not be the right thing to do,
// as activationsprobably needed for learning rule.
// Split into activation and decision components. 

// Also, don't need intermediate matrix cortact, just sum.

// Checked: AI 27/09/2016

NumericVector stract(NumericMatrix wkj,NumericVector ik,
                     double noisecon){
  int i,j,nrow = wkj.nrow(), ncol = wkj.ncol();
  double noise;
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
int i,act=0,ncol = sumact.size();
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
// How is no feedback represented in the input training 
// array?
// Normally, it'd be something like [0,0] where normal
// feedback trials are [1,-1] and [-1,1]

// Checked: AI 27/09/2016
// Not checked AW, too simple. 

double obtrew(int acc){
  double rew;
  if (acc == 1){rew = 1;}
  if (acc == 0){rew = -1;}
  if (acc == -1){rew = 0;}
  return rew;
}


// Function to calculate predicted reward.
// Eq. 14 Edmunds-Wills(2016)

// prep: previous P
// prer: previous R

// Checked: AI 27/09/2016
// Check AW 03-10-2016

double prerew(double prep,double prer,double precon){
  double rew,add;
  add = precon*(prer-prep);
  rew = prep + add;
  return rew;
}


// Function to calculate dopamine release.
// Ashby et al. (2011), equ. 13

// obtrew - obtained reward (1 = correct, 
// 0 = absence of feedback, -1 = incorrect)

// Checked: AI 27/09/2016
// Checked: AW 03-10-2016

double doprel(double obtrew, double prerew){
  double rpe,dn;
  rpe = obtrew - prerew;
  if (rpe > 1){dn = 1;}
  if ((1 >= rpe) and (rpe > -0.25)){dn = (0.8*rpe)+0.2;}
  if (rpe <= -0.25){dn = 0;}
  return dn;
}


// Next is the large equation for adjusting synapse strength
// Function to calculate equation 10 of Ashby et al. (2011)

// Checked: AI 27/09/2016
// Lightly checked: AW 03-10-2016

// nsystr - New SYnapse STRength

// Calculated values:
// systr - SYnapse STRength
// act - sensory cortex activation
// sum - striatal unit activation
// dn - Dopamine released

// Free parameters:
// alpha - alpha-w learning rate parameter of COVIS
// beta - beta-w learning rate parameter of COVIS
// gamma - gamma-w learning rate parameter of COVIS
// nmda - theta nmda par.
// dbase - baseline dopamine
// wmax - Maximum link strength
// ampa - theta ampa par.

double nsystr(double systr,double act,double sum,double dn,
              double alpha,double beta,double gamma,
              double nmda,double ampa,double dbase,
              double wmax){
  double a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,out;
  double out1,out2,out3;
  // section 1 : increases in strength
  a1 = act * alpha;
  b1 = sum - nmda;
  if (b1 < 0){b1 = 0;}
  c1 = dn -dbase;
  if (c1 < 0){c1 = 0;}
  d1 = wmax - systr;
  if (d1 < 0){d1 = 0;}
  out1 = a1*b1*c1*d1;
  // section 2 : decreases in strength
  a2 = beta * act;
  b2 = sum - nmda;
  if (b2 < 0){b2 = 0;}
  c2 = dbase - dn;
  if (c2 < 0){c2 = 0;}
  d2 = systr;
  out2 = a2*b2*c2*d2;
  // section 3: more decreases in strength
  a3 = gamma * act;
  b3 = nmda - sum;
  if (b3 < 0){b3 = 0;}
  c3 = b3 - ampa;
  if (c3 < 0){c3 = 0;}
  d3 = systr;
  out3 = a3*c3*d3;
  out = systr + out1 - out2 - out3;
  return out;
}

// Function for running one trial through the COVIS system
// [[Rcpp::export]]
List slpCOVIS(List st,
              NumericMatrix tr,
              NumericVector initrules,
              NumericMatrix initsy,
              NumericMatrix scups,
              bool crx = true,
              bool respt = true,
              bool xtdo = false){
// This clumsy section copies stuff out of an R List
// There seems to be no way in RCpp to get direct access to
// a List at input?
double corcon = as<double>(st[0]);
double errcon = as<double>(st[1]);
double perscon = as<double>(st[2]);
double decsto = as<double>(st[3]);
double decbound = as<double>(st[4]);
double lambda = as<double>(st[5]);
double envar = as<double>(st[6]);
double emaxval = as<double>(st[7]);
double dbase = as<double>(st[8]);
double alphaw = as<double>(st[9]);
double betaw = as<double>(st[10]);
double gammaw = as<double>(st[11]);
double nmda = as<double>(st[12]);
double ampa = as<double>(st[13]);
double wmax = as<double>(st[14]);
double invar = as<double>(st[15]);
double sconst = as<double>(st[16]);
double prep = as<double>(st[17]);
double prer = as<double>(st[18]);
double etrust = as<double>(st[19]);
double itrust = as<double>(st[20]);
double ocp = as<double>(st[21]);
double oep = as<double>(st[22]);
int colskip = as<int>(st[23]);
int stimdim = as<int>(st[24]);
// End of particularly clumsy section
int i,j,k,x = 3,cdim=0,rrule = -1,expresp,impresp,expacc;
int impacc,sresp=0,sused=0,acc=0, nrow = initsy.nrow();
int ncol = initsy.ncol(),length = tr.nrow();
double hvx,hvp,econf,iconf,dn,crule,imaxval=0; 
NumericVector updrules(clone(initrules)),
                       acts,sumact,cstim,
                       wrules(clone(initrules));
crule = rchoose(Rcpp::clone(updrules),decsto);
NumericMatrix updsy = (Rcpp::clone(initsy));
NumericVector train = tr(0,_);
// Setup output matrix
if (xtdo){x = 45;}
NumericMatrix outmat(length,x);
for(i=0;i<length;i++){
  // Initial setup for current trial
  int l=0,m=0,n=0;
  train = tr(i,_);
  cstim = train[Range(colskip,((colskip-1)+stimdim))];
  // Generate a response from the Explicit system
  cdim = cstim[crule];
  hvx = disfunc(cdim,decbound);
  expresp = expres(hvx,envar,crule);
  // Generate a response from the Implicit system
  acts = actcalc(scups,cstim,sconst);
  sumact = stract(updsy,acts,invar);
  hvp = fabs(sumact(0) - sumact(1));
  impresp = decact(sumact);
  // Make a decision which system response to use
  econf = fabs(hvx)/emaxval; 
  if(fabs(sumact(0)-sumact(1)) > imaxval)
    {imaxval = fabs(sumact(0)-sumact(1));}
  iconf = hvp/imaxval;
  if((econf*etrust) > (iconf*itrust))
    {sresp = expresp;
     sused = 1;}
  else 
    {sresp = impresp;
     sused = 2;}
  // Update Explicit system rules based on accuracy
  if (respt == true)
    {expacc = acccheck(sresp,train,colskip,stimdim);
     impacc = acccheck(sresp,train,colskip,stimdim);}
  if (respt == false)
    {expacc = acccheck(expresp,train,colskip,stimdim);
     impacc = acccheck(impresp,train,colskip,stimdim);}
  if (sused == 1)
     {acc = acccheck(expresp,train,colskip,stimdim);}
  else
     {acc = acccheck(impresp,train,colskip,stimdim);}
  // Update the explicit system based on the accuracy
  if (expacc == 1)
    {updrules[crule] = updsal(corcon,errcon,
                              updrules[crule],expacc);
     crule = crule;}
  else
    {if (crx == true)
      {rrule = rand() % updrules.size();}
     if (crx == false)
      {rrule = rand() % updrules.size();
          for (j=0;j<1000;j++){
            if (crule == rrule)
            {rrule = rand() % updrules.size();}
            else
            {break;}
          }
       }
       updrules[crule] = updsal(corcon,errcon,
                                updrules[crule],expacc);
       for(j=0;j<updrules.size();j++){
         if (updrules[j] < 0){updrules[j] = 0;}
       }
       wrules = Rcpp::clone(updrules);
       wrules[crule] = prerule(wrules[crule],perscon);
       wrules[rrule] = ranrule(wrules[rrule],lambda);
       crule = rchoose(Rcpp::clone(wrules),decsto);}
  if (expacc == 1)
    {etrust = etrust + (ocp*(1-etrust));}
  else 
    {etrust = etrust - (oep*etrust);}
  
  // Update Implicit system based on accuracy
  prep = prerew(prep,prer,0.025);
  prer = obtrew(impacc);
  dn = doprel(prer,prep);
  for(j=0;j<nrow;j++){
    for(k=0;k<ncol;k++){
      updsy(j,k) = nsystr(updsy(j,k),acts(j),sumact(k),dn,
            alphaw,betaw,gammaw,nmda,ampa,dbase,wmax);
    }
  }
  // Update the trust in the implicit system
  itrust = 1 - etrust;
  // Update output matrix
  if (sresp == 1){outmat(i,0) = 1;
                  outmat(i,1) = 0;}
  if (sresp == 2){outmat(i,0) = 0;
                  outmat(i,1) = 1;}
  outmat(i,2) = acc;
  if (xtdo){
            outmat(i,3) = sused;
            outmat(i,4) = etrust;
            outmat(i,5) = itrust;
            outmat(i,6) = cdim;
            outmat(i,7) = hvx;
            outmat(i,8) = expresp;
            outmat(i,9) = hvp;
            outmat(i,10) = impresp;
            outmat(i,11) = econf;
            outmat(i,12) = iconf;
            outmat(i,13) = imaxval;
            outmat(i,14) = emaxval;
            outmat(i,15) = expacc;
            outmat(i,16) = impacc;
            outmat(i,17) = respt;
            outmat(i,18) = rrule;
            outmat(i,19) = crule;
            outmat(i,20) = prep;
            outmat(i,21) = prer;
            outmat(i,22) = dn;
            for(j=23;j<27;j++){
              outmat(i,j) = cstim(l);
              l = l + 1;
              }
            for(j=27;j<43;j++){
              outmat(i,j) = acts(m);
              m = m + 1;
              }
            for(j=43;j<45;j++){
              outmat(i,j) = sumact(n);
              n = n + 1;
              }
            }
    }
return Rcpp::List::create(Rcpp::Named("foutmat") = outmat,
                          Rcpp::Named("frules") = updrules,
                          Rcpp::Named("fsystr") = updsy);
}
