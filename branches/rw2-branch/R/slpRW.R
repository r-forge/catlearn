slpRW <- function(st, tr, xtdo = FALSE, ratings = FALSE) {
    out <- NULL; xout <- NULL; rout <- NULL      # Initialize variables
    w.m <- st$w                    # Initialize weights
    nw <- length(w.m)              # Calculate number of weights    
    for(i in 1:nrow(tr)) {         # Run training loop
        arow <- tr[i, ]            # extract current trial
        if (arow['ctrl'] == 1) {   # Reset weights?
            w.m <- st$w
        }
        lambda <- arow['t']        # extract teaching signal
        a <- arow[(st$colskip + 1):(st$colskip + nw)]   # extract inputs
        suma <- sum(a*w.m)         # Calculate sum of act * weights
        delta <- st$lr * (lambda - suma)   # Calculte error term
          act <- suma              # Allows suma to be read by act2probrat
          theta <- 0.1             # Constant required for act2probrat
          beta <- 0.1              # Constant required for act2probrat
          rat <- act2probrat(act, theta, beta) # Runs act2probrat function
          rdelta <- st$lr * (lambda - rat) # Delta value for ratings
        if (arow['ctrl'] != 2) {   # Unless weights are frozen...
            w.m <- w.m + delta * a # ...update weights
            r.w.m <- w.m + rdelta * a # ...update ratings
        }
        out <- rbind(out, suma)    # Record output activation
        if(xtdo == TRUE) {         # Record weights (if xtdo)
            xout <- rbind(xout, w.m)
        }
        if(ratings == TRUE) {      # Record probability ratings if true
            rout <- rbind(rout, r.w.m)
        }
    }
    if(xtdo==TRUE) {               # Return appropriate list
        ret <- list(out = out, st = w.m, xout = xout)
    } else if (ratings==TRUE) {
        ret <- list(out = out, st = w.m, rout = rout)
    } else if (xtdo==TRUE & ratings==TRUE) {
      ret <- list(out = out, st = w.m, xout = xout, rout = rout)
    } else {
        ret <- list(out = out, st = w.m)
    }
    ret
}
