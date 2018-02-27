#!/usr/bin/env Rscript

library(foreach)
library(doMPI)

data <- read.csv('dataset.csv')

#cl <- makeCluster(mpi.universe.size(),type="MPI")
cl <- startMPIcluster(count=4)

registerDoMPI(cl)
results <- foreach(i=c(25,25,25,25)) %dopar%{
    kmeans(x=data,centers=4,nstart=i)
}
temp.vector <- sapply(results,function(result){result$tot.withinss})
result <- results[[which.min(temp.vector)]]

closeCluster(cl)

print(result)















