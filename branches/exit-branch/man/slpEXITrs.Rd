\name{slpEXITrs}
\alias{slpEXITrs}
\title{
  EXIT - Exemplar-based attention to distinctive input
}
\description{
  Kruschke's (2001) model extension of ADIT (Kruschke, 1996a)
}
\usage{
  slpEXITrs(st,tr)
}
\arguments{
  \item{st}{List of model parameters}
  \item{tr}{R-by-C matrix of training items}
}  

\value{
  Returns a matrix where each row is a trial, as presented to the
  model, and the columns are the response probabilities for 
  each category. It also returns the final state of the network 
  (connection weights and other parameters). 
}

\details{
  Argument \code{tr} must be a matrix, where each row is one trial
  presented to the network, in the order of their occurence.
  \code{tr} requires the following columns.
  
  \code{x1, x2, \dots} - columns for each feature dimension carrying 
  numeric values of either \code{1} if a feature was present, or
  \code{0} if a feature was absent during the corresponding trial.
  These columns have to start with \code{x1} ascending with features 
  \code{\dots, x2, x3, \dots} at adjacent columns.
  
  \code{t1, t2, \dots} - columns for the teaching values indicating
  the true correct category in the current trial. Each category 
  needs a single teaching signal in a dummy coded fashion. E.g.,
  if the first category is the true correct category, then \code{t1}
  is set to \code{1}, else it is set to \code{-1} or \code{0} (both
  work). These columns have to start with \code{t1} ascending with 
  categories \code{\dots, t2, t3, \dots} at adjacent columns.
  
  \code{tr} also requires a column \code{ctrl}, which gives control 
  about resetting the complete network of attention weights and 
  node weights to zero. The first trial has to be set to \code{1}. If 
  \code{ctrl} is set to \code{1} in, e.g. trial 100, then the network
  starts learning from the scratch beginning in this trial.
  
  \code{tr} may have any number of additional columns with any desired 
  name and position, e.g. for readability. As long as the feature columns 
  \code{x1, x2, \dots} are given as defined (i.e. not scattered, across 
  the range of matrix columns), the output is not affected by optional 
  columns. The position of the described groups of columns does not 
  affect the output.

  Argument \code{st} must be a list containing the following required
  items: \code{nFeat}, \code{nCat}, \code{phi}, \code{c}, 
  \code{P}, \code{l_gain}, \code{l_weight}, \code{l_ex},
  \code{iterations}, and \code{eta}


## 4.learning rate for attention weight shifts
## Equation (8)
st$l_gain<-1
## 5. learning rate for associative weights for input output nodes
## Equation (9)
st$l_weight<-1 
## 6. learning rate for associative weights for exemplar gain nodes
## Equation (10)
st$l_ex<- 1 
## iterations of attention shift (Equation 8)
st$iterations<-10
## not explicitly stated in the paper(???):
## How does EXIT initialize attention weights alpha_i?
## ADIT initializes attention equal weights in the beginning 
## of every trial: I use the corresponding formula, 
## but for the first trial only, with:
## the higher eta, the higher the initial weights
st$eta <- 1
  
  \code{nFeat} - integer indicating the number of all possible 
  stimulus features, i.e. the number of  \code{x1, x2, \dots} 
  columns in \code{tr}.
  
  \code{nCat} - integer indicating the number of all categories,
  i.e. the number of  \code{t1, t2, \dots} columns in \code{tr}.
  
  \code{st} requires the following parameters, which are described 
  in the same order as in Kruschke (2001, p.821). The mentioned
  equations refer to the formulas in this article:
  
  \code{phi} - response scaling - Equation (2)
  
  \code{c} - specificity parameter. Defines the arrowness of 
  receptive field in exemplar activation - Equation (3).
  
  \code{P} - Power of attentional gain from exemplars -
  Equation (5)
  
  \code{l_gain} - learning rate for attention strength shifts
  Equation (8)
  
  \code{l_weight} - learning rate for shifting the connections 
  (weights) between the feature input to category output nodes 
  - Equation (9)
  
  \code{l_ex} - learning rate for shifting associative connections #
  (weights) between exemplar activation and gain nodes 
  - Equation (10)
  
  \code{iterations} - number of iterations of shifting attention strength 
  in Equation (8) for each trial. Kruschke (2001, p.820) sets this to the 
  arbitrary value of 10, which produces a larger attention shift in each
  trial.
  
  \code{eta} - is defined in ADIT (Kruschke, 1996a) and used for 
  initializing attention strengths at the beginning of learning (or when
  the network is reset). The higher eta, the higher the initial weights,
  although all equal. Initialized/reset attention weights sum to 1 for
  present features if \code{eta}=1.

\author{René Schlegelmilch}

\references{
  Kruschke, J. K. (1996). Base rates in category learning. \emph{Journal 
  of Experimental Psychology-Learning Memory and Cognition, 22}(1), 3-26.
  
  Kruschke, J. K. (2001). Toward a unified model of attention in 
  associative learning. \emph{Journal of mathematical psychology, 45}(6), 
  812-863.

}

\examples{

  ## Fast learning network:
  st<-list(nFeat=3, 
           nCat=2, 
           phi=2, 
           c=1, 
           P=2,
           l_gain=.6, 
           l_weight=.6,
           l_ex=.6, 
           iterations=10, 
           eta=1)

  ## note that stimuli with all absent features are meaningless within this
  ## model. In tr, a value for x1 = 0 means that a feature (e.g. a symptom
  ## for a disease is absolutely not present, nor its negation.)
  tr<-nosof94train()
  
  ## exclude all trials with all absent features
  tr<-tr[!(tr[,5]==0 & tr[,6]==0 & tr[,7]==0),]
  
  ## initializing ctrl=1 in the first trial
  tr[1,1]<-1  
  
  slp_EXIT(st,tr)$response_probabilities
  
  ## see how predicted choice probabilities converge towards the teaching
  ## singal
  convergence<-as.data.frame(cbind(slp_EXIT(st,tr)$response_probabilities, 
  tr[,c("x1", "x2", "x3", "t1", "t2")]))
  convergence[convergence== -1]<-0
  ## G-square over trials when response probability is compared to the 
  ## teaching signal category 1
  plot(-2*log(dbinom(convergence,1,convergence)), type="l", main="Fast Learning")
  
  
  ## Slow learning network, with reset after half 100 trials:
  st<-list(nFeat=3, 
           nCat=2, 
           phi=2, 
           c=1, 
           P=2,
           l_gain=.1, 
           l_weight=.1,
           l_ex=.1, 
           iterations=10, 
           eta=1)

  ## note that stimuli with all absent features are meaningless within this
  ## model. In tr, a value for x1 = 0 means that a feature (e.g. a symptom
  ## for a disease is absolutely not present, nor its negation.)
  tr<-nosof94train()
  
  ## exclude all trials with all absent features
  tr<-tr[!(tr[,5]==0 & tr[,6]==0 & tr[,7]==0),]
  
  ## initializing ctrl=1 in the first trial and trial 100
  tr[1,"ctrl"]<-1  
  tr[100,"ctrl"]<-1  
  
  slp_EXIT(st,tr)$response_probabilities
  
  ## see how predicted choice probabilities converge towards the teaching
  ## singal
  convergence<-as.data.frame(cbind(slp_EXIT(st,tr)$response_probabilities, 
  tr[,c("x1", "x2", "x3", "t1", "t2")]))
  convergence[convergence== -1]<-0
  ## G-square over trials when response probability is compared to the 
  ## teaching signal category 1
  plot(-2*log(dbinom(convergence,1,convergence)), type="l", main="Slow Learning")

}  
