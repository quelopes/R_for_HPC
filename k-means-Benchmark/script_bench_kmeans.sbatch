#!/bin/sh

#SBATCH --nodes=2
#SBATCH --ntasks-per-node=24
#SBATCH -p treinamento_gpu
#SBATCH -J Rbenchmark


source /scratch/app/modulos/intel-psxe-2016.2.062.sh
module load openmpi/1.10_intel
module load R/3.3.1_intel


${PWD}/script.R








