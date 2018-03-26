## Probability of making the right response (Eq. 8)
## AW: OK, 2018-03-21
.prob.response <- function(C.out, decision.consistency) {
    prob.denom <- sum(exp(decision.consistency * C.out))  # denominator
    prob.nom <- exp(decision.consistency * C.out)  # nominator
    prob <-  prob.nom / prob.denom
    return(prob)
}

## Calculating stimulus distance from a cluster (Eq. 4)
## AW: OK, 2018-03-21
.calc.distances <- function(input, cluster, fac.dims) {
    fac.na <- seq(sum(st$dims))
    mu <- matrix(0, nrow = nrow(cluster),
                 ncol = length(unique(fac.dims)))
    for (k in 1:nrow(cluster)) {
        mu[k, ] <- as.vector(tapply(abs(input - cluster[k, fac.na]), fac.dims,
                                    sum)) * 0.5 ## Equation 4
    }
    return(mu)
}

## Calculating cluster activation and related values (Eq.5, 6, A6)
## act - Activation of each cluster (Eq. 5)
## out - Activations after cluster competition (Eq. 6)
## rec - Recognition score from A6 equation in Appendix in Love and Gureckis (2007)
## AW: OK, 2018-03-21
.cluster.activation <- function(lambda, r, beta, mu) {
    mu.lambda <- sweep(mu, MARGIN = 2, -lambda, `*`)
    nom <- sweep(exp(mu.lambda), MARGIN = 2, lambda ^ r, `*`)  
    act <- apply(nom, MARGIN = 1, sum) / sum(lambda ^ r) # Equation 5
    out <- (act ^ beta / sum(act^beta)) * act # Equation 6
    rec <- sum(out) # Equation A6
    out[which(act < max(act))] <- 0 # For all other non-winning clusters = 0
    clus <- list("act" = act,
              "out" = out,
              "rec" = rec,
              "mu.lambda" = mu.lambda)
    return(clus)
}

slpSUSTAIN <- function(st, tr, xtdo = FALSE) {
    ## Imports from st
    lambda <- st$lambda
    w <-st$w

    ## Setting up factors for later
    
    ## fac.dims: The dimension each position in the stimulus input refers
    ## to. For example, in a three dimensional stimulus with 2,3, and 2, levels
    ## on the dimensions, this would return 1 1 2 2 2 3 3
    
    fac.dims <- rep(seq_along(st$dims), st$dims)

    ## The numbers 1:N, where N is the length of fac.dims. Useful in various
    ## pieces of code later on
    
    fac.na <- seq(sum(st$dims))
    
    ## fac.queried: The positions of the queried dimension values in the
    ## stimulus input
    fac.queried <- seq(sum(st$dims) + 1,
                       which(colnames(tr) == "t") - st$colskip)
    ## AW: Not sure what the purpose of the following code is?
    if(length(fac.queried) == 0){
        fac.queried <- fac.na
    }

    ## Setting up environment
    ## Arrays for xout
    xout <- NULL
    activations <- NULL
    prob.o <- NULL
    rec <- NULL

    for (i in 1:nrow(tr)) {

        ## Setting up current trial
        
        ## trial - Import current trial
        trial <- tr[i, ]

        ## input - Set up stimulus representation
        input <- as.vector(trial[st$colskip:(st$colskip + sum(st$dims) - 1)])
        
        ## Reset network if requested to do so.
        if (trial['ctrl'] == 1) {
            ## Revert to a single cluster centered on the current trial's
            ## stimulus
            cluster <- matrix(as.vector(trial[st$colskip:(length(trial)-1)]),
                              nrow = 1)
            w <- st$w
            lambda <- st$lambda
        }
        
        ## Equation 4 - Calculate distances of stimulus from each cluster's
        ## position
        mu <- .calc.distances(input, cluster, fac.dims)
        
        ## mu.product.pos <- sweep(mu, MARGIN = 2, lambda, `*`)
        
        ## AW: This seems like a quicker and more transparent way to get the
        ## same outcome?
        ## mu.product.pos <- -mu.product.neg

        ## c.act - The activations of clusters and recognition scores        
        c.act <- .cluster.activation(lambda, st$r, st$beta, mu)
        
        ## C.out - Activations of output units (Eq. 7)
        ## AW: OK, 2018-03-23
        C.out <- w[which.max(c.act$act), ] * c.act$out[which.max(c.act$act)]

        ## Response probabilites (Eq.8) - calculated across queried dimension
        ## for supervised learning and across all dimensions for unsupervised
        ## learning.
        ## AW: supervised - OK, 2018-03-23
        ## AW: unsupervised - not sure why you'd calculate this?, 2018-03-23
        if (trial["t"] == 1){
            prob.r <-  .prob.response(C.out[fac.queried], st$d)
        } else {
            prob.r <-  .prob.response(C.out, st$d)
        }

        ## Kruschke's (1992) humble teacher (Eq. 9)
        ## AW: OK, 2018-03-23
        target <- as.vector(trial[st$colskip:(length(trial)-1)])
        target[target == 1] <- pmax(C.out[which(target == 1)], 1)
        target[target == 0] <- pmin(C.out[which(target == 0)], 0)


        ## Cluster recruitment in supervised learning
        ## AW: 2018-03-23: OK, except where noted. Also, quite a lot of code
        ## repetition, I've refactored to reduce this.

        new.cluster <- FALSE

        ## Rules for new cluster under supervised learning
        if (trial["t"] == 1) { 
            
            ifelse(
                length(unique(C.out[fac.queried])) == 1,
                t.queried <- which(target[fac.queried] == 1),
                t.queried <- which.max(C.out[fac.queried])
            )

            ## AW NOTE: If all units have the same activation, this breaks the
            ## tie by going for the unit corresponding to the correct answer
            ## (which will therefore NOT result in a new cluster being
            ## formed). This seems different to the following:

            ## "the output unit representing the correct nominal value must be
            ## the most activated of all the output units forming the queried
            ## stimulus dimension" (Love et al., 2004, p. 315)/

            ## t.queried - the index of the unit in the queried dimension that
            ## has the highest activation.
            
            ## t.queried <- which.max(C.out[fac.queried])
            
            ## If the unit with the highest activation has a target value of
            ## less than one, then the model has made an error and recruits a
            ## new cluster (Eq. 10)...

            if (target[fac.queried][t.queried] < 1) new.cluster <- TRUE

            ## If all the units have the same activation, then the
            ## model has made an error.
            ## if (length(unique(C.out[fac.queried])) == 1) new.cluster <- TRUE
            
        }

        ## Cluster recruitment in unsupervised learning
            
        ## AW:c.act$act[which.max(c.act$act)] is equiv. to max(c.act$act), so
        ## replaced with this simpler for for clarity

        if (trial["t"] != 1 & max(c.act$act < st$tau)) new.cluster <- TRUE

        ## Adding a new cluster if appropriate.
        
        if(new.cluster == TRUE) {
            ## Create new cluster centered on current stimulus

            cluster <- rbind(cluster,
                             as.vector(trial[st$colskip:(length(trial)-1)]))

            ## The new cluster gets a set of weight to the queried
            ## dimension, intialized at zero

            w <-  rbind(w, rep(0, length(st$w)))

            ## The new cluster also needs a set of distances to the
            ## presented stimulus (which will of course be zero)
            
            mu <- rbind(mu, vector(mode = "numeric",
                                   length = length(st$dims)))

            ## ..and now we have to re-calculate the activation of all
            ## clusters
            c.act <- .cluster.activation(lambda, st$r, st$beta, mu)
        }

        ### Lenard's notes ########
        ## xout The ID of the winning cluster is also stored (extended output).
        ## xout is not conditional, because it is used to calculate the
        ## frequencies
        ####

        ## UPDATES
        win <- which.max(c.act$act)
        if (trial['ctrl'] != 2) {
            ## Update position of winning cluster (Equ. 12)
            ## AW: OK, 2018-03-23
            cluster[win, fac.na] <-
                cluster[win, fac.na] +
                (st$eta * (input - cluster[win,fac.na]))
            
            ## Upquate receptive tuning field (Equ. 13)
            ## (Note: mu.lambda includes the minus sign, hence the absence of a
            ## minus sign in its first use below, and the presence of the
            ## addition sign in the second use (despite minus in Eq. 13 here).
            ## AW: OK, 2018-03-23
            lambda <- lambda + (st$eta * exp(c.act$mu.lambda[win, ]) *
                                (1 + c.act$mu.lambda[win, ]))
   

            ## Equation 14 - one-layer delta learning rule (Widrow & Hoff, 1960)
            ## AW: Corrected, 2018-03-23
            ## Lenard's equation:
            ## w[win, ] <- w[win, ] + (st$eta * (target - C.out) * c.act$out[win])
            ## I think the above is wrong, both Love et al. (2004) &
            ## Love+Gureckis (2007) say it's only the queried dimension's
            ## weights that get updated. I think the following does that.
            w[win, fac.queried] <- w[win, fac.queried] +
                (st$eta * (target[fac.queried] - C.out[fac.queried]) *
                 c.act$out[win])
     }

        ## Record additional information about the trial
        xout[i] <- win
        activations[i] <- c.act$out[win]
        prob.o <- rbind(prob.o, prob.r)
        rec[i] <- c.act$rec
    }

    ## Organise output
    rownames(prob.o) <- 1:nrow(prob.o)
    mode <- rbind(c(1:nrow(cluster)), matrix(table(xout), nrow = 1))   
    mean <- mean(mode[1, ])
    ## add coloumns' names for clusters
    ## colnames(cluster) <- colnames(trial[st$colskip:(length(trial)-1)])
    ##colnames(w) <- colnames(tr[st$colskip:(length(trial)-1)])
    ## colnames(prob.o) <- colnames()

    if (xtdo) {
        extdo <- cbind("probabilities" = prob.o, "winning" = xout,
                       "activation" = activations,
                       "recognition score" = rec)        
        rownames(extdo) <- 1:nrow(extdo)
    }

    if (xtdo) {
        ret <- list("xtdo" = extdo, "mean" = mean,
                "mode " = mode, "lambda" = lambda,
                "cluster" = cluster, "weights" = w)
    } else {
        ret <- list("probs" = prob.o, "lambda" = lambda,
                "weights" = w, "cluster" = cluster,
                "mode " = mode)
    }
    return(ret)
}
