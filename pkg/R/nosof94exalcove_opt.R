nosof94exalcove_opt <- function(recompute = FALSE, xtdo = TRUE) {
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
            result = tryCatch({
                optim(params, .alcove.nosof94, method = "L-BFGS-B",
                      lower = lb, upper = ub, control = ctrl)
            }, error = function(e) {
                list(par = c(NA,NA,NA,NA), value = NA)
            })
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
        res.cache <- structure(
            c(1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 10, 10, 1,
              1, 1, 10, 10, 10, 10, 1, 1, 1, 1, 10, 10, 10, 10, 0.01,
              0.5, 0.5, 0.01, 0.01, 0.5, 0.5, 0.01, 0.01, 0.5, 0.5,
              0.01, 0.01, 0.5, 0.5, 0.5, 0.01, 0.5, 0.01, 0.5, 0.01,
              0.5, 0.01, 0.5, 0.01, 0.5, 0.01, 0.5, 0.01, 0.5, 3.3409,
              3.8599, 0.8099, 5.8615, NA, 7.7888, NA, 9.8223, 10.2574,
              10.0013, 10.5796, 9.9529, 9.9174, 9.9999, 9.7686,
              6.8136, 5.8517, 1.3741, 11.3489, NA, 11.5273, NA,
              5.7032, 2.073, 6.1726, 1.2965, 10.0421, 10.0191,
              10.0003, 10.4159, 0.99, 0.987, 0.3886, 0.9504, NA, 0.99,
              NA, 0.99, 0.9089, 0.7922, 0.7007, 0.9897, 1e-04, 0.5003,
              0.552, 0.981, 0.9877, 0.2781, 0.9528, NA, 0.99, NA,
              0.99, 0.0683, 0.99, 0.2778, 0.0117, 0.943, 0.0117,
              0.4437, 1.2676, 1.2613, 0.2888, 1.2584, NA, 1.2557, NA,
              1.2795, 0.1477, 1.28, 0.3975, 0.2533, 1.2854, 0.2765,
              1.3006), .Dim = c(15L, 9L),
            .Dimnames = list(c("result.1", "result.2", "result.3",
                               "result.4", "result.5", "result.6",
                               "result.7", "result.8", "result.9",
                               "result.10", "result.11", "result.12",
                               "result.13", "result.14", "result.15"),
                             c("i.c", "i.phi", "i.la", "i.lw", "i.c",
                               "i.phi", "i.la", "i.lw", "")))
    }
    ## Pick the best and return parameters
    params <- res.cache[which.min(res.cache[,9]),5:8]
    names(params) <- c('c','phi','la','lw')
    ## Print the outcomes
    if(xtdo) {
        print("Best fits from different starting points.")
        print(res.cache)
        print("Best fit overall for:")
        print(params)
    }
    return(params)
}





