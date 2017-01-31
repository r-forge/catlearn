# R Script for an example implementation of COVIS in R
# Author: Angus B. Inkster  
# Start Date: 16/02/2016

# This script is intended as an example of how the COVIS
# part of the catlearn package can be implemented in R.

# Before anything else, clear the environment.
rm(list=ls())
# Use ctrl+L to clear the console

# First lets generate the required training data and 
# initial synapse and scu values.
require(Rcpp)


# set the seed (if you want it to be easily replicable).
set.seed(7)

source("R/wa2001train.R")

sourceCpp("src/slpcovis.cpp")

# Next lets generate the parameter lists required by 
# slpcovis. These values are from the simulation of COVIS
# run in Wills and Pothos 2012 book, with the training set
# generated form Waldron and Ashby(2001). The parameter list
# exppar is a choice as it is one value for no concurrent
# load and one value for concurrent load.

# This comment is to explain the st list taken by slpcovis:
# st = [corcon,errcon,perscon,decsto,decbound,lambda,envar,
# emaxval,dbase,alphaw,betaw,gammaw,nmda,ampa,wmax,invar,
# sconst,prep,prer,etrust,itrust,ocp,oep,colskip,stimdim]
# All of the above are parameters taken by COVIS. You can 
# find a more detailed description in Pothos and Wills 
# (2012).


#-----------------------------------------------------------

critlist <- NULL

# No concurrent load
st <- list(0.0025,0.02,1,1,0.5,5,0,0.5,0.2,0.65,0.19,0.02,
           0.0022,0.01,1,0.00015625,0.00000000001,0,0,0.99,
           0.01,0.01,0.04,3,4,0,nextrules,smat,scvmat)
names(st) <- c('corcon','errcon','perscon','decsto',
               'decbound','lambda','envar','emaxval',
               'dbase','alphaw','betaw','gammaw','nmda',
               'ampa','wmax','invar','sconst','prep','prer',
               'etrust','itrust','ocp','oep','colskip',
               'stimdim','crule','initrules','initsy',
               'scups')


# for (j in 1:10000){
  
tr <- wa2001train(1,20,-1,0,1,200,FALSE)
stims <- as.data.frame(tr[1:16,])
stims <- stims[order(stims$stim),]
stims <- as.matrix(stims)
nextrules <- c(0.25,0.25,0.25,0.25)
smat <- symat(16,2)
scvmat <- scumat(16,4,3,0,stims)

covout <- slpCOVIS(st,tr,crx = TRUE,respt = FALSE,xtdo = TRUE,rgive = TRUE)
if (length(covout$foutmat[1,]) > 2)
  {colnames(covout$foutmat) <- c('Cat1P','Cat2P','acc',
                        'System','cdim','hvx','expresp',
                        'hvp','impresp','econf','iconf',
                        'imaxval','emaxval','expacc',
                        'impacc','respt','rrule','dn',
                        'Etrust','Itrust','crule','prep',
                        'prer','cstim1','cstim2','cstim3',
                        'cstim4','acts1','acts2','acts3',
                        'acts4','acts5','acts6','acts7',
                        'acts8','acts9','acts10','acts11',
                        'acts12','acts13','acts14',
                        'acts15','acts16','sumact1',
                        'sumact2')}
if (length(covout$foutmat[1,]) == 3) 
{colnames(covout$foutmat) <- c('Cat1P','Cat2P','acc')}
covout$foutmat

respmat <- as.data.frame(covout$foutmat[,1:2])
accmat <- as.data.frame(covout$foutmat[,3])
colnames(accmat) <- c('Acc')


for (k in 1:200){
  if (accmat[k,'Acc'] == 0){accmat[k,'Acc'] = 0}
  if (accmat[k,'Acc'] == 1){
    if (k == 1) {accmat[k,'Acc'] = 1}
    else {accmat[k,'Acc'] = accmat[k-1,'Acc'] + 1}
  }
  if (accmat[k,'Acc'] == 8){crit <- k
  break}
  else {crit <- 0}
}

critlist <- c(critlist,crit)

#}


critlist <- critlist[critlist!=0]

mrbc <- mean(critlist)
sdrbc <- sd(critlist)
errrbc<- sdrbc/100

#-----------------------------------------------------------

# Concurrent load
st <- list(0.0025,0.02,20,1,0.5,0.5,0,0.5,0.2,0.65,0.19,0.02,
           0.0022,0.01,1,0.00015625,0.00000000001,0,0,0.99,
           0.01,0.01,0.04,3,4,0,nextrules,smat,scvmat)
names(st) <- c('corcon','errcon','perscon','decsto',
               'decbound','lambda','envar','emaxval',
               'dbase','alphaw','betaw','gammaw','nmda',
               'ampa','wmax','invar','sconst','prep','prer',
               'etrust','itrust','ocp','oep','colskip',
               'stimdim','crule','initrules','initsy',
               'scups')
 
critlist <- NULL


for (j in 1:10000){
  
tr <- wa2001train(1,20,-1,0,1,200,FALSE)
stims <- as.data.frame(tr[1:16,])
stims <- stims[order(stims$stim),]
stims <- as.matrix(stims)
nextrules <- c(0.25,0.25,0.25,0.25)
smat <- symat(16,2)
scvmat <- scumat(16,4,3,0,stims)
  
covout <- slpCOVIS(st,tr,crx = TRUE,respt = FALSE,xtdo = TRUE,rgive = TRUE)
if (length(covout$foutmat[1,]) > 2)
{colnames(covout$foutmat) <- c('Cat1P','Cat2P','acc',
                               'System','cdim','hvx','expresp',
                               'hvp','impresp','econf','iconf',
                               'imaxval','emaxval','expacc',
                               'impacc','respt','rrule','dn',
                               'Etrust','Itrust','crule','prep',
                               'prer','cstim1','cstim2','cstim3',
                               'cstim4','acts1','acts2','acts3',
                               'acts4','acts5','acts6','acts7',
                               'acts8','acts9','acts10','acts11',
                               'acts12','acts13','acts14',
                               'acts15','acts16','sumact1',
                               'sumact2')}
if (length(covout$foutmat[1,]) == 3) 
{colnames(covout$foutmat) <- c('Cat1P','Cat2P','acc')}
covout$foutmat
  
respmat <- as.data.frame(covout$foutmat[,1:2])
accmat <- as.data.frame(covout$foutmat[,3])
colnames(accmat) <- c('Acc')
  
  
for (k in 1:200){
  if (accmat[k,'Acc'] == 0){accmat[k,'Acc'] = 0}
  if (accmat[k,'Acc'] == 1){
    if (k == 1) {accmat[k,'Acc'] = 1}
    else {accmat[k,'Acc'] = accmat[k-1,'Acc'] + 1}
  }
  if (accmat[k,'Acc'] == 8){crit <- k
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
st <- list(0.0025,0.02,1,1,0.5,5,0,0.5,0.2,0.65,0.19,0.02,
           0.0022,0.01,1,0.00015625,0.00000000001,0,0,0.99,
           0.01,0.01,0.04,3,4,0,nextrules,smat,scvmat)
names(st) <- c('corcon','errcon','perscon','decsto',
               'decbound','lambda','envar','emaxval',
               'dbase','alphaw','betaw','gammaw','nmda',
               'ampa','wmax','invar','sconst','prep','prer',
               'etrust','itrust','ocp','oep','colskip',
               'stimdim','crule','initrules','initsy',
               'scups')

for (j in 1:10000){
  
tr <- wa2001train(2,20,-1,0,1,200,FALSE)
stims <- as.data.frame(train[1:16,])
stims <- stims[order(stims$stim),]
stims <- as.matrix(stims)
nextrules <- c(0.25,0.25,0.25,0.25)
smat <- symat(16,2)
scvmat <- scumat(16,4,3,0,stims)
  
covout <- slpCOVIS(st,tr,crx = TRUE,respt = FALSE,xtdo = TRUE,rgive = TRUE)
if (length(covout$foutmat[1,]) > 2)
{colnames(covout$foutmat) <- c('Cat1P','Cat2P','acc',
                               'System','cdim','hvx','expresp',
                               'hvp','impresp','econf','iconf',
                               'imaxval','emaxval','expacc',
                               'impacc','respt','rrule','dn',
                               'Etrust','Itrust','crule','prep',
                               'prer','cstim1','cstim2','cstim3',
                               'cstim4','acts1','acts2','acts3',
                               'acts4','acts5','acts6','acts7',
                               'acts8','acts9','acts10','acts11',
                               'acts12','acts13','acts14',
                               'acts15','acts16','sumact1',
                               'sumact2')}
if (length(covout$foutmat[1,]) == 3) 
{colnames(covout$foutmat) <- c('Cat1P','Cat2P','acc')}
covout$foutmat

respmat <- as.data.frame(covout$foutmat[,1:2])
accmat <- as.data.frame(covout$foutmat[,3])
colnames(accmat) <- c('Acc')
  
  
for (k in 1:200){
  if (accmat[k,'Acc'] == 0){accmat[k,'Acc'] = 0}
  if (accmat[k,'Acc'] == 1){
    if (k == 1) {accmat[k,'Acc'] = 1}
    else {accmat[k,'Acc'] = accmat[k-1,'Acc'] + 1}
  }
  if (accmat[k,'Acc'] == 8){crit <- k
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
st <- list(0.0025,0.02,20,1,0.5,0.5,0,0.5,0.2,0.65,0.19,0.02,
           0.0022,0.01,1,0.00015625,0.00000000001,0,0,0.99,
           0.01,0.01,0.04,3,4,0,nextrules,smat,scvmat)
names(st) <- c('corcon','errcon','perscon','decsto',
               'decbound','lambda','envar','emaxval',
               'dbase','alphaw','betaw','gammaw','nmda',
               'ampa','wmax','invar','sconst','prep','prer',
               'etrust','itrust','ocp','oep','colskip',
               'stimdim','crule','initrules','initsy',
               'scups')

critlist <- NULL


for (j in 1:10000){
  
tr <- wa2001train(2,20,-1,0,1,200,FALSE)
stims <- as.data.frame(train[1:16,])
stims <- stims[order(stims$stim),]
stims <- as.matrix(stims)
nextrules <- c(0.25,0.25,0.25,0.25)
smat <- symat(16,2)
scvmat <- scumat(16,4,3,0,stims)

covout <- slpCOVIS(st,tr,crx = TRUE,respt = FALSE,xtdo = TRUE,rgive = TRUE)
if (length(covout$foutmat[1,]) > 2)
{colnames(covout$foutmat) <- c('Cat1P','Cat2P','acc',
                               'System','cdim','hvx','expresp',
                               'hvp','impresp','econf','iconf',
                               'imaxval','emaxval','expacc',
                               'impacc','respt','rrule','dn',
                               'Etrust','Itrust','crule','prep',
                               'prer','cstim1','cstim2','cstim3',
                               'cstim4','acts1','acts2','acts3',
                               'acts4','acts5','acts6','acts7',
                               'acts8','acts9','acts10','acts11',
                               'acts12','acts13','acts14',
                               'acts15','acts16','sumact1',
                               'sumact2')}
if (length(covout$foutmat[1,]) == 3) 
{colnames(covout$foutmat) <- c('Cat1P','Cat2P','acc')}
covout$foutmat
  
respmat <- as.data.frame(covout$foutmat[,1:2])
accmat <- as.data.frame(covout$foutmat[,3])
colnames(accmat) <- c('Acc')
  
  
for (k in 1:200){
  if (accmat[k,'Acc'] == 0){accmat[k,'Acc'] = 0}
  if (accmat[k,'Acc'] == 1){
    if (k == 1) {accmat[k,'Acc'] = 1}
    else {accmat[k,'Acc'] = accmat[k-1,'Acc'] + 1}
  }
  if (accmat[k,'Acc'] == 8){crit <- k
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
                    ylab = "Mean number of trials
                            necessary to reach criterion",
                    ylim = c(0,75),
                    main = "WA2001 simulation
                            (10000 trials)",
                    names.arg = c("RBC","RBDT",
                                  "IIC","IIDT"))

arrows(simgraph,c(mrbc-(errrbc*2),mrbdt-(errrbdt*2),
       miic-(erriic*2),miidt-(erriidt*2)),simgraph,
       c(mrbc+(errrbc*2),mrbdt+(errrbdt*2),miic+(erriic*2),
       miidt+(erriidt*2)),lwd = 1.5,angle = 90,code = 3,
       length = 0.05)


