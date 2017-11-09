# Unit test for act2probrat

test.act2probrat <- function() {
    out <- act2probrat(c(0.91,0.54,0.11),3.1,0.24)
    corr <- c(0.8886475, 0.7170753, 0.4005918)
    sum((out-corr)^2) < 1e-14  # Return TRUE or FALSE
}
