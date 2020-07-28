
### install docker

# 1. install using default repositary

# sudo apt-get install docker.io
# sudo systemctl start docker
# sudo systemctl enable docker

# 2. install latest version

# sudo apt-get update
# sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo apt-get update
# sudo apt-get install docker-ce

sudo docker run -v /home/y/docker/example_data_dir:/pvacseq_example_data \
   -v /home/y/docker/output_dir:/pvacseq_output_data -it griffithlab/pvactools

# run pVACseq command

pvacseq run \
/pvacseq_example_data/input.vcf \
Test \
HLA-A*02:01,HLA-B*35:01,DRB1*11:01 \
MHCflurry MHCnuggetsI MHCnuggetsII NNalign NetMHC PickPocket SMM SMMPMBEC SMMalign \
/pvacseq_output_data \
-e 8,9,10 --iedb-install-directory /opt/iedb


# run pVACseq command ( modify )

pvacseq run \
/pvacseq_example_data/input.vcf \
Test \
HLA-A*02:01,DRB1*11:01 \
MHCflurry MHCnuggetsI MHCnuggetsII NNalign NetMHC PickPocket SMM SMMPMBEC SMMalign \
/pvacseq_output_data \
-e 8,9,10 --iedb-install-directory /opt/iedb

