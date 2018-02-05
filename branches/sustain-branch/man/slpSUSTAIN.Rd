\name{slpSUSTAIN}
\alias{slpSUSTAIN}
\title{
SUSTAIN Category Learning Model
}
\description{
Supervised and Unsupervised STratified Adaptive Incremental Network
(Love, Medin & Gureckis, 2004)
}

\usage{
slpSUSTAIN(st, tr, xtdo = FALSE)
}

\arguments{
  \item{st}{List of model parameters}

  \item{tr}{Matrix of training items}

  \item{xtdo}{Boolean specifying whether to include extended information
  in the output (see below)} }

\value{

  Returns a list with the following items if \code{xtdo = FALSE}:

  \item{lambda}{Vector of the receptive field tunings for each stimulus
  dimension, after the final trial.}

  \item{weights}{Matrix of connection weights, after the final
    trial.}
  % Rows are? Columns are?

  \item{clusters}{Matrix of recruited clusters, with their positions in
    stimulus space.}
  % Rows are? Columns are?

  \item{mode}{The frequency of clusters.}
  % What does 'frequency of clusters' mean?

  \item{probs}{Matrix of response probabilities. Row are trials, and
  columns represent the nominal space of the queried dimension
  (e.g. column 1 = category A; column 2 = category B). In the case of
  unsupervised learning, it is calculated for all dimensions (as there
  is no queried dimension for unsupervised learning).}

  If \code{xtdo = TRUE}, \code{xtdo} is returned instead of
  \code{probs}:

  \item{xtdo}{A matrix that includes \code{probs}, and additionally
  includes the number of the winning cluster and its output activation
  after cluster competition in Love et al. (2004), Eq. 6. The last
  column contains the recognition scores for the current stimulus from
  Love and Gureckis (2007), Eq. A6; this measure represents model's
  overall familiarity with the stimuli.}

}

\details{

  This function works as a stateful list processor (slp; see Wills et
  al., 2017). It takes a matrix (tr) as an argument, where each row
  represents a single training trial, while each column represents some
  information required by the model, such as the stimulus
  representation, indications of supervised/unsupervised learning, etc.

  Argument \code{st} must be a list containing the following items:

  \code{r} - Attentional focus parameter

  \code{beta} - Cluster competition parameter

  \code{d} - Decision consistency parameter

  \code{eta} - Learning rate parameter

  \code{tau} - Threshold parameter for cluster recruitment under
  unsupervised learning (Love et al., 2004, Eq. 11). If it is not
  present, set tau to 0.
  % If what is not present?

  \code{lambda} - Vector containing the initial lambda (attention) value
  for each stimulus dimension. If all dimensions are equally attended,
  set it to 1.
  % Does this mean it becomes the scalar [1], or do you mean [1, 1, 1]?

  \code{dims} - Vector containing the length of each dimension, i.e the
  number of nominal spaces in the representation of each dimension. For
  Figure 1 of Love et al. (2004), dims = [2, 2, 2].

  \code{colskip} - Number of optional columns and the \code{ctrl}
  column you added to the input matrix, \code{tr}, PLUS ONE. If there
  are no optional columns, set colskip to 2, so R will start after the
  \code{ctrl} by the 2nd coloumn of tr.
  % This seems to operate differently to all other slp modules?

  Argument \code{tr} must be a matrix, where each row is one trial
  presented to the model. Trials are always presented in the order
  specified below:

  \code{ctrl} - A vector of control codes. The control codes are
  processed prior to the trial and prior to updating cluster's position,
  lambdas and weights (Love et al., 2004, Equ.  12, 13 and 14,
  respectively). The available values are: 1 = reset network (i.e. set
  everything passed in \code{st} back to the values in \code{st}); 0 =
  normal trial, 2 = freeze learning.

  \code{opt1, opt2, \dots} - optional columns, which may have any names
  you wish, and you may have as many as you like, but they must be
  placed after the ctrl column, and before the remaining columns (see
  below). These optional columns are ignored by this function, but you
  may wish to use them for readability. For example, you might include
  columns for block number, trial number, and stimulus ID number.

  \code{x1, x2, y1, y2, y3, \dots} - Stimulus representation. The
  columns represent the kth nominal value for ith dimension. It's a
  'padded' way to represent stimulus dimensions with varying nominal
  length, see McDonnel & Gureckis (2011), Fig. 10.2A. All dimensions for
  the trial are represented in this single row. For example, if for the
  presented stimulus, dimension 1 is [0 1] and dimension 2 is [0 1 0]
  then the input representation is [0 1 0 1 0].

  \code{t} - Indicator of supervised vs. unsupervised learning. The
  values can be either 1 = supervised learning or 0 = unsupervised
  learning.

}

\references{

  Love, B. C., & Gureckis, T.M. (2007). Models in Search of a Brain.
  \emph{Cognitive, Affective, & Behavioral Neuroscience, 7}, 90-108.

  Love, B. C., Medin, D. L., & Gureckis, T. M. (2004). SUSTAIN: a
  network model of category learning. \emph{Psychological Review, 111},
  309-332.
  
  McDonnell, J. V., & Gureckis, T. M. (2011). Adaptive clustering models
  of categorization. In E. M. Pothos & A. J. Wills (Eds.), \emph{Formal
  Approaches in Categorization}, pp. 220-252.

  Wills, A.J., O'Connell, G., Edmunds, C.E.R., & Inkster,
  A.B.(2017). Progress in modeling through distributed collaboration:
  Concepts, tools, and category-learning examples. \emph{Psychology of
  Learning and Motivation, 66}, 79-115.

}
\author{
Lenard Dome, Andy Wills
}
