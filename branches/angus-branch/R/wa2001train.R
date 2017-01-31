# Function to generate a matrix containing initial synapse strength 
# stims - Number of sensory cortex units
# cats - Number of striatal units
# Checked: AI 27/09/2016
# Checked: AW 28/09/2016

symat <- function(stims,cats){
  smat = matrix(0,nrow=stims,ncol=cats,byrow = TRUE)
  for(i in 1:cats){
    for(j in 1:stims){
      U <- runif(1,0,1)
      smat[j,i] <- 0.001 + (0.0025 * U)
    }
  }
  return(smat)
}



# Function to get striatal cortical unit values from 
# training matrix or from randomly sampled triplets
# Contains options for either giving the units exact
# stimulus values or sampling randomly

# stims: Number of sensory cortex units 
# dims: Dimensionality of stimulus space

# Checked: AI 27/09/2016
# Not really checked that much : AW 28/09/2016

scumat <- function(stims, dims, colskip, complex, tr){
  valmat = matrix(stims,dims)
  if (complex == 0)
  {
    valmat = tr[1:stims,(colskip+1):(colskip+dims)]
  }
  else
  {
    for(i in 1:dims){
      for(j in 1:stims){
        X <- runif(1,0,1)
        valmat[j,i] <- X
      }
    }
  }
  return(valmat)
}

# This function generates training trials for Wladron and Ashby 2001
# problem = rule-based or information-integration
# blocks = number of blocks to generate
# absval = variable for checking category absence value
wa2001train <- function(problem,blocks,absval,learning,ppts,tlimit = 16*blocks,
                        rep){
  wa2001 <- array(0,dim=c(16,10,2))
  colnames(wa2001) <- c('stim','x1','x2','x3','x4','t1','t2','m1','m2','m3')
  
  wa2001[,,1] <- rbind( # Rule-Based
    c(1,0,0,0,0,1,-1,0,0,0),
    c(2,0,0,0,1,1,-1,0,0,0),
    c(3,0,0,1,0,1,-1,0,0,0),
    c(4,0,1,0,0,1,-1,0,0,0),
    c(5,0,0,1,1,1,-1,0,0,0),
    c(6,0,1,0,1,1,-1,0,0,0),
    c(7,0,1,1,0,1,-1,0,0,0),
    c(8,0,1,1,1,1,-1,0,0,0),
    c(9,1,1,1,1,-1,1,0,0,0),
    c(10,1,1,1,0,-1,1,0,0,0),
    c(11,1,1,0,1,-1,1,0,0,0),
    c(12,1,0,1,1,-1,1,0,0,0),
    c(13,1,1,0,0,-1,1,0,0,0),
    c(14,1,0,1,0,-1,1,0,0,0),
    c(15,1,0,0,1,-1,1,0,0,0),
    c(16,1,0,0,0,-1,1,0,0,0)
  )
  wa2001[,,2] <- rbind( # Information-Integration
    c(1,0,0,0,0,1,-1,0,0,0),
    c(2,0,0,0,1,1,-1,0,0,0),
    c(3,0,0,1,0,1,-1,0,0,0),
    c(4,0,1,0,0,1,-1,0,0,0),
    c(5,0,0,1,1,1,-1,0,0,0),
    c(6,0,1,0,1,1,-1,0,0,0),
    c(7,0,1,1,0,-1,1,0,0,0),
    c(8,0,1,1,1,-1,1,0,0,0),
    c(9,1,1,1,1,-1,1,0,0,0),
    c(10,1,1,1,0,-1,1,0,0,0),
    c(11,1,1,0,1,-1,1,0,0,0),
    c(12,1,0,1,1,-1,1,0,0,0),
    c(13,1,1,0,0,-1,1,0,0,0),
    c(14,1,0,1,0,-1,1,0,0,0),
    c(15,1,0,0,1,1,-1,0,0,0),
    c(16,1,0,0,0,1,-1,0,0,0)
  )
  if (rep == TRUE){reset <- 0}
  else{reset <- 1}
  makelist <- NULL
  fmakelist <- NULL
  for (i in 1:ppts){
  for(blk in 1:blocks) { 
    # Load trials for one block
    block <- wa2001[,,problem]
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






