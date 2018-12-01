#!/usr/bin/env Rscript

# load libraries
library(mlbench)
library(caret)
library(parallel)

# load data
data(PimaIndiansDiabetes)
# rename dataset to keep code below generic
dataset <- PimaIndiansDiabetes

control <- trainControl(method="repeatedcv", number=10, repeats=3)
seed <- 7

metric <- "Accuracy"

preProcess=c("center", "scale")

methods = c('lda', 'glm', 'glmnet', 'svmRadial', 'knn', 'nb', 'rpart', 'C5.0', 'treebag', 'rf', 'gbm')
set.seed(seed)

processos=integer()
tempo=double()

for(i in seq(1, 11, 2)){
	tInicial <- Sys.time()

	cl <- makeCluster(i, type = "SOCK")

	#clusterSetRNGStream(cl, iseed = seed)
	x <- clusterCall(cl, set.seed, seed)
	#x <- clusterEvalQ(cl, set.seed(7))

	out <- clusterMap(cl,
			 fun = train,
			 method = methods,
			 MoreArgs = list(diabetes~.,
					 data=dataset,
					 metric=metric,
					 preProc=c("center", "scale"),
					 trControl=control))

	tFinal <- Sys.time()

	results <- resamples(out)

	summary(results)

	stopCluster(cl)

	processos <- c(processos, i)
	tempo <- c(tempo, tFinal - tInicial)

print(processos)
print(tempo)
}
