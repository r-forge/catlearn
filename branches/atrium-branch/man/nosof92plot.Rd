\name{nosof92plot}
\alias{nosof92plot}
\title{
  
Plot Nosofsky et al. (1992) data / simulations

}
\description{
  
  Produce a line graph similar to that shown in Nosofsky et al. (1992,
  Figures 6, 225).
  
}
\usage{

nosof94plot(results,title = 'Nosofsky et al. (1992)')

}
\arguments{
  
  \item{results}{Mean probability of correct resppnse by block and pattern,
  in the same format as data set \code{nosof92}}
  
  \item{title}{Title to appear at top of plot}
  
}  
\author{
  Angus Inkster
}
\references{
  
  Nosofsky, R.M., Kruschke, J.K and McKinley, S.C. (1992). Combining 
  exemplar-based category representations and connectionist learning rules.
  \emph{Journal of Experimental Psychology: Learning, Memory and Cognition, 
  18(2)}, 211-233.
  
}
\examples{
  data(nosof92)
  nosof94plot(nosof92)
}