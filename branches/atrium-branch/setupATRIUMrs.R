
## "Replicate" Fits of Erickson & Kruschke 1998
## the fitted settings are these:
## but makes no sense - they used psychologically scaled dimension values 
## (appendix C)
st<-list(nCat=4, 
         nFeat=2, 
         beta=c(4.5,4.5), #rule bias (-boundary); index 1: first; 2: second 
         # dimension
         y_r=c(.87080,.87080), #rule gain
         c=1.28296, #specificity
         beta_g=-1.78984, #gate bias
         y_g=1,  # gate gain
         phi=4.07742, # response scaling
         cost=c(1,1), # index 1: exemplar; 2: rule module
         lambda_r=.03375, # rule learning
         lambda_e=.32163, # exemplar learning
         lambda_a=1.96593, # attention learning
         lambda_g=.41313, # gate learning
         prime_dim=2 # tells the model on which dim the rule is
            ) 
## note: prime_dim 1 in the paper is the column "x2" in tr here, which is
##  prime_dim=2
## (can also be a vector with multiple dimensions, the rules will be generated 
## automatically.
## i.e. nRules=length(prime_dim)

## trying out other settings
st<-list(nCat=4, 
         nFeat=2, 
         beta=c(4.5, 4.5), #rule boundaries; index 1 for rule dim 1: index 2: 
         #for dimension 2
         y_r=c(.87080,.87080), #rule gain
         c=.38296, #specificity
         beta_g=-1.78984, #gate bias (positive values bias to exemplar module, 
         #negtive to rule module)
         y_g=1,  # gate gain
         phi=4.07742, # response scaling
         cost=c(1,1), # index 1: exemplar; 2: rule module
         lambda_r=.03375, # rule learning
         lambda_e=.32163, # exemplar learning 
         lambda_a=1.96593, # attention learning
         lambda_g=5.41313, # gate learning
         prime_dim=c(2)) # tells the model on whitch dim the rule is 

### set to exemplar learning rate to 0 for checking whether the rule module 
### (alone) works, and it does.
### Then the "near rule" predictions in the graph below are about 50% for 
### exceptions, which means,
### it is kind of randomly predicted ty a rule 
#st$lambda_e=0
exp(-.5*1000*(.1))
c(10^-5,10^-5)
## full set of possible stimuli
stimuli<-cbind(expand.grid(0:9,0:9),rep(0,100))
sr<-t(cbind(
    c(2,2,0,0,1,0),
    c(1,4,1,0,0,0),
    c(4,1,1,0,0,0),
    c(5,3,1,0,0,0),
    c(7,2,1,0,0,0),
    c(8,4,1,0,0,0),
    c(1,5,0,1,0,0),
    c(2,7,0,1,0,0),
    c(4,6,0,1,0,0),
    c(5,8,0,1,0,0),
    c(7,7,0,0,0,1),
    c(8,5,0,1,0,0)
))
# plot of the category structure:
# layout(matrix(1))
# plot(test_stims, pch=0,cex=5, xlab="Secondary Dimension",ylab="Primary 
# Dimension")
# points(sr[sr[,3]==1,1:2],pch=16,cex=3)
# points(sr[sr[,4]==1,1:2],pch=15,cex=3)
# points(x=sr[sr[,5]==1,1],y=sr[sr[,5]==1,1],pch=1,cex=3, lwd=3)
# points(x=sr[sr[,6]==1,1],y=sr[sr[,6]==1,1],pch=0,cex=3, lwd=3)

1/(1+exp(5))

st$exemplars<-sr[,1:2]
colnames(st$exemplars)<-c("x1","x2")
trainingblocks<-29
tr<-as.data.frame(matrix(0,nrow=(trainingblocks*12),
                         ncol=(1+st$nCat+st$nFeat+2)))
for (i in 1:trainingblocks){
    samp<-sample(1:12,12)
    tr[(1:12)+12*(i-1),2:7]<-sr[samp,]
    tr[(1:12)+12*(i-1),8]<-samp
    tr[(1:12)+12*(i-1),9]<-i
}
tr[1,1]<-1
test_stims<-expand.grid(0:9,0:9)
colnames(tr)<-c("ctrl","x1","x2","t1","t2","t3","t4","stim","block")
testtrials<-as.matrix(cbind(rep(0,nrow(test_stims)),test_stims,
                  rep(0,nrow(test_stims)),rep(0,nrow(test_stims)),rep(0,nrow(test_stims)),
                  rep(0,nrow(test_stims)),rep(0,nrow(test_stims)),rep(30,nrow(test_stims))))
colnames(testtrials)<-c("ctrl","x1","x2","t1","t2","t3","t4","stim","block")
tr<-rbind(tr,testtrials)
head(tr)
tr[tr[,"block"]==30,1]<-2

predics<-slp_ATRIUMrs(st,tr,xtdo=F)

### Generating plot like in Figure 16; but with ATRIUM predictions only
## left plot
layout(matrix(1:2,1,2))
library(plyr)
t1<-which(tr[,"t1"]==1)
t2<-which(tr[,"t2"]==1)
t3<-which(tr[,"t3"]==1)
t4<-which(tr[,"t4"]==1)
tr1<-aggregate(predics[t1,1], by=list(block=tr[t1,"block"]),mean)
tr2<-aggregate(predics[t2,2], by=list(block=tr[t2,"block"]),mean)
tr1n1<-aggregate(predics[t1,3], by=list(block=tr[t1,"block"]),mean)
tr1n2<-aggregate(predics[t1,4], by=list(block=tr[t1,"block"]),mean)
tr2n1<-aggregate(predics[t2,3], by=list(block=tr[t2,"block"]),mean)
tr2n2<-aggregate(predics[t2,4], by=list(block=tr[t2,"block"]),mean)
plot(NULL,xlim=c(0,30),ylim=c(0,1), ylab="p(Correct)",xlab="Trainingblock")
points(rowMeans(cbind(tr1[,2],tr2[,2])), type="b",pch=1)
points(rowMeans(cbind(tr1n1[,2],tr1n2[,2],tr2n1[,2],tr2n2[,2])), type="b",pch=2)
legend(x=0,y=1,legend=c("Correct Rule","Near Exception"), pch=1:2, bty = "n")
## note: with the settings reported in Erickson & Kruschke (fits for scaled dimensions)
## the model produces crazy predcitions 
## use (some) alternative settings for better behavior
## right plot
tr1<-aggregate(predics[t3,3], by=list(block=tr[t3,"block"]),mean)
tr2<-aggregate(predics[t4,4], by=list(block=tr[t4,"block"]),mean)
tr1n1<-aggregate(predics[t3,1], by=list(block=tr[t3,"block"]),mean)
tr1n2<-aggregate(predics[t3,2], by=list(block=tr[t3,"block"]),mean)
tr2n1<-aggregate(predics[t4,1], by=list(block=tr[t4,"block"]),mean)
tr2n2<-aggregate(predics[t4,2], by=list(block=tr[t4,"block"]),mean)
plot(NULL,xlim=c(0,30),ylim=c(0,1), ylab="p(Correct)",xlab="Trainingblock")
points(rowMeans(cbind(tr1[,2],tr2[,2])), type="b",pch=1)
points(rowMeans(cbind(tr1n1[,2])), type="b",pch=2)
points(rowMeans(cbind(tr1n2[,2])), type="b",pch=2)
points(rowMeans(cbind(tr2n1[,2])), type="b",pch=2)
points(rowMeans(cbind(tr2n2[,2])), type="b",pch=2)
legend(x=0,y=1,legend=c("Correct Exception","Near Rule"), pch=1:2, bty="n")
## Note: if a rule predicts two categories,
## each exception could be predicted into one of the two "rule categores", 
## that's why here are 4 trianlge lines (2 exception categoriesx2rulecategories).
## The two triangle lines that make this curved turn represent 
## the applied rules, overall (e.g. large to A and small to B), 
## which of course means that when A is predicted for one exception then B is not,
## the B curve then goes flat.
## Note: When lambda_e is set to 0 then categories 3 and 4 (exceptions), 
## are covered by one of two different rules each (triangles in the right graph)

## Transfer Stimuli
testp<-predics[tr[,"block"]==30,]
mypal <- colorRampPalette( c("black", "white" ) )( 100 )
map2color<-function(x,pal,limits=NULL){
    if(is.null(limits)) limits=range(x)
    pal[findInterval(x,seq(limits[1],limits[2],length.out=length(pal)+1), all.inside=TRUE)]
}
### First: The plot as shown in Figure 13; exception = category 4
### note: space is not rotated as in the paper
layout(matrix(1))
squaresize<-5  ## size of the filled squares
plot(x=test_stims[,2],y=test_stims[,1], cex=squaresize,pch=0, 
     ylab="Primary Dimension (D1)", xlab="Secondary Dimension (D2)",
     ylim=c(-0.5,9.5),xlim=c(-.5,9.5))
categorypredictions<-4 #3 or 4
points(x=test_stims[,2],y=test_stims[,1], cex=squaresize, pch=15,
       col=map2color(testp[,categorypredictions],mypal, limits=c(0,1)))

## insert choice probabilities
xxx<-as.character(round(testp[,categorypredictions],2))
text(x=test_stims[,2],y=test_stims[,1], cex=1, labels=xxx, col="white")
## best i could find...






## just to be sure.... 
### Replicate ALCOVE predictions from the paper
## full set of possible stimuli

## Create Training Sequence + Test Trials (trx)
if (TRUE){
stimuli<-cbind(expand.grid(0:9,0:9),rep(0,100))
## training stimuli
sr<-t(cbind(
    c(2,2,0,0,1,0,0,0),
    c(1,4,1,0,0,0,0,0),
    c(4,1,1,0,0,0,0,0),
    c(5,3,1,0,0,0,0,0),
    c(7,2,1,0,0,0,0,0),
    c(8,4,1,0,0,0,0,0),
    c(1,5,0,1,0,0,0,0),
    c(2,7,0,1,0,0,0,0),
    c(4,6,0,1,0,0,0,0),
    c(5,8,0,1,0,0,0,0),
    c(7,7,0,0,0,1,0,0),
    c(8,5,0,1,0,0,0,0)
))

## create training sequence
trainingblocks<-29
tr<-as.data.frame(matrix(0,nrow=(trainingblocks*12),ncol=11))
for (i in 1:trainingblocks){
    samp<-sample(1:12,12)
    tr[(1:12)+12*(i-1),2:7]<-sr[samp,]
    tr[(1:12)+12*(i-1),10]<-samp
    tr[(1:12)+12*(i-1),11]<-i
}
tr[1,1]<-1

## add test items and freezed learning
test_stims<-expand.grid(0:9,0:9)
colnames(tr)<-c("ctrl","x1","x2","t1","t2","t3","t4","m1","m2","stim","block")
testtrials<-as.matrix(cbind(rep(0,nrow(test_stims)),test_stims,
                            rep(0,nrow(test_stims)),rep(0,nrow(test_stims)),rep(0,nrow(test_stims)),
                            rep(0,nrow(test_stims)),rep(0,nrow(test_stims)),
                            rep(0,nrow(test_stims)),rep(0,nrow(test_stims)),rep(30,nrow(test_stims))))
colnames(testtrials)<-c("ctrl","x1","x2","t1","t2","t3","t4","m1","m2","stim","block")
tr<-rbind(tr,testtrials)
tr[tr[,"block"]==30,1]<-2
plot(tr[tr[,"block"]<30,c(3,4)])
trx<-tr[,1:9]

}
head(trx,20)

## ALCOVE Settings (best parameters) as reported by Erickson & Kruschke
## (does not work)
st<-list(colskip=1, 
         c=.59828, 
         r=1,  ###???
         q=1,  ###???
         phi=6.37629,
         lw=.00855,
         la=1.96770)  

## Alternative ALCOVE Settings (after playing around...)
st<-list(colskip=1, 
         c=.059828,  ## Note: I just inserted a 0 decimal...
         r=1,  ###???
         q=1,  ###???
         phi=4.37629, ## lower -1
         lw=.15, ### higher
         la=1.96770)  
### Note: this setting does not exactly replicate the ALCOVE predictions,
## Dynamics:
## decrease c for increasing the "white exception area" in the test-plot
## decrease c for increasing training performance
## increase lw for increasing the "white exception area" in the test-plot


st$h<-t(sr[,1:2])
st$alpha<-c(0,0)  ###???
st$w<-matrix(0,nrow=4,ncol=12)

### predict
predics<-slpALCOVE(st,as.matrix(trx),dec="ER",attcon=F, humble=F, absval=0)$prob

### Generating plot like in Figure 10; but with ALCOVE predictions only
## left plot
layout(matrix(1:2,1,2))
library(plyr)
t1<-which(tr[,"t1"]==1)
t2<-which(tr[,"t2"]==1)
t3<-which(tr[,"t3"]==1)
t4<-which(tr[,"t4"]==1)
tr1<-aggregate(predics[t1,1], by=list(block=tr[t1,"block"]),mean)
tr2<-aggregate(predics[t2,2], by=list(block=tr[t2,"block"]),mean)
tr1n1<-aggregate(predics[t1,3], by=list(block=tr[t1,"block"]),mean)
tr1n2<-aggregate(predics[t1,4], by=list(block=tr[t1,"block"]),mean)
tr2n1<-aggregate(predics[t2,3], by=list(block=tr[t2,"block"]),mean)
tr2n2<-aggregate(predics[t2,4], by=list(block=tr[t2,"block"]),mean)
plot(NULL,xlim=c(0,30),ylim=c(0,1), ylab="p(Correct)",xlab="Trainingblock")
# points((cbind(tr1[,2])), type="b",pch=1)
# points((cbind(tr2[,2])), type="b",pch=1)
points(rowMeans(cbind(tr1[,2],tr2[,2])), type="b",pch=1)
points(rowMeans(cbind(tr1n1[,2])), type="b",pch=2)
points(rowMeans(cbind(tr1n2[,2])), type="b",pch=2)
points(rowMeans(cbind(tr2n1[,2])), type="b",pch=2)
points(rowMeans(cbind(tr2n2[,2])), type="b",pch=2)
legend(x=0,y=1,legend=c("Correct Rule","Near Exception"), pch=1:2, bty = "n")

## right plot
tr1<-aggregate(predics[t3,3], by=list(block=tr[t3,"block"]),mean)
tr2<-aggregate(predics[t4,4], by=list(block=tr[t4,"block"]),mean)
tr1n1<-aggregate(predics[t3,1], by=list(block=tr[t3,"block"]),mean)
tr1n2<-aggregate(predics[t3,2], by=list(block=tr[t3,"block"]),mean)
tr2n1<-aggregate(predics[t4,1], by=list(block=tr[t4,"block"]),mean)
tr2n2<-aggregate(predics[t4,2], by=list(block=tr[t4,"block"]),mean)
plot(NULL,xlim=c(0,30),ylim=c(0,1), ylab="p(Correct)",xlab="Trainingblock")
points(rowMeans(cbind(tr1[,2],tr2[,2])), type="b",pch=1)
points(rowMeans(cbind(tr1n1[,2])), type="b",pch=2)
points(rowMeans(cbind(tr1n2[,2])), type="b",pch=2)
points(rowMeans(cbind(tr2n1[,2])), type="b",pch=2)
points(rowMeans(cbind(tr2n2[,2])), type="b",pch=2)
legend(x=0,y=1,legend=c("Correct Exception","Near Rule"), pch=1:2, bty="n")




## Transfer Stimuli Plot 
if (TRUE) {
testp<-predics[tr[,"block"]==30,]
mypal <- colorRampPalette( c("black", "white" ) )( 100 )
map2color<-function(x,pal,limits=NULL){
    if(is.null(limits)) limits=range(x)
    pal[findInterval(x,seq(limits[1],limits[2],length.out=length(pal)+1), all.inside=TRUE)]
}
} ## prepares for color gradient

### First: The plot as shown in Figure 11; exception = category 3 & 4
### note: space is not rotated as in the paper
layout(matrix(1))
squaresize<-5  ## size of the filled squares
plot(x=test_stims[,2],y=test_stims[,1], cex=squaresize,pch=0, 
     ylab="Primary Dimension (D1)", xlab="Secondary Dimension (D2)",
     ylim=c(-0.5,9.5),xlim=c(-.5,9.5))
exceptioncategory<-4  ## which category 3 or 4 want to look at?
points(x=test_stims[,2],y=test_stims[,1], cex=squaresize, pch=15,
       col=map2color(testp[,exceptioncategory],mypal, limits=c(0,1)))
## note: turn off "limits" in map2color function to see the direction of prediction
## the color gradient then is scaled to the min and max values of the predictions

## see choice percentages:
xxx<-as.character(round(testp[,exceptioncategory],2))
text(x=test_stims[,2],y=test_stims[,1], cex=1, labels=xxx, col="white")


