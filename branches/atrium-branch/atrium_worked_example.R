# R Script for an example implementation of ATRIUM in R
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

source("R/ek1998train.R")
  
rbias <- as.matrix(rbind(c(-4.5)))
rgain <- as.matrix(rbind(c(0.87080)))
ssxval <- as.matrix(read.csv("ek1998exemplarcoords.csv",header = FALSE))
ssxval <- ssxval[1:100,]

#ssxval <- rbind(c(4,4),c(2,5),c(3,7),c(6,2),c(7,4),c(5,5),c(2,1),c(1,1),c(1,2),c(8,7),c(8,8),c(7,8))

alpha <- c(0.5,0.5)
sweights <- as.matrix(cbind(NULL,c(0,0,0,0)))
lweights <- as.matrix(cbind(NULL,c(0,0,0,0)))
excweights <- as.matrix(cbind(c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ))
exgweights <- c(0,0,0,0,0,0,0,0,0,0
                ,0,0
                ,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0,0,0,0,
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                )
  
st <- list(1,0.03375,1.28296,1,0.32163,-1.78984,1,4.07742,0.41313,1.96593,
           2,4,1,20,3,1,rbias,rgain,ssxval,alpha,sweights,lweights,excweights,
           exgweights)
names(st) <- c('rcost','rmlr','c','ecost','emlr','gbias','ggain','cpsc','gnlr',
               'alr','stimdim','cats','mods','exmplrs','colskip','rdim','rbias',
               'rgain','ssxval','alpha','sweights','lweights',
               'excweights','exgweights')


simcrule <- NULL
simnearex <- NULL

simcexcep <- NULL
simnearule <- NULL

for (i in 1:1000){
  
tr <- ek1998train(29,-1,FALSE,1,406,0)
#tr <- ek1998train(1,-1,FALSE,1,10,0)
#trans <- ek1998trans(1,1,50,2)
  
#tr <- tr[1:5,]


outmat <-  slpATRIUM(st,tr,rgive = TRUE,xtdo = TRUE)



# <- NULL
#for (i in 1:406){
#  tmat <- rbind(tmat,outmat[[i]][['emout']])
#}


gmat <- NULL

for (j in 1:406){
  gmat <- rbind(gmat,as.matrix(cbind(outmat[[j]][['cresp']],which.max(outmat[[j]][['respprob']]))))
}

gmat <- cbind(gmat,tr[,'blk']) 
colnames(gmat) <- c('cresp','resp','blk')
gmat <- as.data.frame(gmat)
gmat$acc <- 0
gmat$acc[gmat$resp == gmat$cresp] <- 1



crule <- gmat[(gmat$cresp == 1) | (gmat$cresp == 2),]

crule <- aggregate(crule,list(crule$blk),mean)

nex <- gmat[((gmat$cresp == 1) & (gmat$resp == 3)) | ((gmat$cresp == 2) & (gmat$resp == 4)),]

nearex <- NULL

for (j in 1:29){
  nearex <- c(nearex,(length(nex$resp[nex$blk == j])/10))
}


cexcep <- gmat[(gmat$cresp == 3) | (gmat$cresp == 4),]
cexcep <- aggregate(cexcep,list(cexcep$blk),mean)


nrule <- gmat[((gmat$cresp == 3) & (gmat$resp == 1)) | ((gmat$cresp == 4) & (gmat$resp == 2)),]

nearule <- NULL

for (j in 1:29){
  nearule <- c(nearule,(length(nrule$resp[nrule$blk == j])/4))
}

#plot(crule$acc,crule$block,
#     type = 'b',xlab = "Block",xaxt = 'n',
#     ylab = "Prop",yaxt = 'n',xlim = c(1,29),ylim = c(0,1),col = 'red')
#lines(nearex,crule$block,
#      type = 'b',col = 'blue')
#axis(1, at=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29), las=1)
#axis(2, at=c(0.0,0.2,0.4,0.6,0.8,1.0), las=1)

#plot(cexcep$acc,cexcep$block,
#     type = 'b',xlab = "Block",xaxt = 'n',
#     ylab = "Prop",yaxt = 'n',xlim = c(1,29),ylim = c(0,1),col = 'red')
#lines(nearule,cexcep$block,
#      type = 'b',col = 'blue')
#axis(1, at=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29), las=1)
#axis(2, at=c(0.0,0.2,0.4,0.6,0.8,1.0), las=1)

simcrule <- cbind(simcrule,crule$acc)
simnearex <- cbind(simnearex,nearex)

simcexcep <- cbind(simcexcep,cexcep$acc)
simnearule <- cbind(simnearule,nearule)

}

x <- rowMeans(simcrule)
y <- rowMeans(simnearex)

plot(x,crule$block,
     type = 'b',xlab = "Block",xaxt = 'n',
     ylab = "Prop",yaxt = 'n',xlim = c(1,29),ylim = c(0,1),col = 'red')
lines(y,crule$block,
      type = 'b',col = 'blue')
axis(1, at=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29), las=1)
axis(2, at=c(0,0.2,0.4,0.6,0.8,1))


w <- rowMeans(simcexcep)
z <- rowMeans(simnearule)

plot(w,cexcep$block,
     type = 'b',xlab = "Block",xaxt = 'n',
     ylab = "Prop",yaxt = 'n',xlim = c(1,29),ylim = c(0,1),col = 'red')
lines(z,cexcep$block,
      type = 'b',col = 'blue')
axis(1, at=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29), las=1)
axis(2, at=c(0,0.2,0.4,0.6,0.8,1))










