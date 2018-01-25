\name{slpSUSTAIN}
\alias{slpSUSTAIN}
\title{
SUSTAIN Network Model of Category Learning
}
\description{

Love, Medin and Gureckis's (2004) SUSTAIN (Supervised and Unsupervised STratified Adaptive Incremental Network) network model of category learning

}

\usage{
slpSUSTAIN(st, tr, xtdo = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{st}{List of model parameters}

  \item{tr}{R matrix of training items}

  \item{xtdo}{Boolean specifying whether to include extended information in the output (see below)}
}

\value{

Returns a list with the following items if xtdo = FALSE,
and \code{xtdo} instead of \code{probs} if xtdo = TRUE:

\item{lambda }{The amount of attentions paid for each dimensions..}

\item{weights }{Connection weights.}

\item{clusters }{The recruited clusters with their positions in the stimuli space.}

\item{mode }{The frequency of clusters.}

\item{probs }{Matrix of response probabilities from the outputs from Equation 8, where row number equals trial number and coloumn equals to the nominal space of the quired dimension. In case of an unsupervised learning, it is still included, but it is calculated for all the dimensions (as there is no quired dimension).}

\item{xtdo }{A matrix that includes the outputs of Equation 8 from \code{probs}, and additionally includes the number of the winning clusters and its output activation after cluster competition in Equation 6.}

}

\details{
%%  ~~ If necessary, more details than the description above ~~

This function works as a state list processor (slp; see Wills et al., 2017). It takes a matrix (tr) as an argument, where each row represents a single training trial, while each coloumn represents different type of information required by the model, such as elemental stimuli representation, indications of supervised/unsupervised learning, etc.


Argument \code{st} must be a list containing the following items:

\code{r} - Attentional focus

\code{beta} - Cluster competition

\code{d} - Decision consistency

\code{eta} - Learning rate

\code{tau} - Threshold for unsupervised learning. If it is not present, set tau to 0.

\code{lambda} - It is a vector containing the lambdas for each dimensions. The value's place in the vector corresponds to its dimension. If all dimensions were payed equal attention, set it to 1.

\code{dims} - A vector containing the length of each dimension, i.e the number of nominal spaces. The length of the vector itself is used by the function to also determine the number of dimensions.

\code{colskip} - Number of optional coloumns and the \code{ctrl} coloumn you added to the input matrix, \code{tr}, PLUS ONE. If there are no optional coloumns, set colskip to 2, so R will start after the \code{ctrl} by the 2nd coloumn of tr.

Argument \code{tr} must be a matrix, where each row is one trial presented to the model. Trials are always presented in the order specified below:

\code{ctrl} - A vector of control codes. The control codes are processed prior to the trial and prior to updating cluster's position, lambdas and weights, to Equation 12, 13, 14 respectively. The available values are: 1 = reset network parameters; 0 = normal trial, 2 = freeze learning.

\code{opt1, opt2, \dots} - Any additional coloumns that contain information other than of ctrl, stimuli representation and t. These coloumns have to be after ctrl and before the stimuli representation. The function ignores these coloumns, but you may wish to use these informations for readability. For that purpose, you might include block or trial number, stimulus number. Colskip has to be set to the number of optional coloumns plus one (see above).

\code{x2, x2, y1, y2, y3, \dots} - Coloumns representing the kth nominal value for ith dimension. Its a padded way to represent stimulus dimensions with varying nominal length. The input pattern of the stimulus essentially works as it was described in Love, Medin, and Gureckis (2004) and more cohesively in Figure10.2A in McDonnell and Gureckis (2011), but organised into a single row. For a stimulus with two dimensions with varying number of nominal spaces represented in a given trial as [0 1] and [0 1 0] should appear in tr for each trial as [ 0 1 0 1 0].


\code{t} - It is an indicator of supervised/unsupervised learning. The values can be either 1 = supervised learning or 0 = unsupervised learning.
}

\references{
%% ~put references to the literature/web site here ~
  Love, B. C., Medin, D. L., & Gureckis, T. M. (2004). SUSTAIN: a 
  network model of category learning. \emph{Psychological Review}, 111(2),
  309-332.
  
  McDonnell, J. V., & Gureckis, T. M. (2011). Adaptive clustering models of 
  categorization. In A. J. Wills & E. M. Pothos (Eds.), \emph{Formal Approaches in 
  Categorization}, pp. 220-252.


  Wills, A.J., O'Connell, G., Edmunds, C.E.R., & Inkster,
  A.B.(2017). Progress in modeling through distributed collaboration:
  Concepts, tools, and category-learning examples. \emph{Psychology of
  Learning and Motivation, 66}, 79-115.

}
\author{
Andy Wills, Lenard Dome
}
\note{
%%  ~~further notes~~

}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
