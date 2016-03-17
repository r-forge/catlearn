
\name{n88train}
\alias{n88train}
\title{
Nosofsky (1988) training blocks
}
\description{
Create randomized training blocks for Experiment 1 of Nosofsky (1988), in a format suitable for category-learning models (e.g. \code{alcovelp}).
}
\usage{
n88train(condition = 'B', blocks = 3, 
          absval = -1)
}
\arguments{
  \item{condition}{Experimental condition 'B', 'E2', or 'E7', 
  as defined by Nosofsky (1988).}
  \item{blocks}{Number of blocks to generate. Omit this argument to get the same
  number of blocks as the published study (3).}
  \item{absval}{Teaching value to be used where category is absent.}
}  
  
\value{
R by C matrix, where each row is one trial, and the columns contain model input.
}

\details{
A matrix is produced, with one row for each trial, and with the following columns: 

\code{ctrl} - Set to 1 (reset model) for trial 1, set to zero (normal trial) for all other trials. 

\code{cond} - 1 = condition B, 2 = condition E2, 3 = condition E7

\code{blk} - training block

\code{stim} - stimulus number (as defined by Nosofsky, 1988)

\code{x1, x2} - input representation. These are the co-ordinates of an MDS solution for
these stimuli (see Nosofsky, 1987).

\code{t1, t2} - teaching signal (1 = category present, absval = category absent)

\code{m1, m2} - Missing dimension flags (always set to zero in this
experiment, indicating all input dimensions are present on all trials)

Nosofsky (1988) report that conditions E2 and E7 had 63 trials per block. It is not possible to implement the relative frequency structure of these conditions with a block length of 63 trials, so this is presumably an error. This implementation assumes a block length of 64 trials for conditions E2 and E7.
}

\author{
Andy Wills
}
\references{
  Nosofsky, R.M. (1987). Attention and learning processes in the identification and
  categorization of integral stimuli, \emph{Journal of Experimental Psychology:
  Learning, Memory and Cognition, 13}, 87--108.

  Nosofsky, R.M. (1988). Similarity, frequency, and category representations, \emph{Journal
  of Experimental Psychology: Learning, Memory and Cognition, 14}, 54--65.
}
\seealso{
}
\examples{
}
