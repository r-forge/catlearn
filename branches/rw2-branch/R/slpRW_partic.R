# Tool for converting Redundancy Effect participant data into a format which 
# can be read by slpRW. The data is turned into the R-object 'tr' (function 
# for 'st' also included)

# # # Instructions # # #
# Data in the top section needs to be filled in by user.
# Use comments for guidance.
# Everything in bottom section section runs automatically & requires no editing.

# Set initial state "st" (learning rate, weights matrix, & desired colskip):
st <- list(lr = 0.09, w = rep(0, 5), 
           colskip = 2)

# Define number of participants:
ppts <- 40

# Define number of training trials for one participant:
ntr.1 <- 32

# Import data for one participant from csv:
partic <- read.csv("ply100traindata.csv") # Name + location for file of choice

#################################################################

# Define number of training trials for all particpants:
ntr.all <- ppts*ntr.1

# Need a matrix which we can populate with data:
tr <- NULL

# Converting data from stim column in partic to binary representation:
for(j in 1:nrow(partic)) {          # Loop reads row by row in partic
  xrow <- partic[j, ]               # Extracts current row within loop
  if (xrow['stim'] == "A") {        # Converts A to binary representation
    tr <- rbind(tr, c(1,0,0,0,0,1)) 
  } else if (xrow['stim'] == "AX") {                    # Converts AX
    tr <- rbind(tr, c(1,0,0,1,0,1))
  } else if (xrow['stim'] == "BY") {                    # Converts BY
    tr <- rbind(tr, c(0,1,0,0,1,1))
  } else if (xrow['stim'] == "CY") {                    # Converts CY
    tr <- rbind(tr, c(0,0,1,0,1,0))
  }
}
  
# Provides standard names for columns:
colnames(tr) <- c("A", "B", "C", "X", "Y", "t")

# Creates object for control matrix:
ctrl <- NULL

# Creates matrix for trial column:
trial <- matrix(rep(1:ntr.1, ppts), 
                nrow = ntr.all, ncol = 1, byrow = TRUE,
                dimnames = list(c(),
                                c("trial")))

# Binds separate matrices together:
tr <- cbind(trial, tr)

for(l in 1:nrow(tr)) {          # Loop reads tr row by row
  yrow <- tr[l, ]               # Extracts current row
  if (yrow["trial"] == 1) {     # Sets ctrl to 1 if at first trial
    ctrl <- rbind(ctrl, 1) 
  } else {                      # Otherwise sets ctrl to 0
    ctrl <- rbind(ctrl, 0)
  }
}

# Binds separate matrices together:
tr <- cbind(ctrl, tr)

# Clears environment of objects no longer required:
rm(partic, ctrl, trial, trial_block, xrow, j, l, ntr.1, ntr.all, ppts, yrow)

# Bosh!!!