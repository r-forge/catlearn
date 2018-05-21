\name{slpEXITrs}
\alias{slpEXITrs}
\title{
  EXIT - Exemplar-based attention to distinctive input
}
\description{
  Kruschke's (2001) model extension of ADIT (Kruschke, 1996a)
}
\usage{
  slpEXITrs(st,tr,xtdo)
}
\arguments{
  \item{st}{List of model parameters}
  \item{tr}{R-by-C matrix of training items}
  \item{tr}{if \code{TRUE} extended output is returned}
}  

\value{
  The reduced output returns a matrix where each row is a trial, 
  as presented to the model, and the columns are the response 
  probabilities for each category. If the extended output is 
  enabled, the state of the network in each learning trial 
  is also returned.The state of the network includes: a list 
  of the input-to-category weights in each trial, i.e. the
  modified \code{w_in_out}. It also includes a list of the 
  modified \code{w_exemplars} associative weights between exemplar 
  nodes and attention gain nodes. It also includes matrices
  containing of the the attention gains, attention strengths,
  and the bias-to-category weights. The trials are indexed on
  the top layer of the output-lists, or by the rows of the
  matrices.
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
  defined settings via \code{w_io_init} and \code{ex_weights_init} 
  (see below).
  
  \code{tr} ## should there be missing dimension flags as in ALCOVE?
  
  \code{tr} may have any number of additional columns with any desired 
  name and position, e.g. for readability. As long as the feature columns 
  \code{x1, x2, \dots} are given as defined (i.e. not scattered, across 
  the range of matrix columns), the output is not affected by optional 
  columns. The position of the described groups of columns does not 
  affect the output.

  Argument \code{st} must be a list containing the following required
  items: \code{nFeat}, \code{nCat}, \code{phi}, \code{c}, 
  \code{P}, \code{l_gain}, \code{l_weight}, \code{l_ex},
  \code{iterations}, \code{sigma}. Arguments 
  \code{w_io_init} and \code{ex_weights_init} are optional 
  in case of custom initialization using \code{ctrl} set to \code{3}. 

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
  receptive field in exemplar node activation - Equation (3).
  
  \code{P} - Attentional normalization power (attentional capacity)
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
  
  \code{sigma} - bias salience (fixed at 1 for remaining features).
  See Kruschke(2001a, Equation 4, p.1399).
 
  \code{w_in_out} - matrix with \code{nFeat} columns and \code{nCat} rows,
  defining the input-to-category association weights, i.e. how much each
  feature is associated to a category (see Equation 1). The \code{nFeat} 
  columns follow the same order as \code{x1, x2, \dots} in \code{tr}, 
  and likewise, the \code{nCat} rows follow the order of  
  \code{t1, t2, \dots}. If \code{ctrl} in \code{tr} is set to \code{1} 
  (initialization- or reset-trial) while defining \code{w_in_out}<-NULL, 
  a default matrix with 0 entries will be used for intilization. 
  Alternatively, if \code{ctrl} in \code{tr} is set to \code{1} 
  while providing custom starting values for \code{w_in_out}, the 
  user-defined matrix \code{w_in_out} will be used  in that trial. 
  The function also provides the option to define a second matrix for 
  re-initialization, for being able to re-initialize the network at a 
  different state. This can be done b setting \code{ctrl} in \code{tr} 
  to \code{3}. In the corresponding trial the node weights are 
  reset corresponding to the matrix \code{w_io_init} which then has to be 
  defined according to the description above. If \code{tr} is 
  never set to \code{3}, then a definition of \code{w_io_init} is not
  required.

  \code{exemplars} - matrix with \code{nFeat} columns and n rows, where
  n is the number of exemplars, such that each row represents a single
  exemplar in memory, and their corresponding feature values. 
  The \code{nFeat} columns follow the same order as \code{x1, x2, \dots} 
  in \code{tr}. The n-rows follow the same order as in the 
  \code{w_exemplars} matrix defined below.
  
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
