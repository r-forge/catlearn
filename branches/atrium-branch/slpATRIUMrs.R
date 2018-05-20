slp_ATRIUMrs<-function(st,tr,xtdo=FALSE){
    output<-.atrium(st,tr, extend=xtdo)
    return(output)
}

.atrium<-function(st,tr,extend){
    
    ## basic processing variables
    ## number of dimension rules
    nRules<-length(st$prime_dim)
    ## vector of category and feature indices (columnname strings)
    tcats<-colnames(tr)[grep("t1$",colnames(tr)):(grep("t1$",colnames(tr))+(st$nCats-1))]
    tfeats<-colnames(tr)[grep("x1$",colnames(tr)):(grep("x1$",colnames(tr))+(st$nFeats-1))]
    
    ## tracking arrays
    response_probabilities<-matrix(0, ncol=st$nCats,nrow=nrow(tr))
    track_w_g<-matrix(0, ncol=nrow(st$exemplars),nrow=nrow(tr))
    # track_w_e<-matrix(0, ncol=nrow(st$exemplars),nrow=nrow(tr))
    track_a_g<- matrix(0, ncol=2,nrow=nrow(tr))
    track_alpha<- matrix(0, ncol=st$nFeats,nrow=nrow(tr))
    
    for (j in 1:nrow(tr)){
     # for (j in 1:348){
    ## initialize
    if (tr[j,"ctrl"]==1){
        ## initialize
        ## rule response gains
        w_r<-matrix(0,nrow=st$nCats, ncol=nRules*2)
            #rownames(w_r)<-tcats  ## debugging only
        ## exemplar response gains
        w_e<-matrix(0,nrow=st$nCats, ncol=nrow(st$exemplars))
            #rownames(w_e)<-tcats  ## debugging only
        ## exemplar gate weights
        w_g<-matrix(0,nrow=1, ncol=nrow(st$exemplars))
        ## dimension attention
        alpha<-rep(1/st$nFeats,st$nFeats)
    }
    
    ## Rule Activation (E1)
    a_rule<-cbind(as.vector(sapply(st$prime_dim,function(x1){
        t(cbind(c(1-(1+exp(-st$y_r*(tr[j,tfeats[x1]]+st$beta[x1])))^-1),
                c((1+exp(-st$y_r*(tr[j,tfeats[x1]]+st$beta[x1])))^-1))) 
        })))
            
    ## Rule output activation (E2)
    r_probs<-(w_r)%*%a_rule
    
    ## ALCOVE output activation (E3)
    a_ej<- (cbind(exp(-.5*st$c*colSums(abs((t(st$exemplars)-as.numeric(tr[j,tfeats]))*alpha)))))
    e_probs<-(w_e)%*%a_ej
    
    ## Gating Node (E5)
    a_g<-c((1+exp(-st$y_g*(sum(w_g*t(a_ej))+st$beta_g)))^-1,
           1-(1+exp(-st$y_g*(sum(w_g*t(a_ej))+st$beta_g)))^-1)
    ## note: a_g[1] is exemplar gate; a_g[2] is rule gat
    ## note: positive values of w_g will activate the exemplar gate,
    ## negative values the rule gate
    
    ## Response Probability (E6)
    probs<-t(a_g[1]*(exp(st$phi*e_probs)/sum(exp(st$phi*e_probs)))+
         a_g[2]*(exp(st$phi*r_probs)/sum(exp(st$phi*r_probs))))
    
    
    ## track
    response_probabilities[j,]<-probs
    ## Learning ##########
    
    if (tr[j,"ctrl"]!=2){
    ## get correct category
    cCat<-which(tr[j,tcats]==1)
    eCat<-which(tr[j,tcats]!=1)
    tr[j,]
    ## Rule teachers (E7)
    t_r<-rep(0,st$nCats)
    t_r[cCat]<- max(1,r_probs[cCat])
    t_r[eCat]<- min(0,r_probs[eCat])
    
    ## Exemplar teachers (E7)
    t_e<-rep(0,st$nCats)
    t_e[cCat]<- max(1,e_probs[cCat])
    t_e[eCat]<- min(0,e_probs[eCat])
   
    ## Rule Accuracy (E9)
    RA<-exp(-.5*st$cost[2]*sum((t_r-r_probs)^2))
    
    ## Exemplar Accuracy (10)
    EA<-exp(-.5*st$cost[1]*sum((t_e-e_probs)^2))
    
    ## Error Signal (E11, why is there E8...?)
    MA<- a_g[1]*EA+a_g[2]*RA
    
    ## Updates #############
    
    ## Rule to category gain update (E12)
    delta_w_r <- sapply(1:(nRules*2), function(x) {
            st$lambda_r*
            (t_r-r_probs)*a_rule[x]*
            ((st$cost[2]*RA*a_g[2])/MA)
    })
    
    
    ## Exemplar to category gain update (E13)
    delta_w_e <- sapply(1:nrow(st$exemplars), function(x) {
            st$lambda_e*
            (t_e-e_probs)*a_ej[x]*
            ((st$cost[1]*EA*a_g[1])/MA)
    })
   
    
    ## Attention Update (E14)
    delta_alpha<-sapply(1:st$nFeats, function(y){
        sum(
        sapply(1:nrow(st$exemplars), function(x) {
            st$lambda_a*
                sum(
                    (t_e-e_probs)*w_e[,x]*
                    ((st$cost[1]*EA*a_g[1])/MA)
                    )*
                a_ej[x]*st$c*
                abs((st$exemplars[x,y])-as.numeric(tr[j,c("x1","x2")][y]))
        })
        )
    })
    
    ## Gate Weight Update (E15)
    delta_w_g<-
    st$lambda_g*((EA-RA)/MA)*prod(a_g)*st$y_g*a_ej
    
    ## Commit updates
    w_r<-w_r+delta_w_r
    #track_w_r[j,]<-w_r
    w_e<-w_e+delta_w_e
    #track_w_e[j,]<-w_e
    alpha<-alpha+delta_alpha
    w_g<-w_g+t(delta_w_g)
    
    }
    track_alpha[j,]<-alpha
    track_w_g[j,]<-w_g
    track_a_g[j,]<-a_g
    }
    if (extend==F){
        return(response_probabilities)
    }
    if (extend==T){
        output<-list()
        output$response_probabilities
        output$track_alpha<-track_alpha
        output$track_w_g<-track_w_g
        output$track_a_g<-track_a_g
        output$w_e<-w_e
        output$w_r<-w_r
        return(output)
    }
}


### debugging tracks

cbind(tr,track_a_g)
