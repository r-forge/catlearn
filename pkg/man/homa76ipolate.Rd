\name{homa76ipolate}
\alias{homa76ipolate}
\title{
  
  MDS co-ordinates for Homa & Vosburgh (1976).

}
\description{
  
  Create estimated multi-dimensional scaling co-ordinates for the
  stimuli used in Homa & Vosburgh (1976), through a method
  interpolation. 

}
\usage{

  homa76ipolate()

}
\arguments{}  
  
\value{

  Data frame with 60 rows and 10 columns. Output is the same as
  data(shin92exp2mds), but with additional rows for stimuli created by
  interpolation.

}

\details{

 This function is intended to serve as a temporary patch until such time
 as a replication of Homa & Vosburgh's (1976) category breadth result is
 conducted including data collection for a full MDS solution.
  
 The function creates estimated MDS co-ordinates for the stimuli in Homa
 & Vosburgh (1976). It takes the MDS co-ordinates for Shin & Nosofsky
 (1992, Exp. 2) as a starting point, because the stimuli in these two
 studies are similar. It then generates additional low, medium, and high
 distortion stimuli by a process of interpolation.

 For example, category 3 has 4 low-disortion stimuli and needs 8
 more. The 4 existing stimuli provide 4 possible values on each MDS
 dimension. This results in 4096 (4^6) stimuli that can be created by
 the recombination of these values (within dimensions). For each
 existing stimulus, its Euclidean distance from the prototype is
 calculated, and a subset of those 4096 stimuli are selected on the
 basis that they have a closely similar distance to the prototype as the
 existing stimulus.

 This subset is then ordered by their Euclidean distance to the existing
 stimulus. One new stimulus is created that is maximally far from the
 existing stimulus. Another new stimulus is created that is averagely
 far from the existing stimulus.

 A similar process is used to generate the other stimuli. For more
 details, inspect the source code, which is extensively commented.
  
}

\author{
  
  Andy Wills

}
\references{

  Homa, D. & Vosburgh, R. (1976). Category breadth and the abstraction
  of prototypical information. \emph{Journal of Experimental Psychology:
  Human Learning and Memory, 2},322-330.
  
  Shin, H.J. & Nosofsky, R.M. (1992). Similarity-scaling studies of
  dot-pattern classification and recognition. \emph{Journal of
  Experimental Psychology: General, 121}, 278--304.
  
}
\seealso{
}
\examples{
}
