## Author: Rene Schlegelmilch
## (Andy Wills made some minor changes)

## Main function

stsimGCMrs<-function(st) {
    ## Add weight for last feature dimension
    st$weights <- as.numeric(c(st$weights, 1-sum(st$weights)))
    
    ## Add choice bias for the last category
    st$choice_bias <- as.numeric(
        c(st$choice_bias, 1-sum(st$choice_bias)))

    ## Set up memory strength parameters
    st$is_memory_pars<-list()

    ## start with all equall memory strengths... 
    for (cat in 1:st$nCats) {
        st$is_memory_pars[[cat]] <-
            c(rep(1, ncol(st$training_items[[cat]])))
    }

    ## then modify...

    ## equal memory boost for all
    if (is.atomic(st$mp)) {
        for (cat in 1:st$nCats) {
            try(st$is_memory_pars[[cat]][st$memory_items[[cat]]] <-
                    st$mp, silent = TRUE)
        }
    }

    ## item-specific memory boost
    if (!is.atomic(st$mp)) {
        for (cat in 1:st$nCats) {
            try(st$is_memory_pars[[cat]][st$memory_items[[cat]]] <-
                    st$mp[[cat]], silent = TRUE)
        }
    }

    ## Pass to calculation function
    get_p <- .gcm.predictions(sensitivity = st$sensitivity, 
                         weights = st$weights, 
                         choice_bias = st$choice_bias, 
                         gamma = st$gamma, 
                         is_memory_pars = st$is_memory_pars, 
                         r_metric = st$r_metric, 
                         training_items = st$training_items, 
                         test_items = st$test_items,
                         p_shape = st$p,
                         nCats = st$nCats)
    return(get_p)
}

Vectorize(st$training_items[[1]],function(x){ 
  x*2
})




## Predictions Function
## See Equation 1 in Nosofsky (2011)

## Calls for similarity comparisons between test items and exemplars
## (gcm.similarity), and then calculates overall summed similarity,
## returns category choice probabilites.


.gcm.predictions <- function(sensitivity, weights, choice_bias, gamma,
                             is_memory_pars, r_metric, p_shape,
                             training_items, test_items, nCats) {
  
  ## ALL RAW TEST-ITEM - EXEMPLAR SIMILARITIES (sims)
  ## for each category of training items:
  sims<-lapply(training_items,function(x){ 
    
    ## for each test item:
    apply(test_items,2, function(y){ 
      
      ## get all exemplar similarities for each test item
      apply(x,2,  
            FUN = function(x) {
              .gcm.similarity(
                c = sensitivity,
                wt = weights,
                r = r_metric,
                p = p_shape,
                x,
                y)
              })
      })
  })
  
  ## apply memory strength parameters on test item exemplar sims
  sims<-Map('*',is_memory_pars,sims)
  
  ## sum all exemplar similarities for each test-item
  sim_sums<-t(matrix(unlist(lapply(sims,colSums)), ncol=nCats))
  
  ## gamma weighting and choice bias
  sums<-t(choice_bias*(sim_sums^gamma))
  
  # relaitivize summed similarities
  predProbs<-sums/rowSums(sums)
  out<-list()
  out$predictions<-predProbs
  out$summed_sims<-t(sim_sums)
  return(out)
}


## Similarity Calculation
## See equation 2 and 3 in Nosofsky (2011)

.gcm.similarity <- function(c, wt, r, p, training_item, test_item) {
    class(training_item) <- "numeric"
    class(test_item) <- "numeric"
    ## absolute distance between feature values (Equation 2)
    tmp<- abs(training_item-test_item)
    ## feature weighted and r-scaled overall distance (Equation 2)    
    distance<- (sum(wt*tmp^r))^(1/r)
    ## Sensitivity and p scaled exponential similarity (Equation 3)
    similarity<-exp(-c*distance^p)
    return(similarity)
}

