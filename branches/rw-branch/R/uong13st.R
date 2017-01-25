
# ST ###

# We need to set values for the initial state of the model,
# including the constants which we be used by slpRW.

# Alpha is salience of stimuli, beta is learnng rate
# parameter, lambda is asymptote of learning, w is a vector
# of associative strengths for each stimulus (with initial
# weights of zero):


st <- list(alpha = 0.25, beta = 0.25, w = rep(0,5), 
           colskip = 4)

print(st)


# Link st to slpRW so model can read the input:
source("src/slpRW.R")