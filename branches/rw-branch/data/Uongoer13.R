# Import the data from CSV file containing experimental data
# Data is from a redundancy effect experiment, as first shown in
# humans by Uengoer et al 2013:

Uengoer13 <- read.csv ("data/trainingdata.csv")


# Tidying up the info in Uengoer13 to make it suitable for use with 
# the slpRW model:

Uengoer13 <- Uengoer13[,c('subj','trial', 'stim','resp','outcome')]

colnames(Uengoer13) <- c('partic','trial','stimtype','resp','corrans')



# Code for removing data (already done as part of pre-processing)


#Uengoer13 <- Uengoer13[Uengoer13$phase %in% 1,]

#Uengoer13 <- Uengoer13[Uengoer13$phase == 1,]


# Need to just look at means for each participant? Also need to match
# up the terminology used in some cells e.g. for ache/noache...