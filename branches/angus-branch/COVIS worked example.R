# R Script for an example implementation of COVIS in R
# Author: Angus B. Inkster  
# Start Date: 16/02/2016

# This script is intended as an example of how the COVIS part of the catlearn package can be implemented in R

# Before anything else, clear the environment
rm(list=ls())
# Use ctrl+L to clear the console

#First thing is to load the example dataset, downloadable from http://www.willslab.co.uk/, the dataset is from 

require(Rcpp)

source("R/shj61train.R")


sourceCpp("src/test.cpp")
nextrules <- c(0.25,0.25,0.25,0.25,0.25,0.25)
rchoose(nextrules,1)





sourceCpp("src/slpcovis.cpp")

train <- shj61train(1,blocks = 16, absval = -1)
nextrules <- c(0.25,0.25,0.25,0.25,0.25,0.25)
crule <- 0
start.time <- Sys.time()  

for(i in 1:nrow(train)){
tr <- train[i,]

print("-----------------------")
print(i)
covout <- covistrial(tr,nextrules=nextrules,colskip = 3,stimdim =3,corcon = 0.0025,
                     errcon = 0.02,perscon = 1, decsto = 1,
                     decbound = 0.5,lambda = 5,nvar = 0,crule = crule)
nextrules <- covout$newrules
crule <- covout$nextr
}
covout
nextrules


end.time <- Sys.time() 
end.time - start.time

