#slpRW

#st and tr as inputs into slpRW function.
#Also includes option for extended output - set to TRUE if required,
#otherwise it defaults to false:
slpRW <- function(st, tr, xtdo = FALSE) {

  #Need something for the outputs to go into (n.b. xout refers
  #to extended output):
  out <- NULL
  xout <- NULL
  
  #Need to unpack what is contained within st list:
  lr.m <- st$lr # learning rate
  w.m <- st$w #vector of stimuli weights
  colskip.m <- st$colskip #columns to skip before stimuli columns
  
  #Runs loop for however many rows are contained within input matrix:
  for(i in 1:nrow(tr)) {
    #Data is pulled out of each row in turn:
    arow <- tr[i, ]
    
    #Designates number of columns (i.e. length of vector) containing 
    #weights of stimuli:
    nw <- length(w.m)
    
    #Model needs to reset initial wieghts each time there is a change
    #in participant; as inticated in 'ctrl' column of input matrix:
    if (arow['ctrl'] == 1) {
      w.m <- st$w 
      }
    
    #Teacher on/off acts as lambda within this model i.e. 1 or 0:
    lambda <- arow['t'] 
    
    #This creates a vector of activations by reading the contents of the
    #stimuli colums within input matrix:
    a <- arow[(colskip.m + 1):(colskip.m + nw)] 
  
    #This is the RW equation - where delta is change in assoc strength:
    suma <- sum(a*w.m)
  
    delta <- lr.m * (lambda - suma)
    
    #New weights are weights plus delta; unless 'ctrl' column contains
    #value of '2' in which case weights remain the same:
    if (arow['ctrl'] != 2) { 
      w.m <- w.m + delta * a
    }

    #Output for each loop added to output from previous loops:
    out <- rbind(out, suma)
    xout <- rbind(xout, w.m)
 }

 #Data that model outputs (incl if/else clause for extended output):
  if(xtdo==TRUE) {
    ret <- list(out = out, xout = xout, st = w.m)
  } else {
    ret <- list(out = out, st = w.m)
  }
 ret
}