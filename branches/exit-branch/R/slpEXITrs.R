## Author: René Schlegelmilch
    
slp_EXITrs<-function(st, tr,xtdo=FALSE) {
    
    out<-.subfunction(st,tr, extendx=xtdo)
    return(out)
   
}

.subfunction<- function(st, tr, extendx){
    #extendx=F
    ## Preparation of processing vars

    ## first column indices of the features
    colFeat1<-grep("x1$", colnames(tr))

    ## and first column of the teacher values
    colt1<-grep("t1$", colnames(tr))
    
    ## set up ouptut matrices
    ## response probability matrix will be the default output
    probs_out<-matrix(0, ncol=st$nCat, nrow=nrow(tr))
    
    ## salience vector sigma
    sig<-rep(1,st$nFeat)
    sig[st$nFeat]<-st$sigma
    ## extended output
    if (extendx==T){
        E4_exemplar_weights<-list()
        weights_in_out<-list()
        gains<-matrix(0,ncol=st$nFeat,nrow=nrow(tr))
        attention<-matrix(0,ncol=st$nFeat,nrow=nrow(tr))
        bias_weight<-matrix(0,ncol=st$nCat ,nrow=nrow(tr))
    }
    
    
    ## go through all the trials and apply model
    for(j in 1:nrow(tr)){
    #for(j in 1:69){   
        ## first define indicator variables for correct cats
        ## cCat: index of present cat; eCat: absent cats
        cCat<-eCat<-c()
        
        ## ("try", in case there are no cats e.g. during test trials)
        try(cCat<-which(tr[j,colt1:(colt1+st$nCat-1)] %in% 1),
            silent==TRUE)
        try(eCat<-which(tr[j,colt1:(colt1+st$nCat-1)] %in% -1),
            silent==TRUE)
        
        ## teaching signals:
        ## The EXIT paper simply states:
        ## t=0 if outcome is absent and t=1 if outcome present.
        teacher<- matrix(0, ncol=st$nCat)
        teacher[cCat]<- 1
        teacher[eCat]<- 0
        
        
        ## Extract input activations for current trial 
        ## (i.e. which feature is present?)
        a_in<-as.numeric(tr[j,colFeat1:(colFeat1+st$nFeat-1)])
       
        ## get the current exemplar (include bias as exemplar...
        ## i.e. bias = always present)
        curEx<-c(which(sapply(1:nrow(st$exemplars), function(x){
            sum(st$exemplars[x,1:(st$nFeat)]==a_in)
        })==(st$nFeat)))
        

        # ## calculate exemplar activation a_ex(x)
        # ## with minkowski metric Equation (3)
        a_ex<-exp(-st$c*rowSums(
            sig*abs(t(
                t(st$exemplars)-
                    as.numeric(a_in)))
        ))

        
        ## is this a reset trial? (ctrl==1)
        ## reset exemplar weight and gain nodes
        if (tr[j,"ctrl"]==1){
        w_exemplars<-st$exemplars
        w_exemplars[]<-0
        w_in_out<-matrix(0,st$nCat,st$nFeat)
        ## just for better understanding and debugging here
        ## rownames(w_in_out)<-c("t1","t2","t3","t4","t5","t6")
        }
        
        ## user defined initialization?
        if (tr[j,"ctrl"]==3){
            w_exemplars<-st$ex_weights_init
            w_in_out<-st$w_io_init
        }
        
        ## calculate current activation of gain nodes g
        ## Equation (4) 
        g<-a_in*sig*exp(colSums(w_exemplars*a_ex))
        ## negative gains are set to 0
        g[g<0]<-0
        
        ## calculate current attention strengths alpha_i
        ## Equation (5) 
        ## Note: used for updates in Equations 9 and 10
        alpha_i<-g/((sum(g^st$P))^(1/st$P))
        
        ## calculate category activation
        ## Equation (1) (or 40 with bias)
        ## Note: used for updates in Equations 9 and 10
        out_act<-(a_in*alpha_i)%*%t(w_in_out)
       
        ## and category probability
        ## Equation (2) (or 39 with bias)
        probs<-exp(out_act*st$phi)/sum(exp(out_act*st$phi))
        
        ## is this a frozen learning trial? (ctrl==2)
        if( tr[j,"ctrl"]!=2) {
        
        
        ## Attention Shifting
        ## Equation (8)
        ## iterates multiple times by an arbitrary number...
        g_inits<-g
        for (k in 1:st$iterations) {
        
            ## calculate attention strengths alpha_i
            ## Note: calculated in each iteration according to Kruschke
            ## Equation (5) 
            alpha_i2<-g/((sum(g^st$P))^(1/st$P))
            
            ## calculate category activation
            ## Note: calculated in each iteration according to Kruschke
            ## Equation (1) 
            out_act2<-(a_in*alpha_i2)%*%t(w_in_out)

            ### Update exemplar gains, attention weights 
            ### and exemplar node weights:::::::::::::::

            ## first term teacher values
            E1<-(teacher-out_act2)
            
            ## second term (wI*a_inI - alpha_I*a_out)
            E2<-t(as.numeric(a_in[a_in==1])*t(w_in_out[,a_in==1])-
                as.numeric(alpha_i2[a_in==1]^(st$P-1))%*%(out_act2))
            
            ## Terms E1 and E2 are calculated for each current input I
            ## and then summed accross category nodes
            Ex<-E1%*%(E2)
            
            ## divided by 3rd term
            E3<-sum(g^st$P)^(1/st$P)
            
            ## Full equation then:
            gain_delta<-st$l_gain*(Ex/E3)
            
            ## adjust g for current Input I
            g[a_in==1]<-g[a_in==1]+gain_delta
            g[g<0]<-0
            ## in the next iteration g is used for re-calculating
            ## alpha i and output activation
        }
        
        ## commiting the changed variables to the 
        ## next steps increases learning speed
        ## Without this step, predicted blocking probs are "lower"
        ## Whithout this step, attenuation is hardly predicted
        ## try it yourself
        out_act<-out_act2
        alpha_i<-alpha_i2
        
        ## Learning of Associations
        ## Gradient of error for weight change
        ## calculated for K (... I assume this means the present category)
        ## and I (present Input)
        ## Equation (9)
        weight_delta<-st$l_weight*(teacher[cCat]-out_act[cCat])*
                        as.numeric(alpha_i[a_in==1])*as.numeric(a_in[a_in==1])
        
        ## adjust for the correct category
        w_in_out[cCat,a_in==1]<-w_in_out[cCat,a_in==1]+weight_delta
        
        ## Gradient of error for exemplar gain change
        ## gain from current exemplar X to present input node I 
        ## Equation (10)
        ## note: a_ex in equation 10 is quite redundant as it is always 1
        ## so I am not sure, whether it has a deeper meaning here...
        ex_in<-st$exemplars[curEx,1:(st$nFeat)]
        ex_weights_delta<- st$l_ex*(g[ex_in==1]-g_inits[ex_in==1])*
                            g_inits[ex_in==1]*a_ex[curEx]
        ## adjusts exemplar-node-to-gain weights for
        w_exemplars[curEx,ex_in==1]<-ex_weights_delta+w_exemplars[curEx,ex_in==1]

        
        }

        
    probs_out[j,]<-probs
    if (extendx==T){
        E4_exemplar_weights[[j]] <-w_exemplars
        weights_in_out[[j]]<-w_in_out
        gains[j,]<-g_inits
        attention[j,]<-alpha_i
    }
    
    }
    if (extendx==F){
        output<-list()
        output$response_probabilities<-probs_out
    } else {
        output<-list()
        output$response_probabilities<-probs_out
        output$E4_exemplar_weights<-E4_exemplar_weights
        output$E1_w_in_out<-weights_in_out
        output$E4_gains<-gains
        output$E5_attention_strengths<-attention
    }
    
    return(output)
}




