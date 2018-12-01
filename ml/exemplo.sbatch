#!/bin/sh

#SBATCH --nodes=2
#SBATCH --ntasks-per-node=12
#SBATCH -p treinamento_gpu
#SBATCH -J exemplo
#SBATCH --exclusive
#SBATCH --time=00:10:00

module load R/3.4.3_gnu
module load openmpi/1.10_gnu

export R_LIBS_USER="/scratch/treinamento/professor/R_for_HPC_UnB/lib"

# Suprime aviso sobre uso de fork()
export OMPI_MCA_mpi_warn_on_fork=0

./ml_parallel_2datasets.R
