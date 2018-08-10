#!/usr/bin/env Rscript

# Refaz sapply.R para usar as versões paralelas do pacote parallel

# Carregamento do pacote
library(parallel) 

# Inicia um cluster com 4 processos e comunicação MPI
cl <- makeCluster(4, type = "MPI")

# Cria uma lista X com 3 elementos:
# 
# * a: um inteiro
# * b: um vetor de inteiros
# * c: uma string
#
# Observe que uma lista pode conter elementos de tipos diferentes, ao contrário
# do vetor
X <- list(a = 1, b = 1:10, c = c("Olá", "Mundo"), d = matrix(seq(1,20), 4, 5))

# Aplica a função length() a cada elemento, retornando um vetor
parSapply(cl, X, FUN = length)

# parSapply() retorna uma matriz quando apropriado.
#
# Considere uma função estados() que retorna 3 estados americanos independente
# do parâmetro passado...
estados <- function(x) sample(state.name, 3)

# ...o retorno é sempre um vetor de comprimento 3...
estados(1)

# ...se parSapply() detectar que nossa função retorna vetores de mesmo tamanho, ela
# irá usá-los como colunas de uma matriz:
parSapply(cl, 1:5, FUN=estados)

# Para os workers
stopCluster(cl)
