nosof94exalcove_opt <- function(recompute = FALSE) {
    if(recompute) {
        ##  Define objective function to minimize
        .alcove.nosof94 <- function(params) {
            out <- nosof94exalcove(params)
            ret <- ssecl(out$error,catlearn::nosof94$error)
            return(ret)
        }
        ## Suppress output of optim function to console
        ctrl <- list(trace=0)
        ## Set bounds for optimzation
        lb <- c(0.0001,0.0001,0.0001,0.0001) # Lower bounds
        ub <- c(20,20,.99,.99)            # Upper bounds
        ## Set starting conditions
        ## crashed: c(1,1,.01,.01), so removed from list
        pset <- rbind(
            c(1,1,.01,.5), c(1,1,0.5,.01), c(1,1,.5,.5),
            c(1,10,.01,.01), c(1,10,.01,.5), c(1,10,.5,.01),
            c(1,10,.5,.5), c(10,1,.01,.01), c(10,1,.01,.5),
            c(10,1,.5,.01), c(10,1,.5,.5), c(10,10,.01,.01),
            c(10,10,.01,.5), c(10,10,.5,.01), c(10,10,.5,.5)
        )
        colnames(pset) <- c('c','phi','la','lw')
        ## Enable multi-core processing cluster
        cores = detectCores()
        c1 <- makeCluster(cores[1])
        registerDoParallel(c1)
        ## Information message
        print(paste(cores[1],"processing threads detected."))
        ## Produce warning message
        print("The optimization will now be re-calculated.")
        print("This can take some hours, and there is no progress bar.")
        print("Calculating...")
        ## Parallel loop around initial conditions
        i=NULL # Pre-defining i here stops CRAN complaining.
        bigresults <- foreach(i=1:15, .combine=rbind,
                              .packages=c('catlearn')) %dopar% {
            params <- pset[i,]
            names(params) <- c('i.c','i.phi','i.la','i.lw')
            result <- optim(params, .alcove.nosof94,
                            method = "L-BFGS-B", lower = lb,
                            upper = ub, control = ctrl)
            tempres <- c(params, result$par, result$value)
            tempres # Equivalent to rbind into bigresults
        }
        ## Stop Cluster
        stopCluster(c1)
        ## Cache result
        colnames(bigresults) <- c('i.c','i.phi','i.la','i.lw','c',
                                  'phi','la','lw','fit')
        
        res.cache <- bigresults
        ## End message
        print("...Calculations completed successfully.")
    } else {
        ## If not recomputing, use cached results
        res.cache <-
            structure(c(1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10,
                        10, 10, 1, 1, 1, 10, 10, 10, 10, 1, 1, 1, 1,
                        10, 10, 10, 10, 0.01, 0.5, 0.5, 0.01, 0.01,
                        0.5, 0.5, 0.01, 0.01, 0.5, 0.5, 0.01, 0.01,
                        0.5, 0.5, 0.5, 0.01, 0.5, 0.01, 0.5, 0.01,
                        0.5, 0.01, 0.5, 0.01, 0.5, 0.01, 0.5, 0.01,
                        0.5, 6.2754, 2.1627, 1.2632, 2.6666, 0.8386,
                        5.6714, 0.8387, 9.8306, 9.9931, 9.9027,
                        9.9504, 9.9482, 9.8383, 9.9998, 3.8863,
                        1.0463, 1.3923, 1.4109, 12.6373, 7.6988,
                        11.8617, 10.5983, 5.6947, 2.9688, 6.0034,
                        1.25, 10.0417, 9.986, 10, 15.5889, 0.9552,
                        0.9796, 0.216, 0.99, 0.1148, 0.9851, 0.34,
                        0.99, 0.4924, 0.9263, 0.4718, 0.99, 1e-04,
                        0.5001, 0.3337, 0.9876, 0.1332, 0.2844, 0.99,
                        0.2875, 0.9868, 0.3103, 0.99, 0.0433, 0.99,
                        0.5382, 0.0116, 0.7629, 0.0119, 0.2271,
                        0.6417, 0.2633, 0.2736, 1.2801, 0.746, 1.2547,
                        0.8772, 1.2815, 0.184, 1.2783, 0.5602, 0.2529,
                        1.2909, 0.2766, 1.2138),
                      .Dim = c(15L, 9L),
                      .Dimnames = list(c("result.1", "result.2",
                                         "result.3", "result.4",
                                         "result.5", "result.6",
                                         "result.7", "result.8",
                                         "result.9", "result.10",
                                         "result.11", "result.12",
                                         "result.13", "result.14",
                                         "result.15"),
                                       c("i.c", "i.phi", "i.la",
                                         "i.lw", "c", "phi", "la",
                                         "lw", "fit")))
    }
    ## Pick the best and return parameters
    params <- res.cache[which.min(res.cache[,9]),5:8]
    names(params) <- c('c','phi','la','lw')
    return(params)
}


