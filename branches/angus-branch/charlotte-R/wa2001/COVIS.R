# COVIS model to look at Waldron & Ashby (2001) as printed in
# Formal models of categorization, editted by Wills & Pothos (2011)

# Set-up ----------------------------------------------------------------------
rm(list=ls()) # Clear all variables in the workspace

# if (!require("pacman")) install.packages("pacman")
# pacman::p_load(ggplot2)

# Functions
source("COVISfunctions.R")

# WA2001 ----------------------------------------------------------------------
# Category structure
WA2001structure <- data.frame("StimulusNo"=1:16,
                     "Dim1"=rep(0:1,each=8),
                     "Dim2"=rep(0:1,each=4),
                     "Dim3"=rep(0:1,each=2),
                     "Dim4"=rep(0:1,each=1),
                     "CategoryRB"=factor(rep(0:1,each=8),labels=c("A","B")),
                     "CategoryII"=factor(rep(0:1),labels=c("A","B")))
WA2001structure$CategoryII <- ifelse(WA2001structure$Dim1+WA2001structure$Dim2+
                                      WA2001structure$Dim3>1.5,
                                     "B","A")

# Parameter values ------------------------------------------------------------
# Explicit system
sigmaE <- 0
deltaC <- 0.0025
deltaE <- 0.02
initialZ <- c(0.25,0.25,0.25,0.25)
# gamma and lambda defined below

# Procedural system
Dbase <- 0.2
alphaW <- 0.65
betaW <- 0.19
gammaW <- 0.02
thetaNMDA <- 0.0022
thetaAMPA <- 0.01
wMax <- 1
sigmaP <- 0.0125

# Competition
deltaOC <- 0.01
deltaOE <- 0.04

# Implementation
totalRules <- 4
pptNo <- 10
    # Get names for striatal weights
J <- paste("w",rep(1:2, each=16),sep="") # No. stimuli
wKJ <- paste(J,1:16,sep="_")

# Generate experiment output
WA2001output <- data.frame("Participant"=rep(1:pptNo, each=2),
                           "CategoryStructure"=factor(rep(1:2),
                                                      label=c("RB","II")),
                           "Manipulation"=factor(rep(1:2, each=2),
                                                 label=c("control","task")),
                           "Trials"=NA,
                           "System"=NA,
                           "NegativeZ"=NA)


for (j in 1:nrow(WA2001output)){

    condition <- WA2001output$CategoryStructure[j]
    # Generate experiment data frame for each participant
    WA2001 <- data.frame()
    for (k in 1:13) {
        WA2001 <- rbind(WA2001,WA2001structure[sample(nrow(WA2001structure)),])
    }
    WA2001 <- WA2001[1:200,]

    WA2001[c("Category","Z1","Z2","Z3","Z4","RuleNo","hE","respExplicit",
             "respProcedural","hP","obtainedReward","predictedReward","RPE",
             "dopamine","thetaE","Response","Correct","NoCorrect")] <- NA
    if (condition=="II"){
        WA2001$Category <- factor(WA2001$CategoryII)
    } else if (condition=="RB"){
        WA2001$Category <- factor(WA2001$CategoryRB)
    }

    WA2001[1,c("Z1","Z2","Z3","Z4")] <- initialZ


    WA2001[wKJ] <- NA
    WA2001[1,wKJ] <- 0.001 + 0.0025*runif(32)

    if (WA2001output$Manipulation[j]=="control") {
        # Parameters for control conditions
        gamma <- 1
        lambda <- 5
    } else if (WA2001output$Manipulation[j]=="task") {
        # Parameters for dual-task conditions
        gamma <- 20
        lambda <- 0.5
    }

# COVIS model -----------------------------------------------------------------
    for (i in 1:nrow(WA2001)){
        # Explicit system: For trial 1, randomly select rule

        Z <- WA2001[i, c("Z1","Z2","Z3","Z4")]
        if (is.na(WA2001$RuleNo[i])) {
            WA2001$RuleNo[i] <- sample(1:totalRules, 1, prob=Z, replace=T)
            WA2001$thetaE[i] <- 0.99
        }

        # Explicit system: Apply rule
        if (WA2001$RuleNo[i]==1) {
            WA2001$hE[i] <- WA2001$Dim1[i]-0.5
            WA2001$respExplicit[i] <- ifelse(WA2001$hE[i]<rnorm(1,0,sigmaE),
                                             "A", "B")
        } else if (WA2001$RuleNo[i]==2) {
            WA2001$hE[i] <- WA2001$Dim2[i]-0.5
            WA2001$respExplicit[i] <- ifelse(WA2001$hE[i]<rnorm(1,0,sigmaE),
                                             "A", "B")
        } else if (WA2001$RuleNo[i]==3) {
            WA2001$hE[i] <- WA2001$Dim3[i]-0.5
            WA2001$respExplicit[i] <- ifelse(WA2001$hE[i]<rnorm(1,0,sigmaE),
                                             "A", "B")
        } else if (WA2001$RuleNo[i]==4) {
            WA2001$hE[i] <- WA2001$Dim4[i]-0.5
            WA2001$respExplicit[i] <- ifelse(WA2001$hE[i]<rnorm(1,0,sigmaE),
                                             "A", "B")
        }

        # Procedural system: Sensory cortex
        I <- rep(0,16); I[WA2001$StimulusNo[i]] <- 1

        # Procedural system: Activation in striatal unit J
        S <- c(sum(WA2001[i,wKJ[1:16]]*I), sum(WA2001[i,wKJ[17:32]]*I))
        WA2001$hP[i] <- S[1]-S[2]
        # Procedural system: Make response
        WA2001$respProcedural[i] <- ifelse(S[1]>S[2], "A", "B")

        # Competition: Select response from explicit and procedural systems
        WA2001$Response[i] <- ifelse(abs(WA2001$hE[i]*WA2001$thetaE[i])>
                                         abs(WA2001$hP[i])*(1-WA2001$thetaE[i]),
                                     WA2001$respExplicit[i],
                                     WA2001$respProcedural[i])
        WA2001$Correct[i] <- ifelse(WA2001$Response[i]==WA2001$Category[i], 1, 0)

        if (i>7) {
            WA2001$NoCorrect[i] <- sum(WA2001$Correct[(i-7):i])
            if (WA2001$NoCorrect[i]>=8) {
                WA2001output$Trials[j] <- i
                WA2001output$System[j] <- ifelse(abs(WA2001$hE[i]*WA2001$thetaE[i])>
                                                 abs(WA2001$hP[i])*(1-WA2001$thetaE[i]),
                                                 "Explicit","Procedural")
                break
            }
        }

        # Explicit system: Edit weights
        Z[WA2001$RuleNo[i]] <- ifelse(WA2001$respExplicit[i]==WA2001$Category[i],
                                      Z[WA2001$RuleNo[i]] + deltaC,
                                      Z[WA2001$RuleNo[i]] - deltaE)

        # Explicit system: Adjust saliences
        if ((min(Z)<0) & is.na(WA2001output$NegativeZ[j])){
            WA2001output$NegativeZ[j]<-1
        }
        Y <- positive(Z)
        # For rule previously active:
        Y[WA2001$RuleNo[i]] <- Z[WA2001$RuleNo[i]] + gamma
        # For randomly selected rule:
        randRule <- sample(1:totalRules, 1, replace=T)
        Y[randRule] <- Z[randRule] + rpois(1, lambda)

        # Procedural system: Reward prediction error
        # Obtained reward
        if (WA2001$respProcedural[i]==WA2001$Category[i]) {
            # If correct
            WA2001$obtainedReward[i] <- 1
        } else {
            # If incorrect
            WA2001$obtainedReward[i] <- -1
        }
        # Predicted reward
        if (i==1){
            WA2001$predictedReward[i] <- 0
        } else {
            WA2001$predictedReward[i] <- WA2001$predictedReward[i-1] +
                0.025*(WA2001$obtainedReward[(i-1)]-
                       WA2001$predictedReward[(i-1)])
        }
        WA2001$RPE[i] <- WA2001$obtainedReward[i]-WA2001$predictedReward[i]
        if (WA2001$RPE[i]>1){
            WA2001$dopamine[i]<-1
        } else if (WA2001$RPE[i]<=-0.25) {
            WA2001$dopamine[i]<-0
        } else {
            WA2001$dopamine[i] <- 0.8*WA2001$RPE[i]+0.2
        }

        if (i==nrow(WA2001)) {
            WA2001output$Trials[j] <- NA
            break
        }

        # Explicit system: Pick rule
        if (WA2001$respExplicit[i]==WA2001$Category[i]) {
            # If correct response keep same rule
            WA2001$RuleNo[i+1] <- WA2001$RuleNo[i]
            WA2001$thetaE[i+1] <- WA2001$thetaE[i]+deltaOC*(1-WA2001$thetaE[i])
        } else {
            # If incorrect response change sampling weights Z
            WA2001$RuleNo[i+1] <- sample(1:totalRules, 1,
                                         prob=positive(Y/sum(Y)),replace=T)
            WA2001$thetaE[i+1] <- WA2001$thetaE[i]-deltaOE*WA2001$thetaE[i]
        }

        # Explicit system: update weights for next trial
        WA2001[i+1,c("Z1","Z2","Z3","Z4")] <- positive(Z)

        # Procedural system: Update links between cortical and striatal units
        wKJvalues <- WA2001[i,wKJ]
        wKJvalues[,paste("w1_", WA2001$StimulusNo[i],sep="")] <-
            wKJvalues[,paste("w1_", WA2001$StimulusNo[i],sep="")] +
            alphaW*positive(S[1]-thetaNMDA)*positive(WA2001$dopamine[i]-Dbase)*
                (wMax-wKJvalues[,paste("w1_", WA2001$StimulusNo[i],sep="")]) -
            (betaW*positive(S[1]-thetaNMDA)*positive(WA2001$dopamine[i]-Dbase)+
                gammaW*positive(positive(thetaNMDA-S[1])-thetaAMPA))*
                wKJvalues[,paste("w1_", WA2001$StimulusNo[i],sep="")]

        wKJvalues[,paste("w2_", WA2001$StimulusNo[i],sep="")] <-
            wKJvalues[,paste("w2_", WA2001$StimulusNo[i],sep="")] +
            alphaW*positive(S[2]-thetaNMDA)*positive(WA2001$dopamine[i]-Dbase)*
            (wMax-wKJvalues[,paste("w2_", WA2001$StimulusNo[i],sep="")]) -
            (betaW*positive(S[2]-thetaNMDA)*positive(WA2001$dopamine[i]-Dbase)+
                 gammaW*positive(positive(thetaNMDA-S[2])-thetaAMPA))*
            wKJvalues[,paste("w2_", WA2001$StimulusNo[i],sep="")]

        WA2001[i+1,wKJ] <- wKJvalues

    } # End of participant loop
} # End of experiment loop

write.csv(WA2001output, "WA2001output.csv")


# # Summary ---------------------------------------------------------------------
# WA2001summary <- summarySE(WA2001output, measurevar="Trials",
#                          groupvars=c("CategoryStructure", "Manipulation"),
#                          na.rm=T)
#
# plot <- ggplot(data=WA2001summary,
#                aes(x=CategoryStructure,y=Trials,fill=Manipulation)) +
#     stat_summary(position=position_dodge(0.75),fun.y = "mean",geom="bar",
#                  width=0.75) +
#     geom_errorbar(aes(ymax=Trials + se,ymin=Trials - se),
#                   width=0.2,linetype="solid",position=position_dodge(0.75))
# plot


