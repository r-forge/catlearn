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



# i <- 1

sourceCpp("src/slpcovis.cpp")

train <- shj61train(1,blocks = 16, absval = -1)
rules <- c(0.25,0.25,0.25,0.25,0.25,0.25)
nextrules <- rules
start.time <- Sys.time()  

#for(i in 1:length(train)){
for(i in 1:5){
tr <- train[i,]
z <- train[i,4:6]
if(i==1)set <- 1
else set <- 0

print("-----------------------")
print(i)
covout <- covistrial(z,tr,nextrules,colskip = 3,corcon = 0.0025,
                     errcon = 0.02,perscon = 1, decsto = 10,
                     decbound = 0.5,lambda = 5,nvar = 0,trl1=set)
nextrules <- covout$newrules
}
covout
rules
end.time <- Sys.time() 
end.time - start.time

