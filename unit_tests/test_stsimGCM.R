## Unit test for stsimGCM
test.stsimGCM <- function() {
    st<-list(
        sensitivity = 3,
        weights = c(.2,.3),
        choice_bias = c(1/3),
        gamma = 1,
        mp = 1,
        r_metric = 1,
        p = 1,
        nCats = 2,
        nFeat=3
    )
                               
    st$tr <- nosof94train(blocks = 1)

    st$mp<-c(3,5)
    
    st$training_items <- as.data.frame(
        t(matrix(cbind(c(1,0,1,1,1,0,1),c(1,1,0,2,1,0,0),
                       c(0,1,0,5,0,1,0),c(0,0,1,1,0,1,1)),
                 ncol=4, nrow=7,
                 dimnames=list(c("stim","x1", "x2", "x3",
                                 "cat1", "cat2", "mem"),
                               c(1:4)))))
    
    out <- stsimGCM(st)

    corr <- rbind(
        c(.2480630, .7519370),
        c(.2336842, .7663158),
        c(.2403604, .7596396),
        c(.2403604, .7596396),
        c(.2852616, .7147384),
        c(.2480630, .7519370),
        c(.2336842, .7663158),
        c(.2852616, .7147384),
        c(.2403604, .7596396),
        c(.2403604, .7596396),
        c(.2852616, .7147384),
        c(.2480630, .7519370),
        c(.2480630, .7519370),
        c(.2336842, .7663158),
        c(.2336842, .7663158),
        c(.2852616, .7147384)
    )

    sum((out-corr)^2) < 1e-13 # Return TRUE or FALSE
    
    }

