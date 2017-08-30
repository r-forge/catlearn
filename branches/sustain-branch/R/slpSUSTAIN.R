 # Probability of making the right response Equation 8
.prob.response <- function(x) {
  e <- exp(1)
  prob.denom <- sum(e^(st$d * x))  # denominator
  prob.nom <- e ^ (st$d * x)  # nominator
  prob <-  prob.nom / prob.denom
  return(prob)
}

slpSUSTAIN <- function(st, tr, xtdo = FALSE) {
 # Imports from st
  ifelse(length(st$lambda) != 1,
         lambda <- st$lambda,
         lambda <- rep(st$lambda, length(st$dims)))
  cluster <- st$cluster
  w <-st$w

 # Setting up environment
 # Arrays for xout, and to store Euler's number (for readability)
  e <- exp(1)
  xout <- NULL

 # Setting up factors for later
 #' fac.dims To deal with padded input representation
 #' fac.na Places of nominal values in cluster's position with NAs excluded,
 #' Used when calculating distances and updating clusters' position
 #' factor quired Places of quired dimensions
  fac.dims <- rep(seq_along(st$dims), st$dims)
  fac.na <- seq(cluster)[-which(is.na.data.frame(cluster))]
  if(length(fac.na) == 0) {
    fac.na <- seq(cluster[, , 1])
  }
  fac.na <- fac.na[1:sum(st$dims)]
  fac.queried <- seq(sum(st$dims) + 1,
                        which(colnames(tr) == "t") - st$colskip)
  if(length(fac.queried) == 0){
    fac.queried <- seq(cluster[, , 1][fac.na])
  }

  for (i in 1:nrow(tr)) {
 # Setting up current trial
 #' trial Import current trial
 #' if Update parameters in case of a new participant or any other reasons
 #' input Set up stimulus representation
 #' mu create array for distances
    trial <- tr[i, ]
    if (trial['ctrl'] != 0) {
    cluster <- st$cluster
    w <- st$w
    ifelse(length(st$lambda) != 1,
           lambda <- st$lambda,
           lambda <- rep(st$lambda, length(st$dims)))
    }
    input <- as.vector(trial[st$colskip:(st$colskip + sum(st$dims) - 1)])
    mu <- array(0, c(dim(cluster)[3], length(st$dims)))

 # Calculate distances of stimulus from each cluster's position
    for (k in 1:dim(cluster)[3]) {
      mu[k, ] <- as.vector(tapply(abs(input - cluster[, , k][fac.na]),
                                  fac.dims, sum,
                                  na.rm = TRUE)) * 0.5 # Equation 4
  }

 # The activations of clusters
 #' H.nom Set up the nominator without the sums
 #' H.act Calculate the activation for each cluster
 #' H.out Output activations after cluster competition
 #' C.out Activations of output units of the quired dimension'
  H.nom <- sweep(e ^ (-lambda * mu), MARGIN = 2, lambda ^ st$r, `*`)
  H.act <- apply(H.nom, MARGIN = 1, sum) / sum(lambda ^ st$r)  # Equation 5
  H.out <- (H.act ^ st$beta / sum(H.act^st$beta)) * H.act  # Equation 6
  H.out[which(H.act < max(H.act))] <- 0
  C.out <- w[, , which.max(H.act)] * H.out[which.max(H.act)]  # Equation 7
  prob <-  .prob.response(C.out)  ## Equation 8

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
 #' with clusters' competition
  if (trial["t"] == 1) {
     ifelse(length(unique(as.vector(C.out[fac.queried]))) == 1,
            t.queried <- which(target[fac.queried] == 1),
            t.queried <- which.max(C.out[fac.queried]))
 # Equation 10
    if (target[fac.queried][t.queried] < 1) {
      cluster <- abind:::abind(cluster, array(trial[st$colskip:(length(trial)-1)],
                                              c(dim(st$cluster))))
      w <-  abind:::abind(w, array(0, dim(st$w)))
      mu <- rbind(mu, vector(mode = "numeric", length = length(st$dims)))
      H.nom <- sweep(e ^ (-lambda * mu), MARGIN = 2, lambda ^ st$r, `*`)
      H.act <- apply(H.nom, MARGIN = 1, sum) / sum(lambda ^ st$r)
      H.out <- (H.act ^ st$beta / sum(H.act^st$beta)) * H.act
      H.out[which(H.act < max(H.act))] <- 0
      }
    } else {
 # Equation 11
    if (H.act[which.max(H.act)] < st$tau) {
      cluster <- abind:::abind(cluster, array(as.vector(input),
                                              c(dim(st$cluster))))
      w <- abind:::abind(w, array(0, dim(st$w)))
      mu <- rbind(mu, vector(mode = "numeric", length = length(st$dims)))
      H.nom <- sweep(e ^ (-lambda * mu), MARGIN = 2, lambda ^ st$r, `*`)
      H.act <- apply(H.nom, MARGIN = 1, sum) / sum(lambda ^ st$r)
      H.out <- (H.act ^ st$beta / sum(H.act^st$beta)) * H.act
      H.out[which(H.act < max(H.act))] <- 0
    }
  }

 # Store the ID of the winning cluster
  win <- which.max(H.act)

 # Update
 #' Only update the winning cluster
 #' Lambdas are updated by the winning cluster
 #' Adjust the winning cluster's weights
 #' xout The ID of the winning cluster is also stored (extended output).
 #' xout is not conditional, because it is used to calculate the frequencies
 # Equation 12
  cluster[, , win][fac.na] <- cluster[, , win][fac.na] +
                                (st$eta * (input - cluster[ , , win][fac.na]))
 # Equation 13
  lambda <- lambda + (st$eta * e^(-lambda * mu[win, ]) * (1 - lambda * mu[win, ]))
 # Equation 14 - one-layer delta learning rule (Widrow & Hoff, 1960)
  w[, , win] <- w[, , win] + (st$eta * (target - C.out) * H.out[win])
  xout[i] <- win
  }

 # Additional information
 #' mode Frequencies of each cluster
 #' mean Mean of clusters (based on cluster's frequencies)
  mode <- rbind(c(1:dim(cluster)[3]), matrix(table(xout), nrow = 1))
  mean <- mean(mode[1, ])

  if (xtdo) {
    ret <- list("cluster" = cluster, "xout" = xout, 
                "mode " = mode, "mean" = mean, "lambda" = lambda)
  } else {
    ret <- list("cluster" = cluster, "mode " = mode, 
                "mean" = mean, "lambda" = lambda)
  }
  return(ret)
}
