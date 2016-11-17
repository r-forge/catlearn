// This script contain the functions for the COVIS list processor of the 
// CATLEARN package
// It is written in C++, using templates from the Rcpp package in R 
// Plugin for enabling C++11
// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include <iostream>
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
  {prules = stimdim*2;
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
  //if(crule%2 == 0){
    if(disval < eps)
    {Response = 1;}
    else
    {Response = 2;}
  //}
  //else{
  //  if(disval < eps) // These need to be commented back in later
  //  {Response = 2;}
  //  else
  //  {Response = 1;}
  //}
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

// Next is the functions for implementation of the procedural (implicit) system

// First are the activation equations

// Utility Function to calculate sensory unit activation on a trial 
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


// Function to calculate the activation of sensory cortex units.
// Equ.9

// scumat: Co-ordinates of the sensory cortex units in psychological space.
// cstim: Co-ordinates of the presented stimulus.
// sconst: alpha (Equ.9)

// Checked: AI 27/09/2016
// Checked: AW 28/09/2016

NumericVector actcalc(NumericMatrix scumat, NumericVector cstim, double sconst){
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

NumericVector stract(NumericMatrix wkj,NumericVector ik,double noisecon){
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
// How is no feedback represented in the input training array?
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

// obtrew - obtained reward (1 = correct, 0 = absence of feedabck, -1
// = incorrect)

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

double nsystr(double systr,double act,double sum,double dn,double alpha,double beta,
              double gamma,double nmda,double ampa,double dbase,double wmax){
  double a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,out,out1,out2,out3;
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
NumericMatrix slpCOVIS(NumericMatrix train,NumericVector nextrules,NumericMatrix initsy,
                NumericMatrix scuval,List exppar,List imppar,List comppar,List extpar){
// This clumsy section copies stuff out of an R List
// There seems to be no way in RCpp to get direct access to a 
// List at input?
double corcon = as<double>(exppar[0]);
double errcon = as<double>(exppar[1]);
double perscon = as<double>(exppar[2]);
double decsto = as<double>(exppar[3]);
double decbound = as<double>(exppar[4]);
double lambda = as<double>(exppar[5]);
double envar = as<double>(exppar[6]);
double emaxval = as<double>(exppar[7]);

double dbase = as<double>(imppar[0]);
double alphaw = as<double>(imppar[1]);
double betaw = as<double>(imppar[2]);
double gammaw = as<double>(imppar[3]);
double nmda = as<double>(imppar[4]);
double ampa = as<double>(imppar[5]);
double wmax = as<double>(imppar[6]);
double invar = as<double>(imppar[7]);
double sconst = as<double>(imppar[8]);
double prep = as<double>(imppar[9]);
double prer = as<double>(imppar[10]);

double etrust = as<double>(comppar[0]);
double itrust = as<double>(comppar[1]);
double ocp = as<double>(comppar[2]);
double oep = as<double>(comppar[3]);

int colskip = as<int>(extpar[0]);
int stimdim = as<int>(extpar[1]);
// respt is whether the two systems get:
// 1 = the overall model response feedback
// 2 = the feedback for each systems response
int respt = as<int>(extpar[2]);
// crx is whether when selecting the random rule to add the poisson variable to:
// 1 = choose any of the rules
// 2 = choose any of the rules that are not the current rule
int crx = as<int>(extpar[3]);
// If xtdo is 1 then the function produces trial by trial state output
int xtdo = as<int>(extpar[4]);
// End of particularly clumsy section
int i,j,k,cdim=0,rrule = -1,expresp,impresp,expacc,impacc,sresp=0,sused=0,acc=0;
int nrow = initsy.nrow(), ncol = initsy.ncol(),length = train.nrow();
double hvx,hvp,econf,iconf,dn,crule,imaxval=0; 
// Have to add a couple of clone functions here, to prevent 
// any change to input variables from R.
// This line defines a number of numeric vectors.
NumericVector updrules(clone(nextrules)),acts,sumact,cstim,wrules(clone(nextrules));
// This line executes once and chooses a rule for the explicit
// system to use for the first trial
crule = rchoose(Rcpp::clone(updrules),decsto);
// This line defines a numeric matrix with the same value as
// initsy, but is then updated on every trial
NumericMatrix updsy = (Rcpp::clone(initsy));
// Ensure that tr starts with some value rather than being empty
NumericVector tr = train(0,_);
// Setup output matrix
//if (xtdo == 1){
NumericMatrix outmat(length,81);//}
//else {NumericMatrix outmat(length,6);}
for(i=0;i<length;i++){
  // Initial setup for current trial
  int l=0,m=0,n=0,o=0,p=0,q=0;
  // set tr to the current training trial row in the training matrix
  tr = train(i,_);
  // set the stimulus dimension values for the current stimulus
  cstim = tr[Range(colskip,((colskip-1)+stimdim))];
  
  // Generate a response from the Explicit system
  
  // This sets the current value for the stimulus dimension
  // being used by the current selected rule
  cdim = cstim[crule]; //(ceil(crule/2)-1)
  // This sets the discriminant value hvx using the discrimant function
  hvx = disfunc(cdim,decbound);
  // This generates a response from the explicit system 
  expresp = expres(hvx,envar,crule);
  
  // Generate a response from the Implicit system
  
  // This line calculates the activations of each sensory 
  // cortical unit and returns it as a matrix of all of them
  acts = actcalc(scuval,cstim,sconst);
  // This line calculates the summed activation for each striatal unit
  sumact = stract(updsy,acts,invar);
  hvp = fabs(sumact(0) - sumact(1));
  // This line calculates the implicit system response
  impresp = decact(sumact);
  
  // Make a decision which system response to use based on the Decision Mechanism
  
  // This line calculates the confidence in the response of the explicit system
  econf = fabs(hvx)/emaxval; 
  // This if statement checks to see if the new value generated is
  // bigger than the previous max and makes it the nex max if bigger
  if(fabs(sumact(0)-sumact(1)) > imaxval){imaxval = fabs(sumact(0)-sumact(1));}
  // This line calculates the confidence in the response of the implicit system
  iconf = hvp/imaxval;
  // This part of code determines which response COVIS uses 
  // and tracks which system was chosen
  if((econf*etrust) > (iconf*itrust))
    {sresp = expresp;
     sused = 1;}
  else {sresp = impresp;
       sused = 2;}
  
  // Update Explicit system rules based on accuracy
  
  // This then sets the system accuracy based on the accruacy of the system used
  if (respt == 1) {expacc = acccheck(sresp,tr,colskip,stimdim);
                   impacc = acccheck(sresp,tr,colskip,stimdim);}
  else {expacc = acccheck(expresp,tr,colskip,stimdim);
        impacc = acccheck(impresp,tr,colskip,stimdim);}
  
  if (sused == 1){acc = acccheck(expresp,tr,colskip,stimdim);}
  else{acc = acccheck(impresp,tr,colskip,stimdim);}
  
  // This part of code updates the explicit system based on the accuracy
  if (expacc == 1){updrules[crule] = updsal(corcon, errcon, updrules[crule],expacc);
                   crule = crule;}
  else{if (crx == 1){rrule = rand() % updrules.size();}
       else{rrule = rand() % updrules.size();
            for (j=0;j<1000;j++){
              if (crule == rrule){rrule = rand() % updrules.size();}
              else{break;}
            }
       }
       updrules[crule] = updsal(corcon, errcon, updrules[crule],expacc);
       for(j=0;j<updrules.size();j++){
         if (updrules[j] < 0){updrules[j] = 0;}
       }
       wrules = Rcpp::clone(updrules);
       wrules[crule] = prerule(wrules[crule],perscon);
       wrules[rrule] = ranrule(wrules[rrule],lambda);
       crule = rchoose(Rcpp::clone(wrules),decsto);}
  // This line updates the trust in the explicit system based on accuracy
  if (expacc == 1){etrust = etrust + (ocp*(1-etrust));}
  else {etrust = etrust - (oep*etrust);}
  
  // Update Implicit system based on accuracy
  
  // THis line updates the predicted reward for the current trial
  prep = prerew(prep,prer,0.025);
  // This line updates the obtained reward for the current trial
  prer = obtrew(impacc);
  // This calculates the dopamine released on the current trial
  dn = doprel(prer,prep);
  // This part of the code updates the synapse strengths
  for(j=0;j<nrow;j++){
    for(k=0;k<ncol;k++){
      updsy(j,k) = nsystr(updsy(j,k),acts(j),sumact(k),dn,
            alphaw,betaw,gammaw,nmda,ampa,dbase,wmax);
    }
  }
  // This part of the code updates the trust in the implicit system
  itrust = 1 - etrust;
  // Update output matrix
  //if (xtdo == 1){
            outmat(i,0) = i+1;
            outmat(i,1) = sresp;
            outmat(i,2) = sused;
            outmat(i,3) = acc;
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
            for(j=45;j<49;j++){
              outmat(i,j) = updrules(o);
              o = o + 1;
              }
            for(j=49;j<65;j++){
              outmat(i,j) = updsy(p,0);
              p = p + 1;
              }
            for(j=65;j<81;j++){
              outmat(i,j) = updsy(q,1);
              q = q + 1;
              }
    //}
    //else{outmat(i,0) = i+1;
        // outmat(i,1) = sresp;
        // outmat(i,2) = sused;
        // outmat(i,3) = acc;
        // outmat(i,4) = etrust;
        // outmat(i,5) = itrust;
        // }
    }
  return outmat;
}

// Rcout<< "crule = " << crule <<"\n";

