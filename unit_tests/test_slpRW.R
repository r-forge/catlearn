test.slpRW <- function() {
    st <- list(lr = 0.01, w = rep(0, 5), colskip = 1) # Initial state

    train <- matrix(c(1, 0, 0, 0, 0, 1,           # Train array
                      1, 0, 0, 1, 0, 1,           # (Redundancy effect)
                      0, 1, 0, 0, 1, 1,
                      0, 0, 1, 0, 1, 0), 
                    nrow = 4, ncol = 6, byrow = TRUE,
                    dimnames = list(c(),
                        c("A", "B", "C", "X", "Y", "t")))
    train <- do.call(rbind, replicate(4,train,simplify = FALSE)) 
    ctrl <- 0
    train <- cbind(ctrl,train)
    out <- slpRW(st,tr)    
}
