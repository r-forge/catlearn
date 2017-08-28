# import the six problems from the python code at https://github.com/NYUCCL/sustain_python.git
# that code was written by Todd Gurecki
# the trials are randomised into 32 blocks for each problem
# stimuli are presented in a padded format for slpSUSTAIN

cond.1 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 0, 0, 0, 1, 1, 1, 1), 8, 4)
tr.nosofsky.shj1 <- NULL
for (i in 1:4) {
tr.nosofsky.shj1 <- cbind(tr.nosofsky.shj1, cond.1[, i], 1 - cond.1[, i])
}
tr.nosofsky.shj1 <- matrix(rep(t(tr.nosofsky.shj1), 32), ncol = 8, byrow = TRUE)
tr.nosofsky.shj1 <- cbind(rep(0, nrow(tr.nosofsky.shj1)), tr.nosofsky.shj1[sample(nrow(tr.nosofsky.shj1)), ], rep(1, nrow(tr.nosofsky.shj1)))
colnames(tr.nosofsky.shj1) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")

cond.2 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 0, 1, 1, 1, 1, 0, 0), 8, 4)
tr.nosofsky.shj2 <- NULL
for (i in 1:ncol(cond.2)) {
  tr.nosofsky.shj2 <- cbind(tr.nosofsky.shj2, cond.2[,i], 1 - cond.2[,i])
}
tr.nosofsky.shj2 <- matrix(rep(t(tr.nosofsky.shj2), 32), ncol = 8, byrow = TRUE)
tr.nosofsky.shj2 <- cbind(rep(0, nrow(tr.nosofsky.shj2)), tr.nosofsky.shj2[sample(nrow(tr.nosofsky.shj2)), ], rep(1, nrow(tr.nosofsky.shj2)))
colnames(tr.nosofsky.shj2) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")


cond.3 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 0, 0, 1, 1, 0, 1, 1), 8, 4)
tr.nosofsky.shj3 <- NULL
for (i in 1:ncol(cond.3)) {
  tr.nosofsky.shj3 <- cbind(tr.nosofsky.shj3, cond.3[,i], 1 - cond.3[,i])
}
tr.nosofsky.shj3 <- matrix(rep(t(tr.nosofsky.shj3), 32), ncol = 8, byrow = TRUE)
tr.nosofsky.shj3 <- cbind(rep(0, nrow(tr.nosofsky.shj3)), tr.nosofsky.shj3[sample(nrow(tr.nosofsky.shj3)), ], rep(1, nrow(tr.nosofsky.shj3)))
colnames(tr.nosofsky.shj3) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")

cond.4 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 0, 0, 1, 0, 1, 1, 1), 8, 4)
tr.nosofsky.shj4 <- NULL
for (i in 1:ncol(cond.4)) {
  tr.nosofsky.shj4 <- cbind(tr.nosofsky.shj4, cond.4[,i], 1 - cond.4[,i])
}
tr.nosofsky.shj4 <- matrix(rep(t(tr.nosofsky.shj4), 32), ncol = 8, byrow = TRUE)
tr.nosofsky.shj4 <- cbind(rep(0, nrow(tr.nosofsky.shj4)), tr.nosofsky.shj4[sample(nrow(tr.nosofsky.shj4)), ], rep(1, nrow(tr.nosofsky.shj4)))
colnames(tr.nosofsky.shj4) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")

cond.5 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 0, 0, 1, 1, 1, 1, 0), 8, 4)
tr.nosofsky.shj5 <- NULL
for (i in 1:ncol(cond.5)) {
  tr.nosofsky.shj5 <- cbind(tr.nosofsky.shj5, cond.5[,i], 1 - cond.5[,i])
}
tr.nosofsky.shj5 <- matrix(rep(t(tr.nosofsky.shj5), 32), ncol = 8, byrow = TRUE)
tr.nosofsky.shj5 <- cbind(rep(0, nrow(tr.nosofsky.shj5)), tr.nosofsky.shj5[sample(nrow(tr.nosofsky.shj5)), ], rep(1, nrow(tr.nosofsky.shj5)))
colnames(tr.nosofsky.shj5) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")

cond.6 <- matrix(c(0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1,
0, 1, 0, 1, 0, 1, 0, 1,
0, 1, 1, 0, 1, 0, 0, 1), 8, 4)
tr.nosofsky.shj6 <- NULL
for (i in 1:ncol(cond.6)) {
  tr.nosofsky.shj6 <- cbind(tr.nosofsky.shj6, cond.6[,i], 1 - cond.6[,i])
}
tr.nosofsky.shj6 <- matrix(rep(t(tr.nosofsky.shj6), 32), ncol = 8, byrow = TRUE)
tr.nosofsky.shj6 <- cbind(rep(0, nrow(tr.nosofsky.shj6)), tr.nosofsky.shj6[sample(nrow(tr.nosofsky.shj6)), ], rep(1, nrow(tr.nosofsky.shj6)))
colnames(tr.nosofsky.shj6) <- c("ctrl", "x1", "x2", "y1", "y2", "z1", "z2", "c1", "c2", "t")

rm(cond.1, cond.2, cond.3, cond.4, cond.5, cond.6)
