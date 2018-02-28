#!/usr/bin/env Rscript

# Exemplo do uso de clusterSplit() e da penalidade que a comunicação pode impor
# ao desempenho

# Carregamento do pacote
library(parallel)

# Inicia um cluster com 40 processos e comunicação MPI
cl <- makeCluster(40, type = "MPI")

# Gera 3 vetores de entrada de 50000 posições
a <- seq(1, 50000, 1)
b <- seq(10, 500000,10)
c <- runif(50000)

# Definiremos uma função simples para ser executada nos processo workers
#
# Ela recebe 3 parâmetros - x, y e z - e retorna (x+y)^z
func <- function(x, y, z){
	#write(paste("Comprimento dos parâmetros passados", length(x), length(y), length(z)), file = paste0(Sys.getpid(), ".log"), append = TRUE)
	(x + y)**z
}

# Mediremos o tempo necessário para processar em paralelo
#
# func(a[1], b[1], c[1])
# func(a[2], b[2], c[2])
# ...
# func(a[50000], b[50000], c[50000])
system.time(out <- clusterMap(cl, func, a, b, c))

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
system.time(out_chunked <- clusterMap(cl, func, a_chunk, b_chunk, c_chunk))

# A linha abaixo testa se a saída gerada pelas 2 abordagens são iguais
#
# stopifnot() gera um erro caso a expressão seja avaliada como falsa
stopifnot(unlist(out) == unlist(out_chunked))

# Para os workers
stopCluster(cl)
