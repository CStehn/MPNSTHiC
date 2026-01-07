#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --job-name=SV_calling_%a
#SBATCH -p agsmall
#SBATCH --mem=50gb
#SBATCH -A largaesp
#SBATCH -t 12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH -e /home/largaesp/shared/PRC2_HiC/SV_calling_%a.err
#SBATCH -o /home/largaesp/shared/PRC2_HiC/SV_calling_%a.out
#SBATCH --array=0-3

module load conda
source activate eaglec

allsamp=(TY_DMSO TY_DOX N32_3 N32_WT2)

HIC="/home/largaesp/shared/PRC2_HiC"
sample=${allsamp[$SLURM_ARRAY_TASK_ID]}
WD="${HIC}/${sample}"
mats="${WD}/aligned/cooler"
out="${WD}/SV_calls"

if [[ ! -d $out ]]; then
	mkdir $out
fi

#predictSV --hic-5k ${mats}/inter_30_5kb.cool \
#	--hic-10k ${mats}/inter_30_10kb.cool \
#	--hic-50k ${mats}/inter_30_50kb.cool \
#	-O $sample -g hg38 --balance-type Raw \
#	--output-format full

predictSV --hic-5k ${mats}/inter_30.5kb.CNVnorm.cool \
	--hic-10k ${mats}/inter_30.10kb.CNVnorm.cool \
	--hic-50k ${mats}/inter_30.50kb.CNVnorm.cool \
	-O "${sample}.CNVnorm" -g hg38 --balance-type CNV \
	--output-format full

