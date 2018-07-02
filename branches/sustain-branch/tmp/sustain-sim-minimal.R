## Minimal simulation to track down differences to sustain_python
## Simulates one eight-trial block of SHJ Type 1.

source('../R/nosof94train.R')
source('../R/slpSUSTAIN-tidy.R')

params = c(9.01245, 1.252233, 16.924073, 0.092327)

## Use same order as sustain_python
t1 <- rbind(c(0,1,0,1,0,1,0,1),
      c(0,1,0,1,1,0,0,1), 
      c(0,1,1,0,0,1,0,1), 
      c(0,1,1,0,1,0,0,1), 
      c(1,0,0,1,0,1,1,0), 
      c(1,0,0,1,1,0,1,0), 
      c(1,0,1,0,0,1,1,0), 
      c(1,0,1,0,1,0,1,0))

t1 <- rbind(t1,t1)

## Create other cols needed by slp
bigtr <- nosof94train(1, blocks = 2, absval = 0, blkstyle = "eights",
                      missing = 'pad', subjs = 100, seed = 7624)
bigtr <- bigtr[1:16,1:4]
bigtr <- cbind(bigtr,t1)
colnames(bigtr) <- c('ctrl', 'cond', 'blk', 'stim', 'x1', 'x2', 'y1',
                     'y2', 'z1', 'z2', 't1', 't2')

init.state <- list(r = params[1], beta = params[2], d = params[3], eta = params[4],
                   tau = 0.0, lambda = c(1, 1, 1), dims = c(2, 2, 2), cluster = NA,
                   w = NA, colskip = 4)

out <- slpSUSTAIN(init.state,bigtr, xtdo=TRUE)

outp <- out$xtdo[,1:2] # Strip out final state info
    ## Combine output to training list
colnames(outp) <- c('p1','p2')
outp <- data.frame(cbind(bigtr,outp))
    ## Calculate response accuracy
outp$pc <- 0
outp$pc[outp$t1 == 1] <- outp$p1[outp$t1 == 1]
outp$pc[outp$t2 == 1] <- outp$p2[outp$t2 == 1]

# Errors
1 - mean(outp$pc)


##########

    ## Combine output to training list
colnames(outp) <- c('p1','p2')
outp <- data.frame(cbind(bigtr,outp))
    ## Calculate response accuracy
outp$pc <- 0
outp$pc[outp$t1 == 1] <- outp$p1[outp$t1 == 1]
outp$pc[outp$t2 == 1] <- outp$p2[outp$t2 == 1]
    ## Convert to error rate
outp$pc <- 1 - outp$pc
out.ag <- aggregate(outp$pc,list(outp$blk,outp$cond),mean)
colnames(out.ag) <- c('block','type','error')

## Convert to error rate
outp$pc <- 1 - outp$pc



#############
