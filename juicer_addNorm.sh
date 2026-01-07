#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --job-name=addNorm_N32_WT2
#SBATCH -p a100-8
#SBATCH --gres=gpu:a100:1
#SBATCH --mem=400gb
#SBATCH --tmp=60gb
#SBATCH -A largaesp
#SBATCH -t 8:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH -e /home/largaesp/stehn007/addNorm_N32_WT2_30.err
#SBATCH -o /home/largaesp/stehn007/addNorm_N32_WT2_30.out
#SBATCH --open-mode=append

module load cuda/8.0 cuda-sdk/8.0
module load java

export IBM_JAVA_OPTIONS="-Xmx150000m -Xgcthreads1"
export _JAVA_OPTIONS="-Xmx150000m -Xms150000m"

JUICER="/home/largaesp/stehn007/bin/juicer"
#FANC="/home/largaesp/stehn007/bin/fanc/bin"
HIC="/home/largaesp/shared/PRC2_HiC"
WD="${HIC}/N32_WT2"
ALIGNED="${WD}/aligned"
SCRIPTS="${JUICER}/SLURM/scripts"
sample=$(echo $WD | perl -pe 's|.*HiC/(.*)|\1|')

echo "Adding Normalization to HiC file for ${sample}"

${SCRIPTS}/juicer_tools addNorm \
	-j 8 \
	${ALIGNED}/inter_30.hic

