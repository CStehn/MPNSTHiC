#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --job-name=CHiC_merging
#SBATCH -p agsmall
#SBATCH --mem=124gb
#SBATCH --tmp=60gb
#SBATCH -A largaesp
#SBATCH -t 48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH -e CHiC_merging.err
#SBATCH -o CHiC_merging.out
#SBATCH --array=0-1

bamdir="/scratch.global/stehn007/chic"

cond=(DMSO Dox)
cur=${cond[$SLURM_ARRAY_TASK_ID]}

out="${bamdir}/${cur}"

files=($(find ${bamdir} -type f -name "*${cur}*hicup.bam"))

module load samtools

samtools merge -o "${out}/S462TY_addback_${cur}_merged.hicup.bam" "${files[0]}" "${files[1]}"



