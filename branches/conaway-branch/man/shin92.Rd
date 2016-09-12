\name{shin92}
\docType{data}
\alias{shin92}
\title{Category size CIRP}
\description{
  
  Category size is the number of examples of a category that have been
  presented to the participant. The category-size effect (e.g. Homa et
  al., 1973) is the phenomenon that, as category size increases, the
  accuracy of generalization to new members of that category also
  increases. The equal-frequency conditions of Experiment 3 of Shin &
  Nosofsky (1992) provides the data for this CIRP.
    
}
\usage{data(shin92)}
\format{
  
  A data frame with the following columns:
  
  \describe{
    
    \item{catsize}{Experimental condition (category size). Takes values
      : 3, 10}
    
    \item{cat}{Category membership of stimulus. Takes values: 1, 2}
    
    \item{stim}{Stimulus code, as defined by Shin & Nosofsky
    (1992). Stimuli beginning 'RN' or 'URN' are the 'novel'
    stimuli. Stimuli beginning 'P' are prototypes. The remaining stimuli
    are the 'old' (training) stimuli. }
    
    \item{c2acc}{Mean probability, across participants, of responding
      that the item belongs to category 2.}
    
  }
}

\details{

  Wills et al. (2016) discuss the derivation of this CIRP. In brief, a
  between-subjects manipulation of category size was selected to avoid a
  potential response-bias confound in within-subject studies of the
  category-size effect. The between-subjects effect has been
  demonstrated independently on three occasions (DiNardo & Toppino,
  1984; Homa et al., 1987; Shin & Nosofsky, 1992). Experiment 3 of Shin
  & Nosofsky (1992) was selected due to the availability of a
  multi-dimensional scaling solution for the stimuli, see
  \code{\link{shin92train}}. 
  
  Experiment 3 of Shin & Nosofsky (1992) involved the classification of
  nine-vertex polygon stimuli drawn from two categories. Category size
  was manipulated between subjects (3 vs. 10 stimuli per
  category). Participants received eight blocks of training, and three
  test blocks.

  The data are as shown in Table 10 of Shin & Nosofsky (1992). The data
  are mean response probabilities for each stimulus in the test phase,
  averaged across test blocks and participants.
  
}

\source{
  
  Shin, H.J. &  Nosofsky, R.M. (1992). Similarity-scaling studies of
  dot-pattern classification and recognition. \emph{Journal
  of Experimental Psychology: General, 121}, 278-304.

}

\references{

  DiNardo, M.J. & Toppino, T.C. (1984). Formation of ill-defined
  concepts as a function of category size and category
  exposure. \emph{Bulletin of the Psychonomic Society, 22}, 317-320.
  
  Homa, D., Burruel, L. & Field, D. (1987). The changing composition of
  abstracted categories under manipulations of decisional change, choice
  difficulty, and category size. \emph{Journal of Experimental
  Psychology: Learning, Memory, and Cognition, 13}, 401-412.
  
  Homa, D., Cross, J., Cornell, D., Goldman, D. & Shwartz,
  S. (1973). Prototype abstraction and classification of new instances
  as a function of number of instances defining the
  prototype. \emph{Journal of Experimental Psychology, 101}, 116-122.

  Wills, A.J., O'Connell, G., Edmunds, C.E.R. & Inkster, A.B. (2016).
  Progress in modeling through distributed collaboration: Concepts,
  tools, and category-learning examples. \emph{The Psychology of
  Learning and Motivation}.
  
}

\author{
  Andy J. Wills \email{andy@willslab.co.uk}
  }

\seealso{

\code{\link{shin92train}}, \code{\link{shin92oat}}    

  }
  
\keyword{datasets}
