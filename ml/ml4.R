#!/usr/bin/env Rscript

# load libraries
library(mlbench)
library(caret)
library(parallel)

# load data
data(PimaIndiansDiabetes)
# rename dataset to keep code below generic
dataset1 <- PimaIndiansDiabetes
colnames(dataset1)[colnames(dataset1) == "diabetes"] <- "classes"

dataset2 <- read.csv("breastCancer.csv")

datasets <- list(dataset1, dataset2)

control <- trainControl(method="repeatedcv", number=10, repeats=3)
seed <- 7

metric <- "Accuracy"

preProcess=c("center", "scale")

methods = c('lda', 'glm', 'glmnet', 'svmRadial', 'knn', 'nb', 'rpart', 'C5.0', 'treebag', 'rf', 'gbm')

methodsA <- rep(methods, length(datasets))
datasetsA <- rep(datasets, each=length(methods))

set.seed(seed)

cl <- makeCluster(22, type = "MPI")

#clusterSetRNGStream(cl, iseed = seed)
x <- clusterCall(cl, set.seed, seed)
#x <- clusterEvalQ(cl, set.seed(7))

# Função para testes, apenas imprime o método e dataset passados
mock <- function(method, data, ...){
	paste(Sys.info()['nodename'], Sys.getpid())
#	print(method)
#	print(colnames(data))
}

out <- clusterMap(cl,
                 fun = mock,
                 method = methodsA,
                 data=datasetsA,
                 MoreArgs = list(classes~.,
                                 metric=metric,
                                 preProc=c("center", "scale"),
                                 trControl=control))
                  


save.image('teste.RData')
print(out)
#resultsA <- resamples(out[1:11])
#resultsB <- resamples(out[12:22])
#
#summary(resultsA)
#summary(resultsB)

stopCluster(cl)
