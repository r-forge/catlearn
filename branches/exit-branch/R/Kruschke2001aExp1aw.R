## Inverse Base Rate Effect
rm(list=ls())
source("slpEXITrs.R")
source("krus96train.R")
tr <- krus96train()

## Parameters from Kruschke (2001)

st <- list(nFeat = 6+1, nCat = 4, phi = 4.42, c = 2.87, P = 2.48, l_gain = 4.42,
           l_weight = .212, l_ex = 1.13, sigma = .401, iterations = 10)

                                        # the bias cue is part of the exemplar... (column 7 =1 all the time)

    exemplars<-rbind(c(1,1,0,0,0,0,1,1,0,0,0),
                     c(1,0,1,0,0,0,1,0,1,0,0),
                     c(0,0,0,1,1,0,1,0,0,1,0),
                     c(0,0,0,1,0,1,1,0,0,0,1))


    st$exemplars<-exemplars[,1:7]
    st$w_exemplars<-exemplars[,1:7]
    st$w_exemplars[]<-0
    st$w_in_out<-matrix(0,st$nCat,st$nFeat)

st$exemplars
predics<-slp_EXITrs(st,tr,xtdo=F)$response_probabilities
## Note the predictions are sensitive to the trial sequence
## and there are only slight differences in I1 and I2 etc... (see full output)

## in Kruschke2003 reply to Winman et al, he reports these EXIT fits
# I	        77.00	11.30	7.70	3.90
# PC	    89.80	1.80	5.40	2.90
# PR	    3.00	87.20	7.80	2.00
# PC.PR	    36.30	56.60	4.70	2.40
# I.PC.PR	58.80	39.40	1.00	0.80
# I.PCo	    33.40	8.70	56.10	1.80
# I.PRo	    30.20	3.80	1.30	64.60
# PC.PRo	41.10	0.70	1.10	57.00
# I.PC.PRo	76.90	0.60	0.30	22.20

# note: e.g. PC =PC1 and PCo = PC2 
# note: I rearranged the reported table to match the output order here


## reduced stims:
stims<-c("I1", "I1.PC1.PR1","I1.PC2","I1.PR2","PC1","PR1", "PC1.PR1","PC1.PR2","I1.PC1.PR2")
testtrials<-which(tr[,"block"]==16)
reduced_stims<-tr[testtrials,"stim"] %in% stims
cbind(tr[testtrials[reduced_stims],"stim"],round(predics[testtrials[reduced_stims],],2))
## if the g shift is only applied to Equation 8 
## (the issue with carry over to subsequent error signals)
## then: "PC1.PR1"  is predicted in the incorrect direction; "PC1" and "I1.PC1.PR2" are too high
## if the shift is applied to subsequent error signals Equations 9 and 10
## then the picture generally fits to the reported values in the table (despite sample randomness)

## so in general: everything looks like the altered category output 
## and the altered alpha values in the 10 iterations are taken to subsequent 
## equations. Only this way the slp predictions approximate the reported ones.

## full
cbind(tr[testtrials,"stim"],round(predics[testtrials,],2))


## training learning -> goes to perfect performance quickly
predics<-slp_EXITrs(st,tr,xtdo=F)$response_probabilities
tr1<-tr[,"t1"]==1
tr2<-tr[,"t2"]==1
tr3<-tr[,"t3"]==1
tr4<-tr[,"t4"]==1
plot(predics[tr1,1])
points(predics[tr2,2],pch=2)
points(predics[tr3,3],pch=3)
points(predics[tr4,4],pch=4)

#### Generating CIRP
krus96 <- read.csv("../krus96.csv")
save(krus96, file = "../data/krus96.RData")
