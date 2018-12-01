#!/bin/sh

#SBATCH --nodes=2
#SBATCH --ntasks-per-node=20
#SBATCH -p treinamento_gpu
#SBATCH -J exemplo
#SBATCH --exclusive

module load R/3.4.3_gnu
module load openmpi/1.10_gnu

export R_LIBS_USER="/scratch/treinamento/professor/R_for_HPC_UnB/lib"
# Suprime aviso sobre uso de fork()
export OMPI_MCA_mpi_warn_on_fork=0

./parApply.R
