
# Start by importing data from csv:

partic1 <- read.csv("ply100_part1train.csv")

# Need a matrix which we can populate with data:

# Need to be able to read stim column from partic1 line by line
# Need if clause where binary representations are created in the
# partic_train matrix on the basis of the info being read from the
# data frame.

partic_train <- NULL

####Method of getting info from partic1 to binaries 
####in partic_train#############

for(j in 1:nrow(partic1)) {
  xrow <- partic1[j, ]
  if (xrow['stim'] == "A") {
    partic_train <- rbind(partic_train, c(1,0,0,0,0,1))
  } else if (xrow['stim'] == "AX") {
    partic_train <- rbind(partic_train, c(1,0,0,1,0,1))
  } else if (xrow['stim'] == "BY") {
    partic_train <- rbind(partic_train, c(0,1,0,0,1,1))
  } else if (xrow['stim'] == "CY") {
    partic_train <- rbind(partic_train, c(0,0,1,0,1,0))
  }
}
  
###########################################

#Let's give our columns sensible names:

colnames(partic_train) <- c("A", "B", "C", "X", "Y", "t")


# We will need a control column to instruct the model whether to
# learn normally, reset weights or stop learning (0, 1 & 2 
# respectively):
ctrl <- matrix(rep(0, 32), 
               nrow = 32, ncol = 1, byrow = TRUE,
               dimnames = list(c(),
                               c("ctrl")))

# A column detailing trial number is needed:
trial <- matrix(c(1:32), 
                nrow = 32, ncol = 1, byrow = TRUE,
                dimnames = list(c(),
                                c("trial")))

# A column detailing trial within block is needed:
trial_block <- matrix(rep(1:4, 8), 
                      nrow = 32, ncol = 1, byrow = TRUE,
                      dimnames = list(c(),
                                      c("trial_block")))

# This will all need combining together:
partic_train <- cbind(ctrl, trial, trial_block, partic_train)

# This sets the first ctrl column entry of each simulated participant
# to one, in order to reset the weights:
partic_train[1,1] = partic_train[1,1] + 1


# For the purpose of environmental hygiene, let's remove all the
# stuff we no longer need:

rm(ctrl, trial, trial_block, xrow, j)

# Is next step to make a loop for all participants together?
