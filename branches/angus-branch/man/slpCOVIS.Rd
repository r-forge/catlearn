\name{slpCOVIS}
\alias{slpCOVIS}
\title{
COVIS category learning model
}
\description{
  
Ashby et al's (1998) category learning model. 

}
\usage{

slpCOVIS(st, tr, crx = TRUE, respt = TRUE, xtdo = FALSE, rgive = FALSE)

}
\arguments{
  
  \item{st}{A List containing a List of model parameters,
  as well as a vector containing initial rule saliencies,
  a matrix containing initial synapse strengths and a 
  matrix containing the stimulus space values preferred 
  by each sensory cortical unit.}
  
  \item{tr}{R-by-C matrix of training items}
  
  \item{crx}{Boolean specifying whether when the explicit 
             system selects a rule to apply the Poisson
             variable to, it includes the current rule or 
             not}
             
  \item{respt}{Boolean specifying whether the explicit and
               implicit system should use the accuracy of 
               the overall model response or their own
               specific responses hen updating after a
               trial}
  
  \item{xtdo}{Boolean specifying whether the output is 
              standard or extended output}
              
  \item{xtdo}{Boolean specifying whether the rule for the 
              explicit system is given or generated randomly.}
  
}  
  
\value{
  Returns a List containing eight components: (1) matrix of
  response probabilities for each output unit on each trial,
  (2) explicit system rule saliencies after final trial,
  (3) implicit system synapse strength after final trial,(4)
  final explicit system trust,(5) final implicit system 
  trust, (6) final rule used by the explicit system, (7) 
  final previous value of predicted reward, (8) final previous 
  value of obtained reward. 
}

\details{

The coverage in this help file is relatively brief; a more
extensive tutorial will be made available as part of the 
catlearn package.

The function works as a stateful list processor.Specifically,
it takes a matrix as an argument, where each row is one
trial for the network, and the columns specify the input
representation. It returns a List containing the predictions
made by the model and the final state of the model, hence 
its description as a 'stateful' list processor.

Argument \code{st} must be a list containing the following:

\code{corcon} - constant to increase current rule saliency
in the case of a correct response.

\code{errcon} - constant to decrease current rule saliency 
in the case of an incorrect response.

\code{perscon} - constant used to calculate rule weights 
when selecting a new rule to use on trial n+1. Specifically
it represents the tendency of a participant to perservere
with the current rule.

\code{decsto} - constant used when choosing a new rule for
the explicit system to use. Specifically if decsto = 1,
then the next rule will be chosen probabalistically. If 
decsto is larger than 1, then the next rule will be chosen
deterministically.
 
\code{decbound} - constant specifying the decision bound
for the rules of the explicit system.
 
\code{lambda} - lambda is a constant reflecting the mean of
the poisson variable. A value randomly sampled from the
poisson varaible is added to a random rule when calculating
the weights for new rule selection.
 
\code{envar} - constant reflecting the variance for the
value used in determining the response made by the explicit
system.
 
\code{emaxval} - constant reflecting the max value possible
for the explicit systems discriminant variable.
 
\code{dbase} - constant specifying the baseline dopamine
value
 
\code{alphaw} - constant specifying the value of alphaw in
Equation 10 in Chapter 4 of Pothos and Wills(2011).

\code{betaw} - constant specifying the value of betaw in
Equation 10 in Chapter 4 of Pothos and Wills(2011).
 
\code{gammaw} - constant specifying the value of gammaw in
Equation 10 in Chapter 4 of Pothos and Wills(2011).
 
\code{nmda} - constant specifying the value of nmda in 
Equation 10 in Chapter 4 of Pothos and Wills(2011).

\code{ampa} - constant specifying the value of ampa in 
Equation 10 in Chapter 4 of Pothos and Wills(2011).

\code{wmax} - constant specifying the value of wmax in 
Equation 10 in Chapter 4 of Pothos and Wills(2011). This
constant represents the maximum stregnth value of a synapse,
between a cortical unit and a striatal unit.

\code{invar} - constant reflecting the variance for the
value used in determining the response made by the implicit
system.

\code{sconst} - represents a scaling constant used in
Equation 8 in Chapter 4 of Pothos and Wills(2011).

\code{prep} - initial value for previous
predicted reward. Used in Equation 12 in Chapter 4 of
Pothos and Wills(2011).

\code{prer} - initial value for previous
obtained reward. Used in Equation 12 in Chapter 4 of
Pothos and Wills(2011).

\code{etrust} - initial value for the trust placed in
the explicit system. Used in Equation 15 in Chapter 4 of
Pothos and Wills(2011).

\code{itrust} - initial value for the trust placed in
the implicit system. 

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
  
Angus Inkster

}

\references{

Ashby, F.G., Alfonso-Reese, L.A., Turken, A.U. & Waldron, E.M. (1998).
A neuropsychological theory of multiple systems in category learning.
\emph{Psychological Review, 105}, 442-481.

Pothos, E.M. & Wills, A.J.(2011). \emph{Formal approaches in 
Categorisation.}Cambridge: University Press.

Wills, A.J., O'Connell, G., Inkster, A.B. & Edmunds, C.E.R. (2016). 
Relative adequacy of formal models: Concepts, tools, and examples in
category learning. \emph{The Psychology of Learning and Motivation}.

}
