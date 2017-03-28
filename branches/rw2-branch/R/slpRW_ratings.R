# Need to convert associative strengths into probability ratings.
# This should be done outside of slpRW and act2probrat.

ratings <- function(st, tr) {

 out <- NULL
 r_out <- NULL # Need object for ratings output to go into
 
 r_wm <- st$w

 nw <- length(st$w)       # Calculate number of weights in tr
 theta <- 0.1             # Constant required for act2probrat
 beta <- 0.1              # Constant required for act2probrat

 # Need to run this process as a loop:
 for(i in 1:nrow(tr)) {       # Run training loop
   arow <- tr[i, ]            # extract current trial
   if (arow['ctrl'] == 1) {   # Reset weights?
     r_wm <- st$w
   }
   lambda <- arow['t']
   a <- arow[(st$colskip + 1):(st$colskip + nw)]
   act <- sum(a*r_wm)
   rat <- act2probrat(act, theta, beta) # Runs act2probrat function
   rdelta <- st$lr * (lambda - rat) # Delta value for ratings
   if (arow['ctrl'] != 2) {   # Unless weights are frozen...
     r_wm <- r_wm + rdelta * a # ...update weights
   }
   out <- rbind(out, rat)       # Generates rating output activation line by line
   r_out <- rbind(r_out, r_wm)  # Generates probability ratings line by line
 }
 
ret <- list(out = out, r_out = r_out, st = r_wm) # Compiles return list

 # Returns list (rating output activations, ratings, and final state given as 
 # ratings):
ret
}