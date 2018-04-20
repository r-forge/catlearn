## catlearn simulation of Nosofsky et al. (1994) with slpSUSTAIN

source('../R/nosof94plot.R') # unchanged from trunk
source('../R/slpSUSTAIN-tidy.R') # new to branch
source('../R/nosof94train.R') # updated in branch
source('../R/nosof94sustain.R') # new to branch

love.res <- read.csv("sustain-nosof94-love2004-tidied.csv")
nosof94plot(love.res)
gureck.res <- read.table("shepard1-1000runs.dat", sep = " ")
gureck.res <- t(gureck.res)

out <- nosof94sustain()
nosof94plot(out)

## The following code is a bit of a hack to handle the way the Love et
## al. simulation handles the 'to-criterion' aspect of the experiment.

load('rawout.RData')
out$rnd <- runif(nrow(out))
out$corr <- 0
out$corr[out$pc < out$rnd] <- 1
out$subj <- rep(1:600, each = 256)
out$subblk <- rep(1:32, each = 8)
out.tc <- aggregate(out$corr, list(out$subblk, out$cond, out$subj), sum)
colnames(out.tc) <- c('subblk', 'cond', 'subj', 'ncor')

btc <- NULL
for(j in 1:600) {
    ncblk <- 0
    for(i in 1:32) {
        pos <- (j-1) * 32 + i
        if(out.tc$ncor[pos] == 8) {
            ncblk <- ncblk + 1
        } else {
            ncblk <- 0
        }
        if(ncblk == 4) {
            btc <- rbind(btc, out.tc[pos,])
            break
        }
    }
}

out.ag <- aggregate(out$pc, list(out$blk, out$subblk, out$cond, out$subj), mean)
colnames(out.ag) <- c('blk','subblk', 'cond', 'subj', 'error')

for(i in 1:600) {
    first <- btc$subblk[i]
    out.ag$error[out.ag$subj == i & out.ag$subblk > btc$subblk[i]] <- 0
}

out.ag.f <- aggregate(out.ag$error,list(out.ag$blk,out.ag$cond),mean)
colnames(out.ag.f) <- c('block','type','error')
nosof94plot(out.ag.f) 



    
    
        
        
    
    

##############

## Simple script to run sustain on nosof94 shepard rep
source('../R/slpSUSTAIN-tidy.R')
## nosof94train Version in this branch is newer than on trunk, so load
source('../R/nosof94train.R') 

## Parameters are the same for all six problems
st <- list(r = 9.01245,
           beta = 1.252233,
           d = 16.924073,
           eta = 0.092327,
           tau = 0.0,
           lambda = c(1, 1, 1),
           dims = c(2, 2, 2),
           cluster = NA,
           w = NA,
           colskip = 4)


tr <- nosof94train(cond = 2, blocks = 32, missing = 'pad', absval = 0,
                   blkstyle = 'eights')

out <- slpSUSTAIN(st, tr, xtdo = FALSE)
out


#### Code for checking stateful aspect of function.
st <- list(r = 9.01245,
           beta = 1.252233,
           d = 16.924073,
           eta = 0.092327,
           tau = 0.0,
           lambda = out$lambda,
           dims = c(2, 2, 2),
           cluster = out$cluster,
           w = out$w,
           colskip = 4)

out2 <- slpSUSTAIN(st, tr.me, xtdo = FALSE)
out2
#######

