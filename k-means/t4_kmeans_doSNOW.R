#!/usr/bin/env Rscript

library(foreach)
library(doSNOW)

data <- read.csv('dataset.csv')

#cl <- makeCluster(mpi.universe.size(),type="MPI")
cl <- makeCluster(10,type="MPI")
clusterExport(cl,c('data'))
registerDoSNOW(cl)
system.time({results <- foreach(i=c(25,25,25,25)) %dopar%{
    kmeans(x=data,centers=4,nstart=i)
}
temp.vector <- sapply(results,function(result){result$tot.withinss})
result <- results[[which.min(temp.vector)]]
})
stopCluster(cl)

print(result)















