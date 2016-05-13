homa76train <- function(condition = 'mixed', learn.blocks = 1,
                        trans.blocks = 1, absval = -1) {
    # Load estimated MDS
    stims <- homa76ipolate()
    # Add category labels
    stims$t1 <- -1
    stims$t2 <- -1
    stims$t3 <- -1
    stims$t1[stims$cat == 1] <- 1
    stims$t2[stims$cat == 2] <- 1
    stims$t3[stims$cat == 3] <- 1
    # Add 'missing dim' tags
    stims$m1 <- 0
    stims$m2 <- 0
    stims$m3 <- 0
    stims$m4 <- 0
    stims$m5 <- 0
    stims$m6 <- 0
    # Select training stims
    train <- stims[stims$type == 'old',]
    # uni-low training stimuli
    train.ul <- train[train$dist == 4,]
    train.ul <- train.ul[order(train.ul$cat),]
    train.ul.mdl <- as.matrix(cbind(train.ul$cat,3,train.ul$dist,1:18,
                                    train.ul[,5:19]))
    colnames(train.ul.mdl) <- c('cat','type','dist','stim','D1','D2',
                                'D3', 'D4','D5', 'D6','t1','t2','t3',
                                'm1','m2','m3','m4','m5','m6')
    rownames(train.ul.mdl) <- NULL
    # mixed training stimuli
    train.mix <- train[1:18,]
    train.mix.mdl <- as.matrix(cbind(train.mix$cat,3,
                                     train.mix$dist,1:18,
                                     train.mix[,5:19]))
    colnames(train.mix.mdl) <- c('cat','type','dist','stim','D1','D2',
                                'D3', 'D4','D5', 'D6','t1','t2','t3',
                                'm1','m2','m3','m4','m5','m6')
    rownames(train.mix.mdl) <- NULL
    # test new stimuli
    new <- stims[stims$type == 'new',]
    new.mdl <- as.matrix(cbind(new$cat,1,new$dist,1:27,new[,5:19]))
    colnames(new.mdl) <- c('cat','type','dist','stim','D1','D2',
                                'D3', 'D4','D5', 'D6','t1','t2','t3',
                                'm1','m2','m3','m4','m5','m6')
    rownames(new.mdl) <- NULL
    # test protos
    protos <- stims[stims$type == 'proto',]
    protos.mdl <- as.matrix(cbind(protos$cat, 2, protos$dist, 1:3,
                                  protos[,5:19]))
    colnames(protos.mdl) <- c('cat','type','dist','stim','D1','D2', 'D3',
                           'D4','D5', 'D6','t1','t2','t3', 'm1','m2',
                           'm3','m4','m5','m6')
    rownames(protos.mdl) <- NULL
    # test old - in mixed condition
    
    # 'one of each level for each category' - p.324
    # This is awkward, as there's no obvious way to
    # choose which stimuli to use. Pick those most
    # typical in terms of distance to prototype.
    # This is calculated in homa76ipolate.R and
    # manually added here:
    # cat 3, bit 4
    #       19        20        21         
    # 0.3623176 1.4790678 0.9782909 
    # cat 3, bit 6
    #       22       23       24        
    # 1.374440 2.560468 2.743945 
    # cat 3, bit 77
    #       25       26       27        
    # 3.395832 2.803322 1.884498 
    # cat 2, bit 4
    #         9        10         
    # 2.7376661 0.8685619
    # cat 2, bit 6
    #       11       12        
    # 1.968816 4.002815
    # cat 2, bit 77
    #       13       14  
    # 2.013126 2.151805 

    # cat3, L - A2-cat3-OL-3
    # cat3, M - A2-cat3-OM-2
    # cat3, H - A2-cat3-OH-2
    # cat2, L - A2-cat2-OL-2
    # cat2, M - A2-cat2-OM-1
    # cat2, H - A2-cat2-OH-2
    # cat1, L - A2-cat1-OL
    # cat1, M - A2-cat1-OM
    # cat1, H - A2-cat1-OH

    old.mix <- train.mix[train.mix$id %in% c('A2-cat3-OL-3',
                                           'A2-cat3-OM-2',
                                           'A2-cat3-OH-2',
                                           'A2-cat2-OL-2',
                                           'A2-cat2-OM-1',
                                           'A2-cat2-OH-2',
                                           'A2-cat1-OL',
                                           'A2-cat1-OM',
                                           'A2-cat1-OH'),]
    old.mix.mdl <- as.matrix(cbind(old.mix$cat,3,
                                   old.mix$dist,1:9,
                                   old.mix[,5:19]))
    colnames(old.mix.mdl) <- c('cat','type','dist','stim','D1','D2',
                               'D3', 'D4','D5', 'D6','t1','t2','t3',
                               'm1','m2', 'm3','m4','m5','m6')
    rownames(old.mix.mdl) <- NULL

    # test old stimuli in uni-low condition
    # '3 low-level distortions of each of the categories'
    # cat 3 - Use all the non-interpolated stimuli
    # cat 2 - Use the 2 non-interpolated plus extra-1
    # (most suitable as it's generated from a typical old and is
    # maximally distant from that old
    # cat 1 - use non-interpolated oldstimulus, and both interpolated
    # created from this old.

    pick <- c('A2-cat3-OL-1','A2-cat3-OL-2','A2-cat3-OL-3',
              'A2-cat2-OL-1','A2-cat2-OL-2', 'cat2-L-extra-1',
              'A2-cat1-OL','cat1-L-extra-1','cat1-L-extra-2')
    
    old.ul  <- train.ul[train.ul$id %in% pick,]
    old.ul.mdl <- as.matrix(cbind(old.ul$cat,3,
                                   old.ul$dist,1:9,
                                   old.ul[,5:19]))
    colnames(old.ul.mdl) <- c('cat','type','dist','stim','D1','D2',
                              'D3', 'D4','D5', 'D6','t1','t2','t3',
                              'm1','m2', 'm3','m4','m5','m6')
    rownames(old.ul.mdl) <- NULL

    ## OK, stimuli generated - now make lists
    
    # Code condition as number                    
    cond <- switch(condition, "mixed" = 1, "uni-low" = 2)
    # Set training block according to condition
    train.out <- switch(condition, "mixed" = train.mix.mdl,
                        "uni-low" = train.ul.mdl)
    # Set tst block according to condition
    test <- switch(condition, "mixed" = rbind(new.mdl, protos.mdl,
    old.mix.mdl), "uni-low" = rbind(new.mdl, protos.mdl,old.ul.mdl)) 

    # Build list
    makelist <- NULL
    makelist2 <- NULL
    # Training phase
    if(learn.blocks > 0) {    
        phase <- 1
        for(blk in 1:learn.blocks) {
            block <- cbind(cond,phase,blk,train.out)
            block <- block[sample(nrow(block)),]
            makelist <- rbind(makelist,block)
        }    
        ctrl <- c(1,rep(0,nrow(makelist)-1))
        makelist <- cbind(ctrl,makelist)
    }
    # Test phase
    if(trans.blocks > 0) {
        phase <- 2
        for(blk in 1:trans.blocks) {
            block <- cbind(cond,phase,blk,test)
            block <- block[sample(nrow(block)),]
            makelist2 <- rbind(makelist2,block)
        }    
        ctrl <- 2
        makelist2 <- cbind(ctrl,makelist2)
    }
    # Combine the two
    makelist <- rbind(makelist,makelist2)
    # If the value for category absence is not -1
    # change the list to reflect this
    if(absval != -1) {
        makelist[makelist[,'t1'] == -1,'t1'] <- absval
        makelist[makelist[,'t2'] == -1,'t2'] <- absval
        makelist[makelist[,'t3'] == -1,'t3'] <- absval
    }
    return(makelist)
}
