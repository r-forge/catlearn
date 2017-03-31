# Data for each participant - mean rating by cue by participant
# For one participant - 15 cues. Need to generate these 15 numbers from model.

# Need to get model to generate this 15 - just pick a learning rate
# Need to use same trial order as participant experienced

ppts <- 40                         # Define your number of participants here
trials <- 32                       # Define your number of trials here

w.all <- output$xout               # Weights for all participants extracted

w.indiv <- NULL                    # Create object for individual participant weights

# Extract final weights by partic
fin.w <- w.all[seq(trials, nrow(w.all), by = trials),]

# Need to extract weights for each participant (40 blocks of 32)
#for (pi in 1:ppts(w.all))
  #apart <- 
  
# Need to extract the final weights from each block of 32 and bind together  
#for (fi in 1:nrow(w.all)) {
  #frow <- w.all[trials, ]
  #w.indiv <- rbind(w.indiv, frow)
#}
  
