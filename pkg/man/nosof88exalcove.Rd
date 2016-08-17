\name{nosof88exalcove}
\alias{nosof88exalcove}
\title{
  
   Simulation of CIRP nosof88 with ex-ALCOVE model

 }
 
\description{

  Runs a simulation of the \code{\link{nosof88}} CIRP using the
  \code{\link{slpALCOVE}} model implementation as an exemplar model and
  \code{\link{nosof88train}} as the input representation.
  
}

\usage{

  nosof88exalcove(params = c(0.787,2.359,0.990,0.057))

}

\arguments{
  
  \item{params}{A vector containing values for c, phi, la, and lw, in
  that order. See \code{\link{slpALCOVE}} for an explanation of these
  parameters.}
  
}  
  
\value{
  
  A matrix of predicted response probabilities, in the same order and
  format as the observed data contained in \code{\link{nosof88}}.

}

\details{

 An exemplar-based simulation using \code{\link{slpALCOVE}} and
 \code{\link{nosof88train}}. The co-ordinates for the radial-basis units
 are taken from the multdimensional scaling solution for these stimuli
 reported by Nosofsky (1987).
 
 The defaults for \code{params} are the best fit of the model to the
 \code{\link{nosof88}} CIRP. They were derived through minimization of
 SSE using non-linear optimization from 16 different initial
 states (using code not included in this archive). 

 The other parameters of slpALCOVE are set as follows: \code{r} = 2,
 \code{q} = 1, initial \code{alpha} = 1 / (number of input dimensions),
 initial \code{w} = 0. These values are conventions of modeling with
 ALCOVE, and should not be considered as free parameters. They are set
 within the \code{nosof88exalcove} function, and hence can't be changed
 without re-writing the function.

 This simulation is reported in Wills & O'Connell (n.d.). 

}

\author{
  
  Andy Wills & Garret O'Connell
  
}
\references{

  Nosofsky, R.M. (1987). Attention and learning processes in the
  identification and categorization of integral stimuli, \emph{Journal
  of Experimental Psychology: Learning, Memory and Cognition, 13},
  87-108.

  Wills, A.J. & O'Connell (n.d.). Averaging
  abstractions. \emph{Manuscript in preparation}.
 
  
}

\seealso{

\code{\link{nosof88}}, \code{\link{nosof88oat}},
\code{\link{nosof88train}}, \code{\link{slpALCOVE}}

}
