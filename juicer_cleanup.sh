#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 12
#SBATCH --mem=60gb
#SBATCH -t 24:00:00
#SBATCH -p agsmall
#SBATCH -A largaesp
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH --mail-type=ALL
#SBATCH -e juicer_cleaning.err
#SBTACH -o juicer_cleaning.out


cd /home/largaesp/shared/PRC2_HiC

# first up, N32_WT2
cd ./N32_WT2/aligned

pigz --best -v -- \
	merged_nodups.txt \
	dups.txt \
	opt_dups.txt \
	abnormal.sam \
	collisions.txt \
	unmapped.sam

echo "N32_WT2 gzipped"

rm collisions_dups.txt collisions_nodups.txt

echo "N32_WT2 clenaed"

# next, TY_DOX
cd ../../TY_DOX/aligned

pigz --best -v -- \
	merged_nodups.txt \
	dups.txt \
	opt_dups.txt \
	abnormal.sam \
	collisions.txt \
	unmapped.sam

echo "TY_DOX gzipped"

rm collisions_dups.txt collisions_nodups.txt

echo "TY_DOX cleaned"

# finally, TY_DMSO
cd ../../TY_DMSO/aligned

pigz --best -v -- \
	merged_nodups.txt \
	dups.txt \
	opt_dups.txt \
	abnormal.sam \
	collisions.txt \
	unmapped.sam

echo "TY_DMSO gzipped"

rm collisions_dups.txt collisions_nodups.txt

echo "TY_DMSO cleaned"

