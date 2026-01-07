#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --job-name=hic_dump_to_long
#SBATCH -p a100-8
#SBATCH --gres=gpu:a100:1
#SBATCH --mem=200gb
#SBATCH --tmp=60gb
#SBATCH -A largaesp
#SBATCH -t 8:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH -e /home/largaesp/stehn007/dump_to_long.err
#SBATCH -o /home/largaesp/stehn007/dump_to_long.out
#SBATCH --array=0-3

module load cuda/8.0 cuda-sdk/8.0
module load java

export IBM_JAVA_OPTIONS="-Xmx150000m -Xgcthreads1"
export _JAVA_OPTIONS="-Xmx150000m -Xms150000m"

JUICER="/home/largaesp/stehn007/bin/juicer"
HIC="/home/largaesp/shared/PRC2_HiC"
WD="${HIC}/TY_DMSO"
ALIGNED="${WD}/aligned"
SCRIPTS="${JUICER}/SLURM/scripts"
sample=$(echo $WD | perl -pe 's|.*HiC/(.*)|\1|')

echo "Calling Loops using HiCCUPS for ${sample}"

