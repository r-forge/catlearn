# imported the logical structure of the six problems from the 
# python code written by Todd Gurecki available
# at https://github.com/NYUCCL/sustain_python.git

# The trials are randomised into 32 blocks (as it was described in their paper).
# For each problem stimuli are presented in a padded format for slpSUSTAIN.
# It is essentially a vectorised version of Figure 10.2A in 
# McDonnell and Gureckis, T. M. (2011)

nosof94sustain.ready <- function(cond = 1, blocks = 32) {

  .shj1 <- NULL
  .shj2 <- NULL
  .shj3 <- NULL
  .shj4 <- NULL
  .shj5 <- NULL
  .shj6 <- NULL
  
  output <- array(0, dim = c(8, 8, 6))

    shj1 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
                     0, 0, 1, 1, 0, 0, 1, 1,
                     0, 1, 0, 1, 0, 1, 0, 1,
                     0, 0, 0, 0, 1, 1, 1, 1), 8, 4)
    for (i in 1:ncol(shj1)) {
    .shj1 <- cbind(.shj1, shj1[, i], 1 - shj1[, i])
    }

    shj2 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
                     0, 0, 1, 1, 0, 0, 1, 1,
                     0, 1, 0, 1, 0, 1, 0, 1,
                     0, 0, 1, 1, 1, 1, 0, 0), 8, 4)
    for (i in 1:ncol(shj2)) {
    .shj2 <- cbind(.shj2, shj2[,i], 1 - shj2[,i])
    }

    shj3 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
                     0, 0, 1, 1, 0, 0, 1, 1,
                     0, 1, 0, 1, 0, 1, 0, 1,
                     0, 0, 0, 1, 1, 0, 1, 1), 8, 4)
    for (i in 1:ncol(shj3)) {
    .shj3 <- cbind(.shj3, shj3[,i], 1 - shj3[,i])
    }


    shj4 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
                     0, 0, 1, 1, 0, 0, 1, 1,
                     0, 1, 0, 1, 0, 1, 0, 1,
                     0, 0, 0, 1, 0, 1, 1, 1), 8, 4)
    for (i in 1:ncol(shj4)) {
    .shj4 <- cbind(.shj4, shj4[,i], 1 - shj4[,i])
    }


    shj5 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
                     0, 0, 1, 1, 0, 0, 1, 1,
                     0, 1, 0, 1, 0, 1, 0, 1,
                     0, 0, 0, 1, 1, 1, 1, 0), 8, 4)
    for (i in 1:ncol(shj5)) {
    .shj5 <- cbind(.shj5, shj5[,i], 1 - shj5[,i])
    }


    shj6 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
                     0, 0, 1, 1, 0, 0, 1, 1,
                     0, 1, 0, 1, 0, 1, 0, 1,
                     0, 1, 1, 0, 1, 0, 0, 1), 8, 4)
    for (i in 1:ncol(shj6)) {
    .shj6 <- cbind(.shj6, shj6[,i], 1 - shj6[,i])
    }

    
    output[, , 1] <- .shj1
    output[, , 2] <- .shj2
    output[, , 3] <- .shj3
    output[, , 4] <- .shj4
    output[, , 5] <- .shj5
    output[, , 6] <- .shj6
    
    ret <- output[,,cond]
    ret <- cbind(1:8, ret)
    ret <- matrix(rep(t(ret), blocks), ncol = 9, byrow = TRUE)
    ret <- cbind(rep(0, nrow(ret)),
                 ret[sample(nrow(ret)), ],
                 rep(1, nrow(ret)))

    ret[1, 1] <- 1
    colnames(ret) <- c("ctrl", "stim", "x1", "x2", "y1", "y2",
                          "z1", "z2", "c1", "c2", "t")
    rm(shj1, shj2, shj3, shj4, shj5, shj6)

    return(ret)
}
