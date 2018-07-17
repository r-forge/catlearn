## ALCOVE unit test, based on size 3 condition of shin92 CIRP
context("slpALCOVE")
library(catlearn)

test.slpALCOVE <- function() {

    load("../data/test_slpalcove.RData")
    tout <- slpALCOVE(st,tr)
    !sum((tout$prob[,1] - cor.out)^2)
    
    }

test_that("slpALCOVE reproduces shin92 CIRP, size 3 condition.", {
    expect_true(test.slpALCOVE())
})

detach("package:catlearn", unload=TRUE)

## Record of generation of RData 
## Set hidden units
## h <- shin92train(condition = 'equal3', learn.blocks = 0,
##                  trans.blocks = 1, absval = -1, format = 'mds',
##                  subjs = 1, seed =8416)
## h <- h[,c('x1','x2','x3','x4')] 
## h <- t(h)

## Set model initial state
## params = c(2, 1, .25, .75)
## st <- list(colskip = 5, r = 2, q = 1,
##                    alpha = c(.25,.25,.25,.25),
##                    w = array(0,dim=c(2,16)), h = h,
##                    c = params[1], phi = params[2],
##                    la = params[3], lw = params[4])

## Set training
## tr <- shin92train(condition = 'equal3', absval = -1,
##                   format = 'mds', subjs = 1, seed =8416)
## Store answer
## cor.out <- out$prob[,1]
