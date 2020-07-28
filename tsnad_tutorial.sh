
# Install TSNAD

docker pull biopharm/tsnad:v2.0

# Usage

docker run -it -v /home/y/docker/TSNAD_tutorial/WES_data:/home/tsnad/samples -v /home/y/docker/TSNAD_tutorial/RNA_data:/home/tsnad/RNA-seq -v /home/y/docker/TSNAD_tutorial/Output:/home/tsnad/results biopharm/tsnad:v2.0 /bin/bash
