## Test of slpMBMF
source('slpMBMF.R')
## Define state list
st <- list(alpha = .3, w = 0, tprob  = rbind(c(.7,.3),c(.3,.7)),
           q1.mf = c(.5, .5), q1.mb = c(.5, .5), q2 = c(.5, .5))
## Load training array
tr <- as.matrix(read.csv("tr.csv", header = TRUE,
                         stringsAsFactors = FALSE))
## Run model
out <- slpMBMF(st,tr)
## Compare to output from Tom's code
load('test_slpMBMF.RData')
if(!sum((out$out[,1] - tom.out)^2)) print("Matches output of Tom's code.")







