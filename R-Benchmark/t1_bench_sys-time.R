#!/usr/bin/env Rscript


do_lm = function(value){
   X <- matrix(rnorm(value), 100, 10)
   y <- X %*% sample(1:10, 10) + rnorm(100)
   b <- lm(y ~ X + 0)$coef
}

start_time <- Sys.time()
do_lm(1000)
end_time <- Sys.time()

print(end_time - start_time)




