## Author: Rene Schlegelmilch
## (Andy Wills made some minor changes)

## Main function
stsimGCMrs<-function(st) {
    ## Add weight for last dimension
    st$weights <- as.numeric(c(st$weights, 1-sum(st$weights)))
    
    ## Add choice bias for last category
    st$choice_bias <- as.numeric(
        c(st$choice_bias, 1-sum(st$choice_bias)))
    
    ## recode memory strength
    memory<-matrix(1, ncol=nrow(st$training_items))
    try(memory[which(st$training_items$mem %in% 1)]<-st$mp, silent==TRUE)
    
    ## pass to prediction function
    get_p<-.gcm.predictions(tdf=st$tr, 
                     ex=st$training_items,
                     mem=memory,
                     r_met=st$r_metric,
                     c=st$sensitivity,
                     p=st$p,
                     gamma=st$gamma,
                     cb=st$choice_bias,
                     weights=st$weights,
                     nCats=st$nCats,
                     nFeat=st$nFeat
                     )
    return(get_p)
}

## Prediction function
.gcm.predictions<-function(tdf, ex,mem,r_met,c,p,gamma,cb,weights, 
                           nCats, nFeat) {
    
    ## Go through every trial/item in the tr matrix/dataframe
    ## and calculate all exemplar similarities weighted by 
    ## memory strength
    ## 
    feat1col<-grep("x1", colnames(tdf))
    sims<-apply(tdf[,feat1col:(feat1col+nFeat-1)],1, 
                function(x,r, w, sens, p1, memo, exemplars, nF){
                    
                    ## calculates absolute feature differences
                    ## between current item and all training items
                    ## and applies metric r
                    ef1col<-grep("x1", colnames(exemplars))
                    d1<-abs(t(t(exemplars[,ef1col:(ef1col+nF-1)])-
                                            (as.vector(x))))^r
                    
                    ## calculates corresponding summed weighted 
                    ## differences and applies metric r
                    d2<-(rowSums(d1*w))^(1/r)
                    
                    ## calculates exponential similarity and
                    ## applies p, c and memory parameters
                    d3<- exp(-sens*(d2^p1))*memo
                },
                r=r_met, w=weights, p1=p, sens=c, 
                memo=mem, exemplars=ex, nF=nFeat
    )
    
    ## sums exemplar similarities for each category
    cat1col<-grep("cat1", colnames(ex))
    simsums<-t(sims)%*%as.matrix(ex[,cat1col:(cat1col+nCats-1)])
    
    ## applies gamma response determinism parameter
    simsums<-simsums^gamma
    
    ## applies category choice bias
    simsums<-t(cb*t(simsums))
    
    ## transforms category similarities to percent choice probability
    simperx<-simsums/(rowSums(simsums))
    
    return(simperx)
}

