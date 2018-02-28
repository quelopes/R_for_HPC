#!/usr/bin/env Rscript

# Exemplo do uso de foreach() com o backend paralelo doParallel

# Carregamento do pacote
library(foreach)
library(doParallel)

# Inicia um cluster com 40 processos e comunicação MPI
cl <- makeCluster(40, type = "MPI")

# Registra o backend paralelo
registerDoParallel(cl)

# Gera 3 vetores de entrada de 50000 posições
a <- seq(1, 10000, 1)
b <- seq(10, 100000,10)
c <- runif(10000)

# Fazendo em paralelo (a[1]+b[1])^c[1], (a[2]+b[2])^c[2] ...
# (a[10000]+b[10000])^c[10000]
out <- foreach(a, b, c) %dopar% {
	func(a, b, c)
}

# Para os workers
stopCluster(cl)
