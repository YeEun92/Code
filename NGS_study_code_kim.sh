

#### for NGS 강의 - 김상수 교수님 ####

## download fastq file - SRR490124

fastq-dump --split-files SRR490124.sra 

## fasqt quality control

# Install fastqc - sequence quality control program from fastq file

wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
unzip fastqc_v0.11.9.zip 
cd FastQC/
chmod +x fastqc
sudo apt-get install default-jre

# usage fastqc program
./fastqc

## trimming process

# install ngsShoRT - trimming program using perl script

cd ~/tools/
wget https://research.bioinformatics.udel.edu/genomics/ngsShoRT/download/ngsShoRT_2.2.tar.gz

sudo perl -MCPAN -e shell
install CPAN
reload CPAN
install String::Approx
install PerlIO::gzip

tar -xzvf ngsShoRT_2.2.tar.gz 

# usage ngsShoRT

perl ngsShoRT.pl -pe1 ~/ncbi/public/sra/SRR490124_1.fastq  -pe2 ~/ncbi/public/sra/SRR490124_2.fastq -o ~/Data/ngsShoRT -methods lqr_5adpt_tera -t 2






