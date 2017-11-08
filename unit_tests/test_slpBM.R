# Unit test for slpBM
# Redundancy effect trained to near asymptote
test.slpBM <- function() {
    st <- list(lr = 0.01, w = rep(0, 5), colskip = 1) # Initial state

    train <- matrix(c(1, 0, 0, 0, 0, 1,           # Train array
                      1, 0, 0, 1, 0, 1,           
                      0, 1, 0, 0, 1, 1,
                      0, 0, 1, 0, 1, 0), 
                    nrow = 4, ncol = 6, byrow = TRUE,
                    dimnames = list(c(),
                        c("A", "B", "C", "X", "Y", "t")))
    train <- do.call(rbind, replicate(1000,train,simplify = FALSE)) 
    ctrl <- 0
    train <- cbind(ctrl,train)
    out <- slpBM(st,train)
    corr <- c(1.0000000, 0.9996873, 0.0000000, 0.9998201, 0.4809313)
    sum((out$st-corr)^2) < 1e-14  # Return TRUE or FALSE
}
