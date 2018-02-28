#!/bin/sh

#SBATCH --nodes=2
#SBATCH --ntasks-per-node=20
#SBATCH -p treinamento_gpu
#SBATCH -J nome_do_job
#SBATCH --exclusive

source /scratch/app/modulos/intel-psxe-2016.2.062.sh
module load openmpi/1.10_intel
module load R/3.3.1_intel

# Suprime aviso sobre uso de fork()
export OMPI_MCA_mpi_warn_on_fork=0

/path/para/o/script.R
