## Inverse Base Rate Effect
## Attempt to replicate Kruschke (2001) simulation of Kruschke (1996),
## Experiment 1
rm(list=ls())
#setwd("/Users/renschl/Desktop/R Projects/EXIT/R")
library(tidyr)
library(dplyr)
source("slpEXITrs.R")
source("krus96train.R")

## Training array from krus96train function

## 56 subjects because this is the closest we can get to Kruschke's
## simulations, which he reports as using "the same stim-
## ulus/feedback sequences as the human participants who gen- erated
## the data". Kruschke (1996) Experiment 1 had 56 participants, none
## of whom were excluded.

### Note: 
### with seed 7777 there are only 3 percentage deviations above 1%
### with seed 8888 there are only 2 percentage deviations above 1%
### with seed 5555 there are      8 percentage deviations above 1%
tr <- krus96train(subj = 56, seed = 8888)
#tr <- krus96train(subj = 1, seed = round(runif(1,1,1000)))

## Parameters from Kruschke (2001; see Appendix)
st <- list(nFeat = 6+1, nCat = 4,
           phi = 4.42, c = 2.87, P = 2.48,
           l_gain = 4.42, l_weight = .222, l_ex = 1.13,
           sigma = c(rep(1,6),.401), 
           iterations = 10)

## note - an additional column =0 indicates absence of bias 
exemplars <- rbind(c(1,1,0,0,0,0,0),
                   c(1,0,1,0,0,0,0),
                   c(0,0,0,1,1,0,0),
                   c(0,0,0,1,0,1,0)) ## bias "cue"/exemplar
## using an extra bias exemplar instead makes no difference, which makes sense.
# exemplars <- rbind(c(1,1,0,0,0,0,0),
#                    c(1,0,1,0,0,0,0),
#                    c(0,0,0,1,1,0,0),
#                    c(0,0,0,1,0,1,0),
#                    c(0,0,0,0,0,0,1)) ## bias "cue"/exemplar


st$exemplars <- exemplars
st$w_exemplars <- exemplars
st$w_exemplars[] <- 0
st$w_in_out <- matrix(0, st$nCat, st$nFeat)

## Run simulation
predics <- slp_EXITrs(st,tr,xtdo=F)$response_probabilities
colnames(predics) <- c("C1", "R1", "C2", "R2")
out.all <- cbind(tr[tr[,"ctrl"]==2,],predics[tr[,"ctrl"]==2,])

## Reduce and aggregate results to compare with Kruschke's simulation.
out <- out.all[out.all$block == 16,]

out.ag.C1 <- aggregate(out$C1, list(out$stim), mean)
colnames(out.ag.C1) <- c("stim", "C1")

out.ag.R1 <- aggregate(out$R1, list(out$stim), mean)
colnames(out.ag.R1) <- c("stim", "R1")

out.ag.C2 <- aggregate(out$C2, list(out$stim), mean)
colnames(out.ag.C2) <- c("stim", "C2")

out.ag.R2 <- aggregate(out$R2, list(out$stim), mean)
colnames(out.ag.R2) <- c("stim", "R2")

out.ag <- cbind(out.ag.C1, out.ag.R1[,2], out.ag.C2[,2],
                    out.ag.R2[,2])

colnames(out.ag) <- c("stim", "C1", "R1", "C2", "R2")

## Abstract stimulus code
out.ag$abstim[out.ag$stim %in% c("I1", "I2")] <- "I"
out.ag$abstim[out.ag$stim %in% c("PC1", "PC2")] <- "PC"
out.ag$abstim[out.ag$stim %in% c("PR1", "PR2")] <- "PR"
out.ag$abstim[out.ag$stim %in% c("PC1.PR1", "PC2.PR2")] <- "PC.PR"
out.ag$abstim[out.ag$stim %in% c("I1.PC1.PR1", "I2.PC2.PR2")] <- "I.PC.PR"
out.ag$abstim[out.ag$stim %in% c("I1.PC2", "I2.PC1")] <- "I.PCo"
out.ag$abstim[out.ag$stim %in% c("I1.PR2", "I2.PR1")] <- "I.PRo"
out.ag$abstim[out.ag$stim %in% c("PC1.PR2", "PC2.PR1")] <- "PC.PRo"
out.ag$abstim[out.ag$stim %in% c("I1.PC1.PR2", "I2.PC2.PR1")] <- "I.PC.PRo"

## Abstract response code
set1 <- c("I1", "PC1", "PR1", "PC1.PR1", "I1.PC1.PR1", "I1.PC2",
          "I1.PR2", "PC1.PR2", "I1.PC1.PR2")

set2 <- c("I2", "PC2", "PR2", "PC2.PR2", "I2.PC2.PR2", "I2.PC1",
          "I2.PR1", "PC2.PR1", "I2.PC2.PR1")
 
out.ag$C[out.ag$stim %in% set1] <- out.ag$C1[out.ag$stim %in% set1]
out.ag$R[out.ag$stim %in% set1] <- out.ag$R1[out.ag$stim %in% set1]
out.ag$Co[out.ag$stim %in% set1] <- out.ag$C2[out.ag$stim %in% set1]
out.ag$Ro[out.ag$stim %in% set1] <- out.ag$R2[out.ag$stim %in% set1]

out.ag$C[out.ag$stim %in% set2] <- out.ag$C2[out.ag$stim %in% set2]
out.ag$R[out.ag$stim %in% set2] <- out.ag$R2[out.ag$stim %in% set2]
out.ag$Co[out.ag$stim %in% set2] <- out.ag$C1[out.ag$stim %in% set2]
out.ag$Ro[out.ag$stim %in% set2] <- out.ag$R1[out.ag$stim %in% set2]

## Aggregate across abstract stim type

out.ag.C <- aggregate(out.ag$C, list(out.ag$abstim), mean)
colnames(out.ag.C) <- c("abstim", "C")

out.ag.R <- aggregate(out.ag$R, list(out.ag$abstim), mean)
colnames(out.ag.R) <- c("abstim", "R")

out.ag.Co <- aggregate(out.ag$Co, list(out.ag$abstim), mean)
colnames(out.ag.Co) <- c("abstim", "Co")

out.ag.Ro <- aggregate(out.ag$Ro, list(out.ag$abstim), mean)
colnames(out.ag.Ro) <- c("abstim", "Ro")

out.ag.abs <- cbind(out.ag.C, out.ag.R[,2], out.ag.Co[,2],
                    out.ag.Ro[,2])

colnames(out.ag.abs) <- c("symptom", "C", "R", "Co", "Ro")

## Convert to long format, and order as per Kruschke 1996
stimorder <- c("I", "PC", "PR", "PC.PR", "I.PC.PR", "I.PCo", "I.PRo",
               "PC.PRo", "I.PC.PRo")

disorder <- c("C", "R", "Co", "Ro")

longun <- gather(out.ag.abs, key = "disease", value = "prop", 2:5)
longun <- arrange(longun, match(symptom, stimorder), match(disease, disorder))

## Load Kruschke's sim results (2001)
krus.sim <- read.csv("../krus96_sim_krus01.csv", stringsAsFactors = FALSE)

comp <- merge(krus.sim, longun)
comp$diff <- round(comp$kprop- comp$prop, 2)

print(comp[abs(comp$diff) > .01,])
nrow(comp[abs(comp$diff) > .01,])

print(comp)
