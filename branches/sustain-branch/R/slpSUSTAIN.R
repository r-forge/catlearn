 # Probability of making the right response Equation 8
.prob.response <- function(C.out, decision.consistency) {
  e <- exp(1)
  prob.denom <- sum(e^(decision.consistency * C.out))  # denominator
  prob.nom <- e ^ (decision.consistency * C.out)  # nominator
  prob <-  prob.nom / prob.denom
  return(prob)
}

 # calculating stimulus distances from clusters position
.calc.distances <- function(input, cluster, fac.dims, fac.na) {
  mu <- matrix(0, nrow = nrow(cluster),
               ncol = length(unique(fac.dims)))
  for (k in 1:nrow(cluster)) {
    mu[k, ] <- as.vector(tapply(abs(input - cluster[k, fac.na]),
                                fac.dims, sum)) * 0.5 # Equation 4
  }
  return(mu)
}

 # nom - Set up the nominator without the sums
 # act - Calculate the activation for each cluster
 # out - Output activations after cluster competition
 # rec - Recognition score from A6 equation in Appendix in Love and Gureckis (2007)
.cluster.activation <- function(lambda, e, r, beta, mu.neg, mu.pos){
  nom <- sweep(e ^ (mu.neg), MARGIN = 2,
                 lambda ^ r, `*`)
  act <- apply(nom, MARGIN = 1, sum) / sum(lambda ^ r) # Equation 5
  out <- (act ^ beta / sum(act^beta)) * act # Equation 6
  rec <- sum(out) # Equation A6
  out[which(act < max(act))] <- 0 # For all other non-winning clusters = 0
  clus <- list("act" = act,
              "out" = out,
              "rec" = rec)
  return(clus)

}

slpSUSTAIN <- function(st, tr, xtdo = FALSE) {
 # Imports from st
  lambda <- st$lambda
  w <-st$w

 # Setting up factors for later
 # fac.dims To deal with padded input representation
 # fac.na Places of nominal values in cluster's position in a vector
 # Used to exclude category label for supervised learning when needed
 # Does not affect unsupervised learning
 # factor queried Places of quired dimensions
  fac.dims <- rep(seq_along(st$dims), st$dims)
  fac.na <- seq(sum(st$dims))
  fac.queried <- seq(sum(st$dims) + 1,
                     which(colnames(tr) == "t") - st$colskip)
  if(length(fac.queried) == 0){
    fac.queried <- fac.na
  }

  # Setting up environment
  # Arrays for xout, and to store Euler's number (for readability)
  e <- exp(1)
  xout <- NULL
  activations <- NULL
  prob.o <- NULL
  rec <- NULL

  for (i in 1:nrow(tr)) {
 # Setting up current trial
 # trial Import current trial
 # if Update parameters in case of a new participant or any case ctrl==1
 # input Set up stimulus representation
    trial <- tr[i, ]
    if (trial['ctrl'] == 1) {
    cluster <- matrix(as.vector(trial[st$colskip:(length(trial)-1)]),
                      nrow = 1)
    w <- st$w
    lambda <- st$lambda
    }
    input <- as.vector(trial[st$colskip:(st$colskip + sum(st$dims) - 1)])
 # Equation 4 - Calculate distances of stimulus from each cluster's position
    mu <- .calc.distances(input, cluster, fac.dims, fac.na)
 # c.act - The activations of clusters and recognition scores
 # C.out Activations of output units of the quired dimension
    mu.product.neg <- sweep(mu, MARGIN = 2, -lambda, `*`)
    mu.product.pos <- sweep(mu, MARGIN = 2, lambda, `*`)
    c.act <- .cluster.activation(lambda, e, st$r, st$beta,
                                 mu.product.neg, mu.product.pos)
    C.out <- w[which.max(c.act$act), ] * c.act$out[which.max(c.act$act)]  # Equation 7
    if (trial["t"] == 1){
      prob.r <-  .prob.response(C.out[fac.queried], st$d)  ## Equation 8 for supervised
    } else {
      prob.r <-  .prob.response(C.out, st$d) # Equation 8 for unsupervised
    }

 # Equation 9 - Kruschke's (1992) humble teacher
    target <- as.vector(trial[st$colskip:(length(trial)-1)])
    target[target == 1] <- pmax(C.out[which(target == 1)], 1)
    target[target == 0] <- pmin(C.out[which(target == 0)], 0)

 # Cluster recruitment
 # supervised: trial == 1, unsupervised: trial == 0 (else in function)
 # If queried target is smaller than one with max(C.out) for supervised or
 # cluster s activation is below threshold for unsupervised

 # Recruiting process
 # For both conditions (supervised or unsupervised learning)
 # Recruited new clusters are centered on the misclassified input pattern
 # Add new clusters weights and set them to zero
 # Add new stimulus' distance (which is zero on all dimensions)
 # Recompute activations of the clusters (including the recruited cluster)
 # with clusters competition
    if (trial["t"] == 1) {
       ifelse(length(unique(C.out[fac.queried])) == 1,
              t.queried <- which(target[fac.queried] == 1),
              t.queried <- which.max(C.out[fac.queried]))

 # Equation 10
    if (target[fac.queried][t.queried] < 1) {
      cluster <- rbind(cluster,
                       as.vector(trial[st$colskip:(length(trial)-1)]))
      w <-  rbind(w, rep(0, length(st$w)))
      mu <- rbind(mu, vector(mode = "numeric",
                             length = length(st$dims)))
      mu.product.neg <- sweep(mu, MARGIN = 2, -lambda, `*`)
      mu.product.pos <- sweep(mu, MARGIN = 2, lambda, `*`)
      c.act <- .cluster.activation(lambda, e, st$r, st$beta,
                                   mu.product.neg, mu.product.pos)
    }
    } else {
      if (c.act$act[which.max(c.act$act)] < st$tau) {
        cluster <- rbind(cluster,
                         as.vector(trial[st$colskip:(length(trial)-1)]))
        w <-  rbind(w, rep(0, length(st$w)))
        mu <- rbind(mu, vector(mode = "numeric",
                               length = length(st$dims)))
        mu.product.neg <- sweep(mu, MARGIN = 2, -lambda, `*`)
        mu.product.pos <- sweep(mu, MARGIN = 2, lambda, `*`)
        c.act <- .cluster.activation(lambda, e, st$r, st$beta,
                                     mu.product.neg, mu.product.pos)
    }
    }


 # Store number of the winning cluster
   win <- which.max(c.act$act)

 # Update
 # Only update the winning cluster
 # Lambdas are updated by the winning cluster
 # Adjust the winning cluster's weights
 # xout The ID of the winning cluster is also stored (extended output).
 # xout is not conditional, because it is used to calculate the frequencies
 # Equation 12
 if (trial['ctrl'] != 2) {
   cluster[win, ][fac.na] <-
     cluster[win, ][fac.na] + (st$eta * (input - cluster[win, ][fac.na]))
 # Equation 13
   lambda <-
     lambda + (st$eta * e ^ (mu.product.neg[win, ]) *
     (1 - mu.product.pos[win, ]))
 # Equation 14 - one-layer delta learning rule (Widrow & Hoff, 1960)
    w[win, ] <- w[win, ] + (st$eta * (target - C.out) * c.act$out[win])
     }
 # Record additional information about the trial
        xout[i] <- win
        activations[i] <- c.act$out[win]
        prob.o <- rbind(prob.o, prob.r)
        rec[i] <- c.act$rec
  }

 # Organise output
  rownames(prob.o) <- 1:nrow(prob.o)
  mode <- rbind(c(1:nrow(cluster)),
                matrix(table(xout), nrow = 1))
  mean <- mean(mode[1, ])
 # add coloumns' names for clusters
  #colnames(cluster) <- colnames(trial[st$colskip:(length(trial)-1)])
  #colnames(w) <- colnames(tr[st$colskip:(length(trial)-1)])
  #colnames(prob.o) <- colnames()

  if (xtdo) {
    extdo <- cbind("probabilities" = prob.o, "winning" = xout,
                   "activation" = activations, "recognition score" = rec)
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
