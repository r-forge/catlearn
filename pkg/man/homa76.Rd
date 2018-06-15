\name{homa76res}
\docType{data}
\alias{homa76res}
\title{Homa & Vosburgh (1976) results}
\description{
  
  The \code{homa76res} data frame has 104 rows and 5 columns of data from
  an experiment on the effect of category breadth on response accuracy
  in a category learning task (Homa & Vosburgh, 1976).  There were 36
  participants per condition; the reported data is averaged across
  participants.
  
}
\usage{data(shin92)}
\format{
  
  A data frame with the following columns:
  
  \describe{
    
  \item{phase}{Experimental phase (within-subjects). Takes values :
  'train','imm', '1wk', '10wk'. The training phase is 'train', the
  others are the immediate, 1-week delay, and 10-week delay test
  phases.}
    
  \item{cond}{Category breadth (between-subjects). Takes values :
  'mixed', 'uni-low'}

  \item{stim}{Stimulus type (within-subjects). Takes values : 'proto',
    'low', 'med', 'high', 'old-low', 'old-med', 'old-high', 'rand'. All
    refer to novel stimuli in the test phase, except those beginning
    'old-', which are stimuli from the training phase presented during
    the test phase. 'low', 'med', 'high' refer to distortion
    level. 'proto' are prototypes. 'rand' are a set of 10 random
    stimuli, generated from prototypes unrelated to those used in
    training. These random stimuli are not mentioned in the Method of
    the paper, but are mentioned in the Results section - they are
    presented at the end of each test session. Empty cell for training
    phase.}

  \item{catsize}{Category size (within-subjects). Takes values : 3, 6,
  9. NA for training phase, and for random stimuli.}

  \item{val}{For test phases: probability of a correct response, except
  for random stimuli, where 'val' is the probability with which the
  random stimuli were placed into the specified category. For training
  phase: number of blocks to criterion}

  }
}
  
\details{

These data were estimated from Figures 1-3 of Homa & Vosburgh
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

