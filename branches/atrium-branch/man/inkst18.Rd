\name{inkst18}
\docType{data}
\alias{inkst18}
\title{Exemplar vs Prototype 5-4 stimuli CIRP}
\description{

  Medin and Schaffer (1978, Experiment 2) trained participants to categorise
  nine four-dimensional stimuli into either 'A' or 'B' categories. They then
  tested participants on all possible stimuli including two training stimuli
  designed to distinguish between exemplar and prototype accounts of category
  learning (See e.g Medin and Schaffer 1978, Figure 4, for details). It is
  presumed that better accuracy on the stimulus closer to the category prototype
  supports a prototype account, whilst better accuracy on the stimulus  that is
  more similar to more members of the category supports an exemplar account. The
  CIRP concerns the result that participants have greater accuracy on the 
  second stimulus and poor accuracy on the first, a result generally taken
  in support of exemplar theories. The dataset reported in this CIRP is from 
  Inkster and Wills (2018).
  
}

\usage{data("inkst18")}

\format{
  A data frame with the following columns:
  
  \describe{
  
    \item{\code{block}}{Numeric indicating the specific training block}
    
    \item{\code{stim1}}{Numeric indicating average accuracy for the first training stimulus}
    
    \item{\code{stim2}}{Numeric indicating average accuracy for the second training stimulus}

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
  
  Inkster and Wills (2018) was selected as the dataset for the CIRP due to having
  acceptable sample size (N=21) and demonstrated the classical result ordinally 
  and significantly.
  
  In Inkster and Wills (2018) the stimuli were those of Minda and Smith (2002),
  cartoon bugs varying on four binary dimensions: body length, head shape,
  eye colour/openness, leg length. Each participant received 6 blocks of 63
  training trials using the 9 training stimuli that can be seen in Table 2 of
  Minda and Smith (2002). Participants made a judgement as to whether the 
  stimulus belonged to  Category A or Category B and received corrective
  feedback. Following each  training block, a transfer phase was conducted
  containing the full 16 stimuli possible stimuli set constructed from the four
  binary stimulus dimensions. These stimuli were presented without corrective 
  feedback. Order of stimulus presentation was randomised during training and
  transfer. The key result within this dataset is the easier learning of the
  second training stimulus than the first training stimulus, characterised by 
  greater accuracy in each training block for the second training stimulus.

}

\source{

  Inkster, A. I. & Wills, A. J. (2018). An enriched dataset of classical category
  learning phenomena. \emph{In Press}.

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

\author{ Angus B. Inkster \email{ainkster@hotmail.co.uk}}

\seealso{\link{inkst18trials},\link{inkst18train}
}

\keyword{datasets}
