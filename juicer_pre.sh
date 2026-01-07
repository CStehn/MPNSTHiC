#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --job-name=hiccups_loop
#SBATCH -p a100-8
#SBATCH --gres=gpu:a100:1
#SBATCH --mem=200gb
#SBATCH --tmp=60gb
#SBATCH -A largaesp
#SBATCH -t 16:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH -e /scratch.global/stehn007/HiC/TY_DMSO/hiccup_loop_%a.err
#SBATCH -o /scratch.global/stehn007/HiC/TY_DMSO/hiccup_loop_%a.out

module load cuda/8.0 cuda-sdk/8.0
module load java

HOME="/home/largaesp/stehn007"
HIC="/scratch.global/stehn007/HiC"
WD="${HIC}/TY_DMSO"
ALIGNED="${WD}/aligned"
SCRIPTS="${WD}/scripts"
sample=$(echo $WD | perl -pe 's|.*HiC/(.*)|\1|')

echo "Calling Loops using HiCCUPS for ${sample}"

java -jar ${HOME}/juicer_tools_1.19.02.jar hiccups \
	${ALIGNED}/inter_30.hic \
	${ALIGNED}/inter_30_loops \
	--threads $SLURM_CPUS_PER_TASK

