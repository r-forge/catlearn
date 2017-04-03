# Need to create test data so that the model gives us predictions.

# Creating a matrix of stimuli we want to generate model predictions for:
  test <- matrix(c(1, 0, 0, 0, 0, 0,
                   0, 1, 0, 0, 0, 0,
                   0, 0, 1, 0, 0, 0,
                   0, 0, 0, 1, 0, 0,
                   0, 0, 0, 0, 1, 0,
                   1, 1, 0, 0, 0, 0,
                   1, 0, 1, 0, 0, 0,
                   1, 0, 0, 1, 0, 0,
                   1, 0, 0, 0, 1, 0,
                   0, 1, 1, 0, 0, 0,
                   0, 1, 0, 1, 0, 0,
                   0, 1, 0, 0, 1, 0,
                   0, 0, 1, 1, 0, 0,
                   0, 0, 1, 0, 1, 0,
                   0, 0, 0, 1, 1, 0),
                 nrow = 15, ncol = 6, byrow = TRUE,
                 dimnames = list(c("A", "B", "C", "X", "Y", "AB", 
                                   "AC", "AX", "AY", "BC", "BX", "BY", 
                                   "CX", "CY", "XY"),
                                 c("A", "B", "C", "X", "Y", "t")))
  
  # As before we need the control column:
  ctrl <- matrix(rep(2, 15), 
                  nrow = 15, ncol = 1, byrow = TRUE,
                  dimnames = list(c(),
                                  c("ctrl")))
  
  # A column detailing trial number is needed:
  trial <- matrix(c(1:15), 
                  nrow = 15, ncol = 1, byrow = TRUE,
                  dimnames = list(c(),
                                  c("trial")))
  
  # Let's combine all of this together:
  test <- cbind(ctrl, trial, test)
  
# For the purpose of environmental hygiene, let's remove all the
# stuff we no longer need:
rm(ctrl, trial)

# This splices the labelled test stimuli after each participant (unlike reading
# this from processed data, it is in alphabetical order and there is only one
# of each stimuli - rows are also labelled for identification)
tr.test <- rbind(tr[1:32, 1:8],test,tr[33:64, 1:8],test,tr[65:96, 1:8],test,
                 tr[97:128, 1:8],test,tr[129:160, 1:8],test,tr[161:192, 1:8],test,
                 tr[193:224, 1:8],test,tr[225:256, 1:8],test,tr[257:288, 1:8],test,
                 tr[289:320, 1:8],test,tr[321:352, 1:8],test,tr[353:384, 1:8],test,
                 tr[385:416, 1:8],test,tr[417:448, 1:8],test,tr[449:480, 1:8],test,
                 tr[481:512, 1:8],test,tr[513:544, 1:8],test,tr[545:576, 1:8],test,
                 tr[577:608, 1:8],test,tr[609:640, 1:8],test,tr[641:672, 1:8],test,
                 tr[673:704, 1:8],test,tr[705:736, 1:8],test,tr[737:768, 1:8],test,
                 tr[769:800, 1:8],test,tr[801:832, 1:8],test,tr[833:864, 1:8],test,
                 tr[865:896, 1:8],test,tr[897:928, 1:8],test,tr[929:960, 1:8],test,
                 tr[961:992, 1:8],test,tr[993:1024, 1:8],test,tr[1025:1056, 1:8],test,
                 tr[1057:1088, 1:8],test,tr[1089:1120, 1:8],test,tr[1121:1152, 1:8],test,
                 tr[1153:1184, 1:8],test,tr[1185:1216, 1:8],test,tr[1217:1248, 1:8],test,
                 tr[1249:1280, 1:8],test)