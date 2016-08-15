# R Script for an example implementation of COVIS in R
# Author: Angus B. Inkster  
# Start Date: 16/02/2016

# This script is intended as an example of how the COVIS part of the catlearn package can be implemented in R

# Before anything else, clear the environment
rm(list=ls())
# Use ctrl+L to clear the console

#First thing is to load the example dataset, downloadable from http://www.willslab.co.uk/, the dataset is from 

require(Rcpp)

sourceCpp("covislp.cpp")

r <- rules(5,0.25,incl = FALSE)
rchoose(r, 5)

stimco(4)
expres(-0.5,1.0)
