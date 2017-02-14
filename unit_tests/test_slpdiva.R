test.slpDIVA <- function() {
    # Test based on a Type IV Shepard et al.(1961) problem.
    load("test_slpdiva.RData")
    tout <- slpDIVA(st,tr)
    sum((out$out - tout$out)^2) == 0
}

    
