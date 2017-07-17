nosof94oat <- function(dta, xtdo = FALSE) {
  
  #ag <- as.data.frame(cbind(c(1,1,1,1,2,2,2,2),c(1,2,3,4,1,2,3,4),
  #                          c(c(0.61,0.73,0.86,0.97),c(0.70,0.88,0.98,0.98))))
  #colnames(ag) <- c('pattern','block','corr')
  # Calculate mean accuracies
  ag <- aggregate(dta$corr,list(dta$pattern,dta$block),mean)
  colnames(ag) <- c('pattern','block','correct')
  # Do OAT
  oat <- TRUE
  p1 <- ag$corr[ag$pattern == 1]
  p2 <- ag$corr[ag$pattern == 2]
  # Type I
  if(!(p1[1] < p2[1])) oat <- FALSE
  if(!(p1[2] < p2[2])) oat <- FALSE
  if(!(p1[3] < p2[3])) oat <- FALSE
  if(!(p1[4] < p2[4])) oat <- FALSE
  
  # Return summary table or OAT?
  if(xtdo) {
    ret <- ag[order(ag$error),]
  } else {
    ret <- oat
  }
  return(ret)    
}
