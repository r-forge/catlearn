print("Running all unit tests.")
library(catlearn)

## Run each of the tests, collate results
res <- NULL

## act2probrat
source('test_act2probrat.R')
res <- rbind(res, c("act2probrat", test.act2probrat()))

## slpALCOVE
source('test_slpALCOVE.R')
res <- rbind(res, c("slpALCOVE", test.act2probrat()))

## slpBM
source('test_slpBM.R')
res <- rbind(res, c("slpBM", test.slpBM()))


## slpCOVIS
source('test_slpcovis.R')
res <- rbind(res, c("slpCOVIS", test.slpCOVIS()))

## slpDIVA
source('test_slpdiva.R')
res <- rbind(res, c("slpDIVA", test.slpDIVA()))

## slpMBMF
source('test_slpMBMF.R')
res <- rbind(res, c("slpMBMF", test.slpMBMF()))

## slpRW
source('test_slpRW.R')
res <- rbind(res, c("slpRW", test.slpRW()))

## stsimGCM
source('test_stsimGCM.R')
res <- rbind(res, c("stsimGCM", test.stsimGCM()))

## Post-process
res <- as.data.frame(res, stringsAsFactors = FALSE)
colnames(res) <- c('test', 'result')
res$result <- as.logical(res$result)

## Outcome
wins <- sum(res$result)
ntest <- nrow(res)

if(wins == ntest) {
    print("OK")
} else {
    print("ERROR:")
    print(res)
}

