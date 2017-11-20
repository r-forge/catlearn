# One stim design.

st <- list(lr = 0.05, w = rep(0, 1), colskip = 1) # Set init state
train <- matrix(c(1, 1), nrow = 1, ncol = 2, byrow = TRUE, 
                dimnames = list(c(), c("A","t"))) # Create matrix
train <- do.call(rbind, replicate(11000, train, simplify = FALSE)) # Replicate
ctrl <- rep(0, 11000) # Create control column
tr <- cbind(ctrl, train) # Bind together
tr[1, 1] = tr[1, 1] + 1 # Set first ctrl entry to 1
rm(ctrl, train) # Tidy env

outRW <- slpRW(st, tr) # Run model
outRW
