# Unit test for slpRW
## Redundancy effect trained on two participants, with 8 weights
## frozen test trials
test.slpRW <- function() {
    load('data/test_slpRW.RData')
    st.copy <- st
    tr.copy <- tr
    out <- slpRW(st,tr)
    ## Compare output with known stored output
    out.match <- !sum((out$suma - cor.out)^2)
    ## Check the code hasn't changed the arguments
    ## (This is sometimes an issue with Rcpp)
    lr.match <- st.copy$lr == st$lr
    w.match <- !sum(!(st.copy$w == st$w))
    colskip.match <- st.copy$colskip == st$colskip
    tr.match <- !sum((tr.copy - tr)^2)
    passes <- sum(out.match + lr.match + w.match + colskip.match +
                  tr.match)
    
    if(passes == 5) {
        ret <- TRUE
    } else {
        ret <- FALSE
    }
    ret
}

## Generating code
##rm(list=ls())
##library(catlearn)

##    st <- list(lr = 0.01, w = rep(0, 5), colskip = 1) # Initial state

##    train <- matrix(c(1, 0, 0, 0, 0, 1,           # Train array
##                      1, 0, 0, 1, 0, 1,           
##                      0, 1, 0, 0, 1, 1,
##                      0, 0, 1, 0, 1, 0), 
##                    nrow = 4, ncol = 6, byrow = TRUE,
##                    dimnames = list(c(),
##                        c("A", "B", "C", "X", "Y", "t")))
##    train <- do.call(rbind, replicate(100,train,simplify = FALSE)) 
##    ctrl <- c(1,rep(0,191),rep(2,8))
##    tr <- cbind(ctrl,train)

## cor.out <- out$suma
##  save(cor.out,st,tr,file='data/test_slpRW.RData')
