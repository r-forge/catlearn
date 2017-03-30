#Use this after using act2probrat to work out ratings...

r_out <- NULL # Need object for ratings output to go into
r_wm <- st$w

teacher <- tr[ ,"t"]                   # Extracts teacher column from tr matrix
ratmat <- cbind(ratings, teacher)      # Binds ratings + teacher matrices
colnames(ratmat) <- c("ratings","teacher") # Gives suitable column names

for(k in 1:nrow(ratmat)) {             # Run training loop in ratmat
  arow <- ratmat[k, ]                  # extracts current trial
  lambda <- arow["teacher"]            # Defines lambda (for own sanity)
  rat <- arow["ratings"]               # Defines ratings (for own sanity)
  rdelta <- st$lr * (lambda - rat)     # Calculates delta value for ratings
  r_wm <- r_wm + rdelta # * a          # Gives trial by trial updated ratings # How do I represent a?
  r_out <- rbind(r_out, r_wm)          # Generates probability rating output
}

ret <- list(r_out = r_out, st = r_wm)  # Compiles return list

rm(r_out, ratings, ratmat, arow, lambda, r_wm, rat, rdelta, teacher, k, 
   beta, theta)                        # Removes excess gubbins from environment

# Returns list (rating output activations, ratings, and final state given as 
# ratings):
ret

# Need to reset between participants!