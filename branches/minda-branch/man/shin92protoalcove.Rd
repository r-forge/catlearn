\name{shin92protoalcove}
\alias{shin92protoalcove}
\title{
  
   Simulation of CIRP shin92 with proto-ALCOVE model

 }
 
\description{

  Runs a simulation of the \code{\link{shin92}} CIRP using the
  \code{\link{slpALCOVE}} model implementation as a prototype model and
  \code{\link{shin92train}} as the input representation.
  
}

\usage{

  shin92protoalcove(params = c(0.3522, 0.9649, 0.0156, 0.9900))

}

\arguments{
  
  \item{params}{A vector containing values for c, phi, la, and lw, in
  that order. See \code{\link{slpALCOVE}} for an explanation of these
  parameters.}
  
}  
  
\value{
  
  A matrix of predicted response probabilities, in the same order and
  format as the observed data contained in \code{\link{shin92}}.

}

\details{

 An exemplar-based simulation using \code{\link{slpALCOVE}} and
 \code{\link{shin92train}}. The co-ordinates for the radial-basis units
 for the two prototypes are derived from the arithmetic means of the
 test stimuli in \code{\link{shin92train}}. The output is the average of
 100 simulated subjects.
 
 The defaults for \code{params} are the best fit of the model to the
 \code{\link{shin92}} CIRP. They were derived through minimization of
 SSE using non-linear optimization from 16 different initial
 states (using code not included in this archive). 

 The other parameters of slpALCOVE are set as follows: \code{r} = 2,
 \code{q} = 1, initial \code{alpha} = 1 / (number of input dimensions),
 inital \code{w} = 0. These values are conventions of modeling with
 ALCOVE, and should not be considered as free parameters. They are set
 within the \code{shin92exaclove} function, and hence can't be changed
 without re-writing the function.

 This simulation was reported in Wills et al. (2016). 

}

\author{
  
  Andy Wills & Garret O'Connell
  
}
\references{

  Shin, H.J. &  Nosofsky, R.M. (1992). Similarity-scaling studies of
  dot-pattern classification and recognition. \emph{Journal
    of Experimental Psychology: General, 121}, 278--304.

  Wills, A.J., O'Connell, G., Edmunds, C.E.R. & Inkster, A.B. (2016).
  Progress in modeling through distributed collaboration: Concepts,
  tools, and category-learning examples. \emph{The Psychology of
  Learning and Motivation}.
  
}

\seealso{

\code{\link{shin92}}, \code{\link{slpALCOVE}}, \code{\link{shin92train}}

}
