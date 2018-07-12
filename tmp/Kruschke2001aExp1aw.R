## Inverse Base Rate Effect
## Replication of Kruschke (2001) simulation of Kruschke (1996, Exp. 1)
rm(list=ls())
library(catlearn)
out <- krus96exit()

## Load Kruschke's sim results (2001) and compare.
krus.sim <- read.csv("krus96_sim_krus01.csv", stringsAsFactors = FALSE)

comp <- merge(krus.sim, out)
comp$diff <- round(comp$kprop- comp$prop, 2)
print(comp)

