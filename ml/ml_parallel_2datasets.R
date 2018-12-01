#!/usr/bin/env Rscript

# Processa 2 datasets em paralelo

# Carrega os pacotes necessários
library(mlbench)
library(caret)
library(parallel)

# Carrega os datasets
data(PimaIndiansDiabetes)
dataset1 <- PimaIndiansDiabetes
dataset2 <- read.csv("breastCancer.csv")
# Renomeia a coluna diabetes do 1º dataset para que ambos tenham uma coluna
# chamada "classes". Esse nome de coluna é usado na chamada a clusterMap().
colnames(dataset1)[colnames(dataset1) == "diabetes"] <- "classes"

control <- trainControl(method="repeatedcv", number=10, repeats=3)

seed <- 7

metric <- "Accuracy"

preProcess=c("center", "scale")

# Cria as listas de métodos e datasets sobre as quais clusterMap() irá iterar.
d <- list(dataset1, dataset2)
m <- c('lda', 'glm', 'glmnet', 'svmRadial', 'knn', 'nb', 'rpart', 'C5.0', 'treebag', 'rf', 'gbm')
methods <- rep(m, length(d))
datasets <- rep(d, each=length(m))

cl <- makeCluster(22, type = "MPI")

#clusterSetRNGStream(cl, iseed = seed)
x <- clusterCall(cl, set.seed, seed)

# Observe que "classes" é usado como parâmetro de train().
#
# Isso não é um problema porque garantimos acima que ambos os datasets teriam
# uma coluna com esse nome.
out <- clusterMap(cl,
                  fun = train,
                  method = methods,
                  data = datasets,
                  MoreArgs = list(classes~.,
                                  metric = metric,
                                  preProc = c("center", "scale"),
                                  trControl = control))
                  

resultsA <- resamples(out[1:11])
resultsB <- resamples(out[12:22])

summary(resultsA)
summary(resultsB)

stopCluster(cl)
