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

# Aplica a função length() a cada elemento, retornando um vetor
sapply(X, FUN = length)

# Considere o uso de sapply() no lugar de unlist(lapply())
unlist(lapply(X, FUN=length))

# sapply() retorna uma matriz quando apropriado.
#
# Considere uma função estados() que retorna 3 estados americanos independente
# do parâmetro passado...
estados <- function(x) sample(state.name, 3)

# ...o retorno é sempre um vetor de comprimento 3...
estados(1)

# ...se sapply() detectar que nossa função retorna vetores de mesmo tamanho, ela
# irá usá-los como colunas de uma matriz:
sapply(1:5, FUN=estados)
