\name{Rescorla-Wagner Learning Model}
\alias{slpRW}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{Rescorla & Wagner's (1972) Theory of Pavlovian conditioning: variations in the effectiveness of reinforcement and non reinforcement.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
slpRW(st, tr)

}
%- maybe also 'usage' for other objects documented here.
\arguments{

  \item{st}{List of model parameters}
  
  \item{tr}{R matrix of training items}
  
%%     ~~Describe \code{x} here~~
}
}
\details{

The content of this help file is intended to provide a brief
overview of the Rescorla Wagner model. The function operates
as a stateful list processor(slp). Specifically, it takes a
matrix (tr) as an argument, where each row represents a single
training trial, while each colum represents the different
types of information required by the model, such as training
stimuli, teaching signals, control signals and trial numbers.
It returns a matrix where each row also represents a single
trial, and where the columns represent summed stumulus
activations, generated over the course of a simulation. The
slpRW function also returns the final state of the model, in
the form of a vector of weights representing associative strengths.

Argument st must be a list containing the following items:

alpha - the salience of the conditioned stimuli (Rescorla Wagner
1972 ref format)

beta - the learning rate parameter of the unconditioned stimuli

w - a vector of weights for the conditioned stimuli (set at an
initial value of zero).

colskip - the number of columns to be skipped in the tr matrix.
colskip should be set to the number of optional columns you have
added to the matrix tr, PLUS ONE. So, if you have added no 
optional columns, colskip=1. This is because the first (non-optional)
column contains the control values (details below).


Argument tr must ve a matrix, where each row is one trial presented
to the model. Trials are always presented in the order specified.
The columns must be as described below, in the order described below:

ctrl - a vector of control codes. Available codes are: 0 = normal trial, 1
reset network (i.e. set associative strengths (weights) back to their initial
values as specified in *** (see below)), 2 = Freeze learning. Control codes are
actioned before the trial is processed.

opt1, opt2, ... optional columns, the names of which are can be defined by the user. It is important that these columns are placed after the control column, and before the reamining columns (see below). These optional columns are ignored by the slpRW function, but you may wish to use them for readability. For example, you might choose to include columns such as block number, trial number, and condition. The argument colskip (see above) must be set to the number of optional columns plus one. 

x1, x2, ... input to the model. There must be one column for each input unit (i.e. stimulus). Each row is one trial. The naming of the input columns can be defined by the user (for example you might wish to use different letters to represent individual stimuli). 

t - teaching signal to model


%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x) 
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
