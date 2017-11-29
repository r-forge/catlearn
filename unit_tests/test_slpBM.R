# Unit test for slpBM
## Redundancy effect trained on two participants, with 8 weights
## frozen test trials
test.slpBM <- function() {
    load('data/test_slpBM.RData')
    st.copy <- st
    tr.copy <- tr
    out <- slpBM(st,tr)
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
## (st and tr were taken from slpRW)
## rm(list=ls())
## library(catlearn)
## cor.out <- out$suma
## save(cor.out,st,tr,file='data/test_slpBM.RData')
