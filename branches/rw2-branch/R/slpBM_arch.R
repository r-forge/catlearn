slpBM <- function(st, tr, xtdo = FALSE) {
    out <- NULL; xout <- NULL     # Initialize variables
    w.m <- st$w                   # Initialize weights
    for (i in 1:nrow(tr)) {       # Run training loop
      arow <- tr[i, ]             # Extract current trial
      if (arow['ctrl'] == 1) {    # Reset weight at each participants
        w.m <- st$w
      }
      lambda <- arow['t']         # Extract teaching signal
      a <- arow[(st$colskip + 1):(st$colskip + length(w.m))]   # Extract inputs
      delta <- st$lr * (lambda - a*w.m)  # Calculate change in assoc strength
      if (arow['ctrl'] != 2) {           # Unless weights are frozen...
      w.m <- w.m + delta * a             # ...update weights
        }
      out <- rbind(out, sum(a*w.m))      # Record output (uses summed error value
                                                # even though delta is seperable)
      if (xtdo==TRUE) {                  # If xtdo = TRUE, record weights
      xout <- rbind(xout, w.m)
        }
      }
    if(xtdo==TRUE) {                           # Return appropriate list
      ret <- list(out = out, xout = xout, st = w.m)
    } else {
      ret <- list(out = out, st = w.m)
    }
   ret
}
