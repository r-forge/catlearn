## Simple script to run sustain on nosof94 shepard rep
source('../R/slpSUSTAIN-tidy.R')
## nosof94train Version in this branch is newer than on trunk, so load
source('../R/nosof94train.R') 

## Parameters are the same for all six problems
st <- list(r = 9.01245,
           beta = 1.252233,
           d = 16.924073,
           eta = 0.092327,
           tau = 0.0,
           lambda = c(1, 1, 1),
           dims = c(2, 2, 2),
           cluster = NA,
           w = NA,
           colskip = 4)


tr <- nosof94train(cond = 2, blocks = 32, missing = 'pad', absval = 0,
                   blkstyle = 'eights')

out <- slpSUSTAIN(st, tr, xtdo = FALSE)
out


#### Code for checking stateful aspect of function.
st <- list(r = 9.01245,
           beta = 1.252233,
           d = 16.924073,
           eta = 0.092327,
           tau = 0.0,
           lambda = out$lambda,
           dims = c(2, 2, 2),
           cluster = out$cluster,
           w = out$w,
           colskip = 4)

out2 <- slpSUSTAIN(st, tr.me, xtdo = FALSE)
out2
#######

