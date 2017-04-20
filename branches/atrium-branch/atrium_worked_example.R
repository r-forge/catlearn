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
ssxval <- ssxval[1:20,]
alpha <- c(0,0)
sweights <- list(as.matrix(cbind(NULL,c(0,0,0,0))))
lweights <- list(as.matrix(cbind(NULL,c(0,0,0,0))))
excweights <- as.matrix(cbind(c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              #,c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0),c(0,0,0,0)
                              ))
exgweights <- c(0,0,0,0,0,0,0,0,0,0
                ,0,0,0,0,0,0,0,0,0,0
                #,0,0,0,0,0,0,0,0,0,0,0,0,0,
                #0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                #0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                )
  
st <- list(1,0.03375,1.28296,1,0.32163,-1.78984,1,4.07742,0.41313,1.96593,
           2,4,1,20,3,1,rbias,rgain,ssxval,alpha,sweights,lweights,excweights,
           exgweights)
names(st) <- c('rcost','rmlr','c','ecost','emlr','gbias','ggain','cpsc','gnlr',
               'alr','stimdim','cats','mods','exmplrs','colskip','rdim','rbias',
               'rgain','ssxval','alpha','sweights','lweights',
               'excweights','exgweights')
  
tr <- ek1998train(29,-1,FALSE,1,406,0)
#tr <- ek1998train(1,-1,FALSE,1,10,0)
#trans <- ek1998trans(1,1,50,2)

outmat <-  slpATRIUM(st,tr,rgive = TRUE,xtdo = TRUE)



fmat <- as.data.frame(outmat$foutmat)
colnames(fmat) <- c('cat1','cat2','cat3','cat4','cresp','ag','error','RA','EA','MA',
                    'cstim1','cstim2','htvec1','htvec2','htvec3','htvec4','htvec5',
                    'htvec6','htvec7','htvec8','rlact','rsact','rmout1','rmout2',
                    'rmout3','rmout4','emout1','emout2','emout3','emout4','sxdist1-1',
                    'sxdist1-2','sxdist1-3','sxdist1-4','sxdist1-5','sxdist1-6','sxdist1-7',
                    'sxdist1-8','sxdist1-9','sxdist1-10','sxdist1-11','sxdist1-12','sxdist1-13',
                    'sxdist1-14','sxdist1-15','sxdist1-16','sxdist1-17','sxdist1-18','sxdist1-19',
                    'sxdist1-20','sxdist2-1','sxdist2-2','sxdist2-3','sxdist2-4','sxdist2-5',
                    'sxdist2-6','sxdist2-7','sxdist2-8','sxdist2-9','sxdist2-10','sxdist2-11',
                    'sxdist2-12','sxdist2-13','sxdist2-14','sxdist2-15','sxdist2-16','sxdist2-17',
                    'sxdist2-18','sxdist2-19','sxdist2-20','xact1','xact2','xact3','xact4',
                    'xact5','xact6','xact7','xact8','xact9','xact10','xact11','xact12',
                    'xact13','xact14','xact15','xact16','xact17','xact18','xact19','xact20',
                    'aweights1','aweights2','ecweights1-1','ecweights1-2','ecweights1-3','ecweights1-4',
                    'ecweights1-5','ecweights1-6','ecweights1-7','ecweights1-8','ecweights1-9',
                    'ecweights1-10','ecweights1-11','ecweights1-12','ecweights1-13','ecweights1-14',
                    'ecweights1-15','ecweights1-16','ecweights1-17','ecweights1-18','ecweights1-19',
                    'ecweights1-20','ecweights2-1','ecweights2-2','ecweights2-3','ecweights2-4',
                    'ecweights2-5','ecweights2-6','ecweights2-7','ecweights2-8','ecweights2-9',
                    'ecweights2-10','ecweights2-11','ecweights2-12','ecweights2-13','ecweights2-14',
                    'ecweights2-15','ecweights2-16','ecweights2-17','ecweights2-18','ecweights2-19',
                    'ecweights2-20','ecweights3-1','ecweights3-2','ecweights3-3','ecweights3-4',
                    'ecweights3-5','ecweights3-6','ecweights3-7','ecweights3-8','ecweights3-9',
                    'ecweights3-10','ecweights3-11','ecweights3-12','ecweights3-13','ecweights3-14',
                    'ecweights3-15','ecweights3-16','ecweights3-17','ecweights3-18','ecweights3-19',
                    'ecweights3-20','ecweights4-1','ecweights4-2','ecweights4-3','ecweights4-4',
                    'ecweights4-5','ecweights4-6','ecweights4-7','ecweights4-8','ecweights4-9',
                    'ecweights4-10','ecweights4-11','ecweights4-12','ecweights4-13','ecweights4-14',
                    'ecweights4-15','ecweights4-16','ecweights4-17','ecweights4-18','ecweights4-19',
                    'ecweights4-20','egweights1','egweights2','egweights3','egweights4',
                    'egweights5','egweights6','egweights7','egweights8','egweights9','egweights10',
                    'egweights11','egweights12','egweights13','egweights14','egweights15','egweights16',
                    'egweights17','egweights18','egweights19','egweights20','rlw1','rlw2','rlw3','rlw4'
                    ,'rsw1','rsw2','rsw3','rsw4')

fmat[1:2,c('ecweights1-1','ecweights1-2','ecweights1-3','ecweights1-4',
            'ecweights1-5','ecweights1-6','ecweights1-7','ecweights1-8','ecweights1-9',
            'ecweights1-10','ecweights1-11','ecweights1-12','ecweights1-13','ecweights1-14',
            'ecweights1-15','ecweights1-16','ecweights1-17','ecweights1-18','ecweights1-19',
            'ecweights1-20','ecweights2-1','ecweights2-2','ecweights2-3','ecweights2-4',
            'ecweights2-5','ecweights2-6','ecweights2-7','ecweights2-8','ecweights2-9',
            'ecweights2-10','ecweights2-11','ecweights2-12','ecweights2-13','ecweights2-14',
            'ecweights2-15','ecweights2-16','ecweights2-17','ecweights2-18','ecweights2-19',
            'ecweights2-20','ecweights3-1','ecweights3-2','ecweights3-3','ecweights3-4',
            'ecweights3-5','ecweights3-6','ecweights3-7','ecweights3-8','ecweights3-9',
            'ecweights3-10','ecweights3-11','ecweights3-12','ecweights3-13','ecweights3-14',
            'ecweights3-15','ecweights3-16','ecweights3-17','ecweights3-18','ecweights3-19',
            'ecweights3-20','ecweights4-1','ecweights4-2','ecweights4-3','ecweights4-4',
            'ecweights4-5','ecweights4-6','ecweights4-7','ecweights4-8','ecweights4-9',
            'ecweights4-10','ecweights4-11','ecweights4-12','ecweights4-13','ecweights4-14',
            'ecweights4-15','ecweights4-16','ecweights4-17','ecweights4-18','ecweights4-19',
            'ecweights4-20')]


fmat[1:20,c('rlw1','rlw2','rlw3','rlw4','cat1','cat2','cat3','cat4','cresp')]

fmat[1:20,c('rmout1','rmout2','rmout3','rmout4','emout1','emout2','emout3','emout4','cresp')]


fmat[180:200,c('rlw1','rlw2','rlw3','rlw4','cat1','cat2','cat3','cat4','cresp')]


hmx <- as.matrix(cbind(c(7.018558,3.93024805,2.90838094,1.984894,1.02360381,0.2404837,
                         1.1185324,1.9890337,1.9872861,1.1168067,0.2463273,1.02535144,
                         1.97909408,2.91012856,3.93199567,5.07497297,7.020305,7.014527,
                         6.0002293753,5.07676428),c(0.8701299,0.8701299,0.8701299,
                         0.8629149,0.8701299,0.8701299,0.8701299,0.8629149,1.4401154,
                         1.4401154,1.4401154,1.4473304,1.4473304,1.4473304,1.4473304,
                         1.4473304,1.4473304,2.03896104,2.03896104,2.03896104)))

axcalc(hmx,c(0,0),c(0,0),1.28296)

w <- as.matrix(cbind(c(0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,
                       0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,
                       0.000000e+00,0.000000e+00,0.2756072,0.2756072,0.2756072,0.2756072,
                       0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00),c(0.000000e+00,
                       0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,
                       0.000000e+00,0.000000e+00,0.2756072,0.2756072,0.2756072,0.2756072,
                       0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,
                       0.000000e+00,0.000000e+00,0.000000e+00),c(0.000000e+00,0.000000e+00,
                       0.000000e+00,0.000000e+00,0.2756072,0.2756072,0.2756072,0.2756072,
                       0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,
                       0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,
                       0.000000e+00,0.000000e+00),c(0.2756072,0.2756072,0.2756072,0.2756072,
                       0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,
                       0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,0.000000e+00,
                       0.000000e+00,0.000000e+00,0.2756072,0.2756072,0.2756072,0.2756072)))

x <- cncalc(w,c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1))


catprob(c(0,0,0,0.0020025614),c(0,0,0,5.512144),0.856907659,4.07742)


catact(lweights,sweights,cbind(0.60716240),cbind(0.39283760),4,1)
