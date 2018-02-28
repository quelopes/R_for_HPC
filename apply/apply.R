#!/usr/bin/env Rscript

# Cria uma matriz M no formato
#
#      [,1] [,2] [,3] [,4]
# [1,]    1    5    9   13
# [2,]    2    6   10   14
# [3,]    3    7   11   15
# [4,]    4    8   12   16
M <- matrix(seq(1,16), 4, 4)

# Aplica min() às linhas
apply(M, 1, min)

# Aplica max() às colunas
apply(M, 2, max)
