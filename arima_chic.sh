#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --job-name=pcHi-C_Chicago
#SBATCH -p agsmall,ag2tb
#SBATCH --mem=124gb
#SBATCH --tmp=60gb
#SBATCH -A largaesp
#SBATCH -t 72:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH -e pcHiC_Chicago_onwards_%a.err
#SBATCH -o pcHiC_Chicago_onwards_%a.out
#SBATCH --array=1-4

source ~/.bash_profile

# NOTE: Had to change perl environment shebang in HiCUP scripts to #!/usr/bin/env perl
# if not working, try messing with that again
# MSI default perl module is not synced with Cwd module (somehow?)

module load R/4.1.0
module load bowtie2
module load bedtools/2.25.0
module load htslib/1.9
module load samtools/1.10
module load bcftools/1.10.2
module load conda
source activate deeptools

FASTQ="/home/largaesp/data_delivery/umgc/2023-q2/230329_A00223_1030_BHY2MVDRX2/Largaespada_Project_154"
HOME="/home/largaesp/stehn007"
SCRATCH="/scratch.global/stehn007/chic"
ARIMA="${HOME}/bin/CHiC"
CHICAGO="${ARIMA}/chicagoTools"
HICUP="${HOME}/bin/HiCUP"
bowtie2="/panfs/roc/msisoft/bowtie2/2.2.4_gcc-4.9.2_haswell/bowtie2"
PAIR1=$(ls ${FASTQ}/*R1* | sed -n ${SLURM_ARRAY_TASK_ID}p)
PAIR2=$(ls ${FASTQ}/*R2* | sed -n ${SLURM_ARRAY_TASK_ID}p)
sample=$(echo $PAIR1 | perl -pe 's|(.*)(Largaespada_Project_154/)(.*)(_S.*)|\3|')
OUT="${SCRATCH}/${sample}"

echo "Results for sample: ${sample}"

mkdir $OUT

${ARIMA}/Arima-CHiC-v1.5.sh \
	-A $bowtie2 \
	-W 0 -Y 0 -Z 0 \
	-X "${HOME}/index/arima/hg38" \
	-C $CHICAGO \
	-H $HICUP \
	-I $PAIR1,$PAIR2 \
	-d ${HOME}/index/hicup/Digest_hg38_Arima.txt \
	-o $OUT \
	-p $sample \
	-O "hg38" \
	-r "5kb" \
	-t $SLURM_CPUS_PER_TASK \
	-b ${ARIMA}/utils/human_GW_PC_S3207364_S3207414_hg38.uniq.bed \
	-R ${HOME}/index/chicago/hg38/5kb/hg38_chicago_input_5kb.rmap \
	-B ${HOME}/index/chicago/hg38/5kb/hg38_chicago_input_5kb.baitmap \
	-D ${HOME}/index/chicago/hg38/5kb	



