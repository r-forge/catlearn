# TR ###

# Need to create the training matrix output (tr)
# Also need to define number of participants (ppts):

tr <- NULL
ppts <- 2

# Using a for loop, we can set the process for one simulated
# participant to repeat for as many participants as we have
# specified above:

for (run in 1:ppts){

  # This creates a matrix containing the basic experimental design
  # (i.e. input activations for each set of training stimli plus
  # a final t column representing outcome/no outcome):
  train <- matrix(c(1, 0, 0, 0, 0, 1,
                    1, 0, 0, 1, 0, 1,
                    0, 1, 0, 0, 1, 1,
                    0, 0, 1, 0, 1, 0), 
              nrow = 4, ncol = 6, byrow = TRUE,
              dimnames = list(c(),
                              c("A", "B", "C", "X", "Y", "t")))

  # Next we need to replicate and bind this to account for the
  # x8 trials:
  train <- do.call(rbind, replicate(8, train, simplify=FALSE))

  # Next we need to randomize the order in which then 32 training
  # trials appear:
  train <- train[sample(nrow(train)),]

  # We will need a control column to instruct the model whether to
  # learn normally, reset weights or stop learning (0, 1 & 2 
  # respectively):
  ctrl <- matrix(rep(0, 32), 
               nrow = 32, ncol = 1, byrow = TRUE,
               dimnames = list(c(),
                               c("ctrl")))

  # A column detailing block is needed:
  block <- matrix(rep(1:4, 8), 
               nrow = 32, ncol = 1, byrow = TRUE,
               dimnames = list(c(),
                               c("block")))

  # Now let's bind all the above together:
  train <- cbind(ctrl, block, train)

  ###############################################################

  # We also need the test stage trials, which we will shortly 
  # bind to the bottom of the matrix.

  # The first section repeats the previous process for the
  # test trials:
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
                 dimnames = list(c(),
                               c("A", "B", "C", "X", "Y", "t")))
  test <- do.call(rbind, replicate(12, test, simplify=FALSE))
  test <- test[sample(nrow(test)),]

  # As before we need the control column:
  ctrlb <- matrix(rep(2, 180), 
                  nrow = 180, ncol = 1, byrow = TRUE,
                  dimnames = list(c(),
                                  c("ctrl")))

  # As before the block column in needed:
  blockb <- matrix(rep(1:15, 12), 
                   nrow = 180, ncol = 1, byrow = TRUE,
                   dimnames = list(c(),
                                   c("block")))

  # Let's combine all of this together:
  test <- cbind(ctrlb, blockb, test)

  ###############################################################

  # This will bind the test and training stages together:
  traintest <- rbind(train, test)

  # A column detailing trial number is needed:
  trial <- matrix(c(1:212), 
                  nrow = 212, ncol = 1, byrow = TRUE,
                  dimnames = list(c(),
                                  c("trial")))

  # A column detailing condition is needed:
  cond <- matrix(rep(1, 212), 
                 nrow = 212, ncol = 1, byrow = TRUE,
                 dimnames = list(c(),
                                 c("cond")))

  # Once again, this will all need combining together:
  traintest <- cbind(trial, cond, traintest)

  # The column order needs to be re-ordered so that it can be 
  # read by slpRW:
  traintest <- traintest[,c('ctrl', 'cond', 'block', 'trial', 'A', 
                            'B', 'C','X', 'Y', 't')]

  # This sets the first ctrl column entry of each simulated participant
  # to one, in order to reset the weights:
  traintest[1,1] = traintest[1,1] + 1

  # This creates the matrix 'tr' which will contain simulated data for
  # as many participants (i.e. loops) as we have specified:

  tr <- rbind(tr, traintest)

  }

# The training matrix 'tr' is now completed.

# For the purpose of environmental hygiene, let's remove all the
# stuff we no longer need:

rm(block, blockb, cond, ctrl, ctrlb, test, train, traintest, trial, 
   ppts, run)
