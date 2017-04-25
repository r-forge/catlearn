# Need to compare observed values (IRL data) with expected values (model data)...

# Read master csv file to get IRL data:
testdata <- read.csv("ply100testdata.csv")

# Aggregate IRL test data:
aggdata <- aggregate(testdata$resp,list(testdata$stim, testdata$subj),
                     mean)

# Provide sensible column names:
colnames(aggdata) <- c('stim', 'subj', 'resp')

# Create object 'obs' for observed data:
obs <- aggdata$resp

# # # Now for the model data # # #

# Select test stage prediction data rows from model:
tpred <- predictions[predictions[ ,"ctrl"] == 2,]

# Define number of stimuli:
nstim <- 15

# Create vector for participants (need to refactor this as very clunky):
ppts <- c(rep(1, nstim), rep(2, nstim), rep(3, nstim), rep(4, nstim),
          rep(5, nstim), rep(6, nstim), rep(7, nstim), rep(8, nstim),
          rep(9, nstim), rep(10, nstim), rep(11, nstim), rep(12, nstim),
          rep(13, nstim), rep(14, nstim), rep(15, nstim), rep(16, nstim),
          rep(17, nstim), rep(18, nstim), rep(19, nstim), rep(20, nstim),
          rep(21, nstim), rep(22, nstim), rep(23, nstim), rep(24, nstim),
          rep(25, nstim), rep(26, nstim), rep(27, nstim), rep(28, nstim),
          rep(29, nstim), rep(30, nstim), rep(31, nstim), rep(32, nstim),
          rep(33, nstim), rep(34, nstim), rep(35, nstim), rep(36, nstim),
          rep(37, nstim), rep(38, nstim), rep(39, nstim), rep(40, nstim))

# Bind ppts to tpred
tpred <- cbind(ppts, tpred)

# Pull out participant 1:
exp1 <- tpred[tpred[ ,"ppts"] == 1, 11]

# Calculate exp1 SSE:
ssecl(obs,exp1)

# Need to generate a for loop for participants 1-40:



# We just want the predicted ratings themselves:
exp <- tpred[ ,10]

# Tidy up...
rm(nstim, ppts)
# Remove objects we don't need:
rm(testdata, aggdata, tpred)

# Calculate SSE:
ssecl(obs,exp)
