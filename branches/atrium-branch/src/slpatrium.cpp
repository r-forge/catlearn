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
int acccheck(int cresp,int resp){
  // Checked AI 13/02/2017
  int out = 0;
  if (resp == cresp){out = 1;}
  return out;
}

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

// Checked AI 13/02/2017

// dimval = dimensional value on the primary dimension
// gain = the gain parameter, defined in E+K1998
// bias = the bias parameter, defined in E+K1998
double smact(double dimval, double gain, double bias){
  double act,expcom;
  expcom = (gain*(dimval+bias))*-1;
  act = 1 - (1/(1 + exp(expcom)));
  return act;
}



// This function is the bottom half of Equ 1, the part for large values

// Checked AI 13/02/2017

// dimval = dimensional value on the primary dimension
// gain = the gain parameter, defined in E+K1998
// bias = the bias parameter, defined in E+K1998
double lact(double dimval,double gain,double bias){
  double act,expcom;
  expcom = (gain*(dimval+bias))*-1;
  act = 1/(1 + exp(expcom));
  return act;
}

// This function is to calculate the activation of a
// category nodes, based on the small-value and large-value
// activations, for all rule modules. Equ 2 in E+K1998

// Checked AI: 06/02/2016

// rlweight = the connection weight between the large value
// rule node to the rule module category node
// rsweight = the connection weight between the small value
// rule node to the rule module category node
// rlact = activation of the large value rule node
// rsact = activation of the small value rule node
// [[Rcpp::export]]
NumericMatrix catact(List rlweights,List rsweights, NumericMatrix rlact,
                     NumericMatrix rsact,int cats,int mods){
  int i,j,k;
  NumericMatrix out(rlact.nrow(),cats);
  for(i=0;i < mods; i++) {
    SEXP cl = rlweights[i];
    SEXP cs = rsweights[i];
    NumericMatrix lw(cl);
    NumericMatrix ls(cs);
    for (j=0;j<lw.nrow();j++){
      for (k=0;k<lw.ncol();k++){
      out(i,j) += (lw(j,k)*rlact(i,k)) + (ls(j,k)*rsact(i,k));
      }
     }
  }
  return out;
}


// Next is the functions for the exemplar module (some of
// this code is taken from slpalcove, as the exemplar
// module is defined as a full implementation of ALCOVE)

// Calculate distances on each dimension from presented stimulus to
// each of exemplar nodes for use in Equ 3 of E+K1998

// Checked AI 13/02/2017

// h = matrix of positions of exemplar nodes, columns are nodes, 
// rows are dimensions in stimulus space
// x = vector of stimulus dimensions for the currently presented stimulus
NumericMatrix xdcalc(NumericMatrix h, NumericVector x) {
  int i, j, nrow = h.nrow(), ncol = h.ncol();
  NumericMatrix out(nrow,ncol);
  for(i=0;i < nrow; i++) {
    for(j=0;j < ncol; j++) {
      out(i,j) = fabs( h(i,j) - x(j));  
    }
  }
  return out;
}

// Calculate activation of exemplar nodes. Produce a vector,
// with length of the number of exemplar nodes, of activations
// for each node. Equ 3 in E+K1998.

// Checked AI 13/02/2017

// hmx = matrix of distances between exemplar nodes and the current stimulus
// m = whether the stimulus dimension is missing
// alpha = vector of attentional strengths for stimulus dimensions
// c = specificty of the node
// [[Rcpp::export]]
NumericVector axcalc(NumericMatrix hmx, NumericVector m, 
                     NumericVector alpha, double c) {
  int i, j, nrow = hmx.nrow(), ncol = hmx.ncol();
  NumericVector out(nrow);
  //Rcout << "out = " << out <<"\n";
  for(i=0;i < nrow; i++) {
    out(i) = 0.0;
    //Rcout << "out = " << out <<"\n";
    for(j=0;j < ncol; j++) {
      if( m[j] == 0 ) out(i) += hmx(i,j) * alpha(j);
      //Rcout << "out = " << out <<"\n";
    }
    out(i) = exp(((-0.5 * c)*out(i)));
    //Rcout << "out = " << out <<"\n";
  }
  return out;
}


// Calculate activation of output nodes, Equ 4 in E+K1998.

// Checked AI 13/02/2017

// w = matrix of connection weights from exemplar nodes to category nodes
// ah = vector of exemplar node activations
// [[Rcpp::export]]
NumericVector cncalc(NumericMatrix w, NumericVector ah) {
  int i,j, nrow = w.nrow(), ncol = w.ncol();
  NumericVector out(nrow);
  //Rcout << "out = " << out <<"\n";
  for(i=0;i < nrow; i++) {
    out(i) = 0.0;
    //Rcout << "out = " << out <<"\n";
    for(j=0;j < ncol; j++) {
      out(i) += ah(j) * w(i,j);
      //Rcout << "out = " << out <<"\n";
    }
  }
  //Rcout << "w = " << w <<"\n";
  //Rcout << "ah = " << ah <<"\n";
  //Rcout << "out = " << out <<"\n";
  return out;
}



// Next is the gating mechanism


// THis function is to calculate the activation of the gating
// node, Equ 5 in E+K1998

// Checked AI 13/02/2017

// exact = vector of exemplar node activations
// gnweights = vector of connection weights between gating
// node and exemplar nodes
// gbias = bias for the gate
// ggain = gain for the gate
double gnact(NumericVector exact, NumericVector gnweights,
             double gbias, double ggain){
  int i;
  double act,out = 0,expcon;
  for(i=0;i < exact.size(); i++){
    out += gnweights(i) * exact(i);
  }
  expcon = ((-1*(ggain * out)) + gbias);
  act = 1/(1+(exp(expcon)));
  return act;
}


// This function is to calculate the probability for picking
// each of the categorys, Equ 6 in E+K1998.

// Checked AI 13/02/2017

// arnodes = vector of category node activations in the rule module
// aenodes = vector of category node activations in the exemplar module
// gatact = gating mechanism activation
// scacon = scaling constant
// [[Rcpp::export]]
NumericVector catprob(NumericVector arnodes,NumericVector aenodes,
                      double gatact,double scacon){
  int i;
  double expconar,expconae,sumar=0,sumae=0;
  NumericVector out(arnodes.size());
  for(i=0;i < arnodes.size(); i++){
    sumar += exp(scacon*arnodes(i));
    sumae += exp(scacon*aenodes(i));
  }
  for(i=0;i < arnodes.size(); i++){
    expconar = (exp(scacon*arnodes(i))/sumar);
    expconae = (exp(scacon*aenodes(i))/sumae);
    out(i) = (gatact*expconae) + ((1-gatact)*expconar);
  }
  return out;
}


// Lastly, the learning equations for ATRIUM

// This function is to generate a vector of humble teacher values
// Equ 7 in E+K1998. The first x values, where x is the number
// of category nodes are for the rule module, with the second
// x values being for the exemplar module.

// Checked AI 13/02/2017

// currht = ht values for the current trial, i.e what category is active
// rmout = output of the rule module
// emout = output of the exemplar module
// [[Rcpp::export]]
NumericVector htval(int cresp, NumericVector rmout,NumericVector emout){
  int i;
  NumericVector out(rmout.size()+emout.size());
  for(i=0;i < rmout.size(); i++){
    if (i == cresp)
      {out(i) = max(NumericVector::create(1,rmout(i)));
       out(i+rmout.size()) = max(NumericVector::create(1,emout(i)));}
    else
      {out(i) = min(NumericVector::create(0,rmout(i)));
       out(i+rmout.size()) = min(NumericVector::create(0,emout(i)));}
  }
  return out;
}


// This function is to calculate the error, Equ 8 in E+K1998.

// Checked AI: 14/02/2016

// tm = Vector of humble teacher values
// rma = vector of rule modules activations
// ema = vector of rule modules activations
// rcost = cost of rule module
// ecost = cost of exemplar module
List error(NumericVector tm, NumericVector rma, NumericVector ema,
             double gact,double rcost,double ecost){
  int i;
  double out,ksumr=0,ksume=0,msum;
  NumericVector rtm = tm[Range(0,(rma.size()-1))],etm = tm[Range(rma.size(),((rma.size()*2)-1))];
  for(i=0;i < rma.size(); i++){
    ksumr += pow((rtm(i)-rma(i)),2);
    ksume += pow((etm(i)-ema(i)),2);
  }
  ksumr = exp(((-0.5*rcost)*ksumr));
  ksume = exp(((-0.5*ecost)*ksume));
  msum = (ksumr*(1-gact))+(ksume*gact);
  out = -1*(log(msum));
  return Rcpp::List::create(Rcpp::Named("Error") = out,
                            Rcpp::Named("RA") = ksumr,
                            Rcpp::Named("EA") = ksume,
                            Rcpp::Named("MA") = msum); 
}

// Next function is Equ 12 in E+K1998, rmwu stands for rule
// module weight update.

// Checked AI: 20/02/2016

// tm = vector of teacher values
// rma = vector of rule module category node activations
// act = vector of activations
// rmw = matrix of weights between rules and rule category nodes (columns are rules, in the order large-small...., rows are category nodes)
// rcost = cost of rule module
// RA = accuracy of the rule module
// MA = mean accuracy of the model
// rmlr = rule module learning rate parameter
// gact = gating node activation
// [[Rcpp::export]]
NumericMatrix rmwu(NumericVector tm,NumericVector rma, NumericVector act,
                   NumericMatrix rmw,double rcost,double RA,
                   double MA,double rmlr,double gact){
  int i,j,nrow = rmw.nrow(),ncol = rmw.ncol();
  NumericVector rtm = tm[Range(0,rma.size()-1)];
  NumericMatrix out(clone(rmw));
  for (i=0;i < ncol; i++){
    for (j=0;j < nrow; j++){
      out(j,i) += (rmlr) * (((1-gact)*(RA)*(rcost))/(MA)) * ((rtm(j)) - (rma(j))) * (act(i));

    }
  }
  return out;
}


// Next function is Equ 13 in E+K1998, emwu stands for rule
// module weight update.

// Checked AI: 20/02/2016

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

// Checked AI: 20/02/2016

// tm = vector of teacher values
// ema = vector of exemplar module category node activations
// exact = vector of exemplar activations
// cstim = vector of current stimulus dimension values
// emw = matrix of weights between category nodes and exemplars (rows are category nodes, columns are exemplars)
// sxdist = matrix of distance from exemplars to current stimulus
// dimatt = vector of current dimensional attentional weights
// EA = Exemplar module accuracy as defined by the function called error
// MA = Mean accuracy as defined by the function called error
// ecost = cost of the exemplar module
// gact = gating node activation
// alr = attentional learning rate parameter
// c = specificity of the exemplar nodes
// [[Rcpp::export]]
NumericVector achange(NumericVector tm,NumericVector ema,NumericVector exact,
                      NumericVector cstim, NumericMatrix emw, NumericMatrix sxdist,
                      NumericVector dimatt, double EA,double MA, double ecost,
                      double gact,double alr, double c){
  int i,j,k;
  double sumek,sumej;
  NumericVector etm = tm[Range((ema.size()),(ema.size()*2)-1)];
  NumericVector out(clone(dimatt));
  //Rcout << "out = " << out <<"\n";
  //Rcout << "EA = " << EA <<"\n";
  //Rcout << "MA = " << MA <<"\n";
  //Rcout << "ecost = " << ecost <<"\n";
  //Rcout << "gact = " << gact <<"\n";
  //Rcout << "alr = " << alr <<"\n";
  //Rcout << "c = " << c <<"\n";
  for (i=0;i < cstim.size(); i++){
    sumej = 0;
    for (j=0;j < emw.ncol(); j++){
      sumek = 0;
      for (k=0;k < emw.nrow(); k++){
        sumek += (((gact)*(EA)*(ecost))/(MA)) * (etm(k)-ema(k)) * (emw(k,j));
        //Rcout << "(etm(k)-ema(k)) = " << (etm(k)-ema(k)) <<"\n";
        //Rcout << "(emw(k,j)) = " << (emw(k,j)) <<"\n";
        //Rcout << "sumek = " << sumek <<"\n";
      }
      sumej += (sumek) * (exact(j)) * (c) * (sxdist(j,i));
      //Rcout << "(sxdist(j,i)) = " << (sxdist(j,i)) <<"\n";
      //Rcout << "sumej = " << sumej <<"\n";
    }
    out(i) += (-1) * (alr) * (sumej);
    //Rcout << "out = " << out <<"\n";
  }
  //Rcout << "out = " << out <<"\n";
  return out;
}



// Next is function 15 from E+K1998, the change in weight from 
// the exemplars to the gating node. THis function works by adding
// the change calculated to the existing weight.7

// Checked AI: 20/02/2016

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
// [[Rcpp::export]]
List slpATRIUM(List st,
               NumericMatrix tr,
               bool rgive = false,
               bool xtdo = false){
// This clumsy section copies stuff out of an R List
// There seems to be no way in RCpp to get direct access to a 
// List at input?
double rcost = as<double>(st["rcost"]);
double rmlr = as<double>(st["rmlr"]);
double c = as<double>(st["c"]);
double ecost = as<double>(st["ecost"]);
double emlr = as<double>(st["emlr"]);
double gbias = as<double>(st["gbias"]);
double ggain = as<double>(st["ggain"]);
double cpsc = as<double>(st["cpsc"]);
double gnlr = as<double>(st["gnlr"]);
double alr = as<double>(st["alr"]);
int stimdim = as<int>(st["stimdim"]);
int cats = as<int>(st["cats"]);
int mods = as<int>(st["mods"]);
//int exmplrs = as<int>(st["exmplrs"]);
int colskip = as<int>(st["colskip"]);
int rdim = as<int>(st["rdim"]);
NumericMatrix rbias = as<NumericMatrix>(st["rbias"]);
NumericMatrix rgain = as<NumericMatrix>(st["rgain"]);
NumericMatrix ssxval = as<NumericMatrix>(st["ssxval"]);
NumericVector alpha = as<NumericVector>(st["alpha"]);
List sweights = as<List>(st["sweights"]);
List lweights = as<List>(st["lweights"]);
NumericMatrix excweights = as<NumericMatrix>(st["excweights"]);
NumericVector exgweights = as<NumericVector>(st["exgweights"]);

// End of particularly clumsy section
// Initialising various variables
int i,j,k,cresp=0;
int length=tr.nrow();
double ag;
NumericVector cstim,xact,m,emout,respprob,htvec;
NumericMatrix rmout(mods,cats),sxdist,rweights,racts,rlact(mods,rgain.nrow()),rsact(mods,rgain.nrow());
List cerr,output,outlist;
//Rcout << "rlact = " << rlact <<"\n";
//Rcout << "rsact = " << rsact <<"\n";



// Ensure that tr starts with some value rather than being empty
NumericVector train = tr(0,_);
//Rcout << "train = " << train <<"\n";
// Initial model setup
// Setup an initial matrix for the rule weights based on
// number of stimulus dimensions and response categories
// NOTE: Rcout cannot handle List types at the minute.
List rlweights = clone(lweights);
List rsweights = clone(sweights);

NumericMatrix ecweights = clone(excweights);
//Rcout << "ecweights = " << ecweights <<"\n";
NumericVector egweights = clone(exgweights);
//Rcout << "egweights = " << egweights <<"\n";
NumericVector aweights = clone(alpha);
//Rcout << "aweights = " << aweights <<"\n";
for (i=0;i < length; i++){
  // set tr to the current training trial row in the training matrix
  train = tr(i,_);
  //Rcout << "train = " << train <<"\n";
  if(train(0) == 1){
     rlweights = List(clone(lweights));
     rsweights = List(clone(sweights)); 
     ecweights = NumericMatrix(clone(excweights));
     egweights = NumericVector(clone(exgweights));
     aweights = NumericVector(clone(alpha));
  }
  //Rcout << "ecweights = " << ecweights <<"\n";
  //Rcout << "egweights = " << egweights <<"\n";
  //Rcout << "aweights = " << aweights <<"\n";
  // set the stimulus dimension values for the current stimulus
  cstim = train[Range(colskip,((colskip-1)+stimdim))];
  m = train[Range(((colskip)+stimdim+cats),((train.size())-1))];
  //Rcout << "cstim = " << cstim <<"\n";
  //Rcout << "m = " << m <<"\n";
  // First is the calculations for the activations in the rule module
  for (j=0;j < rlact.nrow(); j++){
    for (k=0;k < rlact.ncol(); k++){
      rlact(j,k) = lact(cstim(j),rgain(j,k),rbias(j,k));
      rsact(j,k) = smact(cstim(j),rgain(j,k),rbias(j,k));
      if (rgive){
                 rlact(j,k) = lact(cstim(rdim-1),rgain(j,k),rbias(j,k));
                 rsact(j,k) = smact(cstim(rdim-1),rgain(j,k),rbias(j,k));
                }
    }
  }
  //Rcout << "lact = " << rlact <<"\n";
  //Rcout << "smact = " << rsact <<"\n";
  for (j=0;j < rlact.nrow(); j++){
    rmout(j,_) = catact(rlweights,rsweights,rlact,rsact,cats,mods);
  }
  //Rcout << "rmout = " << rmout <<"\n";
  // Next is the calculations for the activations in the exemplar module
  // First calculate the distances of the exemplars from the current stimulus
  sxdist = xdcalc(ssxval,cstim);
  //Rcout << "sxdist = " << sxdist <<"\n";
  // Next calculate the activation of the Exemplar nodes
  xact = axcalc(sxdist,m,aweights,c);
  //Rcout << "xact = " << xact <<"\n";
  // Finally activation of the exemplar category nodes
  emout = cncalc(ecweights,xact);
  //Rcout << "emout = " << emout <<"\n";
  // Now, we calculate the activations for the gating node
  ag = gnact(xact,egweights,gbias,ggain);
  //Rcout << "ag = " << ag <<"\n";
  // Now we calculate the probability that each category is chosen
  respprob = catprob(rmout,emout,ag,cpsc);
  //Rcout << "respprob = " << respprob <<"\n";
  // Next is the learning part of the model, first is the 
  // generation of the vector of humble teacher values.
  if (train(0) < 2){
  for (j=0;j<cats;j++){
      if(train(colskip+stimdim+j) == 1){cresp = j;}
      } 
  //Rcout << "cresp = " << cresp <<"\n";
  htvec = htval(cresp,rmout,emout);
  //Rcout << "htvec = " << htvec <<"\n";
  cerr = error(htvec,rmout,emout,ag,rcost,ecost);
  //double error = cerr("Error");
  //double RA = cerr("RA");
  //double EA = cerr("EA");
  //double MA = cerr("MA");
  //Rcout << "error = " << error <<"\n";
  //Rcout << "RA = " << RA <<"\n";
  //Rcout << "EA = " << EA <<"\n";
  //Rcout << "MA = " << MA <<"\n";
  // Update output list
  if (xtdo){output = Rcpp::List::create(Rcpp::Named("respprob") = respprob,
                                        Rcpp::Named("cresp") = cresp+1,
                                        Rcpp::Named("ag") = ag,
                                        Rcpp::Named("cerr") = cerr,
                                        Rcpp::Named("cstim") = cstim,
                                        Rcpp::Named("htvec") = htvec,
                                        Rcpp::Named("rlact") = rlact,
                                        Rcpp::Named("rsact") = rsact,
                                        Rcpp::Named("rmout") = rmout,
                                        Rcpp::Named("emout") = emout,
                                        Rcpp::Named("sxdist") = sxdist,
                                        Rcpp::Named("xact") = xact,
                                        Rcpp::Named("aweights") = aweights,
                                        Rcpp::Named("ecweights") = ecweights,
                                        Rcpp::Named("egweights") = egweights,
                                        Rcpp::Named("rsw") = rsweights,
                                        Rcpp::Named("rlw") = rlweights);
             outlist.push_back(output);}
  
  else {output = Rcpp::List::create(Rcpp::Named("respprob") = respprob,
                                    Rcpp::Named("cresp") = cresp+1);
        outlist.push_back(output);}
  // Update the weighted connections for each module and the gate node
  for (j=0;j< rlweights.size();j++){
    rlweights(j) = rmwu(htvec,rmout,rlact,rlweights(j),rcost,cerr("RA"),
                        cerr("MA"),rmlr,ag);
    rsweights(j) = rmwu(htvec,rmout,rsact,rsweights(j),rcost,cerr("RA"),
              cerr("MA"),rmlr,ag);
  }
  Rcout << "rmout = " << rmout <<"\n";
  //Rcout << "rlweights.size() = " << rlweights.size() <<"\n";
  //Rcout << "aweights = " << aweights <<"\n";
  aweights = achange(htvec,emout,xact,cstim,ecweights,sxdist,aweights,
                  cerr("EA"),cerr("MA"),ecost,ag,alr,c);
  //Rcout << "achange = " << achange(htvec,emout,xact,cstim,ecweights,sxdist,aweights,
  //                       cerr("EA"),cerr("MA"),ecost,ag,alr,c) <<"\n";
  //Rcout << "aweights = " << aweights <<"\n";
  ecweights = emwu(htvec,emout,xact,ecweights,ecost,cerr("EA"),
                   cerr("MA"),emlr,ag);
  //Rcout << "ecweights = " << ecweights <<"\n";
  egweights = egnchange(egweights,xact,gnlr,cerr("RA"),
                        cerr("EA"),cerr("MA"),ggain,ag);
  //Rcout << "egweights = " << egweights <<"\n";
  }
}
return outlist;
}





// Rcout<< "out = " << out <<"\n";
