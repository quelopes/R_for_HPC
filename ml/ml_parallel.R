#!/usr/bin/env Rscript

# Reescreve ml_serial.R para chamar train() em paralelo

# Carrega os pacotes necessários
library(mlbench)
library(caret)
library(parallel)

# Carrega e renomeia o dataset
data(PimaIndiansDiabetes)
dataset <- PimaIndiansDiabetes

control <- trainControl(method="repeatedcv", number=10, repeats=3)
seed <- 7

metric <- "Accuracy"

preProcess=c("center", "scale")

methods = c('lda', 'glm', 'glmnet', 'svmRadial', 'knn', 'nb', 'rpart', 'C5.0', 'treebag', 'rf', 'gbm')

# Cria um cluster de 11 workers. Um para cada método.
cl <- makeCluster(11, type = "MPI")

#clusterSetRNGStream(cl, iseed = seed)
x <- clusterCall(cl, set.seed, seed)

out <- clusterMap(cl,
                  fun = train,
                  method = methods,
                  MoreArgs = list(diabetes~.,
                                  data = dataset,
                                  metric = metric,
                                  preProc = c("center", "scale"),
                                  trControl = control))
                  

results <- resamples(out)

summary(results)

stopCluster(cl)
