\name{nosof94}
\docType{data}
\alias{nosof94}
\title{Type I-VI category structure CIRP}
\description{

  Shepard et al. (1961) stated that where there are two, equal-sized
  categories constructed from the eight stimuli it is possible to
  produce from varying three binary stimulus dimensions, there are only
  six logically distinct category structures. Shepard et al. (1961)
  labeled these structures as Types I through VI (see e.g. Nosofsky et
  al., 1994, Figure 1, for details). The CIRP concerns the relative
  difficulty of learning these category structures, as indexed by
  classification accuracy. The result, expressed in terms of accuracy,
  is:

  I > II > [III, IV, V] > VI

  The experiment reported by Nosofsky et al. (1994) provides the data
  for this CIRP.
  
}

\usage{data(nosof94)}

\format{
  
  A data frame with the following columns:
  
  \describe{
    
    \item{type}{Type of category structure, as defined by Shepard et al. (1961). 
      Takes values : 1-6}
    
    \item{block}{Training block. Takes values: 1-16}
    
    \item{error}{Mean error probability, averaged across participants}
    
    }
}
\details{

  Wills & O'Connell (n.d.) discuss the derivation of this CIRP. In
  brief, the effect has been demonstrated independently on three
  occasions (Nosofsky et al., 1994; Shepard et al., 1961; Smith et al.,
  2004). Kurtz et al. (2013) discuss and report a number of experiments
  that indicate that the advantage of Type II over Type IV may depend on
  specific details of the experimental design, including the stimulus
  dimensions being easily verbalizable, and the participants being
  explicitly instructed to look for rules.

  Nosofsky et al. (1994) was selected as the CIRP because it had
  acceptable sample size (N=40 per Type), and included simulations of
  the results with a number of different formal models. Inclusion of
  this dataset in \code{catlearn} thus permits a validation of
  \code{catlearn} model implementations against published simulations.

  In Nosofsky et al. (1994) the stimuli varied in shape (squares or
  triangles), type of interior line (solid or dotted), and size (large
  or small). Each participant learned two problems. Each problem was
  trained with feedback, to a criterion of four consecutive sub-blocks
  of eight trials with no errors, or for a maximum of 400 trials. 

  The data are as shown in the first 16 rows of Table 1 of Nosofsky et
  al. (1994). Only the first 16 blocks are reported, for comparability
  with the model fitting reported in that paper. Where a participant
  reached criterion before 16 blocks, Nosofsky et al. assumed they would
  have made no further errors if they had continued.
  
}
\source{
  
  Nosofsky, R.M., Gluck, M.A., Plameri, T.J., McKinley, S.C. and
  Glauthier, P.  (1994). Comparing models of rule-based classification
  learning: A replication and extension of Shepaard, Hovland, and
  Jenkins (1961). \emph{Memory and Cognition, 22}, 352-369.


}

\references{

  Kurtz, K.J., Levering, K.R., Stanton, R.D., Romero, J. & Norris,
  S.N. (2013). Human learning of elemental category structures: Revising
  the classic result of Shepard, Hovland, and Jenkins
  (1961). \emph{Journal of Experimental Psychology: Learning, Memory &
    Cognition, 39}, 552-572.

  Shepard, R.N., Hocland, C.I., & Jenkins, H.M. (1961). learning and
  memorization of classifications. \emph{Psychological Monographs, 75},
  Whole No. 517.

  Smith, J.D., Minda, J.P. & Washburn, D.A. (2004). Category learning in
  rhesus monkeys: A study of the Shepard, Hovland, and Jenkins (1961)
  tasks. \emph{Journal of Experimental Psychology: General, 133}, 398-414.
  
  Wills, A.J. & O'Connell (n.d.). Averaging
  abstractions. \emph{Manuscript in preparation}.
   
  }

  \author{
  Andy J. Wills \email{andy@willslab.co.uk}
  }

\seealso{

\code{\link{nosof94train}}, \code{\link{nosof94oat}}    

  }

\keyword{datasets}
