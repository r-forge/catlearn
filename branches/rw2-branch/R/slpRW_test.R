# Need to create test data so that the model gives us predictions.

# Creating a matrix of stimuli we want to generate model predictions for:
test <- matrix(c(1, 0, 0, 0, 0, 0,
                 0, 1, 0, 0, 0, 0,
                 0, 0, 1, 0, 0, 0,
                 0, 0, 0, 1, 0, 0,
                 0, 0, 0, 0, 1, 0,
                 1, 1, 0, 0, 0, 0,
                 1, 0, 1, 0, 0, 0,
                 1, 0, 0, 1, 0, 0,
                 1, 0, 0, 0, 1, 0,
                 0, 1, 1, 0, 0, 0,
                 0, 1, 0, 1, 0, 0,
                 0, 1, 0, 0, 1, 0,
                 0, 0, 1, 1, 0, 0,
                 0, 0, 1, 0, 1, 0,
                 0, 0, 0, 1, 1, 0),
               nrow = 15, ncol = 6, byrow = TRUE,
               dimnames = list(c("A", "B", "C", "X", "Y", "AB", 
                                 "AC", "AX", "AY", "BC", "BX", "BY", 
                                 "CX", "CY", "XY"),
                               c("A", "B", "C", "X", "Y", "t")))

# As before we need the control column:
ctrl <- matrix(rep(2, 15), 
               nrow = 15, ncol = 1, byrow = TRUE,
               dimnames = list(c(),
                               c("ctrl")))

# A column detailing trial number is needed:
trial <- matrix(c(1:15), 
                nrow = 15, ncol = 1, byrow = TRUE,
                dimnames = list(c(),
                                c("trial")))

# A dummy column for participant number is needed:
ppnt <- matrix(rep(0, 15), 
               nrow = 15, ncol = 1, byrow = TRUE,
               dimnames = list(c(),
                               c("partic")))

# Let's combine all of this together:
test <- cbind(ctrl, ppnt, trial, test)

# For the purpose of environmental hygiene, let's remove all the
# stuff we no longer need:
rm(ctrl, ppnt, trial)


ppts <- 40
tr.test <- NULL
for (i in unique(tr[,"partic"])){ 
  tr.test <- rbind(tr.test,tr[tr[ ,"partic"] == i,], test)
}

# Tidy up environment:
rm(test, ppts, i)

# Boom!