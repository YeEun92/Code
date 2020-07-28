

# reference genome file in FASTA format ; config.ini file modify
# from
# hg38=/path/to/hg38.fa
# hg19=/path/to/hg19.fa
# to
# hg38=/home/y/Data/hg38.fna 
# hg19=/home/y/Date/hg19.fasta
# transIndel files and ScanNeo files 
#	; fix first line, the directory of python (!/usr/bin/python > !/home/y/anaconda3/env/0605/bin/python2)
# COPY AND PASTE [transIndel_build_RNA.py, trandIndel_call.py] TO [~/anaconda3/envs/0605/bin] DIR


# add PATH at last of [.bashrc] file
# nano ~/.bashrc
# export PATH=$PATH:/home/y/tools/transIndel
# export PATH=$PATH:home/y/tools/samtools/bin
# source ~/.bashrc

# Index the HLA reference genome hla_reference_rna.fasta from Optitype /home/y/anaconda3/envs/0518/share/optitype-1.3.2-3/data/hla_reference_rna.fasta
# run once
# yara_indexer ~/anaconda3/pkgs/optitype-1.3.4-0/bin/data/hla_reference_rna.fasta -o hla.index

# samtools install
# ref ; www.htslib.org/download

wget github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2
tar -xvf samtools-1.10.tar.bz2
cd tools/samtools-1.10
./configure --prefix=/home/y/tools/samtools-1.10
make
make install
# conda ; COPY AND PASTE [samtools] file to '~/anaconda3/env/0605/bin' 

# prepare transIndel

conda install -c bioconda HTseq
conda install -c bioconda pysam

# annotation file and vep file download

wget https://www.encodeproject.org/files/gencode.v19.annotation/@@download/gencode.v19.annotation.gtf.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_21/gencode.v21.annotation.gtf.gz

# vep cache file is so huge, so i got this at some other mounted disk
cd /home/data/backup
wget ftp://ftp.ensembl.org/pub/release-100/variation/indexed_vep_cache/homo_sapiens_vep_100_GRCh37.tar.gz

cd /home/y/Data
gzip -d gencode.v19.annotation.gtf.gz
gzip -d gencode.v21.annotation.gtf.gz
tar -zxvf /home/data/backup/homo_sapiens_vep_100_GRCh37.tar.gz  -C ~/.vep/

# STEP 0: Prepare to run ScanNeo
# Sometimes samtools isn't run, then you can do conda update or reinstal samtools at your env

cd ~/[input data directory]/
bwa index hg19.fasta

mkdir tmp
samtools sort -o [sorted RNA bam] -T tmp/[temporary name] [input RNA bam]
rmdir tmp
samtools index [sorted RNA bam]

# STEP 1: INDEL calling using RNA-seq data
cd ~/[input data directory]/
conda activate [env name]

python /PATH/TO/ScanNeo.py indel -i [sorted RNA bam] -r hg19

# STEP 2: indels annotation using VEP

# install some package to prepare annotation
# conda install -c bioconda perl-bioperl-core
# conda install -c bioconda perl-bundle-bioperl 
# conda update -all (ensembl-vep version must be >= 98)

python /PATH/TO/ScanNeo.py anno -i ['.indel.vcf' file of input] -o ['.vep.vcf' file of input] -r hg19


# STEP 3: neoantigen prediction
# there are two command for it

python /PATH/TO/ScanNeo.py hla -i ['.vep.vcf' file of input] --alleles HLA-A*02:01,HLA-B*08:01,HLA-C*03:03 -p [directory include 'mhc_i folder'] -e 8,9 -o [output tsv file]


python /PATH/TO/ScanNeo.py hla -i ['.vep.vcf' file of input] -b [sorted RNA bam = step1 input] -p [directory include 'mhc_i folder'] -o [output tsv file]




