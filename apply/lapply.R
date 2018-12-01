#!/usr/bin/env Rscript

# Cria uma lista X com 3 elementos:
# 
# * a: um inteiro
# * b: um vetor de inteiros
# * c: uma string
#
# Observe que uma lista pode conter elementos de tipos diferentes, ao contrário
# do vetor
X <- list(a = 1, b = 1:10, c = c("Olá", "Mundo"))

# Aplica a função length() a cada elemento
lapply(X, FUN = length)
