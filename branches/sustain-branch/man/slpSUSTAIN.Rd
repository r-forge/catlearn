\name{slpSUSTAIN}
\alias{slpSUSTAIN}
\title{
SUSTAIN Network Model of Category Learning
}
\description{

Love, Medin and Gureckis's (2004) network model of category learning

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

Returns a list with two items if xtdo = FALSE, and four if xtdo = TRUE.

\item{clusters }{The recruited clusters with their positions in the stimuli space.}

\item{mode }{The frequency of clusters.}

\item{weight }{Returns connection weights.}

\item{xout }{The activation of the winning cluster in each trial.}

}

\details{
%%  ~~ If necessary, more details than the description above ~~

This function works as a state list processor (slp; see Wills et al., 2007). It takes a matrix (tr) as an argument, where each row represents a single training trial, while each coloumn represents different type of information required by the model, such as elemental stimuli representation, indications of supervised/unsupervised learning, etc.

It also returns the final state of the model (clusters' position, the frequencies of the recruited clusters, connection weights).

Argument \code{st} must be a list containing the following items:

\code{r} - Attentional focus

\code{beta} - Cluster competition

\code{d} - Decision consistency

\code{eta} - Learning rate

\code{tau} - Threshold for unsupervised learning. If it is not present, set tau to 0.

\code{lambda} - It is a vector containing the lambdas for each dimensions. The value's place in the vector corresponds to its dimension. If all dimensions were payed equal attention, set all lambdas to 1.

\code{cluster} - A three dimensional array of clusters representation. The third dimension represents the cluster, the second (coloumn) represents the dimensions, and the first (rows) represents the cluster's position for each possible nominal values. For dimensions with shorter length than other dimensions, the surplus positions have to be set to NA. Cluster representation works as it was described in Love, Medin and Gureckis (2004).

\code{dims} - A vector containing the length of each dimension, i.e the number of nominal spaces. The length of the vector itself is used by the function to determine the number of dimensions.

\code{w} - Weights for each nominal value for each dimension. It is a three dimensional array, the third dimension being the cluster, the second being the dimension and the first representing the weight for the nominal value in each dimension. Its structure is facsimile to the cluster representation (see above). In Love, Meding and Gureckis (2004), only the weights of the quired dimensions are updated, although they mention that some incidental learning occurs on the nonquired dimensions too. In this function, those weights are also updated, although there is no additional parameter specifying on what rate those
learnings occur. It is only a collateral information which resulted from the way the function deals with matrices and arrays.

\code{colskip} - Number of optional coloumns you added to the input matrix,\code{tr}, PLUS ONE. If there are no optional coloumns, set colskip to 1, so R will start by the 1st coloumn of tr.

Argument \code{tr} must be a matrix, where each row is one trial presented to the model. Trials are always presented in the order specified below:

\code{ctrl} - A vector of control codes. It can be either 0 and 1. 1 = reset model parameters to the initial state of the model; 0 = normal trial.

\code{opt1, opt2, \dots} - Any additional coloumns that contain information other than of ctrl, stimuli representation and t. These coloumns have to be after ctrl and before the stimuli representation. The function ignores these coloumns, but you may wish to use these informations for readability. For that purpose, you might include block or trial number, stimulus number. Colskip has to be set to the number of optional coloumns plus one (see above).

\code{x2, x2, y1, y2, y3, \dots} - Coloumns representing the kth nominal value for ith dimension. Its the padded way to represent stimulus dimensions with varying length. The input pattern of the stimulus essentially works as it was described in Love, Medin, and Gureckis (2004), but organised into a single row. For a stimulus with two dimensions with varying number of possible nominal values represented in a given trial as [0 1] and [0 1 0] should appear in tr for each trial as [0 1 0 1 0].

\code{t} - It is an indicator of supervised/unsupervised learning. The values can be either 1 = supervised learning or 0 = unsupervised learning.
}

\references{
%% ~put references to the literature/web site here ~
Love, B. C., Medin, D. L., & Gureckis, T. M. (2004). SUSTAIN: a network model of category learning. Psychological Review, 111(2), 309–332. https://doi.org/10.1037/0033-295X.111.2.309

Wills, A. J., Connell, G. O., Edmunds, C. E. R., & Inkster, A. B. (2016). Progress in modeling through distributed collaboration: Concepts, tools, and category-learning examples. Psychology of Learning and Motivation, 1–23.

}
\author{
Andy Wills, Lenard Dome
}
\note{
%%  ~~further notes~~
An Rcpp implementation is in the works to boost the speed of the function. Additional parameters, such as category focus or category distinct are also planned to be included in future releases.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
