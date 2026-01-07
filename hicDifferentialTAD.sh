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
#SBATCH -e hicTADdiffs.err
#SBATCH -o hicTADdiffs.out

hic="/home/largaesp/shared/PRC2_HiC"
sampdir="${hic}/${cursamp}"
cooler="${sampdir}/aligned/cooler"
out="${sampdir}/TADs"


module load miniforge
source activate hicexplorer

hicDifferentialTAD \ 
	--targetMatrix "${hic}/TY_DMSO/aligned/cooler/inter_30.100kb.CNVnorm.h5" \
	--controlMatrix "${hic}/TY_DOX/aligned/cooler/inter_30.100kb.CNVnorm.h5" \
	--tadDomains "${hic}/TY_DMSO/TADs/TY_DMSO_100kb_TAD_thres0.005_delta0.1_domains.bed" \
	--threads $SLURM_CPUS_PER_TASK \
	--pValue 0.2 \
	--outFileNamePrefix "${hic}/TY_DMSO/TADs/S462TY_100kb_thres0.005_delta0.1_domainDiffs"

hicDifferentialTAD \
        --targetMatrix "${hic}/TY_DMSO/aligned/cooler/inter_30.10kb.CNVnorm.h5" \
        --controlMatrix "${hic}/TY_DOX/aligned/cooler/inter_30.10kb.CNVnorm.h5" \
        --tadDomains "${hic}/TY_DMSO/TADs/TY_DMSO_10kb_TAD_thres0.005_domains.bed" \
        --threads $SLURM_CPUS_PER_TASK \
        --pValue 0.2 \
        --outFileNamePrefix "${hic}/TY_DMSO/TADs/S462TY_10kb_thres0.005_domainDiffs"

