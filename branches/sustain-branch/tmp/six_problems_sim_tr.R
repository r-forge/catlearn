# import the six problems from the python code at https://github.com/NYUCCL/sustain_python.git
# that code was written by Todd Gurecki
# the trials are randomised into 32 blocks for each problem
# stimuli are presented in a padded format for slpSUSTAIN

cond.1 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 0, 0, 0, 1, 1, 1, 1), 8, 4)
tr.1 <- NULL
for (i in 1:4) {
tr.1 <- cbind(tr.1, cond.1[, i], 1 - cond.1[, i])
}
tr.1 <- matrix(rep(t(tr.1), 32), ncol = 8, byrow = TRUE)
tr.1 <- cbind(rep(0, nrow(tr.1)), tr.1[sample(nrow(tr.1)), ], rep(1, nrow(tr.1)))
colnames(tr.1) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")

cond.2 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 0, 1, 1, 1, 1, 0, 0), 8, 4)
tr.2 <- NULL
for (i in 1:ncol(cond.2)) {
  tr.2 <- cbind(tr.2, cond.2[,i], 1 - cond.2[,i])
}
tr.2 <- matrix(rep(t(tr.2), 32), ncol = 8, byrow = TRUE)
tr.2 <- cbind(rep(0, nrow(tr.2)), tr.2[sample(nrow(tr.2)), ], rep(1, nrow(tr.2)))
colnames(tr.2) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")


cond.3 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 0, 0, 1, 1, 0, 1, 1), 8, 4)
tr.3 <- NULL
for (i in 1:ncol(cond.3)) {
  tr.3 <- cbind(tr.3, cond.3[,i], 1 - cond.3[,i])
}
tr.3 <- matrix(rep(t(tr.3), 32), ncol = 8, byrow = TRUE)
tr.3 <- cbind(rep(0, nrow(tr.3)), tr.3[sample(nrow(tr.3)), ], rep(1, nrow(tr.3)))
colnames(tr.3) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")

cond.4 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 0, 0, 1, 0, 1, 1, 1), 8, 4)
tr.4 <- NULL
for (i in 1:ncol(cond.4)) {
  tr.4 <- cbind(tr.4, cond.4[,i], 1 - cond.4[,i])
}
tr.4 <- matrix(rep(t(tr.4), 32), ncol = 8, byrow = TRUE)
tr.4 <- cbind(rep(0, nrow(tr.4)), tr.4[sample(nrow(tr.4)), ], rep(1, nrow(tr.4)))
colnames(tr.4) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")

cond.5 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 0, 0, 1, 1, 1, 1, 0), 8, 4)
tr.5 <- NULL
for (i in 1:ncol(cond.5)) {
  tr.5 <- cbind(tr.5, cond.5[,i], 1 - cond.5[,i])
}
tr.5 <- matrix(rep(t(tr.5), 32), ncol = 8, byrow = TRUE)
tr.5 <- cbind(rep(0, nrow(tr.5)), tr.5[sample(nrow(tr.5)), ], rep(1, nrow(tr.5)))
colnames(tr.5) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")

cond.6 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 1, 1, 0, 1, 0, 0, 1), 8, 4)
tr.6 <- NULL
for (i in 1:ncol(cond.6)) {
  tr.6 <- cbind(tr.6, cond.6[,i], 1 - cond.6[,i])
}
tr.6 <- matrix(rep(t(tr.6), 32), ncol = 8, byrow = TRUE)
tr.6 <- cbind(rep(0, nrow(tr.6)), tr.6[sample(nrow(tr.6)), ], rep(1, nrow(tr.6)))
colnames(tr.6) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")

rm(cond.1, cond.2, cond.3, cond.4, cond.5, cond.6)
