\name{stsimGCMbk}
\alias{stsimGCMbk}
\title{
  Generalized Context Model
}
\description{
  Nosofsky's (1984, 2011) Generalized Context Model; an exemplar-based
  model of categorization.
}
\usage{
  stsimGMCbk(st)
}
\arguments{
  \item{st}{List of model parameters}
}  
  
\value{
  A matrix of response probabilities, for each stimulus (rows) and
  category (columns). Stimuli and categories are in the same order as
  presented to the model in \code{st}, see below. 
}

\details{

  Argument \code{st} must be a list containing the following items:

  \code{nCats} - integer indicating the number of categories

  \code{training_items} - the exemplars assumed to be stored in memory;
  has to be a list with the following structure:
  
  training_items[[1]] - category 1 exemplars
  
  training_items[[2]] - category 2 exemplars
  
  ...
  
  training_items[[n]] - category n exemplars.
  
  Each [[n]] is a matrix with one column for each stimulus, and one row
  for each stimulus dimension. Each cell carries the value of an
  exemplar on the given stimulus dimension (all numeric values
  possible). The order of feature dimensions corresponds to the order of
  attentional weights which are defined in \code{weights}, e.g. row 1 in
  [[n]] corresponds to the first stimulus dimension. 

  \code{test_items} is a matrix with one column for each presented
  stimulus, and one row for each stimulus dimension. The order of
  stimulus dimensions is the same as in the training_items. Each cell
  carries the value of a stimulus on the given stimulus dimension (all
  numeric values possible).

  \code{sensitivity} - sensitivity parameter c; can take any value
  between 0 (no sensitivity at all) and +infinity (towards being
  sensitive to infinitely small differences). Note: Usually high
  sensitivity makes choices less probabilistic, thus sensitivity c is
  likely to be correlated with gamma.

  \code{weights} - dimensional attention weights. Order corresponds
  to the training and test item dimension rows.) Has to be a one
  dimensional vector of n-1 dimension weights, e.g. of length 2 when
  there are three features, leaving out the \emph{last} dimension. A
  constraint in the GCM is that all attentional weights sum to 1. Thus,
  the sum of n-1 weights should be equal to or smaller than 1, too.  The
  last n-th weight then is computed within the model with: 1 - (sum of
  n-1 feature weights). When setting the weights to 1/(n features) =
  equal weights. (Setting only the n-1 instead of all n feature weights
  eases model fitting procedures, in which the last weight always is a
  linear combination of the n-1 weights.)

  \code{choice_bias} - Category choice biases. Has to be a vector of n-1
  categories, leaving out the last category, under the constraint that
  all biases sum to 1. Vector order corresonds to the order of the [[n]]
  training_item lists. Here the sum of n-1 choice biases should be equal
  to or smaller than 1. Setting the weights to 1/(n categories) = no
  choice bias. The bias for the last category then is computed in the
  model with: 1 - (sum of n-1 category biases). (Again, setting only the
  n-1 category biases eases model fitting procedures, in which the last
  category bias always is a linear combination of the n-1 category
  biases, just in case.)

  \code{gamma} - decision constant.  Can take any value between 0
  (towards more probabilistic) and +infinity (towards deterministic
  choices). Nosofsky (2011) suggests setting gamma higher than 1 when
  individual participants' data are considered. Note that gamma might
  correlate with sensitivity c.

  \code{memory_items} - a list giving information about which exemplars
  in \code{training_items} receive a boost in memory strength from
  \code{mp}. Has to be a list with this structure:

  memory_items[[1]] - boosted category 1 exemplars
  
  memory_items[[2]] - boosted category 2 exemplars

  memory_items[[n]] - boosted category n exemplars

  Each [[n]] is a one-dimensional vector holding the column indices from
  the exemplars in the [[n]]-th \code{training_items} list which will
  get a memory boost.

  For example, \code{st$memory_items[[2]]<-c(1,4)} says that in category
  2 the items in columns 1 and 4 from the corresponding
  \code{training_items} matrix receive a memory boost.

  Memory strength for all items which do not appear in this vector will
  be set to 1, in this case, for all \code{training_items[[2]]}, except
  those from columns 1 and 4.

  In the case where \emph{memory_items} is not set (regardless which
  value is set on \emph{mp}), all memory parameters will be set to 1
  (all equal) automatically.

  \code{mp} - memory parameter. When set to 1, all items are treated as
  having the same memory strength (the same is done when mp is not set
  or NULL).

  When setting mp higher than 1 (can take any value) the pre-defined
  \codee{memory_items} receive a memory strength boost, corresponding to
  \code{mp}, e.g. when mp = 5 then the memory strength is assumed to be 5
  times higher for the items specified in \code{memory_items}.

  Setting mp smaller than 1 yields a memory loss, e.g. mp=.5 means half
  the memory strength compared to non-specified exemplars, mp=2 means
  twice the memory strength compared to non-sepcified exemplars.

  \code{mp} can either be defined by a single integer, thus, giving all
  specified items the same boost, or it can be defined in an
  item-specific way, giving different boosts to different items when
  using the following list structure:

  mp[[1]] - category 1 memory strengths
  
  mp[[2]] - category 2 memory strengths

  ...
  
  mp[[n]] - category n memory strengths

  each [[n]] list then has to be a vector with the same length as the
  corresponding to the \code{memory_items} vectors, and each position in
  the mp[[n]] vector refers to the item on the corresponding position in
  the st$memory_items vectors.

  A third option is, letting \code{mp} differ between categories, but
  not between the items within categories. In this case, use the same
  list structure as before, however, use only a single value for each
  mp[[n]] list entry, which will be the memory strength for all items
  that are specified in $memory_items in the corresponding category.

  \code{r_metric} - From Nosofsky (2011):
  
  r determines the form of the distance metric. In situations involving
  highly separable-dimension stimuli [...], the value r is typically set
  equal to 1, which yields a city-block distance metric . By contrast,
  in situations involving integral-dimension stimuli, the value r is set
  equal to 2, which yields a Euclidean distance metric.
  
  \code{p} - From Nosofsky (2011):

  The value p [...] determines the shape of the function relating
  similarity to distance. In most cases, p is set equal to one, which
  yields an exponential relation between similarity and psychological
  distance [...]. In situations involving highly confusable stimuli,
  however, p is sometimes set equal to 2, yielding a Gaussian relation
  between similarity and distance[...].

  NOTE: When \code{r_metric} and \code{p} are both set to .1, then the
  similarity function acts (nearly exactly) like a simple matching
  algorithm, i.e. as if the feature values from a current test item are
  simply identity-matched onto the features of the exemplar under
  consideration. This might become important, when there are
  qualitatively different feature values (i.e. with no 'real' distance
  scaling).

  For example, consider a current test item with 2 dimensions having the
  (numerically-coded) values 2 (\emph{sales}) and 3(\emph{english}),
  which is compared to an exemplar having the values 2 (\emph{sales})
  and 6 (\emph{latin}), representing the qualitative abilities of a
  job-applicant.  With r and p set to .1, the difference between 3
  (\emph{english}) and 6 (\emph{latin}) on the language-skill feature is
  simply treated as 1 (instead of a distance of 3), indicating that
  there is a simple mismatch, but no higher or lower distance on this
  qualitative dimension. On the other hand, the match on the
  job-experience feature (\emph{sales}) is treated as 0. In other words,
  with r and p set to .1, similarity is just a count function of how
  many features directly match / are identical.
}

\author{ Rene Schlegelmilch, Andy Wills }

\references{

  Nosofsky, R. M. (2011). The generalized context model: An exemplar
  model of classification. In Pothos, E.M. & Wills, A.J. \emph{Formal
  approaches in categorization}. Cambridge University Press.

}

\examples{

  ## Example 1

  ## Three Categories with 2 Training Items each, and 10 transfer/test
  ## items. Each item has three features with four values: memory
  ## strength is equal for all exemplars

  st<-list(
      sensitivity = 3,
      weights = c(.2,.3),
      choice_bias = c(1/3 , 1/4),
      gamma = 1,
      mp = 1,
      r_metric = 1,
      p = 1,
      nCats = 3
  )

  ## training item definitions 
  st$training_items <- list()

  ## category 1  -- mid values on average
  st$training_items[[1]] <- matrix(c(1,2,4,2,3,1), ncol=2, nrow=3)

  ## category 2  -- high values on average
  st$training_items[[2]]<-matrix(c(4,3,4,3,3,2), ncol=2, nrow=3)

  ## category 3  -- low values on average
  st$training_items[[3]]<-matrix(c(1,1,2,2,1,2), ncol=2, nrow=3) 

  ## last 4 items (colums) here are 4 new items, those before are
  ## old/trained
  st$test_items <- matrix(
      c(1, 2, 4, 2, 3, 1, 4, 3, 4, 3,
        3, 2, 1, 1, 2, 2, 1, 2, 1, 1,
        1, 2, 2, 2, 3, 3, 3, 4, 4, 4),
      ncol=10, nrow=3) 

  ## get the resulting predictions for the test items

  stsimGCMbk(st)

  ## columns of the output correspond to category numbers as defined
  ## above rows correspond to the column indices of the test_items

  ## Example 2

  ## Same (settings) as above, except: memory strength is 5 times higher
  ## for for some exemplars

  st$memory_items<-list()

  ## exemplar 1 in category 1 receives higher memory strength
  st$memory_items[[1]]<-c(1)

  ## exemplar 2 in category 3 receives higher memory strength
  st$memory_items[[3]]<-c(2)

  ## for the second category no exemplar receives higher memory
  ## strength, and thus can be ommitted

  ## memory strength is 5 times higher for each of the exemplars defined
  ## in $memory_items
  st$mp<-5 

  ## get predictions
  stsimGCMbk(st)

  ## Example 3 
  ## Same (settings) as above, except: memory strength is item specific,
  ## i.e. memory strength boost is not the same for different exemplars
  st$memory_items<-list()

  ## exemplars 1 in category 1 receive higher memory strength
  st$memory_items[[1]]<-c(1,2)

  ## exemplar 1 in category 2 receives higher memory strength
  st$memory_items[[2]]<-c(2)

  ## no boost in the third category, therefore omitted
  st$mp<-list()

  ## exemplar 1 and 2 in the first category (as defined above) receive a
  ## boost of 10 and 5 respectively (this setting should lead to near
  ## 100\% probability of putting the first item in the output into
  ## category 1, and to a memory-bias for towards putting items into
  ## category 1 depending on their similarity)
  st$mp[[1]]<-c(10,5)

  ## exemplar 2 in the second category (as defined above) receives a
  ## boost of 3 as $memory_items[[3]] is not defined, mp will be
  ## automatically set to 1 there, and can be omitted here
  st$mp[[2]]<-c(3)

  ## get predictions
  stsimGCMbk(st)
}  
