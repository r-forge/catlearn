\name{shin92train}
\alias{shin92train}
\title{
Shin & Nosofsky (1992) training and transfer blocks
}
\description{
  Create randomized training and transfer blocks for Experiment 3 of
  Shin & Nosofsky (1992), in a format suitable for category-learning
  models (e.g. \code{alcovelp}).
}
\usage{
  shin92train(condition = 'equal3', learn.blocks = 8, trans.blocks = 3,
          absval = -1)
}
\arguments{
  
  \item{condition}{Experimental condition 'equal3', 'equal10',
  'unequal3', or 'unequal10', as defined by Shin & Nosofsky (1992).}

  \item{learn.blocks}{Number of training blocks to generate. Omit this
  argument to get the same number of training blocks as the published
  study (8).}

  \item{trans.blocks}{Number of transfer blocks to generate. Omit this
  argument to get the same number of transfer blocks as the published
  study (3).}

  \item{absval}{Teaching value to be used where category is absent.}
}  
  
\value{
R by C matrix, where each row is one trial, and the columns contain model input.
}

\details{
A matrix is produced, with one row for each trial, and with the following columns: 

\code{ctrl} - Set to 1 (reset model) for trial 1, set to zero (normal
trial) for all other training trials, and set to 2 (freeze learning) for
all transfer trials. 

\code{cond} - 1 = equal3, 2 = equal10, 3 = unequal3, 4 = unequal10

\code{phase} - 1 = training, 2 = transfer

\code{blk} - block of trials

\code{stim} - stimulus number; these correspond to the rows in Tables A3
and A4 of Shin & Nosofsky (1992)

\code{x1 ... x6} - input representation. These are the co-ordinates of
an MDS solution for these stimuli (see Shin & Nosofsky, 1992, Tables A3
and A4). Note: Size 3 conditions have a four-dimensional MDS solution,
so the output is x1 ... x4

\code{t1, t2} - teaching signal (1 = category present, absval = category
absent)

\code{m1 ...  m6} - Missing dimension flags (always set to zero in this
experiment, indicating all input dimensions are present on all
trials). Note: ranges from m1 to m4 for Size 3 conditions. 

}

\author{
Andy Wills
}
\references{
  Shin, H.J. (1992). Similarity-scaling studies of dot-pattern
  classification and recognition. \emph{Journal of Experimental
  Psychology: General, 121}, 278--304.
}
\seealso{
}
\examples{
}
