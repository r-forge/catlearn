nosof92train <- function(blocks = 4, absval = -1, subjs = 1, seed = 7624) {
  
  n92train <- array(0,dim=c(9,11,1))
  colnames(n92train) <- c('stim','x1','x2','x3','x4','t1','t2',
                          'm1','m2','m3','m4')
  n92train[,,1] <- rbind(
    c(1,0,0,0,1,1,-1,0,0,0,0),
    c(2,0,1,0,1,1,-1,0,0,0,0),
    c(3,0,1,0,0,1,-1,0,0,0,0),
    c(4,0,0,1,0,1,-1,0,0,0,0),
    c(5,1,0,0,0,1,-1,0,0,0,0),
    c(6,0,0,1,1,-1,1,0,0,0,0),
    c(7,1,0,0,1,-1,1,0,0,0,0),
    c(8,1,1,1,0,-1,1,0,0,0,0),
    c(9,1,1,1,1,-1,1,0,0,0,0)
  )
  
  n92trans <- array(0,dim=c(16,11,1))
  colnames(n92train) <- c('stim','x1','x2','x3','x4','t1','t2',
                          'm1','m2','m3','m4')
  n92trans[,,1] <- rbind(
    c(1,0,0,0,1,1,-1,0,0,0,0),
    c(2,0,1,0,1,1,-1,0,0,0,0),
    c(3,0,1,0,0,1,-1,0,0,0,0),
    c(4,0,0,1,0,1,-1,0,0,0,0),
    c(5,1,0,0,0,1,-1,0,0,0,0),
    c(6,0,0,1,1,-1,1,0,0,0,0),
    c(7,1,0,0,1,-1,1,0,0,0,0),
    c(8,1,1,1,0,-1,1,0,0,0,0),
    c(9,1,1,1,1,-1,1,0,0,0,0),
    c(10,0,1,1,0,0,0,0,0,0,0),
    c(11,0,1,1,1,0,0,0,0,0,0),
    c(12,0,0,0,0,0,0,0,0,0,0),
    c(13,1,1,0,1,0,0,0,0,0,0),
    c(14,1,0,1,0,0,0,0,0,0,0),
    c(15,1,1,0,0,0,0,0,0,0,0),
    c(16,1,0,1,1,0,0,0,0,0,0)
  )
  
  biglist <- NULL
  for (subj in 1:subjs){
    for (blk in 1:blocks){
      makelist <- NULL
      trainblock <- rbind(n92train[,,1],n92train[,,1],n92train[,,1],
                          n92train[,,1],n92train[,,1],n92train[,,1],
                          n92train[,,1])
      trainblock <- trainblock[sample(nrow(trainblock)),]
      trainblock <- cbind(blk,trainblock)
      if (blk == 1){ctrl <- c(1,rep(0,nrow(trainblock)-1))}
      else {ctrl <- c(rep(0,nrow(transblock)))}
      trainblock <- cbind(ctrl,trainblock)
      
      transblock <- n92trans[,,1]
      transblock <- transblock[sample(nrow(transblock)),]
      transblock <- cbind(blk,transblock)
      ctrl <- c(rep(2,nrow(transblock)))
      transblock <- cbind(ctrl,transblock)
      
      makelist <- rbind(trainblock,transblock)
      biglist <- rbind(biglist,makelist)
    }
  }
  # If the value for category absence is not -1
  # change the list to reflect this
  if(absval != -1) {
    biglist[biglist[,'t1'] == -1,'t1'] <- absval
    biglist[biglist[,'t2'] == -1,'t2'] <- absval
  }
  return(biglist)
}