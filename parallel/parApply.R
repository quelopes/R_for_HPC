#!/usr/bin/env Rscript

# Refaz apply.R para usar as versões paralelas do pacote parallel

# Carregamento do pacote
library(parallel)

# Inicia um cluster com 4 processos e comunicação MPI
cl <- makeCluster(4, type = "MPI")

# Cria uma matriz M no formato
#
#      [,1] [,2] [,3] [,4]
# [1,]    1    5    9   13
# [2,]    2    6   10   14
# [3,]    3    7   11   15
# [4,]    4    8   12   16
M <- matrix(seq(1,16), 4, 4)

# Aplica min() às linhas em paralelo
parApply(cl, M, 1, min)

# Mesmo resultado, mais eficiente em algumas situações
parRapply(cl, M, min)

# Aplica max() às colunas em paralelo
parApply(cl, M, 2, max)

# Mesmo resultado, mais eficiente em algumas situações
parCapply(cl, M, max)

# Para os workers
stopCluster(cl)
