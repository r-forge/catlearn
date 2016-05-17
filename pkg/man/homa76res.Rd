\name{homa76res}
\docType{data}
\alias{homa76res}
\title{Homa & Vosburgh (1976) results}
\description{
  
  The \code{homa76res} data frame has 72 rows and 5 columns of data from
  an experiment on the effect of category breadth on response accuracy
  in a category learning task (Homa & Vosburgh, 1976).  There were 36
  participants per condition; the reported data is averaged across
  participants.
  
}
\usage{data(shin92)}
\format{
  
  A data frame with the following columns:
  
  \describe{
    
  \item{phase}{Experimental phase. Takes values : 'train','imm', '1wk',
  '10wk'. The training phase is 'train', the others are the immediate,
  1-week delay, and 10-week delay test phases.}
    
  \item{cond}{Category breadth (between-subjects). Takes values :
  'mixed', 'uni-low'}

  \item{stim}{Stimulus type (within-subjects). Takes values : 'proto',
    'low', 'med', 'high'. Empty cell for training phase.}

  \item{catsize}{Category size (within-subjects). Takes values : 3, 6,
  9. NA for training phase.}

  \item{val}{For test phases: probability of a correct response. For
  training phase: number of blocks to criterion}

  }
}
  
\details{

These data were estimated from Figures 1 and 2 of Homa & Vosburgh
(1976), using \code{plot digitizer} (Huwaldt, 2015).
  
}

\source{

  Homa, D. & Vosburgh, R. (1976). Category breadth and the abstraction
  of prototypical information. \emph{Journal of Experimental Psychology:
  Human Learning and Memory, 2}, 322-330.
  
  Huwaldt, J.A. (2015). Plot Digitizer
  [software]. \url{http://plotdigitizer.sourceforge.net/}

  }
\keyword{datasets}

