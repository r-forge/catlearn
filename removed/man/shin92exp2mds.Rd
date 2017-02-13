\name{shin92exp2mds}
\docType{data}
\alias{shin92exp2mds}
\title{Shin & Nosofsky (1992, Exp. 2) MDS solution}
\description{
  
  The \code{shin92exp2mds} data frame has 30 rows and 10 columns of data
  from a multi-dimensional scaling solution reported by Shin & Nosofsky
  (1992, Table A2). This solution comes from data collected in
  Experiment 2 of that paper.
  
}
\usage{data(shin92exp2mds)}

\format{
  
  A data frame with the following columns:
  
  \describe{
    
    \item{id}{Unique identifier of form A2-catX-YY[-Z] where X is the
      category number, YY is the stimulus code, and Z is the second part
      of the sitmulus code. The identifiers come from Table A2 of Shin &
      Nosofsky (1992)}
  
    \item{cat}{Category from which the stimulus comes; takes values:
    1-3}

   \item{type}{Stimulus type; takes values: proto, old, new}
  
   \item{dist}{Distortion level, in bits; takes values: 0, 4, 6, 7.7}
   
   \item{D1}{Co-ordinate for dimension 1 of MDS solution}
   
   \item{D2}{Co-ordinate for dimension 1 of MDS solution}
   
   \item{D3}{Co-ordinate for dimension 1 of MDS solution}
  
   \item{D4}{Co-ordinate for dimension 1 of MDS solution}
   
   \item{D5}{Co-ordinate for dimension 1 of MDS solution}
   
   \item{D6}{Co-ordinate for dimension 1 of MDS solution}    
    
  }
}
  
\source{
  
  Shin, H.J. &  Nosofsky, R.M. (1992). Similarity-scaling studies of
  dot-pattern classification and recognition. \emph{Journal
  of Experimental Psychology: General, 121}, 278--304.

  }

\keyword{datasets}
