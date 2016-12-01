# # R Script for an example implementation of ATRIUM in R
# Author: Angus B. Inkster  
# Start Date: 16/02/2016

# This script is intended as an example of how the ATRIUM part
# of the catlearn package can be implemented in R

# Before anything else, clear the environment
rm(list=ls())
# Use ctrl+L to clear the console

# First lets generate the required training data and initial synapse and scu values
require(Rcpp)

sourceCpp("src/slpatrium.cpp")







