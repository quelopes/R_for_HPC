#!/usr/bin/env Rscript

# Exemplos de uso de clusterSetRNGStream()
#
# Use essa função para garantir a reprodutibilidade de execuções em paralelo que
# dependem da geração de números aleatórios

# Carregamento do pacote
library(parallel)

# Inicia um cluster com 4 processos e comunicação MPI
cl <- makeCluster(4, type="MPI")

# Define uma função que retorna uma quantidade de números aleatórios passada por
# parâmetro
num_aleatorio <- function(x) {
	runif(x)
}

# A execução abaixo é não reprodutível
#
# Execute mais de uma vez para comprovar
parSapply(cl, 1:4, num_aleatorio)

# A execução abaixo é reprodutível porque configurei a seed do gerador de
# números aletórios com um valor
#
# Execute mais de uma vez para comprovar
clusterSetRNGStream(cl, iseed = 12345)

parSapply(cl, 1:4, num_aleatorio)

# Para os workers
stopCluster(cl)
