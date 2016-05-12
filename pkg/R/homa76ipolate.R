homa76ipolate <- function() {
    data(shin92exp2mds) # Load MDS for S&N92, exp.2 
    stims <- shin92exp2mds
    # Category 3, we need 8 extra 4-bit distortions, 2 extra 6-bit, 2
    # extra 7.7-bit
    proto <- as.matrix(stims[stims$cat == 3 & stims$dist == 0, 5:10])
    # 4-bit distortions first
    bit4 <-  as.matrix(stims[stims$cat == 3 & stims$dist == 4, 5:10])
    bit4diff <- sweep(bit4,2,proto)
    bit4dist <- sqrt(rowSums(bit4diff^2))
    # Generate two at each distance given at bit4dist Generate by
    # doing all combinations of D1-6 values This generates 4096
    # candidates
    bit4extra <- array(0,dim=c(4096,6))
    count <- 0
    for(d1 in 1:4) {
        for(d2 in 1:4) {
            for(d3 in 1:4) {
                for(d4 in 1:4) {
                    for(d5 in 1:4) {
                        for(d6 in 1:4) {
                            count <- count + 1
                            bit4extra[count,] <- c(bit4[d1,'D1'],
                                                   bit4[d2,'D2'],
                                                   bit4[d3,'D3'],
                                                   bit4[d4,'D4'],
                                                   bit4[d5,'D5'],
                                                   bit4[d6,'D6'])
                        }
                    }
                }
            }
        }
    }
    bit4diff.extra <- sweep(bit4extra,2,proto)
    bit4dist.extra <- sqrt(rowSums(bit4diff.extra^2))
    bit4extra <- cbind(bit4extra,bit4dist.extra)
    colnames(bit4extra) <- c('D1','D2','D3','D4','D5','D6','dist')
    # Stimulus 1 - around .3 to .4 to proto
    new1 <- bit4extra[bit4extra[,'dist'] > 0.3 & bit4extra[,'dist'] <
                      0.4,]
    # Difference to existing stimulus 1
    new1diff <- sweep(new1[,1:6],2,bit4[1,])
    new1dist <- sqrt(rowSums(new1diff^2))
    new1 <- cbind(new1,new1dist)
    # Order by that distance
    new1 <- new1[order(new1dist),]
    # Here are our 2 extra stimuli from existing bit4 stimulus One
    # chosen to be maximally dissimilar to existing bit4 stimulus One
    # chosen to be quite dissimilar, but not too similar to the other
    # extra
    extras1 <- as.data.frame(cbind('cat3-L-extra',3,'old',4.0,
                                   new1[c(26,29),1:6]))
    colnames(extras1) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 2 - around 1.43 to 1.53
    new2 <- bit4extra[bit4extra[,'dist'] > 1.43 & bit4extra[,'dist'] <
                      1.53,]
    # Difference to existing stimulus 
    new2diff <- sweep(new2[,1:6],2,bit4[2,])
    new2dist <- sqrt(rowSums(new2diff^2))
    new2 <- cbind(new2,new2dist)
    # Order by that distance
    new2 <- new2[order(new2dist),]
    # Two new stimuli - one maximally dissimilar, one averagely so.
    extras2 <- as.data.frame(cbind('cat3-L-extra',3,'old',4.0,
                                   new2[c(91,183),1:6]))
    colnames(extras2) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 3 - around 0.93 to 1.03
    new3 <- bit4extra[bit4extra[,'dist'] > 0.93 & bit4extra[,'dist'] <
                      1.03,]
    # Difference to existing stimulus 3
    new3diff <- sweep(new3[,1:6],2,bit4[3,])
    new3dist <- sqrt(rowSums(new3diff^2))
    new3 <- cbind(new3,new3dist)
    # Order by that distance
    new3 <- new3[order(new3dist),]
    # Two new stimuli - one maximally dissimilar, one averagely so.
    extras3 <- as.data.frame(cbind('cat3-L-extra',3,'old',4.0,
                                   new3[c(232,464),1:6]))
    colnames(extras3) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 4 - around 1.1 to 1.2
    new4 <- bit4extra[bit4extra[,'dist'] > 1.1 & bit4extra[,'dist'] <
                      1.2,]
    # Difference to existing stimulus 4
    new4diff <- sweep(new4[,1:6],2,bit4[4,])
    new4dist <- sqrt(rowSums(new4diff^2))
    new4 <- cbind(new4,new4dist)
    # Order by that distance
    new4 <- new4[order(new4dist),]
    # Two new stimuli - one maximally dissimilar, one averagely so.
    extras4 <- as.data.frame(cbind('cat3-L-extra',3,'new',4.0,new4[c(328,656),1:6]))
    colnames(extras4) <- c('id','cat','type','dist','D1','D2','D3','D4','D5','D6')
    # NOW... 6-bit distortions 
    bit6 <-  as.matrix(stims[stims$cat == 3 & stims$dist == 6, 5:10])
    bit6diff <- sweep(bit6,2,proto)
    bit6dist <- sqrt(rowSums(bit6diff^2))
    # Generate one at each of the first two distances given at bit6dist
    # Generate by doing all combinations of D1-6 values
    # This generates 4096 candidates
    bit6extra <- array(0,dim=c(4096,6))
    count <- 0
    for(d1 in 1:4) {
        for(d2 in 1:4) {
            for(d3 in 1:4) {
                for(d4 in 1:4) {
                    for(d5 in 1:4) {
                        for(d6 in 1:4) {
                            count <- count + 1
                            bit6extra[count,] <- c(bit6[d1,'D1'],
                                                   bit6[d2,'D2'],
                                                   bit6[d3,'D3'],
                                                   bit6[d4,'D4'],
                                                   bit6[d5,'D5'],
                                                   bit6[d6,'D6'])
                        }
                    }
                }
            }
        }
    }
    bit6diff.extra <- sweep(bit6extra,2,proto)
    bit6dist.extra <- sqrt(rowSums(bit6diff.extra^2))
    bit6extra <- cbind(bit6extra,bit6dist.extra)
    colnames(bit6extra) <- c('D1','D2','D3','D4','D5','D6','dist')
    # Stimulus 1 - around 1.3 to 1.5 to proto
    new5 <- bit6extra[bit6extra[,'dist'] > 1.3 & bit6extra[,'dist'] <
                      1.5,]
    # Difference to existing stimulus 1
    new5diff <- sweep(new5[,1:6],2,bit6[1,])
    new5dist <- sqrt(rowSums(new5diff^2))
    new5 <- cbind(new5,new5dist)
    # Order by that distance
    new5 <- new5[order(new5dist),]
    # Here's our extra stimuli from existing bit6 stimulus 1
    # Chosen to be maximally dissimilar to existing bit6 stimulus 1
    extras5 <- as.data.frame(cbind('cat3-M-extra',3,'new',6.0,
                                   t(new5[405,1:6])))
    colnames(extras5) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 2 - around 2.5 to 2.7 to proto
    new6 <- bit6extra[bit6extra[,'dist'] > 2.5 & bit6extra[,'dist'] <
                      2.7,]
    # Difference to existing stimulus 2
    new6diff <- sweep(new6[,1:6],2,bit6[2,])
    new6dist <- sqrt(rowSums(new6diff^2))
    new6 <- cbind(new6,new6dist)
    # Order by that distance
    new6 <- new6[order(new6dist),]
    # Here's our extra stimuli from existing bit6 stimulus 1
    # Chosen to be maximally dissimilar to existing bit6 stimulus 1
    extras6 <- as.data.frame(cbind('cat3-M-extra',3,'new',6.0,
                                   t(new6[440,1:6])))
    colnames(extras6) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # NOW... 7.7-bit distortions 
    bit77 <-  as.matrix(stims[stims$cat == 3 & stims$dist == 7.7,
                              5:10])
    bit77diff <- sweep(bit77,2,proto)
    bit77dist <- sqrt(rowSums(bit77diff^2))
    # Generate one at each of the first two distances given at
    # bit6dist Generate by doing all combinations of D1-6 values This
    # generates 4096 candidates
    bit77extra <- array(0,dim=c(4096,6))
    count <- 0
    for(d1 in 1:4) {
        for(d2 in 1:4) {
            for(d3 in 1:4) {
                for(d4 in 1:4) {
                    for(d5 in 1:4) {
                        for(d6 in 1:4) {
                            count <- count + 1
                            bit77extra[count,] <- c(bit77[d1,'D1'],
                                                    bit77[d2,'D2'],
                                                    bit77[d3,'D3'],
                                                    bit77[d4,'D4'],
                                                    bit77[d5,'D5'],
                                                    bit77[d6,'D6'])
                        }
                    }
                }
            }
        }
    }
    bit77diff.extra <- sweep(bit77extra,2,proto)
    bit77dist.extra <- sqrt(rowSums(bit77diff.extra^2))
    bit77extra <- cbind(bit77extra,bit77dist.extra)
    colnames(bit77extra) <- c('D1','D2','D3','D4','D5','D6','dist')
    # Stimulus 2 - around 2.6 to 2.8 to proto
    new7 <- bit77extra[bit77extra[,'dist'] > 2.6 & bit77extra[,'dist'] <
                       2.8,]
    # Difference to existing stimulus 1
    new7diff <- sweep(new7[,1:6],2,bit77[2,])
    new7dist <- sqrt(rowSums(new7diff^2))
    new7 <- cbind(new7,new7dist)
    # Order by that distance
    new7 <- new7[order(new7dist),]
    # Here's our extra stimuli from existing bit7.7 stimulus 2
    # Chosen to be maximally dissimilar to existing bit7.7 stimulus 2
    extras7 <- as.data.frame(cbind('cat3-H-extra',3,'new',7.7,t(new7[434,1:6])))
    colnames(extras7) <- c('id','cat','type','dist','D1','D2','D3','D4','D5','D6')
    # Stimulus 4 - around 2.0 to 2.2 to proto
    new8 <- bit77extra[bit77extra[,'dist'] > 2.0 & bit77extra[,'dist'] <
                       2.2,]
    # Difference to existing stimulus 4
    new8diff <- sweep(new8[,1:6],2,bit77[4,])
    new8dist <- sqrt(rowSums(new8diff^2))
    new8 <- cbind(new8,new8dist)
    # Order by that distance
    new8 <- new8[order(new8dist),]
    # Here's our extra stimuli from existing bit77 stimulus 4
    # Chosen to be maximally dissimilar to existing bit77 stimulus 4
    extras8 <- as.data.frame(cbind('cat3-H-extra',3,'new',7.7,
                                   t(new8[545,1:6])))
    colnames(extras8) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')

    cat3extras <- rbind(extras1,extras2,extras3,extras4,extras5,extras6,extras7,extras8)
    #### Category 2
    # Needs 4 extra 4-bit for training, plus 2 for test
    # Needs 2 extra 6-bit
    # Needs 2 extra 7.7-bit
    ########
    proto <- as.matrix(stims[stims$cat == 2 & stims$dist == 0, 5:10])
     # 4-bit distortions first
    bit4 <-  as.matrix(stims[stims$cat == 2 & stims$dist == 4, 5:10])
    bit4diff <- sweep(bit4,2,proto)
    bit4dist <- sqrt(rowSums(bit4diff^2))
    # bit4dist[1] is clearly an outlier, so let's not use for generation.
    # bit4dist[3] is a new stimulus, so let's generate extra new from this.
    # This means we have to get four stimuli from bit4dist[2]

    # Generate all combinations of D1-6 values
    # This generates 729 candidates
    bit4extra <- array(0,dim=c(729,6))
    count <- 0
    for(d1 in 1:3) {
        for(d2 in 1:3) {
            for(d3 in 1:3) {
                for(d4 in 1:3) {
                    for(d5 in 1:3) {
                        for(d6 in 1:3) {
                            count <- count + 1
                            bit4extra[count,] <- c(bit4[d1,'D1'],
                                                   bit4[d2,'D2'],
                                                   bit4[d3,'D3'],
                                                   bit4[d4,'D4'],
                                                   bit4[d5,'D5'],
                                                   bit4[d6,'D6'])
                        }
                    }
                }
            }
        }
    }
    bit4diff.extra <- sweep(bit4extra,2,proto)
    bit4dist.extra <- sqrt(rowSums(bit4diff.extra^2))
    bit4extra <- cbind(bit4extra,bit4dist.extra)
    colnames(bit4extra) <- c('D1','D2','D3','D4','D5','D6','dist')
    # Stimulus 2 - around .84 to .94 to proto
    new1 <- bit4extra[bit4extra[,'dist'] > 0.84 & bit4extra[,'dist'] <
                      0.94,]
    # Difference to existing stimulus 2
    new1diff <- sweep(new1[,1:6],2,bit4[2,])
    new1dist <- sqrt(rowSums(new1diff^2))
    new1 <- cbind(new1,new1dist)
    # Order by that distance
    new1 <- new1[order(new1dist),]
    # Here are our 4 extra stimuli - chosen to largely be different to
    # the existing old, but also different to each other.
    extras1 <- as.data.frame(cbind('cat2-L-extra',2,'old',4.0,
                                   new1[c(7,17,18,21),1:6]))
    colnames(extras1) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 3 - around 1.3 to 1.5
    new3 <- bit4extra[bit4extra[,'dist'] > 0.93 & bit4extra[,'dist'] <
                      1.03,]
    # Difference to existing stimulus 3
    new3diff <- sweep(new3[,1:6],2,bit4[3,])
    new3dist <- sqrt(rowSums(new3diff^2))
    new3 <- cbind(new3,new3dist)
    # Order by that distance
    new3 <- new3[order(new3dist),]
    # Two new stimuli - chosen to be different to existing new, but
    # also to each other
    extras2 <- as.data.frame(cbind('cat2-L-extra',2,'new',4.0,
                                   new3[c(6,20),1:6]))
    colnames(extras2) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # NOW... 6-bit distortions 
    bit6 <-  as.matrix(stims[stims$cat == 2 & stims$dist == 6, 5:10])
    bit6diff <- sweep(bit6,2,proto)
    bit6dist <- sqrt(rowSums(bit6diff^2))
    # Generate one at each of the first two distances given at bit6dist
    # Generate by doing all combinations of D1-6 values
    # This generates 729 candidates
    bit6extra <- array(0,dim=c(729,6))
    count <- 0
    for(d1 in 1:3) {
        for(d2 in 1:3) {
            for(d3 in 1:3) {
                for(d4 in 1:3) {
                    for(d5 in 1:3) {
                        for(d6 in 1:3) {
                            count <- count + 1
                            bit6extra[count,] <- c(bit6[d1,'D1'],
                                                   bit6[d2,'D2'],
                                                   bit6[d3,'D3'],
                                                   bit6[d4,'D4'],
                                                   bit6[d5,'D5'],
                                                   bit6[d6,'D6'])
                        }
                    }
                }
            }
        }
    }
    bit6diff.extra <- sweep(bit6extra,2,proto)
    bit6dist.extra <- sqrt(rowSums(bit6diff.extra^2))
    bit6extra <- cbind(bit6extra,bit6dist.extra)
    colnames(bit6extra) <- c('D1','D2','D3','D4','D5','D6','dist')
    # Stimulus 1 - around 1.95 to 2.05 to proto
    new5 <- bit6extra[bit6extra[,'dist'] > 1.95 & bit6extra[,'dist'] <
                      2.05,]
    # Difference to existing stimulus 1
    new5diff <- sweep(new5[,1:6],2,bit6[1,])
    new5dist <- sqrt(rowSums(new5diff^2))
    new5 <- cbind(new5,new5dist)
    # Order by that distance
    new5 <- new5[order(new5dist),]
    # Here's our extra stimuli from existing bit6 stimulus 1
    # Chosen to be maximally dissimilar to existing bit6 stimulus 1
    extras3 <- as.data.frame(cbind('cat2-M-extra',2,'new',6.0,
                                   t(new5[33,1:6])))
    colnames(extras3) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 2 - around 3.95 to 4.05 to proto
    new6 <- bit6extra[bit6extra[,'dist'] > 3.95 & bit6extra[,'dist'] <
                      4.05,]
    # Difference to existing stimulus 2
    new6diff <- sweep(new6[,1:6],2,bit6[2,])
    new6dist <- sqrt(rowSums(new6diff^2))
    new6 <- cbind(new6,new6dist)
    # Order by that distance
    new6 <- new6[order(new6dist),]
    # Here's our extra stimuli from existing bit6 stimulus 1 Chosen to
    # be maximally dissimilar to existing bit6 stimulus 1
    extras4 <- as.data.frame(cbind('cat2-M-extra',2,'new',6.0,
                                   t(new6[24,1:6])))
    colnames(extras4) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # NOW... 7.7-bit distortions 
    bit77 <-  as.matrix(stims[stims$cat == 2 & stims$dist == 7.7, 5:10])
    bit77diff <- sweep(bit77,2,proto)
    bit77dist <- sqrt(rowSums(bit77diff^2))
    # Generate one at each of the first two distances given at bit6dist
    # Generate by doing all combinations of D1-6 values
    # This generates 729 candidates
    bit77extra <- array(0,dim=c(729,6))
    count <- 0
    for(d1 in 1:3) {
        for(d2 in 1:3) {
            for(d3 in 1:3) {
                for(d4 in 1:3) {
                    for(d5 in 1:3) {
                        for(d6 in 1:3) {
                            count <- count + 1
                            bit77extra[count,] <- c(bit77[d1,'D1'],
                                                    bit77[d2,'D2'],
                                                    bit77[d3,'D3'],
                                                    bit77[d4,'D4'],
                                                    bit77[d5,'D5'],
                                                    bit77[d6,'D6'])
                        }
                    }
                }
            }
        }
    }
    bit77diff.extra <- sweep(bit77extra,2,proto)
    bit77dist.extra <- sqrt(rowSums(bit77diff.extra^2))
    bit77extra <- cbind(bit77extra,bit77dist.extra)
    colnames(bit77extra) <- c('D1','D2','D3','D4','D5','D6','dist')
    # Stimulus 2 - around 1.95 to 2.05 to proto
    new7 <- bit77extra[bit77extra[,'dist'] > 1.95 & bit77extra[,'dist'] <
                       2.05,]
    # Difference to existing stimulus 2
    new7diff <- sweep(new7[,1:6],2,bit77[2,])
    new7dist <- sqrt(rowSums(new7diff^2))
    new7 <- cbind(new7,new7dist)
    # Order by that distance
    new7 <- new7[order(new7dist),]
    # Here's our extra stimuli from existing bit7.7 stimulus 2
    # Chosen to be maximally dissimilar to existing bit7.7 stimulus 2
    extras5 <- as.data.frame(cbind('cat2-H-extra',2,'new',7.7,
                                   t(new7[53,1:6])))
    colnames(extras5) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 3 - around 2.8 to 2.9 to proto
    new8 <- bit77extra[bit77extra[,'dist'] > 2.8 & bit77extra[,'dist'] <
                       2.9,]
    # Difference to existing stimulus 3
    new8diff <- sweep(new8[,1:6],2,bit77[3,])
    new8dist <- sqrt(rowSums(new8diff^2))
    new8 <- cbind(new8,new8dist)
    # Order by that distance
    new8 <- new8[order(new8dist),]
    # Here's our extra stimuli from existing bit77 stimulus 4 Chosen
    # to be maximally dissimilar to existing bit77 stimulus 4
    extras6 <- as.data.frame(cbind('cat3-H-extra',2,'new',7.7,
                                   t(new8[41,1:6])))
    colnames(extras6) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    cat2extras <- rbind(extras1,extras2,extras3,extras4,extras5,
                        extras6)
    ####
    # And, finally, category 1
    # Needs 2 extra 4-bit for training, plus 2 for test
    # Needs 2 extra 6-bit
    # Needs 2 extra 7.7-bit
    ########
    proto <- as.matrix(stims[stims$cat == 1 & stims$dist == 0, 5:10])
     # 4-bit distortions first
    bit4 <-  as.matrix(stims[stims$cat == 1 & stims$dist == 4, 5:10])
    bit4diff <- sweep(bit4,2,proto)
    bit4dist <- sqrt(rowSums(bit4diff^2))
    # Generate all combinations of D1-6 values
    # This generates 64 candidates
    bit4extra <- array(0,dim=c(64,6))
    count <- 0
    for(d1 in 1:2) {
        for(d2 in 1:2) {
            for(d3 in 1:2) {
                for(d4 in 1:2) {
                    for(d5 in 1:2) {
                        for(d6 in 1:2) {
                            count <- count + 1
                            bit4extra[count,] <- c(bit4[d1,'D1'],
                                                   bit4[d2,'D2'],
                                                   bit4[d3,'D3'],
                                                   bit4[d4,'D4'],
                                                   bit4[d5,'D5'],
                                                   bit4[d6,'D6'])
                        }
                    }
                }
            }
        }
    }
    bit4diff.extra <- sweep(bit4extra,2,proto)
    bit4dist.extra <- sqrt(rowSums(bit4diff.extra^2))
    bit4extra <- cbind(bit4extra,bit4dist.extra)
    colnames(bit4extra) <- c('D1','D2','D3','D4','D5','D6','dist')
    # Stimulus 1 - around .9 to 1.0 to proto
    new1 <- bit4extra[bit4extra[,'dist'] > 0.9 & bit4extra[,'dist'] <
                      1,]
    # Difference to existing stimulus 1
    new1diff <- sweep(new1[,1:6],2,bit4[1,])
    new1dist <- sqrt(rowSums(new1diff^2))
    new1 <- cbind(new1,new1dist)
    # Order by that distance
    new1 <- new1[order(new1dist),]
    # Here are our 2 extra stimuli - chosen to largely be different to
    # the existing old, but also different to each other.
    extras1 <- as.data.frame(cbind('cat1-L-extra',1,'old',4.0,
                                   new1[c(3,16),1:6]))
    colnames(extras1) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 2 - around 0.5 to 0.7
    new3 <- bit4extra[bit4extra[,'dist'] > 0.5 & bit4extra[,'dist'] <
                      0.7,]
    # Difference to existing stimulus 2
    new3diff <- sweep(new3[,1:6],2,bit4[2,])
    new3dist <- sqrt(rowSums(new3diff^2))
    new3 <- cbind(new3,new3dist)
    # Order by that distance
    new3 <- new3[order(new3dist),]
    # Two new stimuli - chosen to be different to existing new, but
    # also to each other
    extras2 <- as.data.frame(cbind('cat1-L-extra',1,'new',4.0,
                                   new3[c(6,23),1:6]))
    colnames(extras2) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # NOW... 6-bit distortions 
    bit6 <-  as.matrix(stims[stims$cat == 1 & stims$dist == 6, 5:10])
    bit6diff <- sweep(bit6,2,proto)
    bit6dist <- sqrt(rowSums(bit6diff^2))
    # Generate one at each of the first two distances given at
    # bit6dist Generate by doing all combinations of D1-6 values This
    # generates 64 candidates
    bit6extra <- array(0,dim=c(64,6))
    count <- 0
    for(d1 in 1:2) {
        for(d2 in 1:2) {
            for(d3 in 1:2) {
                for(d4 in 1:2) {
                    for(d5 in 1:2) {
                        for(d6 in 1:2) {
                            count <- count + 1
                            bit6extra[count,] <- c(bit6[d1,'D1'],
                                                   bit6[d2,'D2'],
                                                   bit6[d3,'D3'],
                                                   bit6[d4,'D4'],
                                                   bit6[d5,'D5'],
                                                   bit6[d6,'D6'])
                        }
                    }
                }
            }
        }
    }
    bit6diff.extra <- sweep(bit6extra,2,proto)
    bit6dist.extra <- sqrt(rowSums(bit6diff.extra^2))
    bit6extra <- cbind(bit6extra,bit6dist.extra)
    colnames(bit6extra) <- c('D1','D2','D3','D4','D5','D6','dist')
    # Stimulus 1 - around 0.8 to 1.2 to proto
    new5 <- bit6extra[bit6extra[,'dist'] > 0.8 & bit6extra[,'dist'] <
                      1.2,]
    # Difference to existing stimulus 1
    new5diff <- sweep(new5[,1:6],2,bit6[1,])
    new5dist <- sqrt(rowSums(new5diff^2))
    new5 <- cbind(new5,new5dist)
    # Order by that distance
    new5 <- new5[order(new5dist),]
    # Here's our extra stimuli from existing bit6 stimulus 1
    # Chosen to be maximally dissimilar to existing bit6 stimulus 1
    extras3 <- as.data.frame(cbind('cat1-M-extra',1,'new',6.0,
                                   t(new5[3,1:6])))
    colnames(extras3) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 2 - around 2.0 to 2.2 to proto
    new6 <- bit6extra[bit6extra[,'dist'] > 2.0 & bit6extra[,'dist'] <
                      2.2,]
    # Difference to existing stimulus 2
    new6diff <- sweep(new6[,1:6],2,bit6[2,])
    new6dist <- sqrt(rowSums(new6diff^2))
    new6 <- cbind(new6,new6dist)
    # Order by that distance
    new6 <- new6[order(new6dist),]
    # Here's our extra stimuli from existing bit6 stimulus 1
    # Chosen to be maximally dissimilar to existing bit6 stimulus 1
    extras4 <- as.data.frame(cbind('cat1-M-extra',1,'new',6.0,
                                   t(new6[6,1:6])))
    colnames(extras4) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # NOW... 7.7-bit distortions 
    bit77 <-  as.matrix(stims[stims$cat == 1 & stims$dist == 7.7,
                              5:10])
    bit77diff <- sweep(bit77,2,proto)
    bit77dist <- sqrt(rowSums(bit77diff^2))
    # Generate one at each of the first two distances given at bit6dist
    # Generate by doing all combinations of D1-6 values
    # This generates 64 candidates
    bit77extra <- array(0,dim=c(64,6))
    count <- 0
    for(d1 in 1:2) {
        for(d2 in 1:2) {
            for(d3 in 1:2) {
                for(d4 in 1:2) {
                    for(d5 in 1:2) {
                        for(d6 in 1:2) {
                            count <- count + 1
                            bit77extra[count,] <- c(bit77[d1,'D1'],
                                                    bit77[d2,'D2'],
                                                    bit77[d3,'D3'],
                                                    bit77[d4,'D4'],
                                                    bit77[d5,'D5'],
                                                    bit77[d6,'D6'])
                        }
                    }
                }
            }
        }
    }
    bit77diff.extra <- sweep(bit77extra,2,proto)
    bit77dist.extra <- sqrt(rowSums(bit77diff.extra^2))
    bit77extra <- cbind(bit77extra,bit77dist.extra)
    colnames(bit77extra) <- c('D1','D2','D3','D4','D5','D6','dist')
    # Stimulus 1 - around 3.9 to 4.1 to proto
    new7 <- bit77extra[bit77extra[,'dist'] > 3.9 & bit77extra[,'dist'] <
                       4.1,]
    # Difference to existing stimulus 2
    new7diff <- sweep(new7[,1:6],2,bit77[2,])
    new7dist <- sqrt(rowSums(new7diff^2))
    new7 <- cbind(new7,new7dist)
     # Order by that distance
    new7 <- new7[order(new7dist),]
    # Here's our extra stimuli from existing bit7.7 stimulus 1
    # Chosen to be maximally dissimilar to existing bit7.7 stimulus 1
    extras5 <- as.data.frame(cbind('cat2-H-extra',1,'new',7.7,
                                   t(new7[4,1:6])))
    colnames(extras5) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 2 - around 2.2 to 2.4 to proto
    new8 <- bit77extra[bit77extra[,'dist'] > 2.2 & bit77extra[,'dist'] <
                       2.4,]
    # Difference to existing stimulus 2
    new8diff <- sweep(new8[,1:6],2,bit77[2,])
    new8dist <- sqrt(rowSums(new8diff^2))
    new8 <- cbind(new8,new8dist)
    # Order by that distance
    new8 <- new8[order(new8dist),]
    # Here's our extra stimuli from existing bit77 stimulus 4 Chosen
    # to be maximally dissimilar to existing bit77 stimulus 4
    extras6 <- as.data.frame(cbind('cat1-H-extra',1,'new',7.7,
                                   t(new8[4,1:6])))
    colnames(extras6) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    cat1extras <- rbind(extras1,extras2,extras3,extras4,extras5,
                        extras6)
    # Now combine generated stimuli with the rest
    stims <- rbind(stims,cat1extras,cat2extras,cat3extras)
    stims$cat <- as.numeric(stims$cat)
    stims$dist <- as.numeric(stims$dist)
    stims$D1 <- as.numeric(stims$D1)
    stims$D2 <- as.numeric(stims$D2)
    stims$D3 <- as.numeric(stims$D3)
    stims$D4 <- as.numeric(stims$D4)
    stims$D5 <- as.numeric(stims$D5)
    stims$D6 <- as.numeric(stims$D6)    
    stims
}
