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

processos=integer()
tempo=double()

set.seed(seed)

mock <- function(method, data, ...){
paste(Sys.info()['nodename'])
}

for(i in seq(22, 1, -3)){
	tInicial <- Sys.time()

	cl <- makeCluster(i, type = "MPI")

	#clusterSetRNGStream(cl, iseed = seed)
	x <- clusterCall(cl, set.seed, seed)
	#x <- clusterEvalQ(cl, set.seed(7))



	out <- clusterMap(cl,
			 fun = mock,
			 method = methodsA,
			 data=datasetsA,
			 MoreArgs = list(classes~.,
					 metric=metric,
					 preProc=c("center", "scale"),
					 trControl=control))
			  

	tFinal <- Sys.time()
	processos <- c(processos, i)
	tempo <- c(tempo, tFinal - tInicial)
	print(processos)
	print(tempo)
#	save.image('teste.RData')
#	print(out)
#	resultsA <- resamples(out[1:11])
#	resultsB <- resamples(out[12:22])

#	summary(resultsA)
#	summary(resultsB)

	stopCluster(cl)
}
print(out)
