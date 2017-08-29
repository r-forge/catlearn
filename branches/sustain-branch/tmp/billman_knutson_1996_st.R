# Initial Parameters for SUSTAIN for Billman and Knutson (1996) 
# as reported in Love, B.C., Medin, D.L, and Gureckis, T.M (2004) 
# SUSTAIN: A Network Model of Category Learning. 
# Psychological Review, 11, 309-332.

# It is best to use the stimulus' input pattern from the first trial in
# each condition, because I presume that is the first cluster.
# At the moment, the clusters position has to be typed in, because
# of the possible varying lengths of dimensions (NAs).

st <- list(r = 9.998779, 
           beta = 6.396300,
           d = 1.977312, 
           eta = 0.096564,
           tau = 0.5, 
           lambda = 1.0,
           cluster = array(c(1, 0, 0, 
                             1, 0, 0, 
                             1, 0, 0, 
                             1, 0, 0, 
                             1, 0, 0, 
                             1, 0, 0, 
                             1, 0, 0), 
                           c(3, 7, 1)),
           dims = rep(3, 7),
           w = array(0, c(3, 7, 1)),
           colskip = 2)
