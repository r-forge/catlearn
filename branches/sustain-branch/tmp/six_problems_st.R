# Initial Parameters for SUSTAIN for Nosofsky et al. (1994) 
# as reported in Love, B.C., Medin, D.L, and Gureckis, T.M (2004) 
# SUSTAIN: A Network Model of Category Learning. 
# Psychological Review, 11, 309-332.

# It is best to use the stimulus' input pattern from the first trial in
# each condition, because I presume that is the first cluster.
# At the moment, the clusters position has to be typed in, because
# of the possible varying lengths of dimensions (NAs).

st <- list(r = 9.01245, 
             beta = 1.252233,
             d = 16.924073, 
             eta = 0.092327,
             tau = 0.0, 
             lambda = 1.0,
             cluster = array(c(0, 1, 0, 1, 1, 0, 0, 1), c(2, 4, 1)),
             dims = c(2, 2, 2),
             w = array(0, c(2, 4, 1)),
             colskip = 2)
