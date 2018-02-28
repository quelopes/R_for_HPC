#!/usr/bin/env Rscript

# Retorna um vetor de 5 elementos com 
# sum(1, 5, 1) na 1ª posição,
# sum(2, 4, 2) na 2ª posição,
# sum(3, 3, 3) na 3ª posição,
# sum(4, 2, 4) na 4ª posição e
# sum(5, 1, 5) na 5ª posição.
mapply(sum, 1:5, 5:1, 1:5)

# Faz rep(1, 4), rep(2, 3), rep(3, 2), rep(4, 1)
#
# Nesse caso, só é possível retornar uma lista
mapply(rep, 1:4, 4:1)
