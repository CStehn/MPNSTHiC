#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task 8
#SBATCH --mem=100gb
#SBATCH -t 6:00:00
#SBATCH -p agsmall
#SBATCH -A largaesp
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH --mail-type=ALL
#SBATCH -e homerConvertFormat_%a.err
#SBATCH -o homerConvertFormat_%a.out
#SBATCH --array=0-3

hic="/home/largaesp/shared/PRC2_HiC"
samp=(N32_3 N32_WT2 TY_DMSO TY_DOX)
cursamp=${samp[$SLURM_ARRAY_TASK_ID]}
wd="${hic}/${cursamp}/aligned"
chromsizes="/users/5/stehn007/references/hg38/hg38.chrom.sizes"


pigz -d -p $SLURM_CPUS_PER_TASK ${wd}/merged_nodups.txt.gz

module load miniforge

source activate hicexplorer

merged_nodup2pairs.pl -s 8 -m 30 ${wd}/merged_nodups.txt $chromsizes ${wd}/merged_nodups

cat ${wd}/merged_nodups.pairs | tail -n +30 > ${wd}/merged_nodups_head.pairs

awk '{print $1"\t"$2"\t"$3"\t"$6"\t"$4"\t"$5"\t"$7}' ${wd}/merged_nodups_head.pairs > ${wd}/${cursamp}.summary.txt




