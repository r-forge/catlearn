# DAU: PLY100
# Analysis of experimental data


# Read master csv file:

testdata <- read.csv("ply100testdata.csv")

aggdata <- aggregate(testdata$resp,list(testdata$stim, testdata$subj),
                     mean)

colnames(aggdata) <- c('stim','subj','resp')

obs <- aggdata$resp

# Select test stage prediction data

tpred <- predictions[predictions[ ,"ctrl"] == 2,]

exp <- tpred[ ,10]

ssecl(obs,exp)
