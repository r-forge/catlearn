library(catlearn)
st <- list(lr = 0.05, w = 0, colskip = 1) # Set init state
train <- matrix(c(1, 1), nrow = 1, ncol = 2, byrow = TRUE, 
                dimnames = list(c(), c("A","t"))) # Create matrix
train <- do.call(rbind, replicate(28000, train, simplify = FALSE)) # Replicate
ctrl <- 0 # Create control column
tr <- cbind(ctrl, train) # Bind together
tr[1, 1] = 1 # Set first ctrl entry to 1
tr[10,1] = 1 
rm(ctrl, train) # Tidy env

outBM <- slpBM(st, tr) # Run model
head(outBM$suma,20)
tail(outBM$suma,20)
