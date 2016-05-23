homa76ipolate <- function() {
    data(shin92exp2mds) # Load MDS for S&N92, exp.2
    # The three prototypes
    proto3 <- as.matrix(shin92exp2mds[shin92exp2mds$cat == 3 &
                                     shin92exp2mds$dist == 0, 5:10])
    proto2 <- as.matrix(shin92exp2mds[shin92exp2mds$cat == 2 &
                                     shin92exp2mds$dist == 0, 5:10])
    proto1 <- as.matrix(shin92exp2mds[shin92exp2mds$cat == 1 &
                                     shin92exp2mds$dist == 0, 5:10])
    
    # Category 3, we need 8 extra 4-bit distortions, 2 extra 6-bit, 2
    # extra 7.7-bit
    
    # 4-bit distortions first - distance from own proto
    bit4 <-  as.matrix(shin92exp2mds[shin92exp2mds$cat == 3 &
                                     shin92exp2mds$dist == 4, 5:10])
    bit4diff <- sweep(bit4,2,proto3)
    bit4dist <- sqrt(rowSums(bit4diff^2))

    # Distance from other protos
    bit4diff2 <- sweep(bit4,2,proto2)
    bit4dist2 <- sqrt(rowSums(bit4diff2^2))

    bit4diff1 <- sweep(bit4,2,proto1)
    bit4dist1 <- sqrt(rowSums(bit4diff1^2))
    # Manual check - closer to own proto than others
    rbind(bit4dist,bit4dist2,bit4dist1)
    
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
    # Dist to own proto
    bit4diff.extra3 <- sweep(bit4extra,2,proto3)
    bit4dist.extra3 <- sqrt(rowSums(bit4diff.extra3^2))

    # Dist to proto 2
    bit4diff.extra2 <- sweep(bit4extra,2,proto2)
    bit4dist.extra2 <- sqrt(rowSums(bit4diff.extra2^2))

    # Dist to proto 1
    bit4diff.extra1 <- sweep(bit4extra,2,proto1)
    bit4dist.extra1 <- sqrt(rowSums(bit4diff.extra1^2))
    
    bit4extra <- cbind(bit4extra,bit4dist.extra1,bit4dist.extra2,bit4dist.extra3)
    colnames(bit4extra) <- c('D1','D2','D3','D4','D5','D6','dist1','dist2','dist3')
    # Stimulus 1 - around .3 to .4 to proto
    new1 <- bit4extra[bit4extra[,'dist3'] > 0.3 & bit4extra[,'dist3'] <
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
    
    # Check they are closest to their own prototype (manually)
    new1[c(26,29),]
    id <- c('cat3-L-extra-1','cat3-L-extra-2')
    extras1 <- as.data.frame(cbind(id,3,'old',4.0,
                                   new1[c(26,29),1:6]))
    colnames(extras1) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')

    
    # Stimulus 2 - around 1.43 to 1.53
    new2 <- bit4extra[bit4extra[,'dist3'] > 1.43 & bit4extra[,'dist3'] <
                      1.53,]
    # Difference to existing stimulus 
    new2diff <- sweep(new2[,1:6],2,bit4[2,])
    new2dist <- sqrt(rowSums(new2diff^2))
    new2 <- cbind(new2,new2dist)
    # Order by that distance
    new2 <- new2[order(new2dist),]
    # Two new stimuli - one maximally dissimilar, one averagely so.

    # Check for similarity to all protos (manually)
    new2[c(91,83),]
    
    id <- c('cat3-L-extra-3','cat3-L-extra-4')
    extras2 <- as.data.frame(cbind(id,3,'old',4.0,
                                   new2[c(91,183),1:6]))
    colnames(extras2) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    
    # Stimulus 3 - around 0.93 to 1.03
    new3 <- bit4extra[bit4extra[,'dist3'] > 0.93 & bit4extra[,'dist3'] <
                      1.03,]
    # Difference to existing stimulus 3
    new3diff <- sweep(new3[,1:6],2,bit4[3,])
    new3dist <- sqrt(rowSums(new3diff^2))
    new3 <- cbind(new3,new3dist)
    # Order by that distance
    new3 <- new3[order(new3dist),]
    # Two new stimuli - one maximally dissimilar, one averagely so.
    # Manually check for similarity to all proto
    new3[c(232,363),]
    id <- c('cat3-L-extra-5','cat3-L-extra-6')
    extras3 <- as.data.frame(cbind(id,3,'old',4.0,
                                   new3[c(232,464),1:6]))
    colnames(extras3) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 4 - around 1.1 to 1.2
    new4 <- bit4extra[bit4extra[,'dist3'] > 1.1 & bit4extra[,'dist3'] <
                      1.2,]
    # Difference to existing stimulus 4
    new4diff <- sweep(new4[,1:6],2,bit4[4,])
    new4dist <- sqrt(rowSums(new4diff^2))
    new4 <- cbind(new4,new4dist)
    # Order by that distance
    new4 <- new4[order(new4dist),]
    # Two new stimuli - one maximally dissimilar, one averagely so.
    # Check manually for distance to all protos
    new4[c(328,656),]
    id <- c('cat3-L-extra-7','cat3-L-extra-8')
    extras4 <- as.data.frame(cbind(id,3,'new',4.0,new4[c(328,656),1:6]))
    colnames(extras4) <- c('id','cat','type','dist','D1','D2','D3','D4','D5','D6')
    # NOW... 6-bit distortions 
    bit6 <-  as.matrix(shin92exp2mds[shin92exp2mds$cat == 3 & shin92exp2mds$dist == 6, 5:10])
    bit6diff <- sweep(bit6,2,proto3)
    bit6dist <- sqrt(rowSums(bit6diff^2))
    # Distance from other protos
    bit6diff2 <- sweep(bit6,2,proto2)
    bit6dist2 <- sqrt(rowSums(bit6diff2^2))
    bit6diff1 <- sweep(bit6,2,proto1)
    bit6dist1 <- sqrt(rowSums(bit6diff1^2))
    # Manual check - closer to own proto than others
    rbind(bit6dist,bit6dist2,bit6dist1)    
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

    # Dist to own proto
    bit6diff.extra3 <- sweep(bit6extra,2,proto3)
    bit6dist.extra3 <- sqrt(rowSums(bit6diff.extra3^2))

    # Dist to proto 2
    bit6diff.extra2 <- sweep(bit6extra,2,proto2)
    bit6dist.extra2 <- sqrt(rowSums(bit6diff.extra2^2))

    # Dist to proto 1
    bit6diff.extra1 <- sweep(bit6extra,2,proto1)
    bit6dist.extra1 <- sqrt(rowSums(bit6diff.extra1^2))
    
    bit6extra <- cbind(bit6extra,bit6dist.extra1,bit6dist.extra2,bit6dist.extra3)
    colnames(bit6extra) <- c('D1','D2','D3','D4','D5','D6','dist1','dist2','dist3')

    # Stimulus 1 - around 1.3 to 1.5 to proto
    new5 <- bit6extra[bit6extra[,'dist3'] > 1.3 & bit6extra[,'dist3'] <
                      1.5,]
    # Difference to existing stimulus 1
    new5diff <- sweep(new5[,1:6],2,bit6[1,])
    new5dist <- sqrt(rowSums(new5diff^2))
    new5 <- cbind(new5,new5dist)
    # Order by that distance
    new5 <- new5[order(new5dist),]
    # Here's our extra stimuli from existing bit6 stimulus 1
    # Chosen to be maximally dissimilar to existing bit6 stimulus 1
    # Proto check
    new5[405,]
    extras5 <- as.data.frame(cbind('cat3-M-extra-1',3,'new',6.0,
                                   t(new5[405,1:6])))
    colnames(extras5) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 4 - around 1.3 to 1.5 to proto
    new6 <- bit6extra[bit6extra[,'dist3'] > 1.3 & bit6extra[,'dist3'] <
                      1.5,]
    # Difference to existing stimulus 4
    new6diff <- sweep(new6[,1:6],2,bit6[4,])
    new6dist <- sqrt(rowSums(new6diff^2))
    new6 <- cbind(new6,new6dist)
    # Order by that distance
    new6 <- new6[order(new6dist),]
    # Here's our extra stimuli from existing bit6 stimulus 4
    # Chosen to be averagely dissimilar to existing bit6 stimulus 4
    # Manual proto check
    new6[201,]
    extras6 <- as.data.frame(cbind('cat3-M-extra-2',3,'new',6.0,
                                   t(new6[201,1:6])))
    colnames(extras6) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # NOW... 7.7-bit distortions 
    bit77 <-  as.matrix(shin92exp2mds[shin92exp2mds$cat == 3 &
                                      shin92exp2mds$dist == 7.7,
                                      5:10])
    bit77diff <- sweep(bit77,2,proto3)
    bit77dist <- sqrt(rowSums(bit77diff^2))
    # Difference ot other protos
    bit77diff2 <- sweep(bit77,2,proto2)
    bit77dist2 <- sqrt(rowSums(bit77diff2^2))
    bit77diff1 <- sweep(bit77,2,proto1)
    bit77dist1 <- sqrt(rowSums(bit77diff1^2))
    # Manual check - closer to own proto than others
    rbind(bit77dist,bit77dist2,bit77dist1)    
    # Argh ... one of the existing stimuli is closer to a diff proto!
    shin92exp2mds[shin92exp2mds$cat == 3 & shin92exp2mds$dist == 7.7,]
    # It'd probably be over-cleaning to remove this stimulus for which
    # there is a genuine set of MDS co-ordinates, but let's not base
    # any interpolation on it. Best to use stimuli 3 and 4. 
    
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

    # Dist to own proto
    bit77diff.extra3 <- sweep(bit77extra,2,proto3)
    bit77dist.extra3 <- sqrt(rowSums(bit77diff.extra3^2))

    # Dist to proto 2
    bit77diff.extra2 <- sweep(bit77extra,2,proto2)
    bit77dist.extra2 <- sqrt(rowSums(bit77diff.extra2^2))

    # Dist to proto 1
    bit77diff.extra1 <- sweep(bit77extra,2,proto1)
    bit77dist.extra1 <- sqrt(rowSums(bit77diff.extra1^2))
    
    bit77extra <- cbind(bit77extra,bit77dist.extra1,bit77dist.extra2,bit77dist.extra3)
    colnames(bit77extra) <- c('D1','D2','D3','D4','D5','D6','dist1','dist2','dist3')

    # Stimulus 3 - around 1.8 to 2.0 to proto
    new7 <- bit77extra[bit77extra[,'dist3'] > 1.8 & bit77extra[,'dist3'] <
                       2.0,]
    # Difference to existing stimulus 3
    new7diff <- sweep(new7[,1:6],2,bit77[3,])
    new7dist <- sqrt(rowSums(new7diff^2))
    new7 <- cbind(new7,new7dist)
    # Order by that distance
    new7 <- new7[order(new7dist),]
    # Here's our extra stimuli from existing bit7.7 stimulus 2
    # Chosen to be maximally dissimilar to existing bit7.7 stimulus 2
    # manual proto check
    new7[325,]
    extras7 <- as.data.frame(cbind('cat3-H-extra-1',3,'new',7.7,t(new7[325,1:6])))
    colnames(extras7) <- c('id','cat','type','dist','D1','D2','D3','D4','D5','D6')
    # Stimulus 4 - around 2.0 to 2.2 to proto
    new8 <- bit77extra[bit77extra[,'dist3'] > 2.0 & bit77extra[,'dist3'] <
                       2.2,]
    # Difference to existing stimulus 4
    new8diff <- sweep(new8[,1:6],2,bit77[4,])
    new8dist <- sqrt(rowSums(new8diff^2))
    new8 <- cbind(new8,new8dist)
    # Order by that distance
    new8 <- new8[order(new8dist),]
    # Here's our extra stimuli from existing bit77 stimulus 4
    # Chosen to be maximally dissimilar to existing bit77 stimulus 4
    # Manual proto check
    new8[545,]
    extras8 <- as.data.frame(cbind('cat3-H-extra-2',3,'new',7.7,
                                   t(new8[545,1:6])))
    colnames(extras8) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')

    cat3extras <- rbind(extras1,extras2,extras3,extras4,extras5,extras6,extras7,extras8)
    #### Category 2
    # Needs 4 extra 4-bit for training, plus 2 for test
    # Needs 2 extra 6-bit
    # Needs 2 extra 7.7-bit
    ########
    # 4-bit distortions first
    bit4 <-  as.matrix(shin92exp2mds[shin92exp2mds$cat == 2 & shin92exp2mds$dist == 4, 5:10])
    bit4diff <- sweep(bit4,2,proto2)
    bit4dist <- sqrt(rowSums(bit4diff^2))
    # bit4dist[1] is clearly an outlier, so let's not use for
    # generation.
    # In fact, best to check against other protos also
    bit4diff3 <- sweep(bit4,2,proto3)
    bit4dist3 <- sqrt(rowSums(bit4diff3^2))
    bit4diff1 <- sweep(bit4,2,proto1)
    bit4dist1 <- sqrt(rowSums(bit4diff1^2))
    rbind(bit4dist,bit4dist1,bit4dist3)
    # All are closer to their own proto than the others

    
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

    # Dist to proto 3
    bit4diff.extra3 <- sweep(bit4extra,2,proto3)
    bit4dist.extra3 <- sqrt(rowSums(bit4diff.extra3^2))

    # Dist to proto 2
    bit4diff.extra2 <- sweep(bit4extra,2,proto2)
    bit4dist.extra2 <- sqrt(rowSums(bit4diff.extra2^2))

    # Dist to proto 1
    bit4diff.extra1 <- sweep(bit4extra,2,proto1)
    bit4dist.extra1 <- sqrt(rowSums(bit4diff.extra1^2))
    
    bit4extra <- cbind(bit4extra,bit4dist.extra1,bit4dist.extra2,bit4dist.extra3)
    colnames(bit4extra) <- c('D1','D2','D3','D4','D5','D6','dist1','dist2','dist3')

    # Stimulus 2 - around .84 to .94 to proto
    new1 <- bit4extra[bit4extra[,'dist2'] > 0.84 & bit4extra[,'dist2'] <
                      0.94,]
    # Difference to existing stimulus 2
    new1diff <- sweep(new1[,1:6],2,bit4[2,])
    new1dist <- sqrt(rowSums(new1diff^2))
    new1 <- cbind(new1,new1dist)
    # Order by that distance
    new1 <- new1[order(new1dist),]
    # Here are our 4 extra stimuli - chosen to largely be different to
    # the existing old, but also different to each other.
    # manual other proto checl
    new1[c(7,17,18,21),]
    
    id <- c('cat2-L-extra-1','cat2-L-extra-2','cat2-L-extra-3',
            'cat2-L-extra-4')
    extras1 <- as.data.frame(cbind(id,2,'old',4.0,
                                   new1[c(7,17,18,21),1:6]))
    colnames(extras1) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 3 - around 1.3 to 1.5
    new3 <- bit4extra[bit4extra[,'dist2'] > 0.93 & bit4extra[,'dist2'] <
                      1.03,]
    # Difference to existing stimulus 3
    new3diff <- sweep(new3[,1:6],2,bit4[3,])
    new3dist <- sqrt(rowSums(new3diff^2))
    new3 <- cbind(new3,new3dist)
    # Order by that distance
    new3 <- new3[order(new3dist),]
    # Two new stimuli - chosen to be different to existing new, but
    # also to each other
    new3[c(6,20),]
    id <- c('cat2-L-extra-5','cat2-L-extra-6')
    extras2 <- as.data.frame(cbind(id,2,'new',4.0,
                                   new3[c(6,20),1:6]))
    colnames(extras2) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # NOW... 6-bit distortions 
    bit6 <-  as.matrix(shin92exp2mds[shin92exp2mds$cat == 2 & shin92exp2mds$dist == 6, 5:10])
    bit6diff <- sweep(bit6,2,proto2)
    bit6dist <- sqrt(rowSums(bit6diff^2))
    # Distance from other protos
    bit6diff3 <- sweep(bit6,2,proto3)
    bit6dist3 <- sqrt(rowSums(bit6diff3^2))
    bit6diff1 <- sweep(bit6,2,proto1)
    bit6dist1 <- sqrt(rowSums(bit6diff1^2))
    # Manual check - closer to own proto than others?
    rbind(bit6dist,bit6dist1,bit6dist3)    
    # 12,16 both rather marginal. Base of 11.

    
    # Generate two from the first distance at bit6dist

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

    
    # Dist to proto 3 
    bit6diff.extra3 <- sweep(bit6extra,2,proto3)
    bit6dist.extra3 <- sqrt(rowSums(bit6diff.extra3^2))

    # Dist to proto 2
    bit6diff.extra2 <- sweep(bit6extra,2,proto2)
    bit6dist.extra2 <- sqrt(rowSums(bit6diff.extra2^2))

    # Dist to proto 1
    bit6diff.extra1 <- sweep(bit6extra,2,proto1)
    bit6dist.extra1 <- sqrt(rowSums(bit6diff.extra1^2))

    bit6extra <- cbind(bit6extra,bit6dist.extra1,bit6dist.extra2,bit6dist.extra3)
    colnames(bit6extra) <- c('D1','D2','D3','D4','D5','D6','dist1','dist2','dist3')


    # Stimulus 1 - around 1.95 to 2.05 to proto
    new5 <- bit6extra[bit6extra[,'dist2'] > 1.95 & bit6extra[,'dist2'] <
                      2.05,]
    # Difference to existing stimulus 1
    new5diff <- sweep(new5[,1:6],2,bit6[1,])
    new5dist <- sqrt(rowSums(new5diff^2))
    new5 <- cbind(new5,new5dist)
    # Order by that distance
    new5 <- new5[order(new5dist),]
    # Here's our extra stimuli from existing bit6 stimulus 1 Chosen to
    # be maximally & quite dissimilar to existing bit6 stimulus 1
    # while still being clearly closer to proto 2 than proto 1,3
    # and not too similar to each other
    new5[c(19,33),]
    id <- c('cat2-M-extra-1','cat2-M-extra-2')
    extras3 <- as.data.frame(cbind(id,2,'new',6.0,
                                   new5[c(19,33),1:6]))
    colnames(extras3) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # NOW... 7.7-bit distortions ###
    bit77 <-  as.matrix(shin92exp2mds[shin92exp2mds$cat == 2 & shin92exp2mds$dist == 7.7, 5:10])
    bit77diff <- sweep(bit77,2,proto2)
    bit77dist <- sqrt(rowSums(bit77diff^2))

    # Difference ot other protos
    bit77diff3 <- sweep(bit77,2,proto3)
    bit77dist3 <- sqrt(rowSums(bit77diff3^2))
    bit77diff1 <- sweep(bit77,2,proto1)
    bit77dist1 <- sqrt(rowSums(bit77diff1^2))
    # Manual check - closer to own proto than others
    rbind(bit77dist,bit77dist1,bit77dist3)
    # All OK, 3rd one a bit close.

    # Generate one at each of the first two distances given at bit77dist
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

    
    # Dist to proto 3
    bit77diff.extra3 <- sweep(bit77extra,2,proto3)
    bit77dist.extra3 <- sqrt(rowSums(bit77diff.extra3^2))

    # Dist to proto 2
    bit77diff.extra2 <- sweep(bit77extra,2,proto2)
    bit77dist.extra2 <- sqrt(rowSums(bit77diff.extra2^2))

    # Dist to proto 1
    bit77diff.extra1 <- sweep(bit77extra,2,proto1)
    bit77dist.extra1 <- sqrt(rowSums(bit77diff.extra1^2))
    
    bit77extra <- cbind(bit77extra,bit77dist.extra1,bit77dist.extra2,bit77dist.extra3)
    colnames(bit77extra) <- c('D1','D2','D3','D4','D5','D6','dist1','dist2','dist3')

    # Stimulus 1 - around 1.95 to 2.05 to proto
    new7 <- bit77extra[bit77extra[,'dist2'] > 1.95 & bit77extra[,'dist2'] <
                       2.05,]
    # Difference to existing stimulus 1
    new7diff <- sweep(new7[,1:6],2,bit77[1,])
    new7dist <- sqrt(rowSums(new7diff^2))
    new7 <- cbind(new7,new7dist)
    # Order by that distance
    new7 <- new7[order(new7dist),]
    # Here's our extra stimuli from existing bit7.7 stimulus 2
    # Chosen to be maximally dissimilar to existing bit7.7 stimulus 2
    # Check against other protos [manual]
    new7[53,]
    # It's fine
    extras5 <- as.data.frame(cbind('cat2-H-extra-1',2,'new',7.7,
                                   t(new7[53,1:6])))
    colnames(extras5) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    
    # Stimulus 2 - around 2.1 to 2.2 to proto
    new8 <- bit77extra[bit77extra[,'dist2'] > 2.1 & bit77extra[,'dist2'] <
                       2.2,]
    # Difference to existing stimulus 2
    new8diff <- sweep(new8[,1:6],2,bit77[2,])
    new8dist <- sqrt(rowSums(new8diff^2))
    new8 <- cbind(new8,new8dist)
    # Order by that distance
    new8 <- new8[order(new8dist),]
    # Here's our extra stimuli from existing bit77 stimulus 4 Chosen
    # to be maximally dissimilar to existing bit77 stimulus 4
    new8[40,]
    
    extras6 <- as.data.frame(cbind('cat2-H-extra-2',2,'new',7.7,
                                   t(new8[40,1:6])))
    colnames(extras6) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    cat2extras <- rbind(extras1,extras2,extras3,extras5,
                        extras6)
    ####
    # And, finally, category 1
    # Needs 2 extra 4-bit for training, plus 2 for test
    # Needs 2 extra 6-bit
    # Needs 2 extra 7.7-bit
    ########
      # 4-bit distortions first
    bit4 <-  as.matrix(shin92exp2mds[shin92exp2mds$cat == 1 & shin92exp2mds$dist == 4, 5:10])
    bit4diff <- sweep(bit4,2,proto1)
    bit4dist <- sqrt(rowSums(bit4diff^2))
    # In fact, best to check against other protos also
    bit4diff3 <- sweep(bit4,2,proto3)
    bit4dist3 <- sqrt(rowSums(bit4diff3^2))
    bit4diff2 <- sweep(bit4,2,proto2)
    bit4dist2 <- sqrt(rowSums(bit4diff2^2))
    rbind(bit4dist,bit4dist2,bit4dist3)
    # All are closer to their own proto than the others

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
    # Dist to proto 3
    bit4diff.extra3 <- sweep(bit4extra,2,proto3)
    bit4dist.extra3 <- sqrt(rowSums(bit4diff.extra3^2))

    # Dist to proto 2
    bit4diff.extra2 <- sweep(bit4extra,2,proto2)
    bit4dist.extra2 <- sqrt(rowSums(bit4diff.extra2^2))

    # Dist to proto 1
    bit4diff.extra1 <- sweep(bit4extra,2,proto1)
    bit4dist.extra1 <- sqrt(rowSums(bit4diff.extra1^2))
    
    bit4extra <- cbind(bit4extra,bit4dist.extra1,bit4dist.extra2,bit4dist.extra3)
    colnames(bit4extra) <- c('D1','D2','D3','D4','D5','D6','dist1','dist2','dist3')

    # Stimulus 1 - around .9 to 1.0 to proto
    new1 <- bit4extra[bit4extra[,'dist1'] > 0.9 & bit4extra[,'dist1'] <
                      1,]
    # Difference to existing stimulus 1
    new1diff <- sweep(new1[,1:6],2,bit4[1,])
    new1dist <- sqrt(rowSums(new1diff^2))
    new1 <- cbind(new1,new1dist)
    # Order by that distance
    new1 <- new1[order(new1dist),]
    # Here are our 2 extra stimuli - chosen to largely be different to
    # the existing old, but also different to each other.
    # Proto dist check - OK:
    new1[c(3,16),]    
    id <- c('cat1-L-extra-1','cat1-L-extra-2')
    extras1 <- as.data.frame(cbind(id,1,'old',4.0,
                                   new1[c(3,16),1:6]))
    colnames(extras1) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 2 - around 0.5 to 0.7
    new3 <- bit4extra[bit4extra[,'dist1'] > 0.5 & bit4extra[,'dist1'] <
                      0.7,]
    # Difference to existing stimulus 2
    new3diff <- sweep(new3[,1:6],2,bit4[2,])
    new3dist <- sqrt(rowSums(new3diff^2))
    new3 <- cbind(new3,new3dist)
    # Order by that distance
    new3 <- new3[order(new3dist),]
    # Two new stimuli - chosen to be different to existing new, but
    # also to each other
    new3[c(6,23),]
    # Closer to own proto than others.
    id <- c('cat1-L-extra-3','cat1-L-extra-4')
    extras2 <- as.data.frame(cbind(id,1,'new',4.0,
                                   new3[c(6,23),1:6]))
    colnames(extras2) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # NOW... 6-bit distortions 
    bit6 <-  as.matrix(shin92exp2mds[shin92exp2mds$cat == 1 & shin92exp2mds$dist == 6, 5:10])
    bit6diff <- sweep(bit6,2,proto1)
    bit6dist <- sqrt(rowSums(bit6diff^2))

    # Distance from other protos
    bit6diff3 <- sweep(bit6,2,proto3)
    bit6dist3 <- sqrt(rowSums(bit6diff3^2))
    bit6diff2 <- sweep(bit6,2,proto2)
    bit6dist2 <- sqrt(rowSums(bit6diff2^2))
    # Manual check - closer to own proto than others?
    rbind(bit6dist,bit6dist2,bit6dist3)
    # Yes, 2nd approaching marginal, but stick with it.

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

    # Dist to proto 3 
    bit6diff.extra3 <- sweep(bit6extra,2,proto3)
    bit6dist.extra3 <- sqrt(rowSums(bit6diff.extra3^2))

    # Dist to proto 2
    bit6diff.extra2 <- sweep(bit6extra,2,proto2)
    bit6dist.extra2 <- sqrt(rowSums(bit6diff.extra2^2))

    # Dist to proto 1
    bit6diff.extra1 <- sweep(bit6extra,2,proto1)
    bit6dist.extra1 <- sqrt(rowSums(bit6diff.extra1^2))

    bit6extra <- cbind(bit6extra,bit6dist.extra1,bit6dist.extra2,bit6dist.extra3)
    colnames(bit6extra) <- c('D1','D2','D3','D4','D5','D6','dist1','dist2','dist3')


    
    # Stimulus 1 - around 0.8 to 1.2 to proto
    new5 <- bit6extra[bit6extra[,'dist1'] > 0.8 & bit6extra[,'dist1'] <
                      1.2,]
    # Difference to existing stimulus 1
    new5diff <- sweep(new5[,1:6],2,bit6[1,])
    new5dist <- sqrt(rowSums(new5diff^2))
    new5 <- cbind(new5,new5dist)
    # Order by that distance
    new5 <- new5[order(new5dist),]
    # Here's our extra stimuli from existing bit6 stimulus 1
    # Chosen to be maximally dissimilar to existing bit6 stimulus 1
    # Check against other protos
    new5[3,]
    # fine
    extras3 <- as.data.frame(cbind('cat1-M-extra-1',1,'new',6.0,
                                   t(new5[3,1:6])))
    colnames(extras3) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # Stimulus 2 - around 2.0 to 2.2 to proto
    new6 <- bit6extra[bit6extra[,'dist1'] > 2.0 & bit6extra[,'dist1'] <
                      2.2,]
    # Difference to existing stimulus 2
    new6diff <- sweep(new6[,1:6],2,bit6[2,])
    new6dist <- sqrt(rowSums(new6diff^2))
    new6 <- cbind(new6,new6dist)
    # Order by that distance
    new6 <- new6[order(new6dist),]
    # Here's our extra stimuli from existing bit6 stimulus 2
    # Chosen to be maximally dissimilar to existing bit6 stimulus 1
    # Check other protos
    new6[6,]
    extras4 <- as.data.frame(cbind('cat1-M-extra-2',1,'new',6.0,
                                   t(new6[6,1:6])))
    colnames(extras4) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    # NOW... 7.7-bit distortions 
    bit77 <-  as.matrix(shin92exp2mds[shin92exp2mds$cat == 1 & shin92exp2mds$dist == 7.7,
                              5:10])
    bit77diff <- sweep(bit77,2,proto1)
    bit77dist <- sqrt(rowSums(bit77diff^2))

    # Difference ot other protos
    bit77diff3 <- sweep(bit77,2,proto3)
    bit77dist3 <- sqrt(rowSums(bit77diff3^2))
    bit77diff2 <- sweep(bit77,2,proto2)
    bit77dist2 <- sqrt(rowSums(bit77diff2^2))
    # Manual check - closer to own proto than others
    rbind(bit77dist,bit77dist2,bit77dist3)
    # Argh reprise! The first one is closer to proto 2 than proto 1!
    shin92exp2mds[shin92exp2mds$cat == 1 & shin92exp2mds$dist == 7.7,]
    # Again, I don't want to delete this genuine MDS co-ordinate, but
    # it would also be wise not to build further examples from it.
       
    # Generate two from the second stimulus
    
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
    
    # Dist to proto 3
    bit77diff.extra3 <- sweep(bit77extra,2,proto3)
    bit77dist.extra3 <- sqrt(rowSums(bit77diff.extra3^2))

    # Dist to proto 2
    bit77diff.extra2 <- sweep(bit77extra,2,proto2)
    bit77dist.extra2 <- sqrt(rowSums(bit77diff.extra2^2))

    # Dist to proto 1
    bit77diff.extra1 <- sweep(bit77extra,2,proto1)
    bit77dist.extra1 <- sqrt(rowSums(bit77diff.extra1^2))
    
    bit77extra <- cbind(bit77extra,bit77dist.extra1,bit77dist.extra2,bit77dist.extra3)
    colnames(bit77extra) <- c('D1','D2','D3','D4','D5','D6','dist1','dist2','dist3')

    # Stimulus 2 - around 2.2 to 2.4 to proto
    new8 <- bit77extra[bit77extra[,'dist1'] > 2.2 & bit77extra[,'dist1'] <
                       2.4,]
    # Difference to existing stimulus 2
    new8diff <- sweep(new8[,1:6],2,bit77[2,])
    new8dist <- sqrt(rowSums(new8diff^2))
    new8 <- cbind(new8,new8dist)
    # Order by that distance
    new8 <- new8[order(new8dist),]
    # Here's our extra stimuli from existing bit77 stimulus 4 
    new8[3:4,]
    # They are bit similar to each other, but not much that can be
    # done about that - only 4 to choose from, and if they weren't
    # similar to each other they'd be similar to the existing one.
    id <- c('cat1-H-extra-1','cat1-H-extra-2')
    extras6 <- as.data.frame(cbind(id,1,'new',7.7,
                                   new8[3:4,1:6]))
    colnames(extras6) <- c('id','cat','type','dist','D1','D2','D3',
                           'D4','D5','D6')
    cat1extras <- rbind(extras1,extras2,extras3,extras4,extras6)
    # Now combine generated stimuli with the rest
    stims <- rbind(shin92exp2mds,cat1extras,cat2extras,cat3extras)
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
