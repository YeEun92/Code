

# Step 1) ncbi homepage에서 SRP____ 클릭하여 all run 텍스트 파일 다운로드 & file 위치를 위해서 폴더 옮김

mv Downloads/SRR_Acc_List.txt ncbi/public/[listname].txt 
cd ncbi/public

# Step 2) txt file을 바탕으로 전체 SRR file download

parallel -j 1 prefetch {} ::: $(cat [listname].txt)

# Step 3) convert to FASTQ

parallel -j 1 fastq-dump --skip-technical -F --split-files -O [directory] {} ::: $(cat [listname].txt)



## 김상수교수님 강의 tutorial

https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=SRR490124
