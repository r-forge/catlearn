#Start by setting some required constants (separate script?):
r_out <- NULL # Need object for ratings output to go into
r_wm <- st$w
theta <- 0.1             # Constant required for act2probrat
beta <- 0.1              # Constant required for act2probrat

# Use act2probrat to work out ratings
ratings <- act2probrat(output$out, theta, beta)

teacher <- tr[ ,"t"]
ratmat <- cbind(ratings, teacher)
colnames(ratmat) <- c("ratings","teacher")

for(k in 1:nrow(ratmat)) {       # Run training loop
  arow <- ratmat[k, ]           # extract current trial
  lambda <- arow["teacher"]
  rat <- arow["ratings"]
  rdelta <- st$lr * (lambda - rat) # delta value for ratings
  r_wm <- r_wm + rdelta # * a # How do I represent a?
  r_out <- rbind(r_out, r_wm)  # Generates probability ratings line by line
}

ret <- list(r_out = r_out, st = r_wm) # Compiles return list

rm(r_out, ratings, ratmat, arow, lambda, r_wm, rat, rdelta, teacher, k, beta, theta)

# Returns list (rating output activations, ratings, and final state given as 
# ratings):
ret
