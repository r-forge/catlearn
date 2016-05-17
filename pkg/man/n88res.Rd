\name{n88res}
\docType{data}
\alias{n88res}
\title{Nosofsky (1988) results}
\description{
  
  The \code{n88res} data frame has 72 rows and 4 columns of data from an
  experiment on the effect of instance frequency on response accuracy
  in a category learning task (Nosofsky, 1988, Experiment 1). There were 50
  participants per condition; the reported data is averaged across
  participants.
  
}
\usage{data(n88res)}

\format{
  
  A data frame with the following columns:
  \describe{
    
    \item{cond}{Experimental condition, as defined by Nosofsky (1988). 
      Takes values : 'B', 'E2', 'E7'}
    
    \item{stim}{Stimulus number, as defined by Nosofsky (1988). Takes
      values: 1-12}
    
    \item{interval}{Takes values: 'block3' and 'all_blocks'. The former
      is the final training block (block 3), reported in Table 5 of
      Nosofsky (1988). The latter is an average across all three blocks,
      reported in Table 1 of Nosofsky (1988)}
    
    \item{c2acc}{Mean probability, across particiapnts, of responding
      that the item belongs to category 2.}
  }
}

\source{
  Nosofsky, R.M. (1988). Similarity, frequency, and category representations, \emph{Journal
  of Experimental Psychology: Learning, Memory and Cognition, 14}, 54--65.
  }

\keyword{datasets}
