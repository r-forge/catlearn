spiering.ashby.1 <- matrix(c(0.01,56.09, 1, 0,
                             0.033,67.07, 1, 0,
                             0.056,78.04, 1, 0,
                             0.079,89.02, 1, 0,
                             0.102,100, 1, 0,
                             0.125,110.98, 1, 0,
                             0.026,48.41, 1, 0,
                             0.049,59.39, 1, 0,
                             0.072,70.36, 1, 0,
                             0.095,81.34, 1, 0,
                             0.118,92.31, 1, 0,
                             0.141,103.28, 1, 0,
                             0.042,40.73, 1, 0,
                             0.065,51.7, 1, 0,
                             0.088,62.68, 1, 0,
                             0.111,73.65, 1, 0,
                             0.135,84.63, 1, 0,
                             0.158,95.61, 1, 0), ncol = 4, byrow = TRUE)

spiering.ashby.2 <- matrix(c(0.074, 25.36, 0, 1,
                             0.098, 36.34, 0, 1,
                             0.121, 47.31, 0, 1,
                             0.144, 58.29, 0, 1,
                             0.167, 69.26, 0, 1,
                             0.19, 80.23, 0, 1,
                             0.091, 17.68, 0, 1,
                             0.114, 28.65, 0, 1,
                             0.137, 39.63, 0, 1,
                             0.16, 50.61, 0, 1,
                             0.183, 61.58, 0, 1,
                             0.206, 72.55, 0, 1,
                             0.107, 10, 0, 1,
                             0.13, 20.97, 0, 1,
                             0.153, 31.95, 0, 1,
                             0.176, 42.92, 0, 1,
                             0.2, 53.9, 0, 1,
                             0.223, 64.88, 0, 1), ncol = 4, byrow = TRUE)

spiering.ashby <- rbind(spiering.ashby.1,
                        spiering.ashby.2)

#spiering.ashby[, 2] <- spiering.ashby[, 2]/1000
#spiering.ashby[, 2] <- spiering.ashby[, 2]/max(spiering.ashby[, 2])

diff <- rep(1:3, 6)[order(rep(1:3, 6))]

tr <- cbind(rep(0, nrow(spiering.ashby)), rep(t(diff), 2),
            spiering.ashby, rep(1, nrow(spiering.ashby)))

tr <- matrix(rep(t(tr), 16), ncol = 7, byrow = TRUE)
tr <- tr[sample(nrow(tr)), ]
colnames(tr) <- c("ctrl", "difficulty", "x", "y", "c1", "c2", "t")

tr[1, 1] <- 1
