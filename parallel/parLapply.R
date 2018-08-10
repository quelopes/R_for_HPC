#!/usr/bin/env Rscript

# Refaz lapply.R para usar as versões paralelas do pacote parallel

# Carregamento do pacote
library(parallel)

# Inicia um cluster com 4 processos e comunicação MPI
cl <- makeCluster(4, type = "MPI")

# Cria uma lista X com 3 elementos:
# 
# * a: um inteiro
# * b: um vetor de inteiros
# * c: uma string
# * d: uma matriz
#
# Observe que uma lista pode conter elementos de tipos diferentes, ao contrário
# do vetor
X <- list(a = 1, b = 1:10, c = c("Olá", "Mundo"), d = matrix(seq(1,20), 4, 5))

# Aplica a função length() a cada elemento em paralelo
parLapply(cl, X, fun = length)

# Aplica a função length() a cada elemento em paralelo e com balanceamento de
# carga. Desnecessário nesse problema pequeno.
parLapplyLB(cl, X, fun = length)

# Para os workers
stopCluster(cl)
