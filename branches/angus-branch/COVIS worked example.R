# R Script for an example implementation of COVIS in R
# Author: Angus B. Inkster  
# Start Date: 16/02/2016

# This script is intended as an example of how the COVIS part of the catlearn package can be implemented in R

# Before anything else, clear the environment
rm(list=ls())
# Use ctrl+L to clear the console

#First thing is to load the example dataset, downloadable from http://www.willslab.co.uk/, the dataset is from 

require(Rcpp)

smat <- train[1:8,4:6]
dmat <- c(0,0,0)

sourceCpp("src/test.cpp")



sourceCpp("src/slpcovis.cpp")

# This comment is to explain the lists taken by slpcovis:
# exppar = [corcon,errcon,perscon,decsto,decbound,lambda,envar]
# imppar = [dbase,alphaw,betaw,gammaw,nmda,ampa,wmax,invar,sconst,prep,prer]
# comppar = [etrust,itrust,ocp,oep]
# extpar = [cb,colskip,stimdim,feedback,crule]







tr <- train[1,]
nextrules <- c(0.25,0.25,0.25,0.25,0.25,0.25)
smat <- symat(8,2)
sval <- scumat(8,3,2,0,train)
sval <- sval[,2:4]

covout <- covistrial(tr,nextrules=nextrules,colskip = 3,stimdim = 3,1,corcon = 0.0025,
                     errcon = 0.02,perscon = 1, decsto = 1,decbound = 0.5,lambda = 5,
                     nvar = 0,crule = crule,smat,sval,0.5,0.5,0.65,0.19,0.02,0.0022,1,0.01,
                     0.2,0.99,0.01,0.01,0.04)




source("R/shj61train.R")

train <- shj61train(1,blocks = 16, absval = -1)
nextrules <- c(0.25,0.25,0.25,0.25,0.25,0.25)
crule <- 5
start.time <- Sys.time()  

for(i in 1:nrow(train)){
tr <- train[i,]

print("-----------------------")
print(i)
covout <- covistrial(tr,nextrules=nextrules,colskip = 3,stimdim =3,corcon = 0.0025,
                     errcon = 0.02,perscon = 1, decsto = 1,
                     decbound = 0.5,lambda = 5,nvar = 0,crule = crule, feedback = 1)
print(covout)
nextrules <- covout$newrules
crule <- covout$nextr
}
covout
nextrules


end.time <- Sys.time() 
end.time - start.time
