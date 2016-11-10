\name{nosof94train}
\alias{nosof94train}
\title{

  Input representation of nosof94 for models input-compatible with slpALCOVE.
  
}
\description{
  
  Create randomized training blocks for CIRP \code{nosof94}, in a format
  suitable for the \code{slpALCOVE} model, and other models that use the
  same input representation format. The stimulus co-ordinates are
  assumed, and use the same binary representation as the abstract
  category structure. 

}
\usage{

nosof94train(cond = 1, blocks = 16, absval = -1, subjs = 1, seed = 7624)

}
\arguments{
  
  \item{cond}{Category structure type (1-6), as defined by Shepard et
  al. (1961).}
  
  \item{blocks}{Number of blocks to generate. Omit this argument to get
    the same number of blocks (16) as used in the simulations reported
    by Nosofsky et al. (1994).}
  
  \item{absval}{Teaching value to be used where category is absent.}

  \item{subjs}{Number of simulated subjects to be run.}

  \item{seed}{Sets the random seet.}
  
}  
  
\value{
  
R by C matrix, where each row is one trial, and the columns contain
model input.

}

\details{
  
A matrix is produced, with one row for each trial, and with the
following columns:

\code{ctrl} - Set to 1 (reset model) for trial 1, set to zero (normal
trial) for all other trials.

\code{blk} - training block

\code{stim} - stimulus number (arbitrary, but consistent across
              different values of \code{problem})

\code{x1, x2, x3} - input representation

\code{t1, t2} - teaching signal (1 = category present, absval = category
absent)

\code{m1, m2, m3} - Missing dimension flags (always set to zero in this
experiment, indicating all input dimensions are present on all trials)

In Nosofsky et al. (1994), block 1 was randomized differently to later
blocks. This feature is retained in this implementation.

Although the trial ordering is random, a random seed is used, so
multiple calls of this function with the same parameters should produce
the same output. This is usually desirable for reproducibility and
stability of non-linear optimization. To get a different order, use the
seed argument to set a different seed.

This routine was originally developed to support simulations reported in
Wills & O'Connell (n.d.).

}

\author{
  
  Andy Wills
  
}
\references{
  
  Nosofsky, R.M., Gluck, M.A., Plameri, T.J., McKinley, S.C. and
  Glauthier, P.  (1994). Comparing models of rule-based classification
  learning: A replication and extension of Shepaard, Hovland, and
  Jenkins (1961). \emph{Memory and Cognition, 22}, 352--369

  Shepard, R.N., Hocland, C.I., & Jenkins, H.M. (1961). learning and
  memorization of classifications. \emph{Psychological Monographs, 75},
  Whole No. 517.

   Wills, A.J. & O'Connell (n.d.). Averaging
 abstractions. \emph{Manuscript in preparation}.


  
}
\seealso{
  
  \code{\link{nosof94train}}, \code{\link{nosof94oat}}    

  }
