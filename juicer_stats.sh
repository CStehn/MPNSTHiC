#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --job-name=juicer_stats
#SBATCH -p agsmall
#SBATCH --mem=100gb
#SBATCH --tmp=40gb
#SBATCH -A largaesp
#SBATCH -t 16:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=stehn007@umn.edu
#SBATCH -e /scratch.global/stehn007/HiC/N32_WT2/juicer_stats_%a.err
#SBATCH -o /scratch.global/stehn007/HiC/N32_WT2/juicer_stats_%a.out


module load java

HOME="/home/largaesp/stehn007"
HIC="/scratch.global/stehn007/HiC"
WD="${HIC}/N32_WT2"
ALIGNED="${WD}/aligned"
SCRIPTS="${WD}/scripts"
sample=$(echo $WD | perl -pe 's|.*HiC/(.*)|\1|')
site_file="${WD}/restriction_sites/hg38_Arima.txt"
hg38="${WD}/references/hg38/hg38.fa"

#call stats for all mapped reads

echo "Calling Stats for ${sample}"

java -jar ${HOME}/juicer_tools.jar statistics \
	$site_file \
	${ALIGNED}/inter.txt \
	${ALIGNED}/merged1.txt \
	$hg38

# call stats for mapped reads >30 MAPQ

echo "Calling Stats (MAPQ > 30) for ${sample}"

java -jar ${HOME}/juicer_tools.jar statistics \
	$site_file \
	${ALIGNED}/inter_30.txt \
	${ALIGNED}/merged30.txt \
	$hg38

