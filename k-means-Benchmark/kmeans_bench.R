#!/usr/bin/env Rscript

# === Benchmark do kmeans ===
# --- dependences ---
library(snow)
library(foreach)
library(doSNOW)
library(doMPI)
library(doParallel)

# --- variables --- 
ncenter = 5
ncluters = 4

# ---------------
# === gerador ===
# ---------------
nrow <- 50000
sd <- 0.5
real.centers <- list( x=c(-1.3, -0.7, 0.0, +0.7, +1.2),
                      y=c(-1.0, +1.0, 0.1, -1.3, +1.2) )
data <- matrix(nrow=0, ncol=2)
colnames(data) <- c("x", "y")
for (i in seq(1, 5)) {
  x0 <- rnorm(nrow, mean=real.centers$x[[i]], sd=sd)
  y0 <- rnorm(nrow, mean=real.centers$y[[i]], sd=sd)
  data <- rbind( data, cbind(x0,y0))
}

# --------------------------
# === k-means sequencial ===
# --------------------------
kmeans_seq = function(dt){
  result <- kmeans(dt,centers=ncenter,nstart=100)
}

# ----------------------
# === k-means lapply ===
# ----------------------
kmeans_lapply = function(dt){
  parallel.function <- function(i){
    kmeans(x=dt, centers=ncenter, nstart=i)
  }
  results <- lapply(c(25,25,25,25), FUN=parallel.function)
  results[[1]]$tot.withinss
  temp.vector <- sapply(results, function(result){result$tot.withinss})
  result <- results[[which.min(temp.vector)]]
}

# ----------------------------------
# === k-means foreach sequencial ===
# ----------------------------------
kmeans_foreach = function(dt){
  results <- foreach(i=c(25,25,25,25)) %do%{
    kmeans(x=dt,centers=ncenter,nstart=i)
  }
  temp.vector <- sapply(results,function(result){result$tot.withinss})
  result <- results[[which.min(temp.vector)]]
}

# ----------------------
# === k-means doSNOW ===
# ----------------------
kmeans_doSnow = function(dt,ncent){
  cl <- makeCluster(ncluters,type="MPI")
  clusterExport(cl,c('dt'))
  registerDoSNOW(cl)
  timeExec = system.time({
    results <- foreach(i=c(25,25,25,25)) %dopar%{
      kmeans(x=dt,centers=ncent,nstart=i)
    }
    temp.vector <- sapply(results,function(result){result$tot.withinss})
    result <- results[[which.min(temp.vector)]]
  })
  stopCluster(cl)
  timeExec
}

# ---------------------
# === k-means doMPI ===
# ---------------------
kmeans_doMpi = function(dt,ncent){
  #cl <- makeCluster(mpi.universe.size(),type="MPI")
  cl <- startMPIcluster(count=ncluters)
  registerDoMPI(cl)
  timeExec = system.time({
  results <- foreach(i=c(25,25,25,25)) %dopar%{
    kmeans(x=dt,centers=ncent,nstart=i)
  }
  temp.vector <- sapply(results,function(result){result$tot.withinss})
  result <- results[[which.min(temp.vector)]]
  })
  closeCluster(cl)
  timeExec
}

# --------------------------
# === k-means doParallel ===
# --------------------------
kmeans_doParallel = function(dt,ncent){
  #cl <- makeCluster(mpi.universe.size(),type="MPI")
  cl <- makeCluster(ncluters,type="MPI")
  clusterExport(cl,c('dt'))
  registerDoParallel(cl)
  timeExec = system.time({
  results <- foreach(i=c(25,25,25,25)) %dopar%{
    kmeans(x=dt,centers=ncent,nstart=i)
  }
  temp.vector <- sapply(results,function(result){result$tot.withinss})
  result <- results[[which.min(temp.vector)]]
  })
  stopCluster(cl)
  timeExec
}


vetTime=NULL

# ========================
# === Time  sequential ===
# ========================
vetTimeSeq = NULL

print("Via sequencial")
vetTimeSeq = system.time({kmeans_seq(data)})

print("Via lapply")
vetTimeSeq = rbind(vetTimeSeq,system.time({kmeans_lapply(data)}))

print("Via foreach")
vetTimeSeq = rbind(vetTimeSeq,system.time({kmeans_foreach(data)}))

rownames(vetTimeSeq) = c("seq","lapply","foreach")
vetTimeSeq = vetTimeSeq[,c(1:3)]
vetTimeSeq

# ======================
# === Time  parallel ===
# ======================
vetTimePar = NULL

print("Via doSnow")
vetTimePar = kmeans_doSnow(data,ncenter)

print("Via doMPI")
vetTimePar  = rbind(vetTimePar,kmeans_doMpi(data,ncenter))

print("Via doParallel")
vetTimePar = rbind(vetTimePar,kmeans_doParallel(data,ncenter))

rownames(vetTimePar) = c("doSnow","doMPI","doParallel")
vetTimePar = vetTimePar[,c(1:3)]
vetTimePar

vetTime = rbind(vetTime,rbind(vetTimeSeq,vetTimePar))
write.table(vetTime,"vetTime.csv",sep=",",row.names=T,col.names=T)


