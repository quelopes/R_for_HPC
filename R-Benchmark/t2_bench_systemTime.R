#!/usr/bin/env Rscript

do_lm = function(value){
   X <- matrix(rnorm(value), 100, 10)
   y <- X %*% sample(1:10, 10) + rnorm(100)
   b <- lm(y ~ X + 0)$coef
}


system.time({do_lm(1000)})





