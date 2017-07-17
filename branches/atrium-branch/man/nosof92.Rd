\name{nosof1992}
\docType{data}
\alias{nosof1992}
\title{Exemplar vs Prototype Theory CIRP}
\description{

  Medin and Schaffer (1978, Experiment 2) trained participants to categorise
  nine four-dimensional stimuli into either 'A' or 'B' categories. They then
  tested participants on all possible stimuli including two training stimuli
  designed to distinguish between exemplar and prototype accounts of category
  learning (See e.g Medin and Schaffer 1978, Figure 4, for details). It is
  presumed that better accuracy on the stimulus closer to the category prototype
  supports a prototype account, whilst better accuracy on the stimulus  that is
  more similar to more members of the category supports an exemplar account. The
  CIRP concerns the results that participants have greater accuracy on the 
  second stimulus and poor accuracy on the first, a result generally taken
  in support of exemplar theories. The dataset reported in this CIRP is from 
  Nosofsky, Kruschke and McKinley (1992, Experiment 2).
}

\usage{data(nosof92)}

\format{
  
  A data frame with the following columns:
  
  \describe{
    
    \item{ctrl}{A column designed to give control signals to a model being fit
    to this data}
    
    \item{blk}{Training block. Takes values: 1-16}
    
    \item{stim}{Unique stimulus number. Takes values: 1-16}
    
    \item{x1}{Value on the first binary stimulus dimension. Takes values: 0 or 1.}
    
    \item{x2}{Value on the second binary stimulus dimension. Takes values: 0 or 1.}
    
    \item{x3}{Value on the third binary stimulus dimension. Takes values: 0 or 1.}
    
    \item{x4}{Value on the fourth binary stimulus dimension. Takes values: 0 or 1.}
    
    \item{t1}{Teaching signal used by learning systems within models being
    fit to this data. Indicates membership of Category A in Nosofsky et al.
    (1992). Takes values: 1 or -1}
    
    \item{t2}{Teaching signal used by learning systems within models being
    fit to this data. Indicates membership of Category B in Nosofsky et al.
    (1992). Takes values: 1 or -1}
    
    \item{m1}{Value indicating a missing stimulus value on the first stimulus
    dimension. Generally unused (although some studies present stimuli with 
    missing dimensions). Left in as a commonality across CIRP datasets. Takes 
    values: 0 (no missing value) or 1 (missing value)}
    
    \item{m2}{Value indicating a missing stimulus value on the second stimulus
    dimension. Generally unused (although some studies present stimuli with 
    missing dimensions). Left in as a commonality across CIRP datasets. Takes 
    values: 0 (no missing value) or 1 (missing value)}
    
    \item{m3}{Value indicating a missing stimulus value on the third stimulus
    dimension. Generally unused (although some studies present stimuli with 
    missing dimensions). Left in as a commonality across CIRP datasets. Takes 
    values: 0 (no missing value) or 1 (missing value)}
    
    \item{m4}{Value indicating a missing stimulus value on the fourth stimulus
    dimension. Generally unused (although some studies present stimuli with 
    missing dimensions). Left in as a commonality across CIRP datasets. Takes 
    values: 0 (no missing value) or 1 (missing value)}
    
    }
}

\details{

  Derivation of this CIRP is discussed in terms of defining a CIRP within Wills,
  O'Connell, Edmunds and Inkster (2017). This is a well-demonstrated effect 
  (Blair and Homa, 2003; Minda and Smith, 2002; Nosofsky, Kruschke and McKinley,
  1992; Nosofsky, Palmeri and McKinley, 1994; Rehder and Hoffman, 2005). There
  is some debate about the generality of the ordinal result across different
  stimulus sets and procedures (Nosofsky, 2000; Smith and Minda, 2000), but there
  is a consensus that the ordinal effect is robust within the experimental
  conditions of the original Medin and Schaffer (1978, Experiment 2) study.
  
  Nosofsky et al. (1992, Experiment 2) was selected as the CIRP because it had
  acceptable sample size (N=40), and included simulations of the results with a
  number of different formal models. Inclusion of this dataset in \code{catlearn}
  thus permits a validation of \code{catlearn} model implementations against 
  published simulations.
  
  In Nosofsky et al. (1992) the stimuli varied in size (large or small), shape 
  (triangles or squares), type of interior lines (dotted or dashed) and density
  of interior lines (high or low). Each participant received 4 blocks of 63
  training trials using the 9 training stimuli seen in Table 4 of Nosofsky et 
  al. (1992). They made a judgement as to whether the stimulus belonged to 
  Category A or Category B and received corrective feedback. Following each
  training block, a transfer phase was conducted containing the full 16 stimuli
  from Table 4 of Nosofsky et al. (1992). These stimuli were presented without 
  corrective feedback. Order of stimulus presentation was randomised during
  training and transfer.
  
}

\source{
  
  Nosofsky, R.M., Kruschke, J.K and McKinley, S.C. (1992). Combining 
  exemplar-based category representations and connectionist learning rules.
  \emph{Journal of Experimental Psychology: Learning, Memory and Cognition, 
  18(2)}, 211-233.


}

\references{

  Blair, M. & Homa, D. (2003). As easy to memorize as they are to classify:
  The 5–4 categories and the category advantage. \emph{Memory & Cognition,
  31(8),} 1293-1301.
  
  Minda, J. P. & Smith, D. J. (2002). Comparing prototype-based and 
  exemplar-based accounts of category learning and attentional allocation.
  \emph{Journal of Experimental Psychology: Learning, Memory, and Cognition
  28 (2),} 275-292.
  
  Nosofsky, R. M. (2000).Exemplar representation without generalization? 
  Comment on Smith and Minda's (2000) Thirty categorization results in search
  of a model. \emph{Journal of Experimental Psychology: Learning, Memory, and 
  Cognition, 26(6),} 1735-1743.
  
  Nosofsky, R. M., Palmeri, T. J., & McKinley, S. C. (1994). Rule-plus-exception
  model of classification learning. \emph{Psychological Review, 101(1),} 53-79.
 
  Rehder, B. & Hoffman, A. B. (2005). Eyetracking and selective attention
  in category learning. \emph{Cognitive Psychology, 51,} 1-41.
  
  Smith, D. J. & Minda, J. P. (2000). Thirty categorization results in search 
  of a model. \emph{Journal of Experimental Psychology: Learning, Memory,
  and Cognition 26(1),} 3-27.
  
  Wills, A.J., O'Connell, G., Edmunds, C.E.R., & Inkster, A.B. (2017). 
  Progress in modeling through distributed collaboration: Concepts, tools,
  and category-learning examples. \emph{Psychology of Learning and 
  Motivation, 66,} 79-115.

  }

  \author{
  Angus B. Inkster \email{ainkster@hotmail.co.uk}
  }

\seealso{

\code{\link{nosof92train}}, \code{\link{nosof92oat}}    

  }

\keyword{datasets}









