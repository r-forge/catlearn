\name{alcovelp}
\alias{alcovelp}
\title{
ALCOVE category learning model
}
\description{
Kruschke's (1992) category learning model. This implementation assumes a humble teacher (Kruschke, 1992, Eq. 4b). 
The function has been named alcovelp because it works as a list processor (LP). Specifically, it takes a matrix as an argument, where each row is one trial for the network, and the columns specify the input representation, teaching signals, and other control signals. It returns a matrix where each row is a trial, and the columns are the response probabilities at the output units.
}
\usage{
alcovelp(st, tr)
}
\arguments{
  \item{st}{List of model parameters}
  \item{tr}{R-by-C matrix of training items}
}  
  
\value{
Matrix of response probabilities for each output unit on each trial. 
}

\details{

Argument \code{st} must be a list containing the following items:

\code{colskip} - skip the first N columns of the tr array, where N = colskip. colskip should be set to the
number of optional columns you have added to matrix tr, PLUS ONE. So, if you have added no optional columns,
colskip = 1. This is because the first (non-optional) column contains the control values, below.
  
\code{c} - specificity constant (Kruschke, 1992, Eq. 1). Positive real number. Scales psychological space.

\code{r} - distance metric (Kruschke, 1992, Eq. 1). Set to 1 (city-block) or 2 (Euclidean).

\code{q} - similarity gradient (Kruschke, 1992, Eq. 1). Set to 1 (exponential) or 2 (Gaussian).

\code{phi} - mapping constant (Kruschke, 1992, Eq. 3). Real number, normally positive, acts on decision rule.

\code{lw} - associative learning rate (Kruschke, 1992, Eq. 5) . Real number between 0 and 1.

\code{la} - attentional learning rate (Kruschke, 1992, Eq. 6). Real number between 0 and 1.

\code{h} - R by C matrix of hidden node locations in psychological space, where R = number of input
  dimensions and C = number of hidden nodes.  

\code{alpha} - vector of length N giving initial attention weights for each input dimension, 
  where N = number of input dimensions. If you are not sure what to use here, set all values to 1.

\code{w} - R by C matrix of initial associative strengths, where R = number of output units and
C = number of hidden units. If you are not sure what to use here, set all values to zero.

Argument \code{tr} must be a matrix, where each row is one trial presented to the network. Trials are always presented in the order specified. The columns must be as described below, in the order described below:
  
\code{ctrl} - vector of control codes. Available codes are: 0 = normal trial, 1 = reset network (i.e. set attention weights and associative strengths back to their initial values as specified in h and w (see below)). Control codes
  are actioned before the trial is processed.
  
\code{opt1, opt2, \dots} - optional columns, which may have any names you wish, and you may have as many as
  you like, but they must be placed after the ctrl column, and before the remaining columns (see below). These optional columns are ignored by this function, but you may wish to use them for readability. For example, you might include columns for block number, trial number, and stimulus ID number. The argument colskip (see above) must be set to the number of optional columns plus 1.

\code{x1, x2, \dots} - input to the model, there must be one column for each input unit. Each row is one trial.

\code{t1, t2, \dots} - teaching signal to model, there must be one column for each output unit. Each row is one trial. If the stimulus is a member of category X, then the teaching signal for output unit X must be set to +1, and the teaching signal for all other output units must be set to -1.

\code{m1, m2, \dots} - missing dimension flags, there must be one column for each input unit. Each row is one trial. Where m = 1, that input unit does not contribute to the activation of the hidden units on that trial. This permits modelling of stimuli where some dimensions are missing on some trials (e.g. where modelling base-rate negelct, Kruschke, 1992, p. 29--32). Where m = 0, that input unit contributes as normal. If you are not sure what to use here, set to zero.
}

\author{
Andy Wills
}
\references{
Kruschke, J. (1992). ALCOVE: an exemplar-based connectionist model of 
category learning. \emph{Psychological Review, 99}, 22--44
}
\seealso{
}
\examples{
}
