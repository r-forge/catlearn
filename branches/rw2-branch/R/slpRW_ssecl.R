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

# We just want the predicted ratings themselves:
exp <- tpred[ ,10]

# Remove objects we don't need:
rm(testdata, aggdata, tpred)

# Calculate SSE:
ssecl(obs,exp)
