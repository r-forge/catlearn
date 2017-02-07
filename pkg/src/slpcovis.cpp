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
  // This function is to generate the random variable for
  // Equ 5. in P+W2012. It is generated from a poisson
  // distribution.
  double poisvar = R::rpois(lambda);
  return poisvar;
}

// Epsilon from Page 68 of P+W2012.
double epsilon(double nvar){
  double epsilon = R::rnorm(0,nvar);
  return epsilon;
}

NumericMatrix symat(int stims,int cats){
  // Function to generate matrix of initial synapse 
  // strengths
  // stims - Number of sensory cortex units
  // cats - Number of striatal units
  int i,j;
  double u;
  NumericMatrix smat(stims,cats);
  for(i=0;i < cats; i++){
    for(j=0;j < stims; j++){
      u = R::runif(0,1);
      smat(j,i) = 0.001 + (0.0025 * u);
    }
  }
  return smat;
}
  
// First is the functions for the implementation of the
// explicit (rule-based) system

// Function to calculate the discrimant value used in the 
// Response rule, Eq1 in P+W2012.
double disfunc(double stimval,double deccrit){
  double disval = stimval - deccrit;
  return disval;
}


int expres(double disval, double nvar,int crule){
  // This response rule exists in the explicit system to 
  // decide whether to respond with A or B, referencing two
  // categories as is the norm. Epsilon is a normally
  // distributed variable (Page 68 of P+W2012).
  
  // disval - discriminant value (h_v)
  // nvar - noise (sigma_v)
  // double epsilon = R::rnorm(0.0,nvar);
  int Response;
  double eps = epsilon(nvar);
  if(disval < eps)
  {Response = 1;}
  else
  {Response = 2;}
  return Response;
}


int acccheck(int resp, NumericVector tr,int colskip,
             int stimdim){
  // Function to check accuracy of predicted response
  // against actual response
  
  // Required to decide whether Equ. 2 or 3 of P+W2012 is in
  // force
  int acc;
  acc = 0;
  if ((resp == 1) & (tr[colskip+stimdim] == 1)) acc = 1;
  if ((resp == 2) & (tr[colskip+stimdim] == -1)) acc = 1;
  return acc;
}

double updsal(double corcon, double errcon, double psal,
              int acc){
  // Function to update rule saliency based on accuracy of
  // response. Either increments salience positively based 
  // on a constant if correct, and negatively based on a 
  // different constant if incorrect.Equ. 2/3 of P+W2012.
  
  // corcon - delta C
  // errcon - delta E
  // psal - Z
  // acc = 1 if correct, 0 if incorrect
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
  // This is the first of the functions to transform the
  // saliencies of the rules to weights, Equ 4. in P+W2012.
  // Used for the rule used on the previous trial.
  double rulweight = rulsal + perscon;
  return rulweight;
}

 
double ranrule(double rulsal,double lambda){
  // This is the second of the functions to transform the 
  // saliences of the rules to weights, Equ 5. in P+W2012.
  // Used  for another rule from the set chosen at random.
  double pois = poisvar(lambda);
  double rulweight = rulsal + pois;
  return rulweight;
}

int rchoose(NumericVector exprules, double stocon){
  // This function is to choose a rule based on the
  // probabilities of those rules (probabilities come from 
  // P+W2012, Eq.7)
  
  // exprules - The rule weights
  // stocon - parameter a (this is from Edmunds and 
  // Wills(2016); it is used to establish whether a rule is 
  // chosen deterministically or probabilistically. 1 =
  // probabilistic, >1 = deterministic)
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

double scuact(double sconst,double diff){
  // Utility Function to calculate sensory unit activation on 
  // a trial. 
  // Part of Equ. 8 in P+W2012
  
  // sconst: alpha
  // diff: distance
  double act,super,e;
  super = -(pow(diff,2)/sconst);
  e = 2.718282;
  act = pow(e,super);
  return act;
}

NumericVector actcalc(NumericMatrix scumat,
                      NumericVector cstim, double sconst){
  // Function to calculate the activation of sensory cortex 
  // units. Equ.8 of P+W2012.
  
  // scumat: Co-ordinates of the sensory cortex units in 
  // psychological space.
  // cstim: Co-ordinates of the presented stimulus.
  // sconst: alpha (Equ.8)
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

NumericVector stract(NumericMatrix wkj,NumericVector ik,
                     double noisecon){
  // Function to calculate the activation of striatal units,
  // Equ 9 in P&W2012. Also generates a response based on the
  // summed activation.
  
  // wkj: sensory-striatal link strengths
  // ik: Activation of sensory cortical units
  // noisecon: Normally distributed noise (variance constant)
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

int decact(NumericVector sumact){
  // Function for decision based on summed activations
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

double obtrew(int acc){
  // Function to calculate obtained reward.
  // Part of Eq. 13 in P+W2012.
  double rew;
  if (acc == 1){rew = 1;}
  if (acc == 0){rew = -1;}
  if (acc == -1){rew = 0;}
  return rew;
}


double prerew(double prep,double prer,double precon){
  // Function to calculate predicted reward.
  // Eq. 12 in P+W2012
  
  // prep: previous P
  // prer: previous R
  double rew,add;
  add = precon*(prer-prep);
  rew = prep + add;
  return rew;
}

double doprel(double obtrew, double prerew){
  // Function to calculate dopamine release.
  // Eq 13 of P+W2012.
  
  // obtrew - obtained reward (1 = correct, 
  // 0 = absence of feedback, -1 = incorrect)
  double rpe,dn;
  rpe = obtrew - prerew;
  if (rpe > 1){dn = 1;}
  if ((1 >= rpe) and (rpe > -0.25)){dn = (0.8*rpe)+0.2;}
  if (rpe <= -0.25){dn = 0;}
  return dn;
}

double nsystr(double systr,double act,double sum,double dn,
              double alpha,double beta,double gamma,
              double nmda,double ampa,double dbase,
              double wmax){
  // Function to calculate equation 10 of P+W2012
  
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
              bool crx = true,
              bool respt = true,
              bool rgive = true,
              bool xtdo = false){
// This clumsy section copies stuff out of an R List
// There seems to be no way in RCpp to get direct access to
// a List at input?
double corcon = as<double>(st["corcon"]);
double errcon = as<double>(st["errcon"]);
double perscon = as<double>(st["perscon"]);
double decsto = as<double>(st["decsto"]);
double decbound = as<double>(st["decbound"]);
double lambda = as<double>(st["lambda"]);
double envar = as<double>(st["envar"]);
double emaxval = as<double>(st["emaxval"]);
double dbase = as<double>(st["dbase"]);
double alphaw = as<double>(st["alphaw"]);
double betaw = as<double>(st["betaw"]);
double gammaw = as<double>(st["gammaw"]);
double nmda = as<double>(st["nmda"]);
double ampa = as<double>(st["ampa"]);
double wmax = as<double>(st["wmax"]);
double invar = as<double>(st["invar"]);
double sconst = as<double>(st["sconst"]);
double prep = as<double>(st["prep"]);
double prer = as<double>(st["prer"]);
double etrust = as<double>(st["etrust"]);
double itrust = as<double>(st["itrust"]);
double ocp = as<double>(st["ocp"]);
double oep = as<double>(st["oep"]);
int colskip = as<int>(st["colskip"]);
int stimdim = as<int>(st["stimdim"]);
int crule = as<int>(st["crule"]);
NumericVector initrules = as<NumericVector>(st["initrules"]);
NumericMatrix initsy = as<NumericMatrix>(st["initsy"]);
NumericMatrix scups = as<NumericMatrix>(st["scups"]);
// End of particularly clumsy section
int i,j,k,cdim=0,rrule = -1,expresp,impresp,expacc=0;
int impacc=0,sresp=0,sused=0,acc=0, nrow = initsy.nrow();
int ncol = initsy.ncol(),length = tr.nrow();
double hvx,hvp,econf,iconf,dn=0,imaxval=0;
List frules,fupdsy;
NumericVector fetrust,fitrust,fcrule,fprep,fprer;
NumericVector train = tr(0,_),acts,sumact,cstim;
NumericMatrix updsy,outmat(length,2);
NumericVector updrules = (clone(initrules));
NumericVector wrules = (clone(initrules));
if (rgive){crule = rchoose(Rcpp::clone(updrules),decsto);}
updsy = symat(initsy.nrow(),initsy.ncol());
// Setup output matrix
if (xtdo){outmat = NumericMatrix(length,45);}
// Run loop for length of training matrix
for(i=0;i<length;i++){
  // Initial setup for current trial
  int l=0,m=0,n=0;
  train = tr(i,_);
  // Conditional to establish whether the state of the
  // model needs resetting
  if(train(0) == 1)
  { if (i>0){frules.push_back(updrules);
             fupdsy.push_back(updsy);
             fetrust.push_back(etrust);
             fitrust.push_back(itrust);
             fcrule.push_back(crule);
             fprep.push_back(prep);
             fprer.push_back(prer);}
    crule = as<int>(st["crule"]);
    etrust = as<double>(st["etrust"]);
    itrust = as<double>(st["itrust"]);
    prep = as<double>(st["prep"]);
    prer = as<double>(st["prer"]);
    updrules = NumericVector(clone(initrules));
    wrules = NumericVector(clone(initrules));
    if (rgive){crule = rchoose(Rcpp::clone(updrules),decsto);}
    updsy = symat(initsy.nrow(),initsy.ncol());
  }
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
  // There is a conditional here that lets us freeze 
  // learning if we desire
  if (train(0) < 2){
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
  }
  // Update output matrix
  if (sresp == 1){outmat(i,0) = 1;
                  outmat(i,1) = 0;}
  if (sresp == 2){outmat(i,0) = 0;
                  outmat(i,1) = 1;}
  if (xtdo){
            outmat(i,2) = acc;
            outmat(i,3) = sused;
            outmat(i,4) = cdim;
            outmat(i,5) = hvx;
            outmat(i,6) = expresp;
            outmat(i,7) = hvp;
            outmat(i,8) = impresp;
            outmat(i,9) = econf;
            outmat(i,10) = iconf;
            outmat(i,11) = imaxval;
            outmat(i,12) = emaxval;
            outmat(i,13) = expacc;
            outmat(i,14) = impacc;
            outmat(i,15) = respt;
            outmat(i,16) = rrule;
            outmat(i,17) = dn;
            outmat(i,18) = etrust;
            outmat(i,19) = itrust;
            outmat(i,20) = crule;
            outmat(i,21) = prep;
            outmat(i,22) = prer;
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
frules.push_back(updrules);
fupdsy.push_back(updsy);
fetrust.push_back(etrust);
fitrust.push_back(itrust);
fcrule.push_back(crule);
fprep.push_back(prep);
fprer.push_back(prer);
return Rcpp::List::create(Rcpp::Named("foutmat") = outmat,
                          Rcpp::Named("frules") = frules,
                          Rcpp::Named("fsystr") = fupdsy,
                          Rcpp::Named("fetrust") = fetrust,
                          Rcpp::Named("fitrust") = fitrust,
                          Rcpp::Named("frule") = fcrule,
                          Rcpp::Named("fprep") = fprep,
                          Rcpp::Named("fprer") = fprer);
}
