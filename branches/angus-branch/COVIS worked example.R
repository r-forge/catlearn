# R Script for an example implementation of COVIS in R
# Author: Angus B. Inkster  
# Start Date: 16/02/2016

# This script is intended as an example of how the COVIS part of the catlearn package can be implemented in R

# Before anything else, clear the environment
rm(list=ls())
# Use ctrl+L to clear the console

# First lets generate the required training data and initial synapse and scu values
require(Rcpp)

source("R/wa2001train.R")

train <- wa2001train(1,5,-1)
nextrules <- c(0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25)
smat <- symat(16,2)
scvmat <- scumat(16,4,3,0,train)

# Next lets generate the parameter lists required bty slpcovis
# These values are from the simulation of COVIS run in Wills and Pothos 2012 book,
# with the training set generated form Waldron and Ashby(2001)
# The parameter list exppar is a choice as it is one value for no concurrent load
# and one value for concurrent load

# No concurrent load
exppar <- c(0.0025,0.02,1,1,0.5,5,0)

# Concurrent load
# exppar <- c(0.0025,0.02,20,1,0.5,0.5,0)

imppar <- c(0.2,0.65,0.19,0.02,0.0022,0.01,1,0.00015625,1,0,0)

comppar <- c(0.99,0.01,0.01,0.04)

extpar <- c(2,3,4,1,5)

# This comment is to explain the lists taken by slpcovis:
# exppar = [corcon,errcon,perscon,decsto,decbound,lambda,envar]
# imppar = [dbase,alphaw,betaw,gammaw,nmda,ampa,wmax,invar,sconst,prep,prer]
# comppar = [etrust,itrust,ocp,oep]
# extpar = [cb,colskip,stimdim,feedback,crule]

sourceCpp("src/slpcovis.cpp")

covout <- slpCOVIS(train[1:2,],nextrules,smat,scvmat,exppar,imppar,comppar,extpar)




