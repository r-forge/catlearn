\name{slpEXITrs}
\alias{slpEXITrs}
\title{
  EXIT - Exemplar-based attention to distinctive input
}
\description{
  Kruschke's (2001a,b) model extension of ADIT (Kruschke, 1996a)
  ***CAUTION*** The model codes include equations which are NOT explicitly
  stated in the model descriptions in Kruschke's (2001b).
  The 'changes' are detailed below, and we strongly recommend their 
  consideration, as they do have substantial impact on the model plausibility,
  how the model can (or can not) be interpreted, and how it fits data. 
  However, the implemented 'changes' were necessary to correctly replicate the 
  model predictions reported in Kruschke (2001a Appendix; for the inverse 
  base-rate effect Experiment 1 from Kruschke, 1996a), and the predictions
  reported in Kruschke (2001b; for the blocking and attenuation Experiment 1 
  from Kruschke, & Blair, 2000). Please read the following issues carefully:
  1. Kruschke's (2001b) describes that the gain (g) shift in Equation 8 is
  iterated 10 times. After each iteration alpha (Equation 5) and the 
  output activation (Equation 1) are re-calculated and used for the next 
  iteration to update g a bit more. What is not stated, but implemented in
  our EXIT version, is, that alpha and the output activation are 
  recalculated after the 10th iteration, and then passed to the error gradient 
  for the input-to-output weight update (Equation 9). This (as mentioned above) 
  was necessary to replicate the reported predictions given the best-
  fitting parameters. Crucially, this means that the error gradient that updates 
  the input-to-output weights DOES NOT reflect the prediction error from
  the current trial. Instead, the network now already 'knows' how to 
  allocate attention (g) more optimal, and makes a second prediction for the 
  current trial which is less erroneuous, and then derives a 'new' (post-shift) 
  error gradient for the weight updates. In our replication efforts, the 
  alternative use of the pre-shift values for alpha and the output activation 
  resulted in very different predictions,for both simulated experiments. 
  Unfortunately, this is a major concern, implying that, in the referenced 
  studies, the learning of input-to-output weights was (most probably) 
  attenuated by the gain-shift iterations, which seems, at least, theoretically 
  questionable. In light of the conclusions based on the model fits, 
  we think that the application of EXIT requires a special awareness about this 
  mechanistic issue. We would strongly recommend to reconsider the application
  or interpretation of EXIT with regard to the described model implementation. 
  Please also consider using 'more optimal' error gradients, and check whether 
  the model still performs well in fitting data. Therefore, our EXIT version 
  provides the option to select one of two alternatives for calculating the 
  error gradient in Equation 9, i.e.  a) the use values of alpha and the output 
  activation, which were also used to make the corresponding trial prediction 
  (pre-g-shift), or b) the use of the corresponding values re-calculated after 
  the attention gain shift (post-g-shift), which were used to 'correctly'
  reproduce Kruschke's inverse-base rate effect predictions.
  2. The second, not explicitly stated, prerequisite for replicating the
  mentioned predictions, concerns the definition of the exemplars. To make
  the model work, each exemplar must contain a present 'bias-node' in addition 
  to its defining 'real-world' features. I.e. the bias cue in the stimulus 
  (current trial) always has be \code{1}, and it has to be set to \code{1} as 
  well, in every exemplar. This supposedly allows the model to learn 
  to shift attention to- or away from the bias cue, depending on the exemplar
  (in Equation 10). The implementation of the bias cue is described in more 
  detail in Kruschke (2001a, Appendix). In the corresponding equations 3 and 4 
  an additional sigma parameter is introduced, which is supposed to scale down 
  the overall salience of the bias cue. However, the reported fit of sigma with 
  respect to the described definition of exemplars is meaningless in Equation 3. 
  I.e. in Kruschke's (2001a) model fits, sigma is always set to 1 for the 
  features, and was allowed to vary freely for the bias cue. In Eq.3, sigma is 
  used for weighing the distances between the the present bias cue (stimulus) 
  and the corresponding value on the exemplar. Obviously, this difference is 
  always 0 for the bias cue, when each exemplar is defined to have a value of 1 
  for the bias cue. Hence, the product of sigma (bias) and the exemplar-to-
  stimulus difference (bias) is always 0 in this equation 3, and therefore 
  meaningless (as long as sigma is set to 1 for other features). Thus, in 
  Kruschke's fits, sigma only governs/fits the salience/attention to the bias 
  cue in Eq.4 (but not in Eq. 3). In Eq.4 the attention to the bias cue is
  first mediated by all exemplars associations, then additionally weighed by 
  sigma for the bias cue. However, please be aware, that in our
  simulations the exemplar-mediated attention to the bias cue (i.e. within the 
  exponential term of Eq.4) was always relatively close to 0. Consequently, 
  exponentiating values near 0 always results in values near 1, which, in turn, 
  means that the major amount of attention to the bias cue, in fact, is 
  determined by sigma (almost) alone. And, indeed, eliminating the bias cue from 
  the exemplars (no attention shift learning for the bias), hardly changed our 
  simulation results (yet deviating from the reported predictions). As the 
  input-to-output weights for the bias cue reflect the category base-rates, 
  sigma determines, how much these base rates are mixed with the predictions 
  from the stimulus feature associations in Eq.4. In other words, sigma freely 
  fits what the attention allocation mechanism is supposed to learn about the 
  bias cue, which simply pulls all predictions towards the base rates. As 
  Kruschke (2001a) commits to the idea that attention to the bias cue is 
  learned/shifted, we have the feeling, that this implementation of sigma 
  is not psychologically meaningful, but simply (over-)fits the data in 
  experiments, where participants tend to respond in accordance to the 
  base-rates. And, indeed, our simulatied predictions for the blocking and 
  attenuation experiment (Kruschke, 2001b) substantially deviate from the 
  reported predictions, when assigning just a tiny bit of salience (sigma) to 
  the bias cue, although Kruschke argues, that this should not make any 
  difference, as all base rates were equal in the blocking experiment. Of 
  course, something is learned about the attention to the bias cue, but it seems
  rather unclear whether it contributes to better or worse predictions. Thus,
  one should consider models without variations sigma for truely understanding
  how (or why) the model is able to account for the inverse base rate effect.
  Thus, although we  do not want to advise to circumvent the use of sigma, we 
  would recommend to be very carefull with the conclusions from the model fits,
  especially in additional light of point 1 above, which does not allow to
  straight forwardly interpret the model results as put forward by Kruschke
  (2001a,b) in terms of the involved psychological processes. (Since the EXIT
  model was used to competitively rule out that the inverse base rate effect is 
  not explained by eliminative inference (meaning better explained by EXIT),
  in Kruschke (2001b), there might be reason to review this conclusion.)
  3. Please note, that with the described 'adjustments' we were able to 
  reproduce the Kruschke's (2001a, IBRE from Kruschke1996a) predictions. We used 
  the best fitting parameter values as reported (in the Appendix), and 
  calculated the mean of the absolute differences between all reported 
  predictions and our simulated predictions, which was smaller than .03 percent. 
  The same implementation, however, was slightly less accurately reproducing the 
  predictions reported in Kruschke (2001b) for blocking and attenuation. 
  Kruschke reports 4 tables with predictions for blocking and attenuation with 
  enabled attention learning, and blocking and attenuation with disabled 
  attention learning. The mean of the absolute differences between all these 
  reported predictions and our simulation results were, 0.12 and 0.52 percent 
  with attention learning, respectively; and .002 and .05 percent without 
  attention learning, respectively. These deviations did not seem to be caused 
  by random trial ordering in the simulation. Thus, although all deviations of 
  our model were smaller than 1 percent on average, there is still a (small) 
  possibility, that a (maybe unreported) detail was overlooked, that caused 
  these (tiny) deviations for the blocking experiment. 

}
\usage{
  slpEXITrs(st,tr,xtdo)
}
\arguments{
  \item{st}{List of model parameters}
  \item{tr}{R-by-C matrix of training items}
  \item{xtdo}{if \code{TRUE} extended output is returned}
}  

\value{
  The reduced output returns a matrix where each row is a trial, as presented to 
  the model, and the columns are the response probabilities for each category, 
  in the same order as defined in \code{tr}. If the extended output is enabled, 
  the final state of the network is also returned. This includes: a matrix of 
  the input-to-category weights in each trial, \code{w_in_out}. It also includes 
  the matrix of associations between exemplar nodes and attention gain nodes,
  i.e. \code{w_exemplars}. It also includes the final state of the feature 
  attention gain nodes, i.e. \code{g}. 
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
  \code{0} all network parameters are intialized at 0 in the first trial
  (row 1 in \code{tr} and learning proceeds in subsequent trials.
  If \code{ctrl} is set to \code{1} the network parameters for
  \code{w_in_out} and \code{w_exemplars} are (re-)set to the parameters
  user defined in \code{w_io_init} and \code{ex_weights_init} (see below).
  If \code{ctrl} is set to \code{2} the network learning is frozen 
  (e.g. for testing predictions on new trials without teaching signals).
  If \code{ctrl} is set to \code{3} then \code{w_in_out} and \code{w_exemplars}
  are reset to 0.
  
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
    
  \code{iterations} - number of iterations of shifting attention strength 
  in Equation (8) for each trial. Kruschke (2001, p.820) sets this to the 
  arbitrary value of 10, which produces a larger attention shift in each
  trial.

  \code{l_weight} - learning rate for feature to category associations.  
  - Equation (9)

  \code{preshift} - IMPORTANT! Boolean indicating which error gradient will be
  applied in  Equation 9. If \code{preshift} is set to \code{TRUE}, then alpha 
  and the output activation are used, which were also used to calculate
  the response probability of that trial. If \code{preshift} is set to 
  \code{FALSE}, then alpha and the output activation are used, which were 
  re-calculated after the iterations of Equation 8. Please read the 
  introductory note; Setting \code{preshift} to \code{FALSE} allows to replicate
  the fits reported in Kruschke (2001a,b).

  \code{l_ex} - learning rate for exemplar_node to gain_node associations
  - Equation (10)

  \code{sigma} - feature salience. Has to be defined in one of the two following
  ways: 1. as a numeric value which then is equally applied to all features, or 
  2. as a vector of length n, where n is the number of real features (+ 1 if
  a bias cue is defined in \code{tr}). This vector is then applied
  to the features in the same order as defined in \code{tr}.
  See Kruschke(2001a, Equation 4, p.1399).
 
  \code{w_in_out} - matrix with \code{nFeat} columns and \code{nCat} rows,
  defining the input-to-category association weights, i.e. how much each
  feature is associated to a category (see Equation 1). The \code{nFeat} 
  columns follow the same order as \code{x1, x2, \dots} in \code{tr}, 
  and likewise, the \code{nCat} rows follow the order of  
  \code{t1, t2, \dots}. If \code{ctrl} in \code{tr} is set to \code{1} 
  the corresponding matrix is set to \code{w_in_out}.

  \code{exemplars} - matrix with \code{nFeat} columns and n rows, where
  n is the number of exemplars, such that each row represents a single
  exemplar in memory, and their corresponding feature values. 
  The \code{nFeat} columns follow the same order as \code{x1, x2, \dots} 
  in \code{tr}. The n-rows follow the same order as in the 
  \code{w_exemplars} matrix defined below.
  
  \code{w_exemplars} - matrix which is structurally equivalent to 
  \code{exemplars}. However, the matrix represents the associative weight
  from the exemplar nodes to the gain nodes, as given in Equation 4.
  If \code{ctrl} in \code{tr} is set to \code{1} 
  the corresponding network matrix is set to \code{w_exemplars}.
  
  The \code{nFeat} columns follow the same order as 
  \code{x1, x2, \dots} in \code{tr}. The n-rows follow the same order 
  as in the \code{exemplars} matrix defined below. The order or exemplar
  rows in \code{exemplars} and \code{w_exemplars} is only restricted
  by their equivalence.
  
\author{René Schlegelmilch, Andy Wills}

\references{
  Kruschke, J. K. (1996). Base rates in category learning. \emph{Journal 
  of Experimental Psychology-Learning Memory and Cognition, 22}(1), 3-26.
  
  Kruschke, J. K. (2001). Toward a unified model of attention in 
  associative learning. \emph{Journal of mathematical psychology, 45}(6), 
  812-863.
  
  Kruschke, J. K. (2001). The inverse base-rate effect is not explained by 
  eliminative inference. \emph{Journal of Experimental Psychology: Learning, 
  Memory, and Cognition, 27}(6), 1385.
  
  Kruschke, J. K., & Blair, N. J. (2000). Blocking and backward blocking involve 
  learned inattention. \emph{Psychonomic Bulletin & Review, 7}(4), 636-645.

}

