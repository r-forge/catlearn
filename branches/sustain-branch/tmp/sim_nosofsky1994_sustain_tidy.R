# Simple script to run sustain on nosof94 shepard rep
source('../R/slpSUSTAIN-tidy.R')
source('nosofksy_1994_tr.R')

# Parameters are the same for all six problems
st <- list(r = 9.01245,
           beta = 1.252233,
           d = 16.924073,
           eta = 0.092327,
           tau = 0.0,
           lambda = c(1, 1, 1),
           dims = c(2, 2, 2),
           w = matrix(rep(0, 8), nrow = 1),
           colskip = 2)

## Run simulation
#for (cond in 1:6) {
#  output[[cond]] <- slpSUSTAIN(st, nosof94sustain.ready(cond))
#  print(output[[cond]], zero.print = ".")
#}

tr <- nosof94sustain.ready(1)


#####
out <- slpSUSTAIN(st, nosof94sustain.ready(1), xtdo = FALSE)


