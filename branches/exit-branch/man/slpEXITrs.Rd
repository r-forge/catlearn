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
  each category. It also returns the final state of the network.
  Which partially is given by parameter presets to the model 
  (for details see below). The final state of the network includes: 
  input-to-category weights, i.e. the modified \code{w_in_out}, 
  the modified \code{w_exemplars} associative weights between 
  exemplar nodes and attention gain nodes, the final attention gains,
  the final attention strengths. Each output is indexed corresponding
  to the formula as it appears in, E5_attention_strengths denotes
  attention strengths as defined in equation 5 in Kruschke (2011).
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
  
  \code{t1, t2, \dots} - columns for the teaching values indicating the
  category feedback on the current trial. Each category needs a single
  teaching signal in a dummy coded fashion. E.g., if the first category
  is the correct category for that trial, then \code{t1} is set to
  \code{1}, else it is set to \code{-1}. These columns have to start 
  with \code{t1} ascending with categories \code{\dots, t2, t3, \dots} 
  at adjacent columns.
  
  \code{tr} also requires a column \code{ctrl}, which gives control 
  over the network learning states for exemplar weight nodes, 
  attention gain nodes (and thereby learned attention weights) as well 
  as feature input to category output weights. If \code{ctrl} is set to 
  \code{1} all these network parameters are (set)re-) intialized at 0. 
  Setting \code{ctrl} to \code{0} represents a normal learning trial. 
  If \code{ctrl} is set to \code{2} the network learning is frozen 
  at the current state of learning (e.g. for testing predictions on 
  new trials without teaching signals). 
  If \code{ctrl} is set to \code{3} the network parameters for
  \code{w_in_out} and \code{w_exemplars} are reset to the custom pre-
  defined settings (see below).
  
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

  \code{nFeat} - integer indicating the total number of possible
  stimulus features, i.e. the number of \code{x1, x2, \dots} columns in
  \code{tr}.
  
  \code{nCat} - integer indicating the total number of possible
  categories, i.e. the number of \code{t1, t2, \dots} columns in
  \code{tr}.
  
  \code{st} also requires the following model parameters, which are
  described in the same order as in Kruschke (2001, p.821). The
  mentioned equations refer to the formulae in that article:
  
  \code{phi} - response scaling constant - Equation (2)
  
  \code{c} - specificity parameter. Defines the narrowness of 
  receptive field in exemplar activation - Equation (3).
  
  \code{P} - Attentional normalization power (i.e. attentional capacity)
  - Equation (5). If \code{P} equals \code{1} then the attention weights
  will satisfy the constraint that attention strength for currently 
  present features will sum to one. The sum of attention strengths
  for present features grows as a function of \code{P}.
  
  \code{l_gain} - attentional shift rate - Equation (8)
  
  \code{l_weight} - learning rate for feature to category associations.  
  - Equation (9)
  
  \code{l_ex} - learning rate for exemplar_node to gain_node associations
  - Equation (10)
  
  \code{iterations} - number of iterations of shifting attention strength 
  in Equation (8) for each trial. Kruschke (2001, p.820) sets this to the 
  arbitrary value of 10, which produces a larger attention shift in each
  trial.
 
  \code{w_in_out} - matrix with \code{nFeat} columns and \code{nCat} rows,
  defining the input-to-category association weights, i.e. how much each
  feature is associated to a category (see Equation 1). The \code{nFeat} 
  columns follow the same order as \code{x1, x2, \dots} in \code{tr}, 
  and likewise, the \code{nCat} collumns follow the order of 
  \code{t1, t2, \dots}. If \code{ctrl} in \code{tr} is set to 3 this 
  matrix will be used, e.g. for intializating or resetting the network 
  in the given trial. If \code{ctrl} in \code{tr} is set to 1 a 
  corresponding matrix with 0 entries will be used, e.g. for intilization 
  or reset, however a definition of \code{w_in_out} is required.

  \code{exemplars} - matrix with \code{nFeat} columns and n rows, where
  n is the number of exemplars, such that each row represents a single
  exemplar in memory, and their corresponding feature values. It is
  assumed that all exemplars are present in memory from the very first
  learning trial, however their impact on the output activation depends
  on the exemplar-node-to-gain weights \code{w_exemplars}, which are used
  in Equation 4. The \code{nFeat} columns follow the same order as 
  \code{x1, x2, \dots} in \code{tr}. The n-rows follow the same order 
  as in the \code{w_exemplars} matrix defined below.
  
  \code{w_exemplars} - matrix which is structurally equivalent to 
  \code{exemplars}. However, the matrix represents the associative weight
  from the exemplar nodes to the gain nodes, as given in Equation 4.
  The \code{nFeat} columns follow the same order as 
  \code{x1, x2, \dots} in \code{tr}. The n-rows follow the same order 
  as in the \code{exemplars} matrix defined below. The order or exemplar
  rows in \code{exemplars} and \code{w_exemplars} is only restricted
  by their equivalence.
  
\author{René Schlegelmilch}

\references{
  Kruschke, J. K. (1996). Base rates in category learning. \emph{Journal 
  of Experimental Psychology-Learning Memory and Cognition, 22}(1), 3-26.
  
  Kruschke, J. K. (2001). Toward a unified model of attention in 
  associative learning. \emph{Journal of mathematical psychology, 45}(6), 
  812-863.

}

\examples{

     ### Normal learning
     ### with frozen sequence and reset afterwards 

    ## still quick and dirty check (will be modified)
    tr<-nosof94train()
    ## exclude all trials with all absent features
    tr<-tr[!(tr[,5]==0 & tr[,6]==0 & tr[,7]==0),]    
    
    ## resetting at trial 1 and 100 
    ## with frozen learning period from 30 to 100
    tr[c(1),1]<-1  
    tr[30:100,1]<-2
    
    ## Network:
    ## Fast attention learning network, 
    ## slow exemplar learning 
    st<-list(nFeat=3, 
             nCat=2, 
             phi=2, 
             c=1, 
             P=1,
             l_gain=1, 
             l_weight=.1,
             l_ex=.1, 
             iterations=10, 
             eta=1)
    
    ## set up some exemplars 
    st$exemplars<-tr[1:4,
              colFeat1:(colFeat1+st$nFeat-1)]
    ## initialize exemplar associative weights at 0
    st$w_exemplars<-st$exemplars
    st$w_exemplars[]<-0
    ## initialize feature category weights at 0
    st$w_in_out<-matrix(0,st$nCat,st$nFeat)
    
    ## and run:
    slp_EXIT(st,tr)

    ## see how predicted choice probabilities converge towards the teaching
    ## signl
    convergence<-as.data.frame(cbind(slp_EXIT(st,tr)$response_probabilities, 
                                     tr[,c("x1", "x2", "x3", "t1", "t2")]))

    convergence[convergence[,6]== -1,]<-0
    ## G-square over trials when response probability is compared to the 
    ## teaching signal category 1
    plot(-2*log(dbinom(convergence[,6],1,convergence[,1])), type="l", main="Fast Learning")

