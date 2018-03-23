# Simple script to run sustain on nosof94 shepard rep

source('nosofksy_1994_tr.R')
output <- list()

# Parameters are the same for all six problems
# First cluster is placed on the first input pattern
st <- list(r = 9.01245,
           beta = 1.252233,
           d = 16.924073,
           eta = 0.092327,
           tau = 0.0,
           lambda = c(1, 1, 1), ## AW: was lambda = 1
           dims = c(2, 2, 2),
           w = matrix(rep(0, 8), nrow = 1),
           colskip = 3)

## Run simulation
for (cond in 1:6) {
  output[[cond]] <- slpSUSTAIN(st, nosof94sustain.ready(cond))
  print(output[[cond]], zero.print = ".")
}

## Some toy code below from AW to check out some stuff
tr <- nosof94sustain.ready(1)
##out <- slpSUSTAIN(st, nosof94sustain.ready(1))
##
st$r <- 2
st$d <- 2
st$eta <- .1
lambda <- c(1,2,1)
cluster <- matrix(c(.5,.3,.5,.7,.9,.5,.1,.5,.6,.2,.4,.8,1,0,0,1),nrow=2)
w <- matrix(c(rep(0,12),.2,.1,.3,.4),nrow=2)
