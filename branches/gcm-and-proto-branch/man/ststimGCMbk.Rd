## Basic reference: Nosofsky, R. M. (2011). The generalized context
   model: An exemplar model of classification. Formal approaches in
   categorization, 18-39.

##Output:

## The model predicts category choice probabilities for the
## st$test_items given the predefined exemplars in memory as defined
## in st$training_items, and the model parameter settings.  The model
## output will be the list with settings as well as an $out prediction
## matrix with nrow= test items (in the same order of the columns in
## $test_items), and ncol categories in the order of exemplar
## categories as defined by the $training_items[[n]] lists .

## List description:

st$nCats # integer indicating the number of categories

### the st list, so far (everything is required, if not stated
### otherwise):

st$training_items

## the exemplars. Has to be a list with the following structure:
## $training_items[[1]] ~category 1 exemplars,
## $training_items[[2]] ~category 2 exemplars
## ... $training_items[[n]] ~category n exemplars.

## Each [[n]] is a matrix with one column for each item, and one row
## for each feature dimension. Each cell carries the value of an
## exemplar on the given feature dimension (all numeric values
## possible).

## The order of feature dimensions corresponds to the order of
## attentional weights which are defined in st$weights.

## e.g. row 1 in [[n]] corresponds to the first feature
## dimension. Example below.


st$test_items

## is a matrix with one column for each test/transfer item, and one
## row for each feature dimension. The order of feature dimensions is
## the same as in the training_items (rows).

## Each cell carries the value of a test/transfer item on the given
## feature dimension (all numeric values possible).

st$sensitivity

## sensitivity parameter c; can take any value between 0 (no
## sensitivity at all) and +infinity (towards being sensitive to
## infinitely small differences)

## Note: Usually high sensitivity makes choices less probabilistic,
## thus sensitivity c is likely to be correlated with gamma.

st$weights

## attentional feature weights. (Order corresponds to the training and
## test item feature rows.) Has to be a one dimensional vector of n-1
## feature weights,

## e.g. of length 2 when there are three features, leaving out the
## -last- dimension.

## A constraint in the GCM is that all attentional weights sum to
## 1. Thus, the sum of n-1 weights should be equal to or smaller than
## 1, too.

## The last n-th weight then is computed within the model with: 1 -
## (sum of n-1 feature weights). When setting the weights to 1/(n
## features) = equal weights.

## (Setting only the n-1 instead of all n feature weights eases model
## fitting procedures, in which the last weight always is a linear
## combination of the n-1 weights, just in case.)

st$choice_bias

## Category choice biases. Has to be a vector of n-1 categories,
## leaving out the last category, under the constraint that all biases
## sum to 1.

## Vector order corresonds to the [[n]] $training_item lists.

## Here the sum of n-1 choice biases should be equal to or smaller
## than 1. Setting the weights to 1/(n categories) = no choice
## bias. The bias for the last category then is computed in the model
## with: 1 - (sum of n-1 category biases).

## (Again, setting only the n-1 category biases eases model fitting
## procedures, in which the last category bias always is a linear
## combination of the n-1 category biases, just in case.)

st$gamma

## deterministic boost. Can take any value between 0 (towards more
## probabilistic) and +infinity (towards deterministic choices). 1 =
## no adjustment
.
## Nosofsky (2011) suggests using gamma (setting different from 1)
## when individual participants' data are considered. However, please
## note that gamma might correlate with sensitivity c.

st$memory_items

## a list giving information about which exemplars in $training_items
## receive a boost in memory strength from $mp.

## Has to be a list with this structure:

## memory_items[[1]]~boosted category 1 exemplars,
## memory_items[[2]]~boosted category 2 exemplars,...
## memory_items[[n]]~boosted category n exemplars.

## Each [[n]] is a one-dimensional vector holding the column indices
## from the exemplars in the [[n]]-th $training_items list which will
## get a memory boost.

## E.g. st$memory_items[[2]]<-c(1,4) says that in category 2 the items
## in columns 1 and 4 from the corresponding $training_items
## matrix[[2]] receive a memory boost.

## Memory strength for all items which do not appear in this vector
## will be set to 1, in this case, for all $training_items[[2]],
## except those from columns 1 and 4.

## In case $memory_items is not set (regardless which value is set on
## $mp, then all memory parameters will be set to 1 (all equal)
## automatically.

st$mp

## Memory parameter. When set to 1, all items are treated as having
## the same memory strength (the same is done when mp is not set or
## NULL).

## When setting mp higher than 1 (can take any value) the pre-defined
## $memory_items receive a memory strength boost,

## corresponding to $mp, e.g. when mp=5 then the memory strength is
## assumed to be 5 times higher for the items specified in
## $memory_items. Setting mp smaller than 1 yields a memory loss,

## e.g. mp=.5 means half the memory strength compared to non-specified
## exemplars, mp=2 means twice the memory strength compared to
## non-sepcified exemplars.

## $mp can either be defined by a single integer, thus, giving all
## specified items the same boost, or it can be defined in an
## item-specific way, giving different boosts to different items
## when using the following list structure:

## $mp[[1]]~category 1 memory strengths,
## $mp[[2]]~category 2 memory strengths, ...
## $mp[[n]]~category n memory strengths,

## each [[n]] list then has to be a vector with the same length as the
## corresponding to the st$memory_items vectors,

## and each position in the mp[[n]] vector refers to the item on the
## corresponding position in the st$memory_items vectors.

## A third option is, letting mp differ between categories, but not
## between the items within categories. In this case, use the same
## list structure as before, however,

## use only a single value for each mp[[n]] list entry, which will be
## the memory strength for all items that are specified in
## $memory_items in the corresponding category.

## Example below.

st$r_metric

## From Nosofsky (2011) "r determines the form of the distance
## metric. In situations involving highly separable-dimension stimuli
## [...],

## the value r is typically set equal to 1, which yields a city-block
## distance metric . By contrast, in situations involving
## integral-dimension stimuli,

## the value r is set equal to 2, which yields a Euclidean distance
## metric."

st$p

## From Nosofsky (2011) "The value p [...] determines the shape of the
## function relating similarity to distance. In most cases, p is set
## equal to one, which

## yields an exponential relation between similarity and psychological
## distance [...]. In situations involving highly confusable stimuli,

## however, p is sometimes set equal to 2, yielding a Gaussian
## relation between similarity and distance[...]."

## Important note: when st$r_metric and st$p are both set to .1, then
## the similarity function acts (nearly exactly) like a simple
## matching algorithm, i.e. as if the

## feature values from a current test item are simply identity-matched
## onto the features of the exemplar under consideration. This might
## become important, when there are

## qualitatively different feature values (i.e. with no 'real'
## distance scaling). For example, consider a current test item with 2
## dimensions having the (numerically-coded)

## values 2 ("sales") and 3("english"), which is compared to an
## exemplar having the values 2 ("sales") and 6 ("latin"),
## representing the qualitative abilities of a job-applicant.

## With r and p set to .1, the difference between 3 ("english") and 6
## ("latin") on the language-skill feature is simply treated as "1"
## (instead of a distance of 3),

## indicating that there is a simple "mismatch", but no higher or
## lower distance on this qualitative dimension. On the other hand,

## the "match" on the job-experience feature ("sales") is treated as
## 0. In other words, with r and p set to .1, similarity is just a
## count-function of how much features

## directly match / are identical, for which, however, there still can
## be differences in sensitivity etc.

