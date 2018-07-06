krus96train <- function(blocks = 15, subjs = 1, seed = 7624) {
   set.seed(seed)

    ## note "x7"=bias cue, which is always on

   sr <- rbind(
       ##          I1, PC1, PR1, I2, PC2, PR2, X, t1, t2, t3, t4
       c("I1.PC1",  1,   1,   0,  0,   0,   0, 1,  1,  0,  0,  0),
       c("I1.PC1",  1,   1,   0,  0,   0,   0, 1,  1,  0,  0,  0),
       c("I1.PC1",  1,   1,   0,  0,   0,   0, 1,  1,  0,  0,  0),       
       c("I1.PR1",  1,   0,   1,  0,   0,   0, 1,  0,  1,  0,  0),
       c("I2.PC2",  0,   0,   0,  1,   1,   0, 1,  0,  0,  1,  0),
       c("I2.PC2",  0,   0,   0,  1,   1,   0, 1,  0,  0,  1,  0),
       c("I2.PC2",  0,   0,   0,  1,   1,   0, 1,  0,  0,  1,  0),       
       c("I2.PR2",  0,   0,   0,  1,   0,   1, 1,  0,  0,  0,  1)
   )
   
       
   testitems <- rbind(
       ##             I1, PC1, PR1, I2, PC2, PR2 
       c("I1",         1,   0,   0,  0,   0,   0),
       c("PC1",        0,   1,   0,  0,   0,   0),
       c("PR1",        0,   0,   1,  0,   0,   0),
       c("I2",         0,   0,   0,  1,   0,   0),
       c("PC2",        0,   0,   0,  0,   1,   0),
       c("PR2",        0,   0,   0,  0,   0,   1),
       c("PC1.PR1",    0,   1,   1,  0,   0,   0),
       c("PC2.PR2",    0,   0,   0,  0,   1,   1),
       c("I1.PC1.PR1", 1,   1,   1,  0,   0,   0),
       c(0,0,0,1,1,1,1),
       c(1,0,0,0,1,0,1),
       c(1,0,0,0,0,1,1),
       c(0,1,0,1,0,0,1),
       c(0,0,1,1,0,0,1),
       c(0,1,0,0,0,1,1),
       c(0,0,1,0,1,0,1),
       c(1,1,0,0,0,1,1),
       c(0,0,1,1,1,0,1))

    teststim <- c("I1", "PC1", "PR1", "I2", "PC2", "PR2", "PC1.PR1",
                  "PC2.PR2", "I1.PC1.PR1", "I2.PC2.PR2", "I1.PC2",
                  "I1.PR2", "I2.PC1", "I2.PR1", "PC1.PR2", "PC2.PR1",
                  "I1.PC1.PR2", "I2.PC2.PR1")                                
     
    bigtr <- NULL
    for(subj in 1:subjs) {
       
        trainingitems <- data.frame(cbind("", sr))
    
        colnames(trainingitems) <- c("stim", "x1", "x2", "x3", "x4", "x5",
                                 "x6", "x7", "t1", "t2", "t3", "t4")

        trainingitems[,"stim"] <- c(rep("I1.PC1", 3), "I1.PR1",
                                    rep("I2.PC2", 3), "I2.PR2")
        
        tr <- data.frame(matrix(0, ncol=14, nrow = blocks * nrow(sr)))
    
        for (i in 1:blocks){
            samp <- sample(1:nrow(sr), nrow(sr))
            tr[(1:nrow(sr)) + nrow(sr) * (i-1), 2] <- i
            tr[(1:nrow(sr)) + nrow(sr) * (i-1), 3] <- trainingitems[samp,
                                                                 "stim"]
            tr[(1:nrow(sr)) + nrow(sr) * (i-1), 4:14] <- sr[samp,]
        }
    
        tr[1,1]<-1
    
        colnames(tr) <- c("ctrl", "block", colnames(trainingitems))
    
        testrials <- data.frame(2, 16, teststim, testitems)

        colnames(testrials) <- colnames(tr)
    
        tr <- rbind(tr, testrials)
        bigtr <- rbind(bigtr, tr)
    }
    
    return(bigtr)
}
