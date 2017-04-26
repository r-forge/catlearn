# E+K1998 training matrix function

ek1998train <- function(blocks,absval,rep,ppts,tlimit,learning){
  ek1998 <- array(0,dim=c(14,9))
  colnames(ek1998) <- c('stim','x1','x2','t1','t2','t3','t4','m1','m2')
  
  ek1998[,] <- rbind(
    c(1,4,1,1,-1,-1,-1,0,0),
    c(2,1,4,1,-1,-1,-1,0,0),
    c(3,3,5,1,-1,-1,-1,0,0),
    c(4,2,7,1,-1,-1,-1,0,0),
    c(5,4,8,1,-1,-1,-1,0,0),
    c(6,5,1,-1,1,-1,-1,0,0),
    c(7,7,2,-1,1,-1,-1,0,0),
    c(8,6,4,-1,1,-1,-1,0,0),
    c(9,8,5,-1,1,-1,-1,0,0),
    c(10,5,8,-1,1,-1,-1,0,0),
    c(11,2,2,-1,-1,1,-1,0,0),
    c(12,2,2,-1,-1,1,-1,0,0),
    c(13,7,7,-1,-1,-1,1,0,0),
    c(14,7,7,-1,-1,-1,1,0,0)
  )
  if (rep == TRUE){reset <- 0}
  else{reset <- 1}
  makelist <- NULL
  fmakelist <- NULL
  for (i in 1:ppts){
    for(blk in 1:blocks) { 
      # Load trials for one block
      block <- ek1998[,]
      block <- block[sample(nrow(block)),]
      block <- cbind(blk,block)
      makelist <- rbind(makelist,block)
    }
    makelist <- makelist[1:tlimit,]
    ctrl <- c(reset,rep(learning,nrow(makelist)-1))
    makelist <- cbind(ctrl,makelist)
    fmakelist <- rbind(fmakelist,makelist)
    makelist <- NULL
  }
  
  # If the value for category absence is not -1
  # change the list to reflect this
  if(absval != -1) {
    fmakelist[fmakelist[,'t1'] == -1,'t1'] <- absval
    fakelist[fmakelist[,'t2'] == -1,'t2'] <- absval
  }
  
  return(fmakelist)
}



ek1998trans <- function(blocks,ppts,tlimit,learning){
  ek1998 <- array(0,dim=c(50,3))
  colnames(ek1998) <- c('stim','x1','x2')
  
  ek1998[,] <- rbind(
    c(1,5,0),
    c(2,5,1),
    c(3,5,2),
    c(4,5,3),
    c(5,5,4),
    c(6,5,5),
    c(7,5,6),
    c(8,5,7),
    c(9,5,8),
    c(10,5,9),
    c(11,6,0),
    c(12,6,1),
    c(13,6,2),
    c(14,6,3),
    c(15,6,4),
    c(16,6,5),
    c(17,6,6),
    c(18,6,7),
    c(19,6,8),
    c(20,6,9),
    c(21,7,0),
    c(22,7,1),
    c(23,7,2),
    c(24,7,3),
    c(25,7,4),
    c(26,7,5),
    c(27,7,6),
    c(28,7,7),
    c(29,7,8),
    c(30,7,9),
    c(31,8,0),
    c(32,8,1),
    c(33,8,2),
    c(34,8,3),
    c(35,8,4),
    c(36,8,5),
    c(37,8,6),
    c(38,8,7),
    c(39,8,8),
    c(40,8,9),
    c(41,9,0),
    c(42,9,1),
    c(43,9,2),
    c(44,9,3),
    c(45,9,4),
    c(46,9,5),
    c(47,9,6),
    c(48,9,7),
    c(49,9,8),
    c(50,9,9)
  )
  makelist <- NULL
  fmakelist <- NULL
  for (i in 1:ppts){
    for(blk in 1:blocks) { 
      # Load trials for one block
      block <- ek1998[,]
      block <- block[sample(nrow(block)),]
      block <- cbind(blk,block)
      makelist <- rbind(makelist,block)
    }
    makelist <- makelist[1:tlimit,]
    ctrl <- c(rep(learning,nrow(makelist)))
    makelist <- cbind(ctrl,makelist)
    fmakelist <- rbind(fmakelist,makelist)
    makelist <- NULL
  }
  return(fmakelist)
}
