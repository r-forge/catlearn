\name{shj61train}
\alias{shj61train}
\title{
Nosofsky et al. (1994) training blocks
}
\description{
Create randomized training blocks for the Nosofsky et al. (1994) replication of Shepard et al. (1961), in a format suitable for category-learning models (e.g. \code{alcovelp}).
}
\usage{
shj61train(problem, blocks, absval = -1)
}
\arguments{
  \item{problem}{Category structure type (1-6), as defined by Shepard et al. (1961)}
  \item{blocks}{Number of blocks to generate. Omit this argument to get the same
  number of blocks as the published study (16).}
  \item{absval}{Teaching value to be used where category is absent.}
}  
  
\value{
R by C matrix, where each row is one trial, and the columns contain model input.
}

\details{
A matrix is produced, with one row for each trial, and with the following columns: 

\code{ctrl} - Set to 1 (reset model) for trial 1, set to zero (normal trial) for all other trials. 

\code{blk} - training block

\code{stim} - stimulus number (arbitrary, but consistent across \code{type})

\code{x1, x2, x3} - input representation

\code{t1, t2} - teaching signal (1 = category present, absval = category absent)

\code{m1, m2, m3} - Missing dimension flags (always set to zero in this
experiment, indicating all input dimensions are present on all trials)

In Nosofsky et al. (1994), block 1 was randomized differently to later blocks. This feature is retained in this implementation.
}

\author{
Andy Wills
}
\references{
  Nosofsky, R.M., Gluck, M.A., Plameri, T.J., McKinley, S.C. and Glauthier, P. 
  (1994). Comparing models of rule-based classification learning: A replication
  and extension of Shepaard, Hovland, and Jenkins (1961). \emph{Memory and Cognition, 
  22}, 352--369
}
\seealso{
}
\examples{
}
