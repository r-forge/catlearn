### Draft Code GCM as stateful list processor 
## Author: René Schlegelmilch (r.schlegelmilch@psychologie.uzh.ch)

## Basic reference: Nosofsky, R. M. (2011). The generalized context model: An exemplar model of classification. Formal approaches in categorization, 18-39.

#Output:
# The model predicts category choice probabilities for the st$test_items given the predefined exemplars in memory as defined in st$training_items, and the model parameter settings.
# The model output will be the list with settings as well as an $out prediction matrix with nrow= test items (in the same order of the columns in $test_items), 
# and ncol categories in the order of exemplar categories as defined by the $training_items[[n]] lists .

# List description:
##############################################
st$nCats # integer indicating the number of categories

### the st list, so far (everything is required, if not stated otherwise):
st$training_items  ## the exemplars. Has to be a list with the following structure: $training_items[[1]] ~category 1 exemplars, $training_items[[2]] ~category 2 exemplars ... $training_items[[n]] ~category n exemplars.
# Each [[n]] is a matrix with one column for each item, and one row for each feature dimension. Each cell carries the value of an exemplar on the given feature dimension (all numeric values possible). 
# The order of feature dimensions corresponds to the order of attentional weights which are defined in st$weights.
# e.g. row 1 in [[n]] corresponds to the first feature dimension. Example below.

st$test_items # is a matrix with one column for each test/transfer item, and one row for each feature dimension. The order of feature dimensions is the same as in the training_items (rows).
#Each cell carries the value of a test/transfer item on the given feature dimension (all numeric values possible).

st$sensitivity  # sensitivity parameter c; can take any value between 0 (no sensitivity at all) and +infinity (towards being sensitive to infinitely small differences) 
#Note: Usually high sensitivity makes choices less probabilistic, thus sensitivity c is likely to be correlated with gamma.

st$weights # attentional feature weights. (Order corresponds to the training and test item feature rows.) Has to be a one dimensional vector of n-1 feature weights, 
# e.g. of length 2 when there are three features, leaving out the -last- dimension.
# A constraint in the GCM is that all attentional weights sum to 1. Thus, the sum of n-1 weights should be equal to or smaller than 1, too. 
# The last n-th weight then is computed within the model with: 1 - (sum of n-1 feature weights). When setting the weights to 1/(n features) = equal weights. 
# (Setting only the n-1 instead of all n feature weights eases model fitting procedures, in which the last weight always is a linear combination of the n-1 weights, just in case.)

st$choice_bias  ## Category choice biases. Has to be a vector of n-1 categories, leaving out the last category, under the constraint that all biases sum to 1. 
# Vector order corresonds to the [[n]] $training_item lists.
# Here the sum of n-1 choice biases should be equal to or smaller than 1. Setting the weights to 1/(n categories) = no choice bias. The bias for the last category then is computed in the model with: 1 - (sum of n-1 category biases).
# (Again, setting only the n-1 category biases eases model fitting procedures, in which the last category bias always is a linear combination of the n-1 category biases, just in case.)

st$gamma # deterministic boost. Can take any value between 0 (towards more probabilistic) and +infinity (towards deterministic choices). 1 = no adjustment.
# Nosofsky (2011) suggests using gamma (setting different from 1) when individual participants' data are considered. However, please note that gamma might correlate with sensitivity c.

st$memory_items # a list giving information about which exemplars in $training_items receive a boost in memory strength from $mp. 
#Has to be a list with this structure: memory_items[[1]]~boosted category 1 exemplars, memory_items[[2]]~boosted category 2 exemplars,... memory_items[[n]]~boosted category n exemplars.
# Each [[n]] is a one-dimensional vector holding the column indices from the exemplars in the [[n]]-th $training_items list which will get a memory boost. 
# E.g. st$memory_items[[2]]<-c(1,4) says that in category 2 the items in columns 1 and 4 from the corresponding $training_items matrix[[2]] receive a memory boost.
# Memory strength for all items which do not appear in this vector will be set to 1, in this case, for all $training_items[[2]], except those from columns 1 and 4.
# In case $memory_items is not set (regardless which value is set on $mp, then all memory parameters will be set to 1 (all equal) automatically.

st$mp # Memory parameter. When set to 1, all items are treated as having the same memory strength (the same is done when mp is not set or NULL). 
# When setting mp higher than 1 (can take any value) the pre-defined $memory_items receive a memory strength boost,
# corresponding to $mp, e.g. when mp=5 then the memory strength is assumed to be 5 times higher for the items specified in $memory_items. Setting mp smaller than 1 yields a memory loss, 
# e.g. mp=.5 means half the memory strength compared to non-specified exemplars, mp=2 means twice the memory strength compared to non-sepcified exemplars.
# $mp can either be defined by a single integer, thus, giving all specified items the same boost, or it can be defined in an item-specific way, giving different boosts to different items
# when using the following list structure: 
# $mp[[1]]~category 1 memory strengths, $mp[[2]]~category 2 memory strengths, ... $mp[[n]]~category n memory strengths,
# each [[n]] list then has to be a vector with the same length as the corresponding to the st$memory_items vectors, 
# and each position in the mp[[n]] vector refers to the item on the corresponding position in the st$memory_items vectors.
# A third option is, letting mp differ between categories, but not between the items within categories. In this case, use the same list structure as before, however,
# use only a single value for each mp[[n]] list entry, which will be the memory strength for all items that are specified in $memory_items in the corresponding category.
# Example below.



st$r_metric # From Nosofsky (2011) "r determines the form of the distance metric. In situations involving highly separable-dimension stimuli [...], 
# the value r is typically set equal to 1, which yields a city-block distance metric . By contrast, in situations involving integral-dimension stimuli, 
#the value r is set equal to 2, which yields a Euclidean distance metric."

st$p  # From Nosofsky (2011) "The value p [...] determines the shape of the function relating similarity to distance. In most cases, p is set equal to one, which
#yields an exponential relation between similarity and psychological distance [...]. In situations involving highly confusable stimuli,
# however, p is sometimes set equal to 2, yielding a Gaussian relation between similarity and distance[...]."
# Important note: when st$r_metric and st$p are both set to .1, then the similarity function acts (nearly exactly) like a simple matching algorithm, i.e. as if the 
# feature values from a current test item are simply identity-matched onto the features of the exemplar under consideration. This might become important, when there are 
# qualitatively different feature values (i.e. with no 'real' distance scaling). For example, consider a current test item with 2 dimensions having the (numerically-coded) 
# values  2 ("sales") and 3("english"), which is compared to an exemplar having the values 2 ("sales") and 6 ("latin"), representing the qualitative abilities of a job-applicant. 
# With r and p set to .1, the difference between 3 ("english") and 6 ("latin") on the language-skill feature is simply treated as "1" (instead of a distance of 3),
# indicating that there is a simple "mismatch", but no higher or lower distance on this qualitative dimension. On the other hand,
# the "match" on the job-experience feature ("sales") is treated as 0. In other words, with r and p set to .1, similarity is just a count-function of how much features 
# directly match / are identical, for which, however, there still can be differences in sensitivity etc.




###### GCM Model Codes
#####################################################################################################################################################################

###################################### Main Function
slpGCM_draft<-function(st) {
  # re-defines weights vector (adds weight for the last feature dimension)
  st$weights<-as.numeric(c(st$weights, 1-sum(st$weights)))
  # re-defines choice bias vector (adds choice bias for the last category)
  st$choice_bias<-as.numeric(c(st$choice_bias, 1-sum(st$choice_bias)))
  # using the given settings for constructing a memory strength matrix, the model can handle easily:
  st$is_memory_pars<-list() 
  for (cat in 1:st$nCats) st$is_memory_pars[[cat]]<-c(rep(1,ncol(st$training_items[[cat]])))  ## start with all equall memory strengths, then modify...
  if (is.atomic(st$mp)) for (cat in 1:st$nCats)  try(st$is_memory_pars[[cat]][st$memory_items[[cat]]]<-st$mp, silent=TRUE)  ## equal memory boost for all
  if (!is.atomic(st$mp)) for (cat in 1:st$nCats) try(st$is_memory_pars[[cat]][st$memory_items[[cat]]]<-st$mp[[cat]], silent=TRUE) ## item specific memory boost
  
  get_p<-gcm.predictions_draft(sensitivity=st$sensitivity, 
                         weights= st$weights, 
                         choice_bias=st$choice_bias, 
                         gamma=st$gamma, 
                         is_memory_pars=st$is_memory_pars, 
                         r_metric=st$r_metric, 
                         training_items=st$training_items, 
                         test_items=st$test_items,
                         p_shape=st$p,
                         nCats=st$nCats)
  output<-st
  output$out<-get_p
  return(output)
}

###################################### Sub Functions

### Prediction Function, as equation 1 in Nosofsk (2011) 
# calls for similarity comparisons between test items and exemplars (gcm.similarity), 
# and then calculates overall summed similarity,
# returns category choice probabilites.

gcm.predictions_draft <- function(sensitivity, weights, choice_bias, gamma, is_memory_pars, r_metric, p_shape, training_items, test_items, nCats){
  nTest <- ncol(test_items) # number of test items
  predProbs <- matrix(0, ncol=nCats, nrow = nTest) # matrix for test item predictions (ncol=number of categories, nrow = number of test items in order of appearence)
  for (currentItem in 1:nTest){
    summed_similarity <- rep(0,nCats)  # vector holding predicted category response probabilities for the current test item
    for (cat in 1:nCats){
      summed_similarity[cat] <- (sum(is_memory_pars[[cat]]*(apply(training_items[[cat]],2,
                                                                  FUN = function(x) gcm.similarity_draft(c=sensitivity,wt=weights, r=r_metric, p=p_shape,
                                                                                                   x,test_items[,currentItem])))))
    }
    summed_similarity<-summed_similarity^gamma  # gamma response determinism
    summed_similarity<-summed_similarity*choice_bias # choice biases
    predProbs[currentItem,] <- summed_similarity/sum(summed_similarity) # summed simularites for the current item and each category
  }
  return(predProbs)
}



### Similarity Calculation # as equation 2 and 3 in Nosofsky (2011)

gcm.similarity_draft <- function(c, wt, r, p, training_item, test_item){
  class(training_item)<-"numeric"
  class(test_item)<-"numeric"
  tmp<- sqrt((training_item-test_item)^2) # absolute distance between feature values  //equation 2
  distance<- (sum(wt*tmp^r))^(1/r)  # feature weighted and r-scaled overall distance  //equation 2
  similarity<-exp(-c*distance^p) # Sensitivity and p scaled exponential similarity // equation 3
  return(similarity)
}

###################################### FIN.




################# Examples:
## Example 1: Three Categories with 2 Training Items each, and 10 transfer/test items. Each item has three features with four values:
## memory strength is equal for all exemplars
st<-list(sensitivity=3, weights=c(.2,.3),choice_bias=c(1/3,1/4), gamma=1, mp=1, r_metric=1, p=1,
         nCats=3 )
#training item definitions 
st$training_items<-list()
st$training_items[[1]]<-matrix(c(1,2,4,2,3,1), ncol=2, nrow=3) # category 1  -- mid values on average
st$training_items[[2]]<-matrix(c(4,3,4,3,3,2), ncol=2, nrow=3) # category 2  -- high values on average
st$training_items[[3]]<-matrix(c(1,1,2,2,1,2), ncol=2, nrow=3) # category 3  -- low values on average

st$test_items<-matrix(c(1,2,4,2,3,1,4,3,4,3,3,2,1,1,2,2,1,2,1,1,1,2,2,2,3,3,3,4,4,4), ncol=10, nrow=3) # last 4 items (colums) here are 4 new items, those before are old/trained

# get the resulting predictions for the test items
slpGCM_draft(st)
## columns of the output correspond to category numbers as defined above
## rows correspond to the column indices of the test_items

################# 
## Example 2: same (settings) as above, except:
## memory strength is 5 times higher for for some exemplars

st$memory_items<-list()
st$memory_items[[1]]<-c(1) ## exemplar 1 in category 1 receives higher memory strength
st$memory_items[[3]]<-c(2) ## exemplar 2 in category 3 receives higher memory strength
## for the second category no exemplar receives higher memory strength, and thus can be ommitted

st$mp<-5 ## memory strength is 5 times higher for each of the exemplars defined in $memory_items

# get predictions
slpGCM_draft(st)

################# 
## Example 3: same (settings) as above, except:
## memory strength is item specific, i.e. memory strength boost is not the same for different exemplars
st$memory_items<-list()
st$memory_items[[1]]<-c(1,2) ## exemplars 1 in category 1 receive higher memory strength
st$memory_items[[2]]<-c(2) ## exemplar 1 in category 2 receives higher memory strength
# no boost in the third category, therefore omitted

st$mp<-list()
st$mp[[1]]<-c(10,5) ## exemplar 1 and 2 in the first category (as defined above) receive a boost of 10 and 5 respectively 
#(this setting should lead to near 100 % probability of putting the first item in the output into category 1, 
# and to a memory-bias for towards putting items into category 1 depending on their similarity)
st$mp[[2]]<-c(3) ## exemplar 2 in the second category (as defined above) receives a boost of 3 
# as $memory_items[[3]] is not defined, mp will be automatically set to 1 there, and can be omitted here 

# get predictions
slpGCM_draft(st)



