slpRW <- function(st, tr, xtdo = FALSE) {
    out <- NULL; xout <- NULL      # Initialize variables
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
        if (arow['ctrl'] != 2) {   # Unless weights are frozen...
            w.m <- w.m + delta * a # ...update weights
        }
        out <- rbind(out, suma)    # Record output activation
        if(xtdo == TRUE) {         # Record weights (if xtdo)
            xout <- rbind(xout, w.m)
        }
    }
    if(xtdo==TRUE) {               # Return appropriate list
        ret <- list(out = out, st = w.m, xout = xout)
    } else {
        ret <- list(out = out, st = w.m)
    }
    ret
}
