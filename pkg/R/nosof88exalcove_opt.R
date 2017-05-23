## Run minimization
nosof88exalcove_opt <- function(recompute = FALSE, trace = 0) {
    ##  Define objective function to minimize
    .alcove.nosof88 <- function(params) {
        out <- nosof88exalcove(params)
        ret <- ssecl(out$c2acc,nosof88$c2acc)
        ## 'nosof88' for development 
        ## 'catlearn::nosof88' for package release
        return(ret)
    }

    ## Set level of output verbosity
    ctrl <- list(trace=trace)
    
    ## Set bounds for optimzation
    lb <- c(0.0001,0.0001,0.0001,0.0001) # Lower bounds
    ub <- c(20,5,.99,.99)            # Upper bounds

    ## Set starting conditions
    pset <- rbind(
        c(2,1,.25,.25), c(2,1,.75,.25), c(2,1,.75,.75), c(2,3,.25,.25),
        c(2,3,.25,.75), c(2,3,.75,.25), c(2,3,.75,.75), c(8,1,.25,.25),
        c(8,1,.25,.75), c(8,1,.75,.25), c(8,1,.75,.75), c(8,3,.25,.25),
        c(8,3,.25,.75), c(8,3,.75,.25), c(8,3,.75,.75)
    )
    colnames(pset) <- c('c','phi','la','lw')
    ## crashed: c(2,1,.25,.75),

    if(recompute) {
        bigresults = NULL
        ## Run optimzation
        for(i in 1:15) {
            params <- pset[i,]
            names(params) <- c('c','phi','la','lw')
            result <- optim(params, .alcove.nosof88,
                            method = "L-BFGS-B",
                            lower = lb, upper = ub,
                            control = ctrl)
            bigresults <- rbind(bigresults, c(params, result$par,
                                              result$value))
        }
    } 
    return(bigresults)
}


