
# Start by importing data from csv:

partic1 <- read.csv("ply100_part1train.csv")


# Need a matrix which we can populate with data:

partic_train <- matrix(rep(0, 192), 
                       nrow = 32, ncol = 6, byrow = TRUE,
                       dimnames = list(c(),
                                       c("A", "B", "C", "X", "Y", "t")))

# Need to be able to read stim column from partic1 line by line
# Need if clause where binary representations are created in the
# partic_train matrix on the basis of the info being read from the
# data frame.

for()
  
################adapt from this###########  
if partic1$stim == "A"


for(i in 1:nrow(tr)) {         # Run training loop
  arow <- tr[i, ]            # extract current trial
  if (arow['ctrl'] == 1) {   # Reset weights?
    w.m <- st$w
  }
###########################################