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
           lambda = 1.0,
           dims = c(2, 2, 2),
           w = matrix(rep(0, 8), nrow = 1),
           colskip = 3)

for (cond in 1:6) {
  output[[cond]] <- slpSUSTAIN(st, nosof94sustain.ready(cond))
  print(output[[cond]], zero.print = ".")
}
