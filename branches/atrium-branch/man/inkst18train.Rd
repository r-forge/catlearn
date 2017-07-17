 \name{inkst18train}
\alias{inkst18train}

\title{

  Input representation of nosof92 for models input-compatible with slpALCOVE.

}

\description{

  Create randomized training blocks for CIRP \code{inkst18}, in a format
  suitable for the currently implemented models. The stimulus co-ordinates are
  assumed, and use the same binary representation as the abstract
  category structure.
  
}

\usage{
inkst18train(blocks = 6, absval = -1, subjs = 1, seed = 1337)
}

\arguments{

  \item{blocks}{Number of blocks to generate. Omit this argument to get
    the same number of blocks (6) as used in Inkster adn Wills (2018).}
  
  \item{absval}{Teaching value to be used where category is absent.}

  \item{subjs}{Number of simulated subjects to be run.}

  \item{seed}{Sets the random seed.}
  
}

\value{

R by C matrix, where each row is one trial, and the columns contain
model input.

}

\details{

  A matrix is produced, with one row for each trial, and with the
following columns:

\code{ctrl} - Set to 1 (reset model) for trial 1 of the first training block,
set to zero (normal trial) for the rest of the training trials. Set to 2 
(no learning) for the transfer trials, which occur between blocks of learning.

\code{blk} - training/transfer block

\code{stim} - stimulus number according to Smith and Minda (2002)

\code{x1, x2, x3, x4} - input representation

\code{t1, t2} - teaching signal (1 = category present, absval = category
absent)

\code{m1, m2, m3,m4} - Missing dimension flags (always set to zero in this
experiment, indicating all input dimensions are present on all trials)

Although the trial ordering is random, a random seed is used, so
multiple calls of this function with the same parameters should produce
the same output. This is usually desirable for reproducibility and
stability of non-linear optimization. To get a different order, use the
seed argument to set a different seed.

}

\author{

  Angus Inkster

}

\references{

  Smith, D. J. & Minda, J. P. (2000). Thirty categorization results in search 
  of a model. \emph{Journal of Experimental Psychology: Learning, Memory,
  and Cognition 26(1),} 3-27.

}

\seealso{
  
  \code{\link{inkst18train}}, \code{\link{nosof92inkst18}}
}

