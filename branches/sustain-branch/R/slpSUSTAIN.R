 # Probability of making the right response Equation 8
.prob.response <- function(C.out, decision.consistency) {
  e <- exp(1)
  prob.denom <- sum(e^(decision.consistency * C.out))  # denominator
  prob.nom <- e ^ (decision.consistency * C.out)  # nominator
  prob <-  prob.nom / prob.denom
  return(prob)
}

.calc.distances <- function(input, cluster, fac.dims, fac.na) {
  mu <- matrix(0, nrow = nrow(cluster),
               ncol = length(unique(fac.dims)))
  for (k in 1:nrow(cluster)) {
    mu[k, ] <- as.vector(tapply(abs(input - cluster[k, fac.na]),
                                fac.dims, sum)) * 0.5 # Equation 4
  }
  return(mu)
}

cluster.activation <- function(lambda, e, r, beta, mu.neg, mu.pos){

}

slpSUSTAIN <- function(st, tr, xtdo = FALSE) {
 # Imports from st
  ifelse(length(st$lambda) != 1,
         lambda <- st$lambda,
         lambda <- rep(st$lambda, length(st$dims)))
  w <-st$w

 # Setting up factors for later
 #' fac.dims To deal with padded input representation
 #' fac.na Places of nominal values in cluster's position in a vector
 #' Used to exclude category label for supervised learning when needed
 #' Does not affect unsupervised learning
 #' factor queried Places of quired dimensions
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
  prob.o <- NULL
  cout.o <- NULL

  for (i in 1:nrow(tr)) {
 # Setting up current trial
 #' trial Import current trial
 #' if Update parameters in case of a new participant or any case ctrl==1
 #' input Set up stimulus representation
 # browser()
    trial <- tr[i, ]
    if (trial['ctrl'] == 1) {
    cluster <- matrix(as.vector(trial[st$colskip:(length(trial)-1)]),
                      nrow = 1)
    w <- st$w
    ifelse(length(st$lambda) != 1,
           lambda <- st$lambda,
           lambda <- rep(st$lambda, length(st$dims)))
    }
    input <- as.vector(trial[st$colskip:(st$colskip + sum(st$dims) - 1)])
 # Calculate distances of stimulus from each cluster's position
    mu <- .calc.distances(input, cluster, fac.dims, fac.na)

 # The activations of clusters
 #' H.nom Set up the nominator without the sums
 #' H.act Calculate the activation for each cluster
 #' H.out Output activations after cluster competition
 #' C.out Activations of output units of the quired dimension
    mu.product.neg <- sweep(mu, MARGIN = 2, -lambda, `*`)
    mu.product.pos <- sweep(mu, MARGIN = 2, lambda, `*`)
    H.nom <- sweep(e ^ (mu.product.neg), MARGIN = 2, lambda ^ st$r, `*`)
    H.act <- apply(H.nom, MARGIN = 1, sum) / sum(lambda ^ st$r)  # Equation 5
    H.out <- (H.act ^ st$beta / sum(H.act^st$beta)) * H.act  # Equation 6

    H.out[which(H.act < max(H.act))] <- 0
    C.out <- w[which.max(H.act), ] * H.out[which.max(H.act)]  # Equation 7
    prob.r <-  .prob.response(C.out[fac.queried], st$d)  ## Equation 8

 # Equation 9 - Kruschke's (1992) humble teacher
    target <- as.vector(trial[st$colskip:(length(trial)-1)])
    target[target == 1] <- pmax(C.out[which(target == 1)], 1)
    target[target == 0] <- pmin(C.out[which(target == 0)], 0)

 # Cluster recruitment
 #' supervised: trial == 1, unsupervised: trial == 0 (else in function)
 #' If queried target is smaller than one with max(C.out) for supervised or
 #' cluster's activation is below threshold for unsupervised

 # Recruiting process
 #' For both conditions (supervised or unsupervised learning)
 #' Recruit new cluster centered on the misclassified input pattern
 #' Add new cluster's weights and set them to zero
 #' Add new stim's distance (which is zero on all dimensions)
 #' Recompute activations of the clusters (including the recruited cluster)
 #' with clusters competition
    if (trial["t"] == 1) {
       ifelse(length(unique(C.out[fac.queried])) == 1,
              t.queried <- which(target[fac.queried] == 1),
              t.queried <- which.max(C.out[fac.queried]))
    }
 # Equation 10
    if (target[fac.queried][t.queried] < 1 || H.act[which.max(H.act)] < st$tau) {
      cluster <- rbind(cluster,
                       as.vector(trial[st$colskip:(length(trial)-1)]))
      w <-  rbind(w, rep(0, length(st$w)))
      mu <- rbind(mu, vector(mode = "numeric",
                             length = length(st$dims)))
      mu.product.neg <- sweep(mu, MARGIN = 2, -lambda, `*`)
      mu.product.pos <- sweep(mu, MARGIN = 2, lambda, `*`)
      H.nom <- sweep(e ^ (mu.product.neg), MARGIN = 2,
                     lambda ^ st$r, `*`)
      H.act <- apply(H.nom, MARGIN = 1, sum) / sum(lambda ^ st$r)
      H.out <- (H.act ^ st$beta / sum(H.act^st$beta)) * H.act
      H.out[which(H.act < max(H.act))] <- 0
      }

 # Store number of the winning cluster
   win <- which.max(H.act)

 # Update
 #' Only update the winning cluster
 #' Lambdas are updated by the winning cluster
 #' Adjust the winning cluster's weights
 #' xout The ID of the winning cluster is also stored (extended output).
 #' xout is not conditional, because it is used to calculate the frequencies
 # Equation 12
 if (trial['ctrl'] != 2) {
   cluster[win, ][fac.na] <-
     cluster[win, ][fac.na] + (st$eta * (input - cluster[win, ][fac.na]))
 # Equation 13
   lambda <-
     lambda + (st$eta * e ^ (mu.product.neg[win, ]) *
     (1 - mu.product.pos[win, ]))
 # Equation 14 - one-layer delta learning rule (Widrow & Hoff, 1960)
    w[win, ] <- w[win, ] + (st$eta * (target - C.out) * H.out[win])
    xout[i] <- win
    que[i] <- which(target[fac.queried]==1)
    }
  }
  # browser()
  prob.xout <- cbind(prob.o, que, xout)
  mode <- rbind(c(1:nrow(cluster)),
                matrix(table(xout), nrow = 1))
  mean <- mean(mode[1, ])

  if (xtdo) {
    ret <- list("prob" = prob.xout, "xout" = xout,
                "mode " = mode, "lambda" = lambda,
                "cluster" = cluster, "weights" = w)
  } else {
    ret <- list("lambda" = lambda, "weight" = w,
                "cluster" = cluster,
                "mode " = mode, "mean" = mean)
  }
  return(ret)
}
