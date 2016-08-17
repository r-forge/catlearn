\name{nosof88}
\docType{data}
\alias{nosof88}
\title{Within-category stimulus frequency CIRP}
\description{

Within-category stimulus frequency is the number of times a stimulus has
been observed as a member of a specific category; sometimes referred to
as 'instantiation frequency' (Barsalou, 1985). Increasing instantiation
frequency of a stimulus increases categorization accuracy for that
stimulus ('direct' effect), and for other similar stimuli ('indirect'
effect). Experiment 1 of Nosofsky (1988) provides the data for this
CIRP.
  
}

\usage{data(nosof88)}

\format{
  
  A data frame with the following columns:
  \describe{
    
    \item{cond}{Experimental condition, see 'details'. 1 = 'B', 2 =
    'E2', 3 = 'E7'}
    
    \item{stim}{Stimulus number, see Nosofsky (1988), Figure 1. Takes
    values: 1-12}
    
    \item{c2acc}{Mean probability, across participants, of responding
      that the item belongs to category 2.}
  }
}

\details{

 Wills & O'Connell (n.d.) discuss the derivation of this CIRP. In
 brief, both the direct and indirect effects have been independently
 replicated. Direct effect: Harris et al. (2008), Nosofsky
 (1988). Indirect effect: Barsalou (1985), Erickson & Kruschke (1998),
 Florian (1992), Homa et al. (1991), Nosofsky (1991). Experiment 1 of
 Nosofsky (1988) was selected due to the availability of a
 multidimensional scaling solution for the stimuli, see
 \code{\link{nosof88train}}, and because it includes an assessment of
 both the direct and the indirect effect.

 Experiment 1 of Nosofsky(1988) involved the classification of Munsell
 chips of fixed hue (5R) varying in brightness (value) and saturation
 (chroma). Instantiation frequency was manipulated between subjects. In
 condition B, all stimuli were equally frequent. In condition E2 (E7),
 stimulus 2 (7) was approximately five times as frequent as each of the
 other stimuli. In condition E2 (E7), stimulus 4 (9) indexes the
 indirect effect. There were three blocks of training. Block length was
 48 trials for condition B and 63 trials for conditions E2 and E7. The
 training phase was followed by a transfer phase, which is not included
 in this CIRP (see Nosofsky, 1988, for details).

 The data are as shown in Table 1 of Nosofsky (1988). The data are mean
 response probabilities for each stimulus in the training phase,
 averaged across blocks and participants.  
  
}

\source{

  Nosofsky, R.M. (1988). Similarity, frequency, and category
  representations, \emph{Journal of Experimental Psychology: Learning,
  Memory and Cognition, 14}, 54-65.

}

\references{

 Barsalou, L.W. (1985). Ideals, central tendency, and frequency of
 instantiation as determinants of graded structure in
 categories. \emph{Journal of Experimental Psychology: Learning, Memory
 & Cognition, 11}, 629-654.

 Erickson, M.A. & Kruschke, J. (1998). Rules and exemplars in category
 learning. \emph{Journal of Experimental Psychology: General, 127},
 107-140.

 Florian, J. (1992). Frequency effects of categorization and
 recognition. \emph{Proceedings of the 14th Annual Conference of the
 Cognitive Science Society}, 826-831.
  
 Harris, H.D., Murphy, G.L. & Rehder, B. (2008). Prior knowledge and
 exemplar frequency. \emph{Memory & Cognition, 36}, 1335-1350.

 Homa, D., Dunbar, S. & Nohre, L. (1991). Instance frequency,
 categorization, and the modulating effect of experience. \emph{Journal
 of Experimental Psychology: Learning, Memory & Cognition, 17}, 444-458.

 Nosofsky, R.M. (1991). Tests of an exemplar model for relating
 perceptual classification and recognition memory. \emph{Journal of
 Experimental Psychology: Human Perception and Performance, 17}, 3-27.
 
 Wills, A.J. & O'Connell (n.d.). Averaging
 abstractions. \emph{Manuscript in preparation}.
 
}

\author{
  Andy J. Wills \email{andy@willslab.co.uk}
  }

\seealso{

\code{\link{nosof88train}}, \code{\link{nosof88oat}}    

  }

\keyword{datasets}
