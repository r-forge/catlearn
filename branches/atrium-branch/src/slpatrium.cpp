// This script contains the functions for the ATRIUM list 
// processor of the CATLEARN package, written in C++, using
// templates from RCPP.
// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include <iostream>
using namespace Rcpp;


// The paper referencing where the equations come from is
// Erickson and Krushke (1998)

// General Utility Functions



// ATRIUM, much like COVIS has two parts, a rule module and 
// an exemplar module. It also contains a gating mechanism.
// Unlike COVIS however, the output of the two modules is
// combined through the gating mechanism to produce a probability
// for each response.


// First part is the functions for the rule module


// This function is to calculate the activation of the rule nodes
// (Equ 1). However this equation has two parts: one for small
// dimensional values and one for large values. This function
// is the top half of Equ 1, the part for small values.

// dimval = dimensional value on the primary dimension
// gain = the gain parameter, defined in E+K1998
// bias = the bias parameter, defined in E+K1998
// [[Rcpp::export]]
double smact(double dimval, double gain, double bias){
  double act,expcom;
  expcom = (gain*(dimval+bias))*-1;
  act = 1 - (pow(1 + exp(expcom),-1));
  return act;
}



// This function is the bottom half of Equ 1, the part for large values

// dimval = dimensional value on the primary dimension
// gain = the gain parameter, defined in E+K1998
// bias = the bias parameter, defined in E+K1998
// [[Rcpp::export]]
double lact(double dimval,double gain,double bias){
  double act,expcom;
  expcom = (gain*(dimval+bias))*-1;
  act = pow(1 + exp(expcom),-1);
  return act;
}

// This function is to calculate the activation of a specific
// category node, based on the small-value and large-value
// activations. Equ 2 in E+K1998

// lvweight = the connection weight between the large value
// rule node to the rule module category node
// svweight = the connection weight between the small value
// rule node to the rule module category node
// lact = activation of the large value rule node
// smact = activation of the small value rule node

// [[Rcpp::export]]
NumericVector catact(NumericVector lvweights,NumericVector svweights,double lact, double smact){
  int i;
  NumericVector act(lvweights.size());
  for(i=0;i < lvweights.size(); i++) {
  act(i) = (lvweights(i)*lact)+(svweights(i)*smact);}
  return act;
}


// Next is the functions for the exemplar module (some of
// this code is taken from slpalcove, as the exemplar
// module is defined as a full implementation of ALCOVE)

// Calculate distances on each dimension from presented stimulus to
// each of exemplar nodes for use in Equ 3 of E+K1998

// h = matrix of positions of exemplar nodes, columns are nodes, 
// rows are dimensions in stimulus space
// x = vector of stimulus dimensions for the currently presented stimulus
// [[Rcpp::export]]
NumericMatrix xdcalc(NumericMatrix h, NumericVector x) {
  int i, j, nrow = h.nrow(), ncol = h.ncol();
  NumericMatrix out(nrow,ncol);
  for(i=0;i < nrow; i++) {
    for(j=0;j < ncol; j++) {
      out(i,j) = fabs( h(i,j) - x(i));  
    }
  }
  return out;
}

// Need to check the function of m in next function with Andy

// Calculate activation of exemplar nodes. Produce a vector,
// with length of the number of exemplar nodes, of activations
// for each node. Equ 3 in E+K1998.

// hmx = matrix of distances between exemplar nodes and the current stimulus
// m
// alpha = vector of attentional strengths for stimulus dimensions
// c = specificty of the node
// [[Rcpp::export]]
NumericVector axcalc(NumericMatrix hmx, NumericVector m, 
                     NumericVector alpha, double c) {
  int i, j, nrow = hmx.nrow(), ncol = hmx.ncol();
  NumericVector out(ncol);
  for(j=0;j < ncol; j++) {
    out(j) = 0.0;
    for(i=0;i < nrow; i++) {
      if( m[i] == 0 ) out(j) += hmx(i,j) * alpha(i);
    }
    out(j) = exp(-0.5 * c);
  }
  return out;
}


// Calculate activation of output nodes, Equ 4 in E+K1998.

// w = matrix of connection weights from exemplar nodes to category nodes
// ah = vector of category node activations
// [[Rcpp::export]]
NumericVector cncalc(NumericMatrix w, NumericVector ah) {
  int i,j, nrow = w.nrow(), ncol = w.ncol();
  NumericVector out(nrow);
  for(j=0;j < nrow; j++) {
    out(j) = 0.0;
    for(i=0;i < ncol; i++) {
      out(j) += ah(i) * w(j,i);
    }
  }
  return out;
}



// Next is the gating mechanism


// THis function is to calculate the activation of the gating
// node, Equ 5 in E+K1998

// exact = vector of exemplar node activations
// gnweights = vector of connection weights between gating
// node and exemplar nodes
// gbias = bias for the gate
// ggain = gain for the gate
// [[Rcpp::export]]
double gnact(NumericVector exact, NumericVector gnweights,
             double gbias, double ggain){
  int i;
  double act,out,expcon;
  for(i=0;i < exact.size(); i++){
    out += gnweights(i) * exact(i);
  }
  expcon = ((-1*(ggain * out)) + gbias);
  act = 1 + pow(exp(expcon),-1) ;
  return act;
}


// This function is to calculate the probability for picking
// each of the categorys, Equ 6 in E+K1998.

// arnodes = vector of category node activations in the rule module
// aenodes = vector of category node activations in the exemplar module
// gatact = gating mechanism activation
// scacon = scaling constant
// [[Rcpp::export]]
NumericVector catprob(NumericVector arnodes,NumericVector aenodes,
                      double gatact,double scacon){
  int i,j;
  double expconar,expconae,sumar,sumae;
  NumericVector out(arnodes.size());
  for(i=0;i < arnodes.size(); i++){
    for(j=0;j < arnodes.size(); j++){
      sumar += exp(scacon*arnodes(j));
      sumae += exp(scacon*aenodes(j));
    }
    expconar = (exp(scacon*arnodes(i))/sumar);
    expconae = (exp(scacon*aenodes(i))/sumae);
    out(i) = (gatact*expconar) + ((1-gatact)*expconae);
  }
  return out;
}


// Lastly, the learning equations for ATRIUM

// This function is to generate a vector of humble teacher values
// Equ 7 in E+K1998. The first x values, where x is the number
// of category nodes are for the rule module, with the second
// x values being for the exemplar module.

// currht = ht values for the current trial, i.e what category is active
// rmout = output of the rule module
// emout = output of the exemplar module
// [[Rcpp::export]]
NumericVector htval(NumericVector currht, NumericVector rmout,
                    NumericVector emout){
  int i;
  NumericVector out(rmout.size()+emout.size());
  for(i=0;i < rmout.size(); i++){
    if (currht(i) == 1){out(i) = max(NumericVector::create(1,rmout(i)));}
    else{out(i) = min(NumericVector::create(0,rmout(i)));}
    if (currht(i) == 1){out(i+rmout.size()) = max(NumericVector::create(1,emout(i)));}
    else{out(i+rmout.size()) = min(NumericVector::create(0,emout(i)));}
  }
  return out;
}


// This function is to calculate the error, Equ 8 in E+K1998.

// tm = Vector of humble teacher values
// rma = vector of rule modules activations
// ema = vector of rule modules activations
// modprob = vector of probabilities for each module
// rcost = cost of rule module
// ecost = cost of exemplar module
// [[Rcpp::export]]
List error(NumericVector tm, NumericVector rma, NumericVector ema,
             NumericVector modprob,double rcost,double ecost){
  int i;
  double out,ksumr,ksume,msum;
  NumericVector rtm = tm[Range(0,rma.size())],etm = tm[Range(rma.size()+1,rma.size()*2)];
  for(i=0;i < rma.size(); i++){
    ksumr += pow(rtm(i)-rma(i),2);
    ksume += pow(etm(i)-ema(i),2);
  }
  ksumr = exp(((-0.5*rcost)*ksumr));
  ksume = exp(((-0.5*ecost)*ksume));
  msum = (ksumr*modprob(0))+(ksume*modprob(1));
  out = -1*(log(msum));
  return Rcpp::List::create(Rcpp::Named("Error") = out,
                            Rcpp::Named("RA") = ksumr,
                            Rcpp::Named("EA") = ksume,
                            Rcpp::Named("MA") = msum); 
}

// Next function is Equ 12 in E+K1998, rmwu stands for rule
// module weight update.

// tm = vector of teacher values
// rma = vector of rule module category node activations
// ruleact = vector of small and large rule activations(columns are large-small, rows are rules)
// rmw = matrix of weights between rules and rule category nodes (columns are rules, in the order large-small...., rows are category nodes)
// rcost = cost of rule module
// RA = accuracy of the rule module
// MA = mean accuracy of the model
// rmlr = rule module learning rate parameter
// gact = gating node activation
// [[Rcpp::export]]
NumericMatrix rmwu(NumericVector tm,NumericVector rma, NumericMatrix ruleact,
                   NumericMatrix rmw,double rcost,double RA,
                   double MA,double rmlr,double gact){
  int i,j,nrow = rmw.nrow(),ncol = rmw.ncol(), sorl;
  NumericVector rtm = tm[Range(0,rma.size())];
  NumericMatrix out(clone(rmw));
  for (i=0;i < ncol; i++){
    for (j=0;j < nrow; j++){
      if(j%2 == 0){sorl = 0;}
      else{sorl = 1;}
      out(j,i) += (rmlr) * (((1-gact)*(RA)*(rcost))/(MA)) * ((rtm(j)) - (rma(j))) * (ruleact(sorl,i));
    }
  }
  return out;
}


// Next function is Equ 13 in E+K1998, emwu stands for rule
// module weight update.

// tm = vector of teacher values
// ema = vector of exemplar module category node activations
// exact = vector of exemplar activations
// emw = matrix containing existing weights between exemplars and category nodes (rows are category nodes, columns are exemplars)
// ecost = cost of exemplar module
// EA = accuracy of the exemplar module
// MA = mean accuracy of the model
// emlr = exemplar module learning rate parameter
// gact = gating node activation
// [[Rcpp::export]]
NumericMatrix emwu(NumericVector tm,NumericVector ema, 
                   NumericVector exact, NumericMatrix emw,
                   double ecost,double EA,
                   double MA,double emlr,double gact){
  int i,j,nrow = emw.nrow(),ncol = emw.ncol();
  NumericVector etm = tm[Range((ema.size()),(ema.size()*2)-1)];
  NumericMatrix out(clone(emw));
  for (i=0;i < ncol; i++){
    for (j=0;j < nrow; j++){
      out(j,i) += (emlr) * (((gact)*(EA)*(ecost))/(MA)) * ((etm(j)) - (ema(j))) * (exact(i));
    }
  }
  return out;
}



// Next is function 14 from E+K1998, the change in the attention
// for each stimulus dimension. 

// tm = vector of teacher values
// ema = vector of exemplar module category node activations
// exact = vector of exemplar activations
// cstim = vector of current stimulus dimension values
// emw = matrix of weights between category nodes and exemplars (rows are category nodes, columns are exemplars)
// hmx = matrix of exemplar locations in stimulus space
// dimatt = vector of current dimensional attentional weights
// EA = Exemplar module accuracy as defined by the function called error
// MA = Mean accuracy as defined by the function called error
// ecost = cost of the exemplar module
// gact = gating node activation
// alr = attentional learning rate parameter
// c = specificity of the exemplar nodes
// [[Rcpp::export]]
NumericVector achange(NumericVector tm,NumericVector ema,NumericVector exact,
                      NumericVector cstim, NumericMatrix emw, NumericMatrix hmx,
                      NumericVector dimatt, double EA,double MA, double ecost,
                      double gact,double alr, double c){
  int i,j,k;
  double sumek,sumej;
  NumericVector etm = tm[Range((ema.size()),(ema.size()*2)-1)];
  NumericVector out(clone(dimatt));
  for (i=0;i < cstim.size(); i++){
    sumej = 0;
    for (j=0;j < exact.size(); j++){
      sumek = 0;
      for (k=0;k < ema.size(); k++){
        sumek += (((gact)*(EA)*(ecost))/(MA)) * (etm(k)-ema(k)) * (emw(k,j)) ;
      }
      sumej += (sumek) * (exact(j)) * (c) * (fabs(hmx(j,i) - cstim(j)));
    }
    out(i) += (-1) * (alr) * (sumej);
  }
  return out;
}



// Next is function 15 from E+K1998, the change in weight from 
// the exemplars to the gating node. THis function works by adding
// the change calculated to the existing weight.

// egnweight = vector of weight between the gating node and the exemplars
// exact = vector of exemplar activations
// gnlr = gating node learning rate parameter
// RA = Rule module accuracy as defined by the function called error
// EA = Exemplar module accuracy as defined by the function called error
// MA = Mean accuracy as defined by the function called error
// ggain = gating node gain parameter
// gact = activation of the gating node
// [[Rcpp::export]]
NumericVector egnchange(NumericVector egnweight, NumericVector exact,
                        double gnlr,double RA,double EA, double MA,
                        double ggain, double gact){
  int i;
  NumericVector out(clone(egnweight));
  for (i=0;i < out.size(); i++){
    out(i) += (gnlr) * (((EA)-(RA))/(MA)) * (gact) * (1 - gact) * (ggain) * (exact(i)); 
  }
  return out;
}





// Now for the full function for slpATRIUM

NumericMatrix slpATRIUM(NumericMatrix train,
                        List rmpar,List empar,List gnpar,List extpar){
// This clumsy section copies stuff out of an R List
// There seems to be no way in RCpp to get direct access to a 
// List at input?
double rbias = as<double>(rmpar[0]);
double rgain = as<double>(rmpar[1]);
double rcost = as<double>(rmpar[2]);
double rmlr = as<double>(rmpar[3]);

double c = as<double>(empar[0]);
double ecost = as<double>(empar[1]);
double emlr = as<double>(empar[2]);

double gbias = as<double>(gnpar[0]);
double ggain = as<double>(gnpar[1]);
double cpsc = as<double>(gnpar[2]);
double gnlr = as<double>(gnpar[3]);

double alr = as<double>(extpar[0]);
// End of particularly clumsy section



int length;
NumericMatrix outmat(length,5);





return outmat;
}