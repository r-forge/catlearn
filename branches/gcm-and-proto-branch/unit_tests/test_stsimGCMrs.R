## Unit tests for slpGCMbk

## These are for development purposes only and will not appear in the
## published package.

## Load development code
source("../R/stsimGCMrs.R")

## Load stored outputs known (believed?) to be correct
load("test_stsimGCMrs.RData")

## slpGCMbk unit test 1

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

## columns of the output correspond to category numbers as defined
## above rows correspond to the column indices of the test_items

t1 <- stsimGCMrs(st)
if(sum(t1 == ut1) == 30) print("Test 1 passed.")

## Unit test 2

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
t2 <- stsimGCMrs(st)
if(sum(t2 == ut2) == 30) print("Test 2 passed.")

## Unit test 3 
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
## 100 % probability of putting the first item in the output into
## category 1, and to a memory-bias for towards putting items into
## category 1 depending on their similarity)
st$mp[[1]]<-c(10,5)


## exemplar 2 in the second category (as defined above) receives a
## boost of 3 as $memory_items[[3]] is not defined, mp will be
## automatically set to 1 there, and can be omitted here
st$mp[[2]]<-c(3)


## get predictions
t3 <- stsimGCMrs(st)
if(sum(t3 == ut3) == 30) print("Test 3 passed.")


