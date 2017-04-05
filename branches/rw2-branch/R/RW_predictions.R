# Generates ratings:
output <- slpRW(st, tr.test)
ratings <- act2probrat(output$out, theta, beta)
predictions <- cbind(tr.test, ratings)