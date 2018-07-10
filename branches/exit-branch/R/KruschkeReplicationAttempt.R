#rm(list=ls())
#library(catlearn)


## Blocking and Attenuation
## This code generates a random sequence of trials (tr)
## following the experimental procedure as done in
## Kruschke & Blair, 2000, Experiment 1, which was
## fit using EXIT in Kruschke, 2001
KruschkeBlair2000Exp1<-function(seed){
    set.seed(seed)
    ncolumns<-17
    train1<-as.data.frame(matrix(0,ncol=ncolumns,nrow=2))
    colnames(train1)<-c("x1","x2","x3","x4","x5","x6","x7","x8","x9","x10", "t1","t2","t3","t4","t5","t6","stim")
    train1[,c("t1","t2","t3","t4","t5","t6")]<--1
    train1[1,c("x1","t1")]<-1;      train1[1,c("stim")]<-"A"
    train1[2,c("x4","t3")]<-1;      train1[2,c("stim")]<-"D"
    
    train2<-as.data.frame(matrix(0,ncol=ncolumns,nrow=3))
    colnames(train2)<-c("x1","x2","x3","x4","x5","x6","x7","x8","x9","x10", "t1","t2","t3","t4","t5","t6","stim")
    train2[,c("t1","t2","t3","t4","t5","t6")]<--1
    train2[1,c("x1","x2","t1")]<-1; train2[1,c("stim")]<-"AB"
    train2[2,c("x4","t3")]<-1;      train2[2,c("stim")]<-"D"
    train2[3,c("x8","x9","t6")]<-1; train2[3,c("stim")]<-"HI"
    
    block1<-as.data.frame(matrix(0,ncol=ncolumns,nrow=11))
    colnames(block1)<-c("x1","x2","x3","x4","x5","x6","x7","x8","x9","x10", "t1","t2","t3","t4","t5","t6","stim")
    block1[,c("t1","t2","t3","t4","t5","t6")]<--1
    block1[1,c("x1","x2")]<-1; block1[1,c("stim")]<-"AB"
    block1[2,c("x4")]<-1;      block1[2,c("stim")]<-"D"
    block1[3,c("x8","x9")]<-1; block1[3,c("stim")]<-"HI"
    block1[4,c("x2","x8")]<-1; block1[4,c("stim")]<-"BH"
    block1[5,c("x2","x9")]<-1; block1[5,c("stim")]<-"BI"
    block1[6,c("x2","x4")]<-1; block1[6,c("stim")]<-"BD"
    block1[7,c("x1","x4")]<-1; block1[7,c("stim")]<-"AD"
    block1[8,c("x1","x8")]<-1; block1[8,c("stim")]<-"AH"
    block1[9,c("x1","x9")]<-1; block1[9,c("stim")]<-"AI"
    block1[10,c("x4","x8")]<-1; block1[10,c("stim")]<-"DH"
    block1[11,c("x4","x9")]<-1; block1[11,c("stim")]<-"DI"
    
    train3<-as.data.frame(matrix(0,ncol=ncolumns,nrow=6))
    colnames(train3)<-c("x1","x2","x3","x4","x5","x6","x7","x8","x9","x10", "t1","t2","t3","t4","t5","t6","stim")
    train3[,c("t1","t2","t3","t4","t5","t6")]<--1
    train3[1,c("x1","t1")]<-1;      train3[1,c("stim")]<-"A"
    train3[2,c("x4","t3")]<-1;      train3[2,c("stim")]<-"D"
    train3[3,c("x7","t5")]<-1;      train3[3,c("stim")]<-"G"
    train3[4,c("x1","x2","x3","t2")]<-1;      train3[4,c("stim")]<-"ABC"
    train3[5,c("x4","x5","x6","t4")]<-1;      train3[5,c("stim")]<-"DEF"
    train3[6,c("x7","x8","x9","t6")]<-1;      train3[6,c("stim")]<-"GHI"
    
    block2<-as.data.frame(matrix(0,ncol=ncolumns,nrow=20))
    colnames(block2)<-c("x1","x2","x3","x4","x5","x6","x7","x8","x9","x10", "t1","t2","t3","t4","t5","t6","stim")
    block2[,c("t1","t2","t3","t4","t5","t6")]<--1
    block2[1,c("x1")]<-1;               block2[1,c("stim")]<-"A"
    block2[2,c("x1","x2","x3")]<-1;     block2[2,c("stim")]<-"ABC"
    block2[3,c("x4")]<-1;               block2[3,c("stim")]<-"D"
    block2[4,c("x4","x5","x6")]<-1;     block2[4,c("stim")]<-"DEF"
    block2[5,c("x7")]<-1;               block2[5,c("stim")]<-"G"
    block2[6,c("x7","x8","x9")]<-1;     block2[6,c("stim")]<-"GHI"
    block2[7,c("x2","x5")]<-1;          block2[7,c("stim")]<-"BE"
    block2[8,c("x2","x6")]<-1;          block2[8,c("stim")]<-"BF"
    block2[9,c("x3","x5")]<-1;          block2[9,c("stim")]<-"CE"
    block2[10,c("x3","x6")]<-1;         block2[10,c("stim")]<-"CF"
    block2[11,c("x2","x8")]<-1;         block2[11,c("stim")]<-"BH"
    block2[12,c("x2","x9")]<-1;         block2[12,c("stim")]<-"BI"
    block2[13,c("x3","x8")]<-1;         block2[13,c("stim")]<-"CH"
    block2[14,c("x3","x9")]<-1;         block2[14,c("stim")]<-"CI"
    block2[15,c("x1","x2")]<-1;         block2[15,c("stim")]<-"AB"
    block2[16,c("x1","x3")]<-1;         block2[16,c("stim")]<-"AC"
    block2[17,c("x4","x5")]<-1;         block2[17,c("stim")]<-"DE"
    block2[18,c("x4","x6")]<-1;         block2[18,c("stim")]<-"DF"
    block2[19,c("x7","x8")]<-1;         block2[19,c("stim")]<-"GH"
    block2[20,c("x7","x9")]<-1;         block2[20,c("stim")]<-"GI"
    
    ## number of trials overall
    ntrials<-20*2+20*3+1*11+15*6+1*20
    
    block_index<-c(rep("training1",20*2),rep("training2",20*3),rep("blocking",1*11),rep("training3",15*6),rep("attenuation",1*20))
    ## set up all training trials
    tr<-as.data.frame(matrix(0,ncol=ncolumns+2,nrow=ntrials))
    colnames(tr)<-c("ctrl", "x1","x2","x3","x4","x5","x6","x7","x8","x9","x10", "t1","t2","t3","t4","t5","t6","stim", "block")
    tr$block<-block_index
    ##train1
    tmp<-as.data.frame(matrix(0,ncol=ncolumns,nrow=20*2))
    for (i in 1:20)  tmp[(1:2)+(i-1)*2,]<-train1[sample(1:2,2),]
    tr[tr$block=="training1",2:(ncolumns+1)]<-tmp
    ##train2
    tmp<-as.data.frame(matrix(0,ncol=ncolumns,nrow=20*3))
    for (i in 1:20)  tmp[(1:3)+(i-1)*3,]<-train2[sample(1:3,3),]
    tr[tr$block=="training2",2:(ncolumns+1)]<-tmp
    ##test1 (blocking)
    tmp<-as.data.frame(matrix(0,ncol=ncolumns,nrow=1*11))
    for (i in 1:1)  tmp[(1:11)+(i-1)*11,]<-block1[sample(1:11,11),]
    tr[tr$block=="blocking",2:(ncolumns+1)]<-tmp
    ##train3 
    tmp<-as.data.frame(matrix(0,ncol=ncolumns,nrow=15*6))
    for (i in 1:15)  tmp[(1:6)+(i-1)*6,]<-train3[sample(1:6,6),]
    tr[tr$block=="training3",2:(ncolumns+1)]<-tmp
    ##test2 
    tmp<-as.data.frame(matrix(0,ncol=ncolumns,nrow=1*20))
    for (i in 1:1)  tmp[(1:20)+(i-1)*20,]<-block2[sample(1:20,20),]
    tr[tr$block=="attenuation",2:(ncolumns+1)]<-tmp
    
    ## set ctrl values
    tr$ctrl<-0
    tr$ctrl[1]<-1
    tr$ctrl[tr$block=="blocking"]<-2
    tr$ctrl[tr$block=="attenuation"]<-2
    ## enable the bias cue
    tr$x10<-1
    
    
    exemplars<-
        rbind(train1[train1[,"stim"]=="A",1:9],
              train1[train1[,"stim"]=="D",1:9],
              train3[train3[,"stim"]=="G",1:9],
              train2[train2[,"stim"]=="AB",1:9],
              train2[train2[,"stim"]=="HI",1:9],
              train3[train3[,"stim"]=="ABC",1:9],
              train3[train3[,"stim"]=="DEF",1:9],
              train3[train3[,"stim"]=="GHI",1:9])
    exemplars[,"x10"]<-0
    exemplars<-rbind(exemplars,c(0,0,0,0,0,0,0,0,0,1))
    rownames(exemplars)<-c("A","D","G","AB","HI","ABC","DEF","GHI","bias")
    return(list(tr=tr,exemplars=exemplars))
}
se<-round(runif(1,1,10000))
tr<-KruschkeBlair2000Exp1(seed=7777)$tr
exemplars<-KruschkeBlair2000Exp1(seed=se)$exemplars

source("slpEXITrs.R")
## best fit values for EXIT with attention shifting 
## as reported in Kruschke, 2001 
st<-list(nFeat=9+1,# +bias cue 
         nCat=6, 
         phi=4.43, 
         c=.348, 
         P=1.07,
         l_gain=1.27, 
         l_weight=.316,
         l_ex=.0121, 
         iterations=10,
         sigma=c(rep(1,9),0))
st$exemplars<-exemplars[1:8,]
st$w_exemplars<-st$exemplars
st$w_exemplars[]<-0
st$w_in_out<-matrix(0,st$nCat,st$nFeat)

nrow(tr)
predictions<-as.data.frame(matrix(NA,ncol=8,nrow=nrow(tr)))
colnames(predictions)<-c("block","stim","t1","t2","t3","t4","t5","t6")
predictions$stim<-tr$stim;predictions$block<-tr$block
predictions[,c("t1","t2","t3","t4","t5","t6")]<-
    round(slp_EXITrs(st,tr, xtdo=F)$response_probabilities,3)

## The Kruschke Table (Kruschke & Blair,2000)
## Human Data
# Symp	1	    2	    3   	4   	5   	6
# BH/BI	15	    6.3	    3.8	    6.3	    10	    58.8
# AB	81.3	3.8	    3.8	    3.8	    5	    2.5
# D 	2.5	    0	    96.3	1.3	    0   	0
# HI	1.3	    0	    0	    1.3	    2.5	    95
# BD	15	    3.8	    66.3	6.3	    2.5	    6.3
# AD	42.5	13.8	30	    2.5	    11.3	0
# AH/AI	65	    1.3	    1.3	    5	    3.8	    23.8
# DH/DI	2.5	    6.3	    43.8	5	    10	    32.5

### Corresponding Model Predictions
# BH/BI	6.60	6.50	6.50	6.50	6.50	67.40
# AB	80.30	3.90	3.90	3.90	3.90	3.90
# D	    1.10	1.10	94.40	1.10	1.10	1.10
# HI	1.20	1.20	1.20	1.20	1.20	93.80
# BD	5.80	5.70	71.20	5.70	5.70	5.70
# AH/AI	54.10	3.90	3.90	3.90	3.90	30.20
# AD	52.00	3.70	33.10	3.70	3.70	3.70
# DH/DI	4.40	4.40	44.40	4.40	4.40	38.10

stims<-predictions[predictions$block=="blocking",][1:11,2]
if (T){
pdevs<-cbind(c("BH/BI","AH/AI","DH/DI","D","AB","HI", "BD","AD"),
      round(rbind(
(colMeans(predictions[predictions$block=="blocking" & 
                predictions$stim %in% c("BH","BI"),][,3:8])-
        c(6.60,	6.50,	6.50,	6.50,	6.50,	67.40)/100),
(colMeans(predictions[predictions$block=="blocking" & 
                          predictions$stim %in% c("AH","AI"),][,3:8])-
        c(54.10,	3.90,	3.90,	3.90,	3.90,	30.20)/100),
(colMeans(predictions[predictions$block=="blocking" & 
                          predictions$stim %in% c("DH","DI"),][,3:8])-
        c(4.40,	4.40,	44.40,	4.40,	4.40,	38.10)/100),
(predictions[predictions$block=="blocking" & 
                predictions$stim %in% c("D"),][,3:8]-
    c(1.10,	1.10,	94.40,	1.10,	1.10,	1.10)/100),
(predictions[predictions$block=="blocking" & 
                 predictions$stim %in% c("AB"),][,3:8]-
     c(80.30,	3.90,	3.90,	3.90,	3.90,	3.90)/100),
(predictions[predictions$block=="blocking" & 
                 predictions$stim %in% c("HI"),][,3:8]-
     c(1.20,	1.20,	1.20,	1.20,	1.20,	93.80)/100),
(predictions[predictions$block=="blocking" & 
                 predictions$stim %in% c("BD"),][,3:8]-
     c(	5.80,	5.70,	71.20,	5.70,	5.70,	5.70)/100),
(predictions[predictions$block=="blocking" & 
                 predictions$stim %in% c("AD"),][,3:8]-
     c(	52.00,	3.70,	33.10,	3.70,	3.70,	3.70)/100)
),
4)*100)
}
colnames(pdevs)<-c("stim","t1","t2","t3","t4","t5","t6")
pdevs

## And the current slpEXIT predictions
## blocking overall
## please note the order of symptoms differs % percent is in decimals
#predictions[predictions$block=="blocking",] [1:11,2:8]
## notes: everything looks like the altered category output 
## and the altered alpha values in the 10 iterations are taken to subsequent 
## equations. Only this way the slp predictions approximate the reported ones.
## see also the other replication attempt


##Attenuation
## Human Data
# BE/BF	2.50	22.50	2.50	58.10	3.10	11.30
# A	    94.40	1.30	1.30	1.30	0.60	1.30
# ABC	13.80	72.50	0.60	4.70	2.50	5.00
# D	    3.10	0.60	93.80	1.30	0.00	1.30
# DEF	1.30	5.00	12.50	72.50	2.50	6.30
# G	    0.60	0.00	1.90	0.60	95.60	1.30
# GHI	1.30	6.30	2.50	5.60	6.90	77.50
# CE/CF	1.30	39.40	5.00	42.50	3.10	8.80
# BH/BI	1.30	21.90	0.60	6.30	3.80	66.30
# CH/CI	1.90	48.80	1.90	3.10	5.00	39.40
# AB	56.90	27.50	3.10	4.40	0.60	7.50
# AC	34.40	56.30	1.30	1.30	3.10	3.80
# DE/DF	1.30	6.30	31.30	51.90	3.10	6.30
# GH/GI	0.60	4.40	3.80	3.80	34.40	53.10

## Reported Model Predictions
# BE/BF	5.40	26.80	5.40	51.50	5.40	5.40
# A	    94.40	1.10	1.10	1.10	1.10	1.10
# ABC	13.70	72.40	3.50	3.50	3.50	3.50
# D	    1.10	1.10	94.40	1.10	1.10	1.10
# DEF	3.30	3.30	12.40	74.20	3.30	3.30
# G	    1.10	1.10	1.10	1.10	94.30	1.10
# GHI	2.60	2.60	2.60	2.60	8.10	81.40
# CE/CF	4.40	47.80	4.40	34.50	4.40	4.40
# BH/BI	4.80	23.40	4.80	4.80	4.30	57.90
# CH/CI	4.10	44.30	4.10	4.10	3.80	39.60
# AB	53.30	26.90	4.90	4.90	4.90	4.90
# AC	28.60	55.80	3.90	3.90	3.90	3.90
# DE/DF	4.50	4.50	34.40	47.40	4.50	4.50
# GH/GI	4.20	4.20	4.20	4.20	27.80	55.50


## slpExit predictions
## please note order of symptoms differs; and % in decimals
#predictions[predictions$block=="attenuation",2:8]

if (T){
    pdevs<-cbind(c("BE/BF","CE/CF","BH/BI","CH/CI","DE/DF",
                   "GH/GI", "A","D","G","AB","AC","ABC","DEF","GHI"),
             round(rbind(
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                    predictions$stim %in% c("BE","BF"),][,3:8])-
                          c(5.40,	26.80,	5.40,	51.50,	5.40,	5.40)/100),
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                    predictions$stim %in% c("CE","CF"),][,3:8])-
                          c(4.40,	47.80,	4.40,	34.50,	4.40,	4.40)/100),
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                    predictions$stim %in% c("BH","BI"),][,3:8])-
                          c(4.80,	23.40,	4.80,	4.80,	4.30,	57.90)/100),
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                    predictions$stim %in% c("CH","CI"),][,3:8])-
                          c(4.10,	44.30,	4.10,	4.10,	3.80,	39.60)/100),
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                 predictions$stim %in% c("DE","DF"),][,3:8])-
                          c(4.50,	4.50,	34.40,	47.40,	4.50,	4.50)/100),
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                predictions$stim %in% c("GH","GI"),][,3:8])-
                          c(4.20,	4.20,	4.20,	4.20,	27.80,	55.50)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("A"),][,3:8]-
                          c(94.40,	1.10,	1.10,	1.10,	1.10,	1.10)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("D"),][,3:8]-
                          c(1.10,	1.10,	94.40,	1.10,	1.10,	1.10)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("G"),][,3:8]-
                          c(1.10,	1.10,	1.10,	1.10,	94.30,	1.10)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("AB"),][,3:8]-
                          c(53.30,	26.90,	4.90,	4.90,	4.90,	4.90)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("AC"),][,3:8]-
                          c(28.60,	55.80,	3.90,	3.90,	3.90,	3.90)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("ABC"),][,3:8]-
                          c(13.70,	72.40,	3.50,	3.50,	3.50,	3.50)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("DEF"),][,3:8]-
                          c(3.30,	3.30,	12.40,	74.20,	3.30,	3.30)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("GHI"),][,3:8]-
                             c(2.60,	2.60,	2.60,	2.60,	8.10,81.40)/100)
                 ),
                 4)*100)
}
colnames(pdevs)<-c("stim","t1","t2","t3","t4","t5","t6")
pdevs


#####################################################

## best fit values for EXIT WITHOUT attention shifting 
## as reported in Kruschke, 2001 
st<-list(nFeat=9+1,# +bias cue 
         nCat=6, 
         phi=4.35, 
         c=.348, 
         P=1.16,
         l_gain=0, 
         l_weight=.186,
         l_ex=0, 
         iterations=10,
         sigma=c(rep(1,9),0))
st$exemplars<-exemplars
st$w_exemplars<-st$exemplars
st$w_exemplars[]<-0
st$w_in_out<-matrix(0,st$nCat,st$nFeat)


nrow(tr)
predictions<-as.data.frame(matrix(NA,ncol=8,nrow=nrow(tr)))
colnames(predictions)<-c("block","stim","t1","t2","t3","t4","t5","t6")
predictions$stim<-tr$stim;predictions$block<-tr$block
predictions[,c("t1","t2","t3","t4","t5","t6")]<-
    round(slp_EXITrs(st,tr, xtdo=F)$response_probabilities,3)


## blocking (see figure 2 in Kruschke, 2001,
##Model predictions
# BH/BI	18.10	7.30	7.30	7.30	7.30	52.70	
# AB	92.80	1.40	1.40	1.40	1.40	1.40
# D	    1.20	1.20	93.90	1.20	1.20	1.20
# HI	1.80	1.80	1.80	1.80	1.80	91.20
# BD	14.20	5.70	62.80	5.70	5.70	5.70
# AH/AI	69.90	2.70	2.70	2.70	2.70	19.30
# AD	63.50	2.40	26.70	2.40	2.40	2.40
# DH/DI	4.50	4.50	49.40	4.50	4.50	32.50

## slpExit here
stims<-predictions[predictions$block=="blocking",][1:11,2]
if (T){
    pdevs<-cbind(c("BH/BI","AH/AI","DH/DI","D","AB","HI", "BD","AD"),
                 round(rbind(
                     (colMeans(predictions[predictions$block=="blocking" & 
                                               predictions$stim %in% c("BH","BI"),][,3:8])-
                          c(18.10,	7.30,	7.30,	7.30,	7.30,	52.70)/100),
                     (colMeans(predictions[predictions$block=="blocking" & 
                                               predictions$stim %in% c("AH","AI"),][,3:8])-
                          c(69.90,	2.70,	2.70,	2.70,	2.70,	19.30)/100),
                     (colMeans(predictions[predictions$block=="blocking" & 
                                               predictions$stim %in% c("DH","DI"),][,3:8])-
                          c(4.50,	4.50,	49.40,	4.50,	4.50,	32.50)/100),
                     (predictions[predictions$block=="blocking" & 
                                      predictions$stim %in% c("D"),][,3:8]-
                          c(1.20,	1.20,	93.90,	1.20,	1.20,	1.20)/100),
                     (predictions[predictions$block=="blocking" & 
                                      predictions$stim %in% c("AB"),][,3:8]-
                          c(92.80,	1.40,	1.40,	1.40,	1.40,	1.40)/100),
                     (predictions[predictions$block=="blocking" & 
                                      predictions$stim %in% c("HI"),][,3:8]-
                          c(1.80,	1.80,	1.80,	1.80,	1.80,	91.20)/100),
                     (predictions[predictions$block=="blocking" & 
                                      predictions$stim %in% c("BD"),][,3:8]-
                          c(14.20,	5.70,	62.80,	5.70,	5.70,	5.70)/100),
                     (predictions[predictions$block=="blocking" & 
                                      predictions$stim %in% c("AD"),][,3:8]-
                          c(63.50,	2.40,	26.70,	2.40,	2.40,	2.40)/100)
                 ),
                 4)*100)
}
colnames(pdevs)<-c("stim","t1","t2","t3","t4","t5","t6")
pdevs
## perfect... (note 1=1% 100=100%)
## Note: So if the small deviations with attention learning are meaningful
## deviations, they are tied to the equations with
## l_gain and l_ex


##(non-existent) attenuation
## Model predictions
# BE/BF	6.70	37.70	3.70	37.70	7.10	7.10
# A	    90.00	3.50	1.60	1.60	1.60	1.60
# ABC	11.30	69.30	4.80	4.80	4.80	4.80
# D	    1.60	1.60	90.30	3.40	1.60	1.60
# DEF	4.90	4.90	9.50	70.70	4.90	4.90
# G	    1.90	1.90	1.90	1.90	89.80	2.50
# GHI	2.10	2.10	2.10	2.10	4.60	87.10
# CE/CF	2.80	39.30	3.80	39.30	7.40	7.40
# BH/BI	4.30	24.20	4.50	4.50	2.80	59.60
# CH/CI	1.80	24.90	4.70	4.70	2.90	61.20
# AB	41.70	39.10	4.80	4.80	4.80	4.80
# AC	22.40	52.00	6.40	6.40	6.40	6.40
# DE/DF	5.90	5.90	28.50	47.90	5.90	5.90
# GH/GI	4.10	4.10	4.10	4.10	20.90	62.70

## slpExit here
if (T){
    pdevs<-cbind(c("BE/BF","CE/CF","BH/BI","CH/CI","DE/DF",
                   "GH/GI", "A","D","G","AB","AC","ABC","DEF","GHI"),
                 round(rbind(
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                               predictions$stim %in% c("BE","BF"),][,3:8])-
                          c(6.70,	37.70,	3.70,	37.70,	7.10,	7.10)/100),
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                               predictions$stim %in% c("CE","CF"),][,3:8])-
                          c(2.80,	39.30,	3.80,	39.30,	7.40,	7.40)/100),
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                               predictions$stim %in% c("BH","BI"),][,3:8])-
                          c(4.30,	24.20,	4.50,	4.50,	2.80,	59.60)/100),
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                               predictions$stim %in% c("CH","CI"),][,3:8])-
                          c(1.80,	24.90,	4.70,	4.70,	2.90,	61.20)/100),
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                               predictions$stim %in% c("DE","DF"),][,3:8])-
                          c(5.90,	5.90,	28.50,	47.90,	5.90,	5.90)/100),
                     (colMeans(predictions[predictions$block=="attenuation" & 
                                               predictions$stim %in% c("GH","GI"),][,3:8])-
                          c(4.10,	4.10,	4.10,	4.10,	20.90,	62.70)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("A"),][,3:8]-
                          c(90.00,	3.50,	1.60,	1.60,	1.60,	1.60)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("D"),][,3:8]-
                          c(1.60,	1.60,	90.30,	3.40,	1.60,	1.60)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("G"),][,3:8]-
                          c(1.90,	1.90,	1.90,	1.90,	89.80,	2.50)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("AB"),][,3:8]-
                          c(41.70,	39.10,	4.80,	4.80,	4.80,	4.80)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("AC"),][,3:8]-
                          c(22.40,	52.00,	6.40,	6.40,	6.40,	6.40)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("ABC"),][,3:8]-
                          c(11.30,	69.30,	4.80,	4.80,	4.80,	4.80)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("DEF"),][,3:8]-
                          c(4.90,	4.90,	9.50,	70.70,	4.90,	4.90)/100),
                     (predictions[predictions$block=="attenuation" & 
                                      predictions$stim %in% c("GHI"),][,3:8]-
                          c(2.10,	2.10,	2.10,	2.10,	4.60,	87.10)/100)
                 ),
                 4)*100)
}
colnames(pdevs)<-c("stim","t1","t2","t3","t4","t5","t6")
pdevs
### alright perfect again all deviations < 0.3%

