#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 12
#SBATCH --mem=400gb
#SBATCH -t 6:00:00
#SBATCH -p agsmall
#SBATCH -A largaesp
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH --mail-type=ALL
#SBATCH -e hicPCA_%a.err
#SBATCH -o hicPCA_%a.out
#SBATCH --array=0-3

hic="/home/largaesp/shared/PRC2_HiC"
samp=(N32_3 N32_WT2 TY_DMSO TY_DOX)
cursamp=${samp[$SLURM_ARRAY_TASK_ID]}
sampdir="${hic}/${cursamp}"
cooler="${sampdir}/aligned/cooler"
out="${sampdir}/PCA"


if [[ ! -d $out ]]; then
	mkdir $out
fi

module load miniforge

source activate hicexplorer

# convert .hic file at 50000 kb resolution to .cool matrix, then to .h5, then comp pearson cor matrix
# run PCA on the pearson cor matrix

hicConvertFormat --matrices "${cooler}/inter_30.100kb.raw.cool" \
	--outFileName "${cooler}/inter_30.100kb.raw.h5" \
	--inputFormat cool --outputFormat h5 \
	--correction_name VC

hicTransform --matrix "${cooler}/inter_30.100kb.raw.h5" \
	--method pearson \
	--outFileName "${out}/${cursamp}_100kb_rawPearson.h5"


setout="${out}/${cursamp}_100kb_rawPearson_PC"
hicPCA --matrix "${out}/${cursamp}_100kb_rawPearson.h5" -we 1 2 3 4 5 \
	--outputFileName "${setout}1.bedGraph" "${setout}2.bedGraph" "${setout}3.bedGraph" "${setout}4.bedGraph" "${setout}5.bedGraph" \
	--format bedgraph
