list.of.packages = c("ggplot2","devtools","doParallel","doSNOW","foreach","snow","mlbench","caret","glmnet",
"klaR","gbm")

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(devtools)
devtools::install_github("eddelbuettel/rbenchmark")
devtools::install_github("olafmersmann/microbenchmark")



