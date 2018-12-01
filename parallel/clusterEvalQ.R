#!/usr/bin/env Rscript

# Exemplos de uso de clusterEvalQ() e clusterCall()

# Carregamento do pacote
library(parallel)

# Inicia um cluster com 4 processos e comunicação MPI
cl <- makeCluster(4, type="MPI")

# Define uma variável a de valor 10 **no mestre** e exporta essa variável para
# os workers
a <- 10
clusterExport(cl, "a")

# Muda o valor de a para 5 **no mestre**. Agora o mestre tem a=5 e os workers
# tem a=10
a <- 5

# Usa clusterEvalQ para avaliar a expressão 'print(a)' **em cada nó do cluster**
clusterEvalQ(cl, print(a))

# Já clusterCall() avalia os argumentos **no mestre** e transmite os argumentos
# aos workers, que executam a função.
clusterCall(cl, print, a)

# Um uso típico de clusterEvalQ é carregar um pacote nos workers
clusterEvalQ(cl, library(MASS))

# Agora o data frame Cushings, presente no pacote MASS está disponível nos
# workers
clusterEvalQ(cl, sample(Cushings$Pregnanetriol, 1))

# Para os workers
stopCluster(cl)
