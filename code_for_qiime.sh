
# make list of files

cd 16s_rRNA_DATA
ls *.gz | cut -f 1 -d . > list.txt
mkdir 16s_rRNA_DATA/Merged_Reads

## run join_paired_ends.py ##

# with for loops & list.txt
# referense script is followed link
# wget raw.githubusercontent.com/edamame-course/Amplicon_Analysis/master/resources/Merged_Reads_Script.sh


for x in $(<list.txt)
do
    join_paired_ends.py -f ${x%.R1.fq.gz}.R1.fq.gz -r ${x%.R2.fq.gz}.R2.fq.gz -o ./${x} -j 40 -p 75
    mv ${x}/fastqjoin.join.fastq Merged_Reads/${x}_merged.fastq
    convert_fastaqual_fastq.py -c fastq_to_fastaqual -f Merged_Reads/${x}_merged.fastq -o Merged_Reads/${x}
    mv Merged_Reads/${x}/${x}_merged.fna Merged_Reads/${x}_merged.fasta
    rm -r Merged_Reads/${x}
    rm Merged_Reads/${x}_merged.fastq
    rm -r ${x}/
done


# compare with upper one
# (add trimming process)
# wget https://github.com/najoshi/sickle/archive/master.zip
# unzip master.zip
# cd sickle_master
# make
# sudo mv sickle /usr/bin/sickle
# cd /home/qiime/16s_rRNA_DATA

for x in $(<list.txt)
do
    join_paired_ends.py -f ${x%.R1.fq.gz}.R1.fq.gz -r ${x%.R2.fq.gz}.R2.fq.gz -o ./${x} -j 40 -p 75
    sickle se -t sanger -f ./${x}/fastqjoin.join.fastq -o $x.ice.fastq -l 25
    mv $x.ice.fastq Merged_Reads/${x}_merged.fastq
    convert_fastaqual_fastq.py -c fastq_to_fastaqual -f Merged_Reads/${x}_merged.fastq -o Merged_Reads/${x}
    mv Merged_Reads/${x}/${x}_merged.fna Merged_Reads/${x}_merged.fasta
    rm -r Merged_Reads/${x}
    rm Merged_Reads/${x}_merged.fastq
    rm -r ${x}/
done


## 







