\name{slpCOVIS}
\alias{slpCOVIS}
\title{
COVIS category learning model
}
\description{
  
  COVIS category learning model (Ashby et al. 1998), as described in 
  Ashby et al. (2011) and Edmunds & Wills (2016).

}
\usage{

slpCOVIS(st, tr, crx = TRUE, respt = TRUE, xtdo = FALSE, rgive = TRUE)

}
\arguments{
  
  \item{st}{List of model parameters}
  
  \item{tr}{R-by-C matrix of training items}
  
  \item{crx}{Boolean. Explicit System. If set to TRUE, the current rule
  is included in the random selection of a rule to receive a weight
  increase from the Possion distribution. If set to FALSE, the current
  rule is not included in this random selection.} 
             
  \item{respt}{Boolean. Decision system. If set to TRUE, the overall
  model response is compared to the feedback in order to determine
  whether each of the Explicit System and Procedural System was correct
  or incorrect. If set to FALSE, the response of the Explicit System is
  compared to the feedback to determine whether the Explicit System was
  correct or incorrect, and the response of the Procedural System is
  compared to the feedback to determine whether the Procedural System
  was correct or incorrect.}

  \item{xtdo}{Boolean. If TRUE, extended output is returned (see below).}
              
  \item{rgive}{Boolean. Explicit system. Usually set to TRUE. See below
  for use cases where you may wish to set it to FALSE.}
  
}  
  
\value{
  
  Returns a List containing eight components:

  \item{foutmat}{Where \code{xtdo = FALSE}, foutmat is a matrix of
    response probabilities for each output unit on each trial; where
    \code{xtdo = TRUE} ...}

  \item{frules}{Explicit system - rule saliences after final trial}

  \item{fsystr}{Procedural system - cortico-striatal synaptic strengths
    after final trial)

  \item{fetrust}{Decision system - trust in explicit system after final
    trial}

  \item{fitrust}{Decision system - trust in procedural system after
    final trial}

  \item{frule}{Explicit system - rule used by explicit system on final
    trial}

  \item{fprep}{Implicit system - predicted reward value on final trial}

  \item{fprer}{Implicit system - obtained reward value on final trial}

}

\details{

  The coverage in this help file is relatively brief; for a more
  extensive tutorial, see Inkster et al. (n.d.).

  The function works as a stateful list processor (slp; see Wills et
  al., 2017). Specifically, it takes a matrix (tr) as an argument, where
  each row is one trial for the network, and the columns specify the
  input representation. It returns a List containing the predictions
  made by the model and the final state of the model, hence its
  description as a 'stateful' list processor.

  Argument \code{st} must be a list containing the following
  information. Parameter names in brackets in the descriptions below
  follow the naming conventions of Ashby et al. (2011), and Edmunds &
  Wills (2016). Equation numbers are from Ashby et al. (2011); where
  there is no equation, the page number is given instead.

  \code{corcon} - (delta_c) - Explicit system, Eq. 2 - constant by which
  to increase current rule saliency in the case of a correct response.
  
  \code{errcon} - (delta_e) - Explicit system, Eq. 3 - constant by which
  to decrease current rule saliency in the case of an incorrect
  response.
  
  \code{perscon} - (gamma) - Explicit system, Eq. 4 - perseveration
  constant, i.e. value to add to the salience of the current rule to
  obtain its rule weight.

  \code{decsto} - (a) - Explicit system, Eq. 7 - decision stochasticity
  when using rule weights to select the rule for the next trial. For
  Ashby et al. (2011)'s implementation, a = 1. For other uses, see
  Edmunds & Wills (2016).

  \code{decbound} - (C) - Explicit system, Eq. 1 - constant representing
  the location of the decision bound on a single dimension. In the
  current implementation of slpCOVIS, this location is the same for all
  dimensions.

  \code{lambda} - (lambda) - Explicit system, Eq. 5 - Mean of the
  Poission distribution. A value randomly sampled from the Poisson
  distribution is added to a random rule when calculating the weights
  for new rule selection.
 
  \code{envar} - (sigma^2_E) - Explicit system, p. 68  - Variance
  of the noise distribution used to determine which response the
  explicit system makes on the current trial. In Ashby et al. (2011) and
  Edmunds & Wills (2016), it is set to zero. In this implementation of
  slpRW, positive values should also work but have not been extensively
  tested.
 
  \code{emaxval} - Decision system, p.77 - The maximum possible value of
  the the Explicit system's discriminant variable. For example, if the
  stimulus value varies from zero to one, and C (see above) is 0.5, then
  the maximum value is 1-0.5 = 0.5.

  \code{dbase} - (D_base) - Procedural system, Eq. 10 - baseline
  dopamine level.

  \code{alphaw} - (alpha_w) - Procedural system, Eq. 10 - Learning rate
  parameter in force when striatal activation is above the NMDA
  threshold, and dopamine is above baseline.

  \code{betaw} - (beta_w) - Procedural system, Eq. 10 - Learning rate
  parameter in force when striatal activation is above the NMDA
  threshold, and dopamine is below baseline.

  \code{gammaw} - (gamma_w) - Procedural system, Eq. 10 - Learning rate
  parameter in force when striatal activation is between the AMPA and
  NMDA thresholds.

  \code{nmda} - (theta_NMDA) - Procedural system, Eq. 10 - Activation
  threshold for post-synaptic NMDA.

  \code{ampa} - (theta_AMPA) - Procedural system, Eq. 10 - Activation
  threshold for post-synaptic AMPA.

  \code{wmax} - (w_max) - Procedural system, Eq. 10 - Intended upper
  weight limit for a cortico-striatal link. Ashby et al. (2011) neglect
  to specify a value for w_max; in Edmunds & Wills (2016), w_max = 1.

  \code{invar} - (sigma^2_p) - Procedural system, Eq. 9 - Variance of the
  normally-distributed noise used to calculate striatal unit activation.

  \code{sconst} - (alpha) - Procedural system, Eq. 8 - scaling constant
  for cortical unit activation; in Edmunds & Wills (2016), alpha = 0.14.

  \code{prep} - ( P_(n-1) ) - Procedural system, Eq. 12 - predicted
  reward value immediately prior to first trial.

  \code{prer} - ( R_(n-1) ) - Procedural system, Eq. 12 - obtained
  reward value immediately prior to first trial.

  \code{etrust} - (theta_E) - Decision system, Eq. 15 - trust in the
  explicit system immediately prior to first trial.

  \code{itrust} - (theta_P) - Decision system, p. 77 - trust in the
  procedural system immediately prior to first trial.

  \code{ocp} - (delta_OC) - Decision system, Eq. 15 - constant used to
  increase trust in the Explicit system after 
  
  \code{oep} - (delta_OE) - Decision system, Eq. 16 - 

  
\code{oep} - constant used to adjust the trust in the
explicit system based on a correct response. Used in
Equation 15 in Chapter 4 of Pothos and Wills(2011).

\code{ocp} - constant used to adjust the trust in the
implicit system based on a correct response. Used in
Equation 16 in Chapter 4 of Pothos and Wills(2011).

\code{colskip} - skip the first N columns of the tr array, where N =
colskip. colskip should be set to the number of optional columns you
have added to matrix tr, PLUS ONE. So, if you have added no optional
columns, colskip = 1. This is because the first (non-optional) column
contains the control values, below.
  
\code{stimdim} - constant indicating the number of stimulus
dimensions.

\code{crule} - constant indicating the starting rule given to
the explicit system.

Argument \code{tr} must be a matrix, where each row is one trial
presented to the network. Trials are always presented in the order
specified. The columns must be as described below, in the order
described below:
  
\code{ctrl} - vector of control codes. Available codes are: 0 = normal
  trial, 1 = reset network (i.e. set attention weights and associative
  strengths back to their initial values as specified in h and w (see
  below)), 2 = Freeze learning. Control codes are actioned before the
  trial is processed.
  
\code{opt1, opt2, \dots} - optional columns, which may have any names
  you wish, and you may have as many as you like, but they must be
  placed after the ctrl column, and before the remaining columns (see
  below). These optional columns are ignored by this function, but you
  may wish to use them for readability. For example, you might include
  columns for block number, trial number, and stimulus ID number. The
  argument colskip (see above) must be set to the number of optional
  columns plus 1.

\code{x1, x2, \dots} - input to the model, there must be one column for
each input unit. Each row is one trial.

\code{t1, t2, \dots} - teaching signal to model, there must be one
column for each output unit. Each row is one trial. If the stimulus is a
member of category X, then the teaching signal for output unit X must be
set to +1, and the teaching signal for all other output units must be
set to \code{absval}.

\code{m1, m2, \dots} - missing dimension flags, there must be one column
for each input unit. This does not do anything for the COVIS model,
however this allows ease of comparability and the ability to run the
same training matrix through different models.

Argument \code{crx} specifies whether, when selecting a rule to 
apply the Poisson variable to in Eqaution 5, the current rule is included 
in the rules to choose from.

Argument \code{respt} specifies whether, when the implicit and explicit
systems learn, they use feedback to the models response or their 
individual responses.

Argument \code{rgive} specifies whether to use the chosen rule to start
the explict system \code{crule} or to choose one at random.

Argument \code{xtdo} (eXTenDed Output), if set to TRUE, will output to
the console all of the values used by slpcovis ona trial by trial
level. 


}

\author{
  
Angus Inkster, Andy Wills

}

\references{

Ashby, F.G., Alfonso-Reese, L.A., Turken, A.U. & Waldron, E.M. (1998).
A neuropsychological theory of multiple systems in category learning.
\emph{Psychological Review, 105}, 442-481.

Ashby, F.G., Paul, E.J., & Maddox, W.T. (2011). COVIS. In Pothos, E.M. &
Wills, A.J. (2011). \emph{Formal approaches in
  categorization}. Cambridge, UK: Cambridge University Press.

Edmunds, C.E.R., & Wills, A.J. (2016). Modeling category learning using
a dual-system approach: A simulation of Shepard, Hovland and Jenkins
(1961) by COVIS. In A. Papfragou, D. Grodner, D. Mirman, &
J.C. Trueswell (Eds.). \emph{Proceedings of the 38th Annual Conference
of the Cognitive Science Society} (pp. 69-74). Austin, TX: Cognitive
Science Society.

Inkster, A.B., Edmunds, C.E.R., & Wills, A.J. (n.d.). A
distributed-collaboration resource for dual-process modeling in category
learning. \emph{Manuscript in preparation}.

Pothos, E.M. & Wills, A.J.(2011). \emph{Formal approaches in 
Categorisation.}Cambridge: University Press.

Wills, A.J., O'Connell, G., Edmunds, C.E.R., & Inkster,
A.B.(2017). Progress in modeling through distributed collaboration:
Concepts, tools, and category-learning examples. \emph{Psychology of
  Learning and Motivation, 66}, 79-115.

}

\note{

  1. Ashby et al. (2011) state that the intended operation of COVVIS is
  theta_NMDA > theta_AMPA, but the values they report are theta_NMDA =
  .0022, theta_AMPA = .01.

  2. Ashby et al. (2011) includes constants w_max (Eq. 10) and alpha
  (Eq. 8), but do not report values for either in their simulation.
  
  }