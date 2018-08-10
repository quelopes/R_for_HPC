#!/usr/bin/env Rscript

# Exemplo de uso de clusterExport()

# Carregamento do pacote
library(parallel)

# Inicia um cluster com 4 processos e comunicação MPI
cl <- makeCluster(4, type = "MPI")

# Vamos definir uma váriável inteira a ser exportada
expoente <- 3

# clusterExport() recebe um **vetor de strings** com nomes das variáveis, não as
# variáveis em si
clusterExport(cl, "expoente")

X <- 1:10

# Definimos uma função que usa expoente, mas ele não é recebido por parâmetro
# A chamada abaixo só funciona por causa do clusterExport() anterior
parLapply(cl, X, fun = function(b) b**expoente)

# Para os workers
stopCluster(cl) 
