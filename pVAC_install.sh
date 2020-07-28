
# Install pVACtools directly
# do must conda environment, python 3.x

# Need some prepare that official do not describes

sudo apt-get install libbz2-dev
conda install -c bioconda pysam

# if have some error, 
# try this
# conda create -n [env_name] python=3.7 pysam=0.9.0

# install

pip install pvactools

# check version

pip list

# if you wanna upgrade

pip install pvactools --upgrade

# Installing IEDB binding prediction tools

conda deactivate

cd tools

sudo apt-get update
sudo apt-get install -y tcsh gawk
wget https://downloads.iedb.org/tools/mhci/2.19.2/IEDB_MHC_I-2.19.2.tar.gz
cd mhc_i
./configure

cd ~/tools

wget https://downloads.iedb.org/tools/mhcii/2.17.6/IEDB_MHC_II-2.17.6.tar.gz
tar -zxcf IEDB_MHC_II-2.17.6.tar.gz
cd mhc_ii
./configure.py

# Install MHCflurry

pip install mhcflurry
mhcflurry-download fetch
mhcflurry-predict -h

pip install tensorflow==1.15.0





