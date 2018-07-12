## Inverse Base Rate Effect
## Replication of Kruschke (2001) simulation of Kruschke (1996, Exp. 1)
rm(list=ls())
source("slpEXIT.R")
source("krus96train.R")
source("krus96exit.R")
out <- krus96exit()

## Load Kruschke's sim results (2001) and compare.
krus.sim <- read.csv("../krus96_sim_krus01.csv", stringsAsFactors = FALSE)

comp <- merge(krus.sim, out)
comp$diff <- round(comp$kprop- comp$prop, 2)
print(comp)


#####################

## Training array from krus96train function

## 56 subjects because this is the closest we can get to Kruschke's
## simulations, which he reports as using "the same stim-
## ulus/feedback sequences as the human participants who gen- erated
## the data". Kruschke (1996) Experiment 1 had 56 participants, none
## of whom were excluded.

### Note: 
### with seed 7777 there are only 3 percentage deviations above 1%
### with seed 8888,2,1 there are only 2 percentage deviations above 1%
### with seed 5555 there are      8 percentage deviations above 1%

## AW: This is just a randomization issue. If you run 500 participants with seed 555
## there are no deviations above .01. So, it would seem Kruschke got
## lucky with the 56 sequences he used, in the sense that they were
## particularly representative. Of course, he'd also argue that these
## were the right 56 to use because that's what the participants
## got... Either way, we can emulate that success using 56 subjects
## and a seed of 1


