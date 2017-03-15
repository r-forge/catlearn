# Tool for converting participant data into a fomat which can be read by slpRW
# The data is turned into the R-object 'tr' (function for 'st' also included)

# Set initial state (i.e. create st):
st <- list(lr = 0.09, w = rep(0, 5), 
           colskip = 3)

# Import data for one participant from csv:
partic <- read.csv("ply100_part1train.csv")

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

# Creates matrix for control column:
ctrl <- matrix(rep(0, 32), 
               nrow = 32, ncol = 1, byrow = TRUE,
               dimnames = list(c(),
                               c("ctrl")))

# Creates matrix for trial column:
trial <- matrix(c(1:32), 
                nrow = 32, ncol = 1, byrow = TRUE,
                dimnames = list(c(),
                                c("trial")))

# Creates matrix for trial within block:
trial_block <- matrix(rep(1:4, 8), 
                      nrow = 32, ncol = 1, byrow = TRUE,
                      dimnames = list(c(),
                                      c("trial_block")))

# Binds separate matrices together:
tr <- cbind(ctrl, trial, trial_block, tr)

# Sets the first ctrl column entry to one:
tr[1,1] = tr[1,1] + 1

# Clears environment of objects no longer required:
rm(ctrl, trial, trial_block, xrow, j)

# Is next step to make a loop for all participants together?
