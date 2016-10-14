`.sourceCpp_0_DLLInfo` <- dyn.load('lib/slpcovis.cpp.dll')

slpCOVIS <- Rcpp:::sourceCppFunction(function(train, nextrules, initsy, scuval, exppar, imppar, comppar, extpar) {}, FALSE, `.sourceCpp_0_DLLInfo`, 'sourceCpp_0_slpCOVIS')

rm(`.sourceCpp_0_DLLInfo`)
