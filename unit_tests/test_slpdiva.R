test.slpDIVA <- function() {
    ## Test based on a Type IV Shepard et al.(1961) problem.
    load("data/test_slpdiva.RData")
    tout <- slpDIVA(st,tr)
    !sum((tout$out[,1] - cor.out)^2)
}

    
