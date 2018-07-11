krus96exit <- function(params = c(2.87, 2.48, 4.42, 4.42, .222, 1.13,
                                  .401)) {

    ### INCOMPLETE ... 
    ## Set state
    exemplars <- rbind(c(1,1,0,0,0,0,1),
                       c(1,0,1,0,0,0,1),
                       c(0,0,0,1,1,0,1),
                       c(0,0,0,1,0,1,1))

    w_exemplars <- exemplars
    
    st <- list(nFeat = 7, nCat = 4,
               phi = params[3], c = params[1], P = params[2],
               l_gain = params[4], l_weight = params[5], l_ex = params[6],
               sigma = c(rep(1,6), params[7]), 
               iterations = 10, exemplar)  
    }
