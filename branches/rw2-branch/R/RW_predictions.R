# Sources functions into env:
source('R/slpRW.R')
source('R/act2probrat.R')
source('R/ssecl.R')

# Generates output:
output <- slpRW(st, tr)

# Generates ratings:
ratings <- act2probrat(output$out, theta, beta)

# Creates matrix displaying model predictions:
predictions <- cbind(tr, ratings)

# Tidy environment:
rm(theta, beta, output, ratings)
