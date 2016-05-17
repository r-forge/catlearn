\name{shin92}
\docType{data}
\alias{shin92}
\title{Shin & Nosofsky (1992) results}
\description{
  
  The \code{shin92} data frame has 92 rows and 5 columns of data from an
  experiment on the effect of category size and instance frequency on
  response accuracy in a category learning task (Shin & Nosofsky, 1992,
  Experiment 3). There were 30 participants per condition; the reported
  data is averaged across participants.
  
}
\usage{data(shin92)}
\format{
  
  A data frame with the following columns:
  
  \describe{
    
    \item{cond}{Experimental condition (frequency). Takes values :
      'equal', 'unequal'}
    
    \item{catsize}{Experimental condition (category size). Takes values
      : 3, 10}
    
    \item{cat}{Category membership of stimulus. Takes values: 1, 2}
    
    \item{stim}{Stimulus code, as defined by Shin & Nosofsky (1992)}
    
    \item{c2acc}{Mean probability, across particiapnts, of responding
      that the item belongs to category 2.}
    
  }
}
  
\source{
  
  Shin, H.J. &  Nosofsky, R.M. (1992). Similarity-scaling studies of
  dot-pattern classification and recognition. \emph{Journal
  of Experimental Psychology: General, 121}, 278--304.

  }

\keyword{datasets}
