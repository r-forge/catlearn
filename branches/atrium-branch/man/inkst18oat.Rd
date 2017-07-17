\name{inkst18oat}

\alias{inkst18oat}

\title{

  Ordinal Adequacy Test for simulations of the inkst18 dataset
  
}

\description{

  Tests whether a model output passes the ordinal adequacy criteria for
  the \code{\link{inkst18}} CIRP.
  
}

\usage{

  inkst18oat(dta, xtdo = FALSE)
  
}

\arguments{

  \item{dta}{Matrix containing model output. The matrix must have the
  same format, row order, and column names, as \code{data(nosof92)};
  with that proviso, the output of any simulation implementation can be
  handled by this function.}
  
  \item{xtdo}{eXTenDed Output: Either \code{TRUE} or \code{FALSE}}
  
}

\value{

Where \code{xtdo=FALSE}, this function returns TRUE if the ordinal
adequacy tests are passed, and FALSE otherwise.

Where \code{xtdo=TRUE}, this function returns a summary matrix,
containing mean correct response to A1 and A2 stimuli during the
four training blocks.

}

\details{

  This function implements a standard ordinal adequacy test for the
  \code{\link{inkst18}} CIRP. Specifically, a model passes this test if
  the accuracy (averaged across stimuli), obeys the following:

  1 < 2 < 3 < 4 < 5 < 6
  
  and the accuracy (averaged across blocks), obeys the following:
  
  stim2 > stim1

  Alternatively, by setting \code{xtdo} to \code{TRUE}, this function
  returns the accuracy for stim1 and stim 2 by block.

}

\author{
  
  Angus Inkster 
  
}

\seealso{

  \code{\link{inkst18}}    

}