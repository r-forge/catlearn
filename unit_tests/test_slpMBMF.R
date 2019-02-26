## Unit test for slpMBMF
test.slpMBMF <- function() {
    load('data/test_slpMBMF.RData')

    st <- list(
        alpha = .3,
        lambda = .5,
        w = 0.5,
        beta = 2,
        p = .2,
        tprob  = rbind(c(.7,.3),c(.3,.7)),
        q1.mf = c(.5, .5),
        q1.mb = c(.5, .5),
        q2 = c(.5, .5)
    )
    
    out <- slpMBMF(st,tr1)

    !sum((out$out[,1] - cor.out)^2)
}








