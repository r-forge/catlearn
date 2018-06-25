\name{slpATRIUMrs}
\alias{slpATRIUMrs}
\title{
    ATRIUM - Attention To Rules and Instances in a Unified Model
}
\description{
   As published in Erickson & Kruschke (1998)
}
\usage{
slpATRIUMrs(st,tr,xtdo)
}
\arguments{
\item{st}{List of model parameters}
\item{tr}{R-by-C matrix of training trials}
\item{xtdo}{if \code{TRUE} extended output is returned}
}  

\value{
  The reduced output returns a matrix where each row is a trial, 
  as presented to the model, and the columns are the response 
  probabilities for each category. If the extended output is 
  enabled, the state of the network in each learning trial 
  is also returned. This includes: ...
}

\details{
  Argument \code{tr} must be a matrix, where each row is one trial
  presented to the network, in the order of their occurence.
  \code{tr} requires the following columns.

\code{x1, x2, \dots} - columns for each feature dimension carrying 
  numeric values of the stimulus features, which are represented
  on a continuous scale. Thus, each column \code{\dots, x2, x3, \dots}
  represents a stimulus dimension. They have to start with \code{x1} 
  ascending with dimensions \code{\dots, x2, x3, \dots} at adjacent 
  columns.

\code{t1, t2, \dots} - columns for the teaching values indicating the
  category feedback on a given trial. Thus, each column represents
  one category. In each row values of \code{\dots, t2, t3, \dots} 
  indicate whether a category was present with \code{1}, or absent
  with \code{-1}. However, a value different from \code{1} will
  be considered as absence of the category in any case. Again, these 
  columns have to start with \code{t1} ascending with categories 
  \code{\dots, t2, t3, \dots} at adjacent columns.

\code{tr} also requires a column \code{ctrl}, which gives control 
  over the network learning over trials. If \code{ctrl} is set to 
  \code{1} all network nodes are (re-)intialized to 0, and
  learning starts from scratch (again). Setting \code{ctrl} to 
  \code{0} represents a normal learning trial. If \code{ctrl} is set 
  to \code{2} the network learning is frozen at the current state of 
  learning (e.g. for testing predictions on new trials without teaching 
  signals). 

\code{tr} ## should there be missing dimension flags as in ALCOVE?

\code{tr} may contain additional columns with any desired 
  name, e.g. for readability. As long as the feature columns 
  \code{x1, x2, \dots} and the category columns \code{t1, t2, \dots} are 
  provided as defined (i.e. not scattered, across the range of matrix 
  columns), and as long as they have different column names, the output 
  is not affected by additional columns. 

Argument \code{st} must be a list containing the following required
  items: \code{nFeat}, \code{nCat},.... 

\code{nFeat} - integer indicating the total number of stimulus dimensions, 
  i.e. the number of \code{x1, x2, \dots} columns in \code{tr}.

\code{nCat} - integer indicating the total number of categories, i.e. the 
  number of \code{t1, t2, \dots} columns in \code{tr}.

\code{st} also requires the following items, which refer to the 
  model parameters. The corresponding equations in Erickson & Kruschke 
  (1998) are referenced in brackets.

\code{beta} - (Equation 1) a numeric vector indicating the boundaries between 
  two categories on the given dimensions. Has to be numeric vector of length n, 
  where n denotes the number of stimulus dimensions in their order 
  corresponding to \code{x1, x2, \dots} in \code{tr}. (Please note: the sign of 
  beta will be set to negative within the model. Please use positive values 
  here.) E.g. with two dimensions, where \code{x1} splits categories at the 
  value of 4, and \code{x2} splits the categories at 3, then \code{beta} can be 
  defined by c(4,3), in case it is not estimated. In any case, the length of 
  \code{beta} has to be n, regardless of how which dimension(s) are considered 
  for the application of rules, defined by \code{prime_dim} (see below).

\code{prime_dim} - Indicates which of the dimensions receives a rule 
  representation,in the rule module. E.g. in Erickson & Kruschke (1998) there is 
  only one "primary dimension" that splits the categories, although the stimuli 
  have two dimensions. Consequently, they implemented a rule for the primary 
  dimension only. This can be done by setting \code{prime_dim} to the integer 
  indicating the index of the considered dimension(s) corresponding to 
  \code{x1, x2, \dots}. E.g., if you want a rule only for the dimension 
  \code{x2} only, then set \code{prime_dim} to 2. If you want to consider the 
  first two dimensions \code{x1, x2}, set  \code{prime_dim} to c(1,2). Please 
  make sure, that appropriate boundaries are set in \code{beta}, as well. The 
  dimension indices provided by \code{prime_dim} also index the boundaries in 
  \code{beta}.

\code{y_r} - (Equation 1) rule gain. Has to be a numeric vector of length n, 
  where n is the number of dimensions. Again, the indices of \code{y_r} 
  correspond to \code{x1, x2, \dots} in order. Since the rule gain is not fully 
  specified for multiple rules in Erickson & Kruschke (1998), \code{y_r} could 
  be used in two ways. First, as general output scaling (or sensitivity) of the 
  rule module, i.e. if all values of \code{y_r} are set to be equal. And second, 
  it could also be used as dimension/rule specific gain, acting similar to a 
  dimension attention weight, i.e. if the values of \code{y_r} differ between 
  dimensions. E.g. with two dimensions and \code{y_r} set to c(1,1), each of the 
  two (possible) rules has the same gain. However, when \code{y_r} set to e.g. 
  c(1,3), then the rule for the second dimension gets more 'decisive' 
  (more weight) than that for the first dimension.

\code{c} - (Equation 3) exemplar similarity/sensitivity gradient in the exemplar 
  module. Has to be a postive numeric value.

\code{y_g} - (Equation 5) gate gain. Has to be a positive numeric value. Higher 
  values of \code{y_g} will lead to stronger mixing of exemplar and rule outputs 
  in Equation 6. Higher values of \code{y_g}  lead to rather 'deterministic' 
  selection of one of the two modules. (\code{y_g} is set to 1 in Erickson & 
  Kruschke (1998)).

\code{beta_g} - (Equation 5) gate bias. Has to be a numeric value. Positive 
  values bias (give additional weight) towards the exemplar module, negative 
  values bias towards the rule model solutions, when both predictions are mixed 
  in Equation 6.

\code{phi} - (Equation 6) response scaling parameter. Has to be a positive 
  numeric value. Values larger than 1 lead to more deterministic response 
  probabilities.

\code{cost} - (Equations 9 & 10). Has to be a postive numeric vector of length 2, 
  where the first index refers to the (learning) cost for the exemplar module, 
  and the second index refers to the (learning) cost of the rule modules. The 
  cost parameters are not further justified or specified in Erickson & Kruschke 
  (1998), and were set to 1 during their estimations, i.e. in the current 
  implementation to c(1,1),. In the corresponding Equations 9 & 10 the 
  \code{cost} acts like a module specific (de-)amplifier of the error signal. 
  E.g. setting the values of \code{cost} to c(10^5,10^5) will always lead to 
  error signals near 1 for both modules, and setting \code{cost} to 
  c(10^-5,10^-5) will always lead to error signals near 0 for both modules, 
  regardless of their current accuracy in predicting the present outcome. 
  Thus, handle the cost values with special care (or simply set them to c(1,1)).

\code{lambda_r} - (Equation 12) rule module learning rate. Has to be a positive 
  numeric value.

\code{lambda_e} - (Equation 13) exemplar module learning rate. Has to be a 
  positive numeric value.

\code{lambda_a} - (Equation 14) attention learning rate. Has to be a positive 
  numeric value.

\code{lambda_g} - (Equation 15) gate-node learning rate. Has to be a positive 
  numeric value.


\author{René Schlegelmilch}

\references{
  Erickson, M. A., & Kruschke, J. K. (1998). Rules and exemplars in category 
  learning. Journal of Experimental Psychology: General, 127(2), 107.

}
