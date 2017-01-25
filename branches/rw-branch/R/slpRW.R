#slpRW

#st and tr as inputs into slpRW function:
slpRW <- function(st, tr) {

  #Need something for the output to go into:
  out <- NULL
  
  #Need to unpack what is contained within st list:
  alpha.m <- st$alpha #value of alpha
  beta.m <- st$beta # value of beta
  w.m <- st$w #vector of stimuli weights
  colskip.m <- st$colskip #columns to skip before stimuli columns
  
  #Runs loop for however many rows are contained within input matrix:
  for(i in 1:nrow(tr)) {
    #Data is pulled out of each row in turn:
    arow <- tr[i,]
    
    #Designates number of columns (i.e. length of vector) containing 
    #weights of stimuli:
    nw <- length(w.m)
    
    #Model needs to reset iniial wieghts each time there is a change
    #in participant; as inticated in 'ctrl' column of input matrix:
    if (arow[, 'ctrl'] == 1) {
      w.m <- st$w 
      }
    
    #Teacher on/off acts as lambda within this model i.e. 1 or 0:
    lambda <- arow['t'] 
    
    #This creates a vector of activations by reading the contents of the
    #stimuli colums within input matrix:
    a <- arow[(colskip.m + 1):(colskip.m + nw)] 
    
    #This is the RW equation - where delta is change in assoc strength:
    suma <- sum(a*w.m)
    
    delta <- alpha.m * beta.m * (lambda - suma)
    
    #New weights are weights plus delta; unless 'ctrl' column contains
    #value of '2' in which case weights remain the same:
    if (arow['ctrl'] != 2) { 
      w.m <- w.m + delta 
    }

    #Output for each loop added to output from previous loops:
    out <- rbind(out, suma)

    #n.b. could also include weights on each trial as an extended output.
  
 }

 #Data that model outputs:
 ret <- list(out = out, st = w.m)
 
}
