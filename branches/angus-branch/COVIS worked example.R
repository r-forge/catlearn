# R Script for an example implementation of COVIS in R
# Author: Angus B. Inkster  
# Start Date: 16/02/2016

# This script is intended as an example of how the COVIS part of the catlearn package can be implemented in R

# Before anything else, clear the environment
rm(list=ls())
# Use ctrl+L to clear the console

# First lets generate the required training data and initial synapse and scu values
require(Rcpp)


# setwd("C:/Users/ainks/Documents/slpcovis/angus-branch")

source("R/wa2001train.R")

sourceCpp("src/slpcovis.cpp")

train <- wa2001train(1,20,-1)
train <- train[1:200,]
stims <- as.data.frame(train[1:16,])
stims <- stims[order(stims$stim),]
stims <- as.matrix(stims)
nextrules <- c(0.25,0.25,0.25,0.25)
smat <- symat(16,2)
scvmat <- scumat(16,4,3,0,stims)





critlist <- NULL

# Next lets generate the parameter lists required by slpcovis
# These values are from the simulation of COVIS run in Wills and Pothos 2012 book,
# with the training set generated form Waldron and Ashby(2001)
# The parameter list exppar is a choice as it is one value for no concurrent load
# and one value for concurrent load

# No concurrent load
exppar <- c(0.0025,0.02,1,1,0.5,5,0,0.5)

# Concurrent load
# exppar <- c(0.0025,0.02,20,1,0.5,0.5,0,0.5)

imppar <- c(0.2,0.65,0.19,0.02,0.0022,0.01,1,0.00015625,0.00000000001,0,0)

comppar <- c(0.99,0.01,0.01,0.04)

extpar <- c(3,4,1)

# This comment is to explain the lists taken by slpcovis:
# exppar = [corcon,errcon,perscon,decsto,decbound,lambda,envar,emaxval]
# imppar = [dbase,alphaw,betaw,gammaw,nmda,ampa,wmax,invar,sconst,prep,prer]
# comppar = [etrust,itrust,ocp,oep]
# extpar = [colskip,stimdim,respt]

critlist <- NULL


for (j in 1:50){
    
sourceCpp("src/slpcovis.cpp")

covout <- slpCOVIS(train,nextrules,smat,scvmat,exppar,imppar,comppar,extpar)
colnames(covout) = c('Trial','Resp','System','Acc','Etrust','Itrust')

covout <- as.data.frame(covout)

for (k in 1:200){
  if (covout[k,'Acc'] == 0){covout[k,'Acc'] = 0}
  if (covout[k,'Acc'] == 1){
    if (k == 1) {covout[k,'Acc'] = 1}
    else {covout[k,'Acc'] = covout[k-1,'Acc'] + 1}
  }
  if (covout[k,'Acc'] == 8){crit <- k
  break}
  else (crit <- 0)
}

critlist <- c(critlist,crit)

}


critlist2 <- c(critlist2,mean(critlist))





critlist2 <- critlist2[-13]



mean(critlist2)






#critlist2 <- critlist2[critlist2 != 0]

#critlist2 <- critlist2[-13]


#critlist2 <- critlist2[!is.na(critlist2)]

#mean(critlist2)

## Current problems

##Error in .Primitive(".Call")(<pointer: 0x0000000071286950>, train, nextrules,  : 
##                               negative length vectors are not allowed
# This is a wrap round error, where the value for something gets so high it wraps around to negative

##Error: cannot allocate vector of size 9.0 Gb
##In addition: Warning messages:
##  1: In slpCOVIS(train, nextrules, smat, scvmat, exppar, imppar, comppar,  :
##                   Reached total allocation of 4011Mb: see help(memory.size)
# This is a memory issue

# Also R sometimes crashes when running the large simulations
