# PLY34: Script to run model recovery 
# CERE - 17-8-2015 - Created

#-------------------------------------------------------------------------------
# Setup
rm(list=ls())

# Packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(grt, foreach, doParallel, parallel)

source('PLY34 Functions.R')

# Setup parallel backend to use 8 processors
number_cores <- detectCores(logical=FALSE)

# Setup data frame
center <- 100.0
no_trials <- 400.0
#-------------------------------------------------------------------------------
recovered_models <- read.csv("Data/recovered_models.csv")
# Run loop
cl <- makeCluster(number_cores-1)
registerDoParallel(cl)

chunks <- seq(1, nrow(recovered_models), 20)
for (j in 1:length(chunks)){
  start_i <- chunks[j]
  end_i <- chunks[j]+19
  
  if(end_i>dim(recovered_models)[1]) end_i<-dim(recovered_models)[1]
  
  output <- foreach(i=start_i:end_i, .combine="rbind") %dopar% {
    source('PLY34 Functions.R')
    # Generate appropriate category structure
    cat_mean <- list("A"=c(recovered_models$meanA_x[i], recovered_models$meanA_y[i]), 
                     "B"=c(recovered_models$meanB_x[i], recovered_models$meanB_y[i]))
    sigma12 <- recovered_models$sigma_x[i]*recovered_models$sigma_y[i]*recovered_models$rho[i]
    sigma <- list("both"=matrix(c(recovered_models$sigma_x[i]^2, sigma12, 
                                  sigma12, recovered_models$sigma_y[i]^2), 2, 2))
    stimuli <- generate_stimuli(type="UD", mean=cat_mean, sigma=sigma, 
                                length=no_trials)
    # Loop to get responses/model fits
    models <- data.frame("participant"=1:recovered_models$no_ppts[i])
    models[c("Model","BIC","wBIC_UD", "wBIC_GLC", "wBIC_CJ","wBIC_RND")]<-NA
    for (ppt in 1:recovered_models$no_ppts[i]){
      stimuli["participant"] <- ppt
      if (recovered_models$strategyType[i]=="RND"){
        stimuli["response"] <- random_responses(no_trials, bias=0.5)
      } else if (recovered_models$strategyType[i]=="UD"){
        stimuli["response"] <- ud_responses(category_structure=stimuli[,1:4], 
                                            perceptual_noise=recovered_models$perceptualNoise[i],
                                            boundary=50, 
                                            boundary_noise=recovered_models$boundaryNoise[i], 
                                            exp_noise=recovered_models$experimentalNoise[i])
      } else if (recovered_models$strategyType[i]=="II"){
        stimuli["response"] <- ii_responses(category_structure=stimuli[,1:4], 
                                            perceptual_noise=recovered_models$perceptualNoise[i],
                                            gradient=1, y_intercept=0, 
                                            boundary_noise=recovered_models$boundaryNoise[i], 
                                            exp_noise=recovered_models$experimentalNoise[i])
      } else if (recovered_models$strategyType[i]=="CJ"){
        stimuli["response"] <- cj_responses(category_structure=stimuli[,1:4], 
                                            perceptual_noise=recovered_models$perceptualNoise[i],
                                            x_intercept=50.0, y_intercept=50.0, type="CJ_UL",
                                            boundary_noise=recovered_models$boundaryNoise[i], 
                                            exp_noise=recovered_models$experimentalNoise[i])
      }
      
      model_fit <- apply_models(stimuli, 
                                models=list('UDX'=T, 'UDY'=T, 'GLC'=T, 'CJ_LL'=F, 
                                            'CJ_UL'=T, 'CJ_UR'=F, 'CJ_LR'=T, 'RND_FIX'=T,
                                            'RND_BIAS'=F, 'TINAH_V1'=F, 'TINAH_V2'=F, 'CJ2'=F,
                                            'GCM'=F, 'XruleX'=F, 'YruleX'=F),
                                response_label="response")
      model_fit <- model_fit[complete.cases(model_fit),]
      win_model <- model_fit[model_fit$Rank==1,]
      models[ppt,2:3] <- win_model[1, c("Model","BIC")]
      
      all_model <- aggregate(list(model_fit$wBIC), list(model_fit$Model), mean)
      colnames(all_model)<-c("Model", "wBIC")
      models$wBIC_UD[ppt] <- mean(all_model$wBIC[all_model$Model=="UDX"], 
                             all_model$wBIC[all_model$Model=="UDY"])
      models$wBIC_GLC[ppt] <- all_model$wBIC[all_model$Model=="GLC"]
      models$wBIC_CJ[ppt] <- mean(all_model$wBIC[all_model$Model=="CJ_UL"], 
                                  all_model$wBIC[all_model$Model=="CJ_LR"])
      models$wBIC_RND[ppt] <- all_model$wBIC[all_model$Model=="RND_FIX"]
    }
    models <- models[complete.cases(models),]
    proportions <- c(nrow(models[models$Model=="UDX"|models$Model=="UDY",]), 
                     nrow(models[models$Model=="GLC",]), 
                     nrow(models[models$Model=="CJ_UL"|models$Model=="CJ_UR",]),
      nrow(models[models$Model=="RND_FIX"|models$Model=="RND_BIAS",]))/nrow(models)
    wBICs <- c(mean(models$wBIC_UD[models$Model=="UDX"|models$Model=="UDY"]),
               mean(models$wBIC_GLC[models$Model=="GLC"]),
               mean(models$wBIC_UD[models$Model=="CJ_UL"|models$Model=="CJ_LR"]),
               mean(models$wBIC_RND[models$Model=="RND_FIX"]))
    c(proportions, wBICs)
  }
  recovered_models[start_i:end_i,c("prop_UD","prop_II","prop_CJ","prop_RND", 
                                   "wBIC_UD", "wBIC_GLC", "wBIC_CJ","wBIC_RND")]<-output
  write.csv(recovered_models, "Data/recovered_models.csv")
  print(j)
}
stopCluster(cl)

