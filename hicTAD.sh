#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 12
#SBATCH --mem=20gb
#SBATCH -t 6:00:00
#SBATCH -p agsmall
#SBATCH -A largaesp
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH --mail-type=ALL
#SBATCH -e hicTADfinding_%a.err
#SBATCH -o hicTADfinding_%a.out
#SBATCH --array=0-3

hic="/home/largaesp/shared/PRC2_HiC"
samp=(N32_3 N32_WT2 TY_DMSO TY_DOX)
cursamp=${samp[$SLURM_ARRAY_TASK_ID]}
sampdir="${hic}/${cursamp}"
cooler="${sampdir}/aligned/cooler"
out="${sampdir}/TADs"
thres=(0.01 0.005 0.001)
delta=(0.1 0.2 0.5)

if [[ ! -d $out ]]; then
	mkdir $out
fi

module load miniforge
source activate hicexplorer

## trying multiple different resolutions and thresholds and comparing
#hicFindTADs --matrix "${cooler}/inter_30.100kb.CNVnorm.h5" \
#	--outPrefix "${out}/${cursamp}_100kb_TAD_thres0.05" \
#	--correctForMultipleTesting fdr \
#	--thresholdComparisons 0.05 \
#	--minDepth 300000 \
#	--maxDepth 1000000 \
#	--delta 0.01

# loop over different thresholds 
for i in {0..2};
do
	curthres=${thres[$i]}
	curdelta=${delta[$i]}
	hicFindTADs --matrix "${cooler}/inter_30.100kb.CNVnorm.h5" \
		--TAD_sep_score_prefix "${out}/${cursamp}_100kb_TAD_thres0.05" \
		--outPrefix "${out}/${cursamp}_100kb_TAD_thres0.005_delta${curdelta}" \
		--correctForMultipleTesting fdr \
		--thresholdComparisons 0.005 \
		--delta $curdelta \
		--numberOfProcessors $SLURM_CPUS_PER_TASK
done
