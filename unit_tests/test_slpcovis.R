test.slpCOVIS <- function() {
    load("test_slpcovis.RData")
    set.seed(7)
    out <- slpCOVIS(st,tr,crx = TRUE,respt = FALSE,rgive = TRUE,
                    xtdo = FALSE)
    sum((out$foutmat - testres$foutmat)^2) == 0
}


