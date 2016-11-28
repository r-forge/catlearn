# R Script for an example implementation of COVIS in R
# Author: Angus B. Inkster  
# Start Date: 16/02/2016

# This script is intended as an example of how the COVIS part of the catlearn package can be implemented in R

# Before anything else, clear the environment
rm(list=ls())
# Use ctrl+L to clear the console

# First lets generate the required training data and initial synapse and scu values
require(Rcpp)


# set the seed (if you want it to be easily replicable)
set.seed(7)

source("R/wa2001train.R")

sourceCpp("src/slpcovis.cpp")

# Next lets generate the parameter lists required by slpcovis
# These values are from the simulation of COVIS run in Wills and Pothos 2012 book,
# with the training set generated form Waldron and Ashby(2001)
# The parameter list exppar is a choice as it is one value for no concurrent load
# and one value for concurrent load

imppar <- c(0.2,0.65,0.19,0.02,0.0022,0.01,1,0.00015625,0.00000000001,0,0)

comppar <- c(0.99,0.01,0.01,0.04)

extpar <- c(3,4,1,1,0)

# This comment is to explain the lists taken by slpcovis:
# exppar = [corcon,errcon,perscon,decsto,decbound,lambda,envar,emaxval]
# imppar = [dbase,alphaw,betaw,gammaw,nmda,ampa,wmax,invar,sconst,prep,prer]
# comppar = [etrust,itrust,ocp,oep]
# extpar = [colskip,stimdim,respt,crx,xtdo]


#-----------------------------------------------------------

critlist <- NULL

# No concurrent load
exppar <- c(0.0025,0.02,1,1,0.5,5,0,0.5)

for (j in 1:10000){
  
train <- wa2001train(1,20,-1)
train <- train[1:200,]
stims <- as.data.frame(train[1:16,])
stims <- stims[order(stims$stim),]
stims <- as.matrix(stims)
nextrules <- c(0.25,0.25,0.25,0.25)
smat <- symat(16,2)
scvmat <- scumat(16,4,3,0,stims)

covout <- slpCOVIS(train,nextrules,smat,scvmat,exppar,imppar,comppar,extpar)
#if (extpar[5] == 1){
colnames(covout) = c('Trial','Resp','System','Acc','Etrust',
                                            'Itrust','cdim','hvx','expresp','hvp',
                                            'impresp','econf','iconf','imaxval',
                                            'emaxval','expacc','impacc','respt',
                                            'rrule','crule','prep','prer','dn',
                                            'cstim1','cstim2','cstim3','cstim4',
                                            'acts1','acts2','acts3','acts4','acts5',
                                            'acts6','acts7','acts8','acts9','acts10',
                                            'acts11','acts12','acts13','acts14','acts15',
                                            'acts16','sumact1','sumact2','updrules1',
                                            'updrules2','updrules3','updrules4',
                                            'updsyA_1','updsyA_2','updsyA_3','updsyA_4',
                                            'updsyA_5','updsyA_6','updsyA_7','updsyA_8',
                                            'updsyA_9','updsyA_10','updsyA_11','updsyA_12',
                                            'updsyA_13','updsyA_14','updsyA_15','updsyA_16',
                                            'updsyB_1','updsyB_2','updsyB_3','updsyB_4',
                                            'updsyB_5','updsyB_6','updsyB_7','updsyB_8',
                                            'updsyB_9','updsyB_10','updsyB_11','updsyB_12',
                                            'updsyB_13','updsyB_14','updsyB_15','updsyB_16')#}
#else {colnames(covout) = c('Trial','Resp','System','Acc','Etrust','Itrust')}

covout <- as.data.frame(covout)

for (k in 1:200){
  if (covout[k,'Acc'] == 0){covout[k,'Acc'] = 0}
  if (covout[k,'Acc'] == 1){
    if (k == 1) {covout[k,'Acc'] = 1}
    else {covout[k,'Acc'] = covout[k-1,'Acc'] + 1}
  }
  if (covout[k,'Acc'] == 8){crit <- k
  break}
  else {crit <- 0}
}

critlist <- c(critlist,crit)

}


critlist <- critlist[critlist!=0]

mrbc <- mean(critlist)
sdrbc <- sd(critlist)
errrbc<- sdrbc/100

#-----------------------------------------------------------

# Concurrent load
 exppar <- c(0.0025,0.02,20,1,0.5,0.5,0,0.5)

critlist <- NULL


for (j in 1:10000){
  
  train <- wa2001train(1,20,-1)
  train <- train[1:200,]
  stims <- as.data.frame(train[1:16,])
  stims <- stims[order(stims$stim),]
  stims <- as.matrix(stims)
  nextrules <- c(0.25,0.25,0.25,0.25)
  smat <- symat(16,2)
  scvmat <- scumat(16,4,3,0,stims)
  
  covout <- slpCOVIS(train,nextrules,smat,scvmat,exppar,imppar,comppar,extpar)
  #if (extpar[5] == 1){
  colnames(covout) = c('Trial','Resp','System','Acc','Etrust',
                       'Itrust','cdim','hvx','expresp','hvp',
                       'impresp','econf','iconf','imaxval',
                       'emaxval','expacc','impacc','respt',
                       'rrule','crule','prep','prer','dn',
                       'cstim1','cstim2','cstim3','cstim4',
                       'acts1','acts2','acts3','acts4','acts5',
                       'acts6','acts7','acts8','acts9','acts10',
                       'acts11','acts12','acts13','acts14','acts15',
                       'acts16','sumact1','sumact2','updrules1',
                       'updrules2','updrules3','updrules4',
                       'updsyA_1','updsyA_2','updsyA_3','updsyA_4',
                       'updsyA_5','updsyA_6','updsyA_7','updsyA_8',
                       'updsyA_9','updsyA_10','updsyA_11','updsyA_12',
                       'updsyA_13','updsyA_14','updsyA_15','updsyA_16',
                       'updsyB_1','updsyB_2','updsyB_3','updsyB_4',
                       'updsyB_5','updsyB_6','updsyB_7','updsyB_8',
                       'updsyB_9','updsyB_10','updsyB_11','updsyB_12',
                       'updsyB_13','updsyB_14','updsyB_15','updsyB_16')#}
  #else {colnames(covout) = c('Trial','Resp','System','Acc','Etrust','Itrust')}
  
  covout <- as.data.frame(covout)
  
  for (k in 1:200){
    if (covout[k,'Acc'] == 0){covout[k,'Acc'] = 0}
    if (covout[k,'Acc'] == 1){
      if (k == 1) {covout[k,'Acc'] = 1}
      else {covout[k,'Acc'] = covout[k-1,'Acc'] + 1}
    }
    if (covout[k,'Acc'] == 8){crit <- k
    break}
    else {crit <- 0}
  }
  
  critlist <- c(critlist,crit)
  
}


critlist <- critlist[critlist!=0]

mrbdt <- mean(critlist)
sdrbdt <- sd(critlist)
errrbdt <- sdrbdt/100


#-----------------------------------------------------------

critlist <- NULL

# No concurrent load
exppar <- c(0.0025,0.02,1,1,0.5,5,0,0.5)

for (j in 1:10000){
  
  train <- wa2001train(2,20,-1)
  train <- train[1:200,]
  stims <- as.data.frame(train[1:16,])
  stims <- stims[order(stims$stim),]
  stims <- as.matrix(stims)
  nextrules <- c(0.25,0.25,0.25,0.25)
  smat <- symat(16,2)
  scvmat <- scumat(16,4,3,0,stims)
  
  covout <- slpCOVIS(train,nextrules,smat,scvmat,exppar,imppar,comppar,extpar)
  #if (extpar[5] == 1){
  colnames(covout) = c('Trial','Resp','System','Acc','Etrust',
                       'Itrust','cdim','hvx','expresp','hvp',
                       'impresp','econf','iconf','imaxval',
                       'emaxval','expacc','impacc','respt',
                       'rrule','crule','prep','prer','dn',
                       'cstim1','cstim2','cstim3','cstim4',
                       'acts1','acts2','acts3','acts4','acts5',
                       'acts6','acts7','acts8','acts9','acts10',
                       'acts11','acts12','acts13','acts14','acts15',
                       'acts16','sumact1','sumact2','updrules1',
                       'updrules2','updrules3','updrules4',
                       'updsyA_1','updsyA_2','updsyA_3','updsyA_4',
                       'updsyA_5','updsyA_6','updsyA_7','updsyA_8',
                       'updsyA_9','updsyA_10','updsyA_11','updsyA_12',
                       'updsyA_13','updsyA_14','updsyA_15','updsyA_16',
                       'updsyB_1','updsyB_2','updsyB_3','updsyB_4',
                       'updsyB_5','updsyB_6','updsyB_7','updsyB_8',
                       'updsyB_9','updsyB_10','updsyB_11','updsyB_12',
                       'updsyB_13','updsyB_14','updsyB_15','updsyB_16')#}
  #else {colnames(covout) = c('Trial','Resp','System','Acc','Etrust','Itrust')}
  
  covout <- as.data.frame(covout)
  
  
  
  
  
  for (k in 1:200){
    if (covout[k,'Acc'] == 0){covout[k,'Acc'] = 0}
    if (covout[k,'Acc'] == 1){
      if (k == 1) {covout[k,'Acc'] = 1}
      else {covout[k,'Acc'] = covout[k-1,'Acc'] + 1}
    }
    if (covout[k,'Acc'] == 8){crit <- k
    break}
    else {crit <- 0}
  }
  
  critlist <- c(critlist,crit)
  
}


critlist <- critlist[critlist!=0]

miic <- mean(critlist)
sdiic <- sd(critlist)
erriic <- sdiic/100


#-----------------------------------------------------------

# Concurrent load
exppar <- c(0.0025,0.02,20,1,0.5,0.5,0,0.5)

critlist <- NULL


for (j in 1:10000){
  
  train <- wa2001train(2,20,-1)
  train <- train[1:200,]
  stims <- as.data.frame(train[1:16,])
  stims <- stims[order(stims$stim),]
  stims <- as.matrix(stims)
  nextrules <- c(0.25,0.25,0.25,0.25)
  smat <- symat(16,2)
  scvmat <- scumat(16,4,3,0,stims)
  
  covout <- slpCOVIS(train,nextrules,smat,scvmat,exppar,imppar,comppar,extpar)
  #if (extpar[5] == 1){
  colnames(covout) = c('Trial','Resp','System','Acc','Etrust',
                       'Itrust','cdim','hvx','expresp','hvp',
                       'impresp','econf','iconf','imaxval',
                       'emaxval','expacc','impacc','respt',
                       'rrule','crule','prep','prer','dn',
                       'cstim1','cstim2','cstim3','cstim4',
                       'acts1','acts2','acts3','acts4','acts5',
                       'acts6','acts7','acts8','acts9','acts10',
                       'acts11','acts12','acts13','acts14','acts15',
                       'acts16','sumact1','sumact2','updrules1',
                       'updrules2','updrules3','updrules4',
                       'updsyA_1','updsyA_2','updsyA_3','updsyA_4',
                       'updsyA_5','updsyA_6','updsyA_7','updsyA_8',
                       'updsyA_9','updsyA_10','updsyA_11','updsyA_12',
                       'updsyA_13','updsyA_14','updsyA_15','updsyA_16',
                       'updsyB_1','updsyB_2','updsyB_3','updsyB_4',
                       'updsyB_5','updsyB_6','updsyB_7','updsyB_8',
                       'updsyB_9','updsyB_10','updsyB_11','updsyB_12',
                       'updsyB_13','updsyB_14','updsyB_15','updsyB_16')#}
  #else {colnames(covout) = c('Trial','Resp','System','Acc','Etrust','Itrust')}
  
  covout <- as.data.frame(covout)
  
  for (k in 1:200){
    if (covout[k,'Acc'] == 0){covout[k,'Acc'] = 0}
    if (covout[k,'Acc'] == 1){
      if (k == 1) {covout[k,'Acc'] = 1}
      else {covout[k,'Acc'] = covout[k-1,'Acc'] + 1}
    }
    if (covout[k,'Acc'] == 8){crit <- k
    break}
    else {crit <- 0}
  }
  
  critlist <- c(critlist,crit)
  
}


critlist <- critlist[critlist!=0]

miidt <- mean(critlist)
sdiidt <- sd(critlist)
erriidt <- sdiidt/100


simgraph <- barplot(c(mrbc,mrbdt,miic,miidt),
        xlab = "Condition",
        ylab = "Mean number of trials necessary to reach criterion",
        ylim = c(0,75),
        main = "WA2001 simulation(10000 trials)",
        names.arg = c("RBC","RBDT","IIC","IIDT"))

arrows(simgraph, c(mrbc-(errrbc*2),mrbdt-(errrbdt*2),miic-(erriic*2),miidt-(erriidt*2)), simgraph,
       c(mrbc+(errrbc*2),mrbdt+(errrbdt*2),miic+(erriic*2),miidt+(erriidt*2)), lwd = 1.5, angle = 90,
       code = 3, length = 0.05)





# At this point, we have acheived independent simulation convergence.
# Points that we had to agree on/discuss during implementation, not specific enough.
# Rule salience going below zero 
# Parameter values being constrained between 0-1, is this also true for saliencies and do they have to add to 1. Does this also apply to Y.
# Whether response is system based or model based
# Whether the active rule on an incorrect trial can have both boosting vaiables
# The role of delta - mentioned but never used
# Equation 12 is particularly badly written, not acutally R+W
# AMPA/NMDA values - These seem incorrect as it means that the third line of Equation 10 never activates.
# Combining confidence and trust - is this as intended, as it causes the trust of the rule based system to be the same regardless of accuracy
# How did Erick Paul acutally do the sampling for the simulated data? Never mentioned.




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
