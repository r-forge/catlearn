\name{homa76train}
\alias{homa76train}
\title{
  
Homa & Vosburgh (1976) training and transfer blocks

}
\description{
  
  Create randomized training and transfer blocks for Homa & Vosburgh
  (1976), in a format suitable for category-learning models
  (e.g. \code{alcovelp}).

}
\usage{

  homa76train(condition = 'mixed', learn.blocks = 1, trans.blocks = 1,
          absval = -1)

}
\arguments{
  
  \item{condition}{Experimental condition 'mixed' or 'uni-low', as
  defined by Homa & Vosburgh (1976).}

  \item{learn.blocks}{Number of training blocks to generate.}

  \item{trans.blocks}{Number of transfer blocks to generate.}

  \item{absval}{Teaching value to be used where category is absent.}
  
}  
  
\value{
  
R by C matrix, where each row is one trial, and the columns contain
model input.

}

\details{

A matrix is produced, with one row for each trial, and with the
following columns:

\code{ctrl} - Set to 1 (reset model) for trial 1, set to zero (normal
trial) for all other training trials, and set to 2 (freeze learning) for
all transfer trials.

\code{cond} - 1 = "mixed", 2 = "uni-low"

\code{phase} - 1 = training, 2 = transfer

\code{blk} - block of trials

\code{cat} - category stimulus belongs to (1 = 3-item category, 2 =
6-item category, 3 = 9-item category).

\code{type} - stimulus type (1 = new, 2 = protos, 3 = old)

\code{stim} - stimulus number

\code{D1 ... D6} - input representation. These are the co-ordinates of
an estimated MDS solution for these stimuli - for details of the method
of estimation, see function \code{homa76ipolate}, and then read the
'further notes' at the end of this section. The source code of this
function is also extensively commented.

\code{t1 ... t3} - teaching signal (1 = category present, absval =
category absent)

\code{m1 ...  m6} - Missing dimension flags (always set to zero in this
experiment, indicating all input dimensions are present on all trials).

Further notes:

For 'old' test stimuli in condition 'mixed', Homa & Vosburgh (1976)
specify 'one of each [distortion] level for each category'. For the
size-3 category this is unambiguous. For the size-6 and size-9
categories, this function picks the stimuli most typical in their
Euclidean distance to the prototype.

For 'old' test stimuli in condition 'uni-low', Homa & Vosburgh (1976)
specify 'three low-level distortions of each of the categories'. For the
size-9 category, this function uses all non-interpolated stimuli. For
the size-3 category, this function uses the single non-interpolated
stimulus plus both interpolated stimuli. For the size-6 category, this
function uses the two non-interpolated stimuli, plus stimulus 'extra-1' -
picked because it is generated from a typical old stimulus and is
maximally distant from that stimulus.

}

\author{
  
Andy Wills

}

\references{

  Homa, D. & Vosburgh, R. (1976). Category breadth and the abstraction
  of prototypical information. \emph{Journal of Experimental Psychology:
  Human Learning and Memory, 2},322-330.

}
\seealso{
}
\examples{
}
