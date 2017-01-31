\name{slpRW}
  \alias{slpRW}
\title{
RW associative Learning Model
}
\description{

Rescorla & Wagner's (1972) Theory of Pavlovian conditioning: variations in the effectiveness of reinforcement and non reinforcement.
}
\usage{

slpRW(st, tr, xtdo = FALSE)

}
\arguments{

  \item{st}{List of model parameters}
  
  \item{tr}{R matrix of training items}
  
  \item{xtdo}{Boolean specifying whether to include extended information in the output (see below)}
  
}
}
\details{

The contents of this help file are intended to provide a brief overview of slpRW. 

The function operates as a stateful list processor (slp). Specifically, it takes a matrix (tr) as an argument, where each row represents a single training trial, while each column represents the different types of information required by the model, such as training stimuli, teaching signals and control signals. It returns a matrix where each row also represents a single trial, and where the column represents summed stumulus activations (i.e. associative strengths), generated over the course of a simulation. The slpRW function also returns the final state of the model, in the form of a vector of weights representing associative strengths.

Please note that further development is planned for slpRW, with the next release scheduled for September 2017. The most significant change will be model optimisation (by translation from R script to C++ script), which will greatly improve the speed at which the model can run. Also, there will be more flexibility in terms of setting the learning rate. The constant lr (see below) will be split into its constituent alpha and beta parts, while beta will be further split into beta-1 and beta-0.

Argument st must be a list containing the following items:

lr - the learning rate. This is set as a constant value for simulations. It is comprised of two constants multiplied together (alpha and beta: the salience of the conditioned stimuli, and the learning rate parameter of the unconditioned stimuli, respectively (Rescorla & Wagner, 1972)).

w - a vector of weights for the conditioned stimuli (set at an initial value of zero).

colskip - the number of optional columns to be skipped in the tr matrix. colskip should be set to the number of optional columns you have added to the tr matrix, PLUS ONE. So, if you have added no optional columns, colskip=1. This is because the first (non-optional) column contains the control values (details below).

Argument tr must be a matrix, where each row is one trial presented to the model. Trials are always presented in the order specified. The columns must be as described below, in the order described below:

ctrl - a vector of control codes. Available codes are: 0 = normal trial; 1 reset model (i.e. set associative strengths (weights) back to their initial values as specified in w (see above)); 2 = Freeze learning. Control codes are actioned before the trial is processed.

opt1, opt2, ... any number of preferred optional columns, the names of which can be chosen by the user. It is important that these columns are placed after the control column, and before the remaining columns (see below). These optional columns are ignored by the slpRW function, but you may wish to use them for readability. For example, you might choose to include columns such as block number, trial number and condition. The argument colskip (see above) must be set to the number of optional columns plus one. 

x1, x2, ... any number of preferred stimulus inputs to the model. There must be one column for each input unit (i.e. stimulus). Each row is one trial. The naming of the input columns can be defined by the user (for example you might wish to use different letters to represent individual stimuli). 

t - teaching signal to the model. This can be a value of one or zero, depending on whether the stimuli are paired with the outcome, or the absence of the outcome, respectively. The teaching signal provides the role of lambda, within the Rescorla-Wagner equation (i.e. the asymptote of associative strength for conditioned stimuli (Rescorla & Wagner, 1972)).

Argument xtdo (eXTenDed Output), if set to TRUE, will include cumulative weights of associative strength (w.m) at the end of each trial (i.e. for each stimulus input).

}

\value{

Returns a list containing two components: (1) matrix of summed output activations (suma) (i.e. sum of associative strengths) for each trial; (2) weights of associative strength (st) after the final trial.
 

%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\author{
Stuart Spicer

}
\references{

Rescorla, R. A., & Wagner, A. R. (1972). A theory of Pavlovian conditioning: Variations in the effectiveness of reinforcement and nonreinforcement. In A. H. Black & W. F. Prokasy (Eds.), Classical conditioning II: Current research and theory (pp. 64–99). New York: Appleton-Century-Crofts.

Wills, A.J., O'Connell, G., Edmunds, C.E.R., & Inkster, A.B.(2016). Progress in modeling through distributed collaboration: Concepts, tools, and category-learning examples. The Psychology of Learning and Motivation.

}