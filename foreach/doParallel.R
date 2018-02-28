#!/usr/bin/env Rscript

# Exemplo do uso de foreach() com o backend paralelo doParallel
#
# Assim como clusterSplit.R, demonstra a penalidade que a comunicação pode impor
# ao desempenho

# Carregamento dos pacotes
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

# Mediremos o tempo necessário para processar em paralelo
#
# (a[1]+b[1])^c[1]
# (a[2]+b[2])^c[2]
# ...
# (a[10000]+b[10000])^c[10000]
system.time(out <- foreach(x=a, y=b, z=c) %dopar% {
	(x + y)**z
})

# Agora dividiremos as entradas numa quantidade de fatias igual ao tamanho do
# cluster
a_chunk <- clusterSplit(cl, a)
b_chunk <- clusterSplit(cl, b)
c_chunk <- clusterSplit(cl, c)

# Mediremos o tempo necessário para processar em paralelo
#
# func(a_chunk[1], b_chunk[1], c_chunk[1])
# func(a_chunk[2], b_chunk[2], c_chunk[2])
# ...
# func(a_chunk[40], b_chunk[40], c_chunk[40])
system.time(out_chunks <- foreach(i=1:40) %dopar% {
	(a_chunk[[i]] + b_chunk[[i]])**c_chunk[[i]]
})

# A linha abaixo testa se a saída gerada pelas 2 abordagens são iguais
#
# stopifnot() gera um erro caso a expressão seja avaliada como falsa
stopifnot(unlist(out) == unlist(out_chunks))

# Para os workers
stopCluster(cl)
