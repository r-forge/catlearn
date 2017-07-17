\name{nosof92oat}
\alias{nosof92oat}
\title{

  Ordinal Adequacy Test for simulations of nosof92 CIRP

}

\description{

  Tests whether a model output passes the ordinal adequacy criteria for
  the \code{\link{nosof92}} CIRP.
  
}

\usage{

  nosof92oat(dta, xtdo=FALSE)

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

