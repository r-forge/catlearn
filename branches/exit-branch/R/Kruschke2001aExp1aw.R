source("slpEXITrs.R")
## Inverse Base Rate Effect
## And this code generates a random sequence of trials (tr)
## following the experimental procedure as done in
## Kruschke & Blair, 2000, Experiment 1, which was
## fit using EXIT in Kruschke, 2001

Kruschke1996Exp1<-function(){
    sr<-rbind(c(1,1,0,0,0,0,1,1,0,0,0),
              c(1,1,0,0,0,0,1,1,0,0,0),
              c(1,1,0,0,0,0,1,1,0,0,0),
              c(1,0,1,0,0,0,1,0,1,0,0),
              c(0,0,0,1,1,0,1,0,0,1,0),
              c(0,0,0,1,1,0,1,0,0,1,0),
              c(0,0,0,1,1,0,1,0,0,1,0),
              c(0,0,0,1,0,1,1,0,0,0,1))
    
    trainingitems<-as.data.frame(cbind(rep(0,nrow(sr)),sr,rep("",nrow(sr))))
    colnames(trainingitems)<-c("ctrl","x1","x2","x3","x4","x5","x6","x7", "t1","t2","t3","t4","stim")
    ## note "x7"=bias cue, which is always on
    trainingitems[,"stim"]<-c(rep("I1.PC1",3),"I1.PR1",rep("I2.PC2",3),"I2.PR2")
    exemplars<-rbind(c(1,1,0,0,0,0,1,1,0,0,0),
                     c(1,0,1,0,0,0,1,0,1,0,0),
                     c(0,0,0,1,1,0,1,0,0,1,0),
                     c(0,0,0,1,0,1,1,0,0,0,1))

    trainingblocks<-15
    tr<-as.data.frame(matrix(0,ncol=14,nrow=trainingblocks*nrow(sr)))
    for (i in 1:trainingblocks){
        samp<-sample(1:nrow(sr),nrow(sr))
        tr[(1:nrow(sr))+nrow(sr)*(i-1),2:12]<-sr[samp,]
        tr[(1:nrow(sr))+nrow(sr)*(i-1),13]<-trainingitems[samp,"stim"]
        tr[(1:nrow(sr))+nrow(sr)*(i-1),14]<-i
    }
    tr[1,1]<-1
    colnames(tr)<-c(colnames(trainingitems),"block")
    
    testitems<-rbind(c(1,0,0,0,0,0,1,0,0,0,0),
                     c(0,1,0,0,0,0,1,0,0,0,0),
                     c(0,0,1,0,0,0,1,0,0,0,0),
                     c(0,0,0,1,0,0,1,0,0,0,0),
                     c(0,0,0,0,1,0,1,0,0,0,0),
                     c(0,0,0,0,0,1,1,0,0,0,0),
                     c(0,1,1,0,0,0,1,0,0,0,0),
                     c(0,0,0,0,1,1,1,0,0,0,0),
                     c(1,1,1,0,0,0,1,0,0,0,0),
                     c(0,0,0,1,1,1,1,0,0,0,0),
                     c(1,0,0,0,1,0,1,0,0,0,0),
                     c(1,0,0,0,0,1,1,0,0,0,0),
                     c(0,1,0,1,0,0,1,0,0,0,0),
                     c(0,0,1,1,0,0,1,0,0,0,0),
                     c(0,1,0,0,0,1,1,0,0,0,0),
                     c(0,0,1,0,1,0,1,0,0,0,0),
                     c(1,1,0,0,0,1,1,0,0,0,0),
                     c(0,0,1,1,1,0,1,0,0,0,0))
    nrow(testitems)         
    testrials<-as.data.frame(cbind(rep(2,nrow(testitems)),testitems,rep(0,nrow(testitems)),rep(0,nrow(testitems))))
    colnames(testrials)<-colnames(tr)
    testrials$block<-16
    testrials$stim<-c("I1","PC1","PR1","I2","PC2","PR2",                         ### I, PC, PR
                      "PC1.PR1","PC2.PR2", "I1.PC1.PR1","I2.PC2.PR2",            ### PC.PR, I.PC.PR
                      "I1.PC2","I1.PR2","I2.PC1","I2.PR1",                       ### I.PCo, I.PRo
                      "PC1.PR2","PC2.PR1",                                       ### PC.PRo
                      "I1.PC1.PR2","I2.PC2.PR1")                                 ### I.PC.PRo
    tr<-rbind(tr,testrials)
    return(list(tr=tr,exemplars=exemplars[,1:7]))
}
tr<-Kruschke1996Exp1()$tr
exemplars<-Kruschke1996Exp1()$exemplars

## Parameters from Kruschke (2001)

st<-list(nFeat=6+1, nCat=4, phi=4.42, c=2.87, P=2.48, l_gain=4.42, l_weight=.212, l_ex=1.13, sigma=.401, iterations=10)

## Parameters from Kruschke (2003)
st<-list(nFeat=6+1, ## +1 =bias
         nCat=4, 
         phi=5.00, ## Choice decisiveness
         c=9.62,  ## Exemplar specificity
         P=17.0, ## attention capacity
         l_gain=2.65, ## attention shifting rate
         l_weight=.135, ## output association learning rate
         l_ex=1.0313, ## attention learning rate
         sigma=.938, ## bias salience
         iterations=10)


# the bias cue is part of the exemplar... (column 7 =1 all the time)
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
