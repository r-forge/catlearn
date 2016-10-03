// This script contain the functions for the COVIS list processor of the 
// CATLEARN package
// It is written in C++, using templates from the Rcpp package in R 
#include <Rcpp.h>
#include <iostream>
//#include <vector>
using namespace Rcpp;

expacc = acccheck(expresp,tr,colskip,stimdim);
updrules = nextrules;
updrules[crule]  = updsal(corcon, errcon, updrules[crule], expacc);

rrule = rand() % updrules.size();
updrules[crule] = prerule(updrules[crule],perscon);
updrules[rrule] = ranrule(updrules[rrule],lambda);

nextrule = rchoose(Rcpp::clone(updrules),decsto);


