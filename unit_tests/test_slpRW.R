# Unit test for slpRW
# Redundancy effect trained to near asymptote
test.slpRW <- function() {
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
    out <- slpRW(st,train)
    corr <- c(0.994065062,
              0.666646152,
              -0.333312922,
              0.009533391,
              0.333333230)
    sum((out$st-corr)^2) < 1e-18  # Return TRUE or FALSE
}
