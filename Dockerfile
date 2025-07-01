FROM satijalab/seurat:5.0.0

RUN apt-get update && apt-get install -y \
    curl \
    software-properties-common \
    dirmngr \
    gpg \
    curl \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    make \
    cmake \
    gfortran \
    libxt-dev \
    liblapack-dev \
    libblas-dev \
    sudo \
    wget \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Install JupyterLab
RUN apt-get update && apt-get install -y \
    python3-pip python3-dev curl libzmq3-dev \
    && pip3 install --no-cache-dir jupyterlab notebook \
    && Rscript -e "install.packages('IRkernel', repos='https://cloud.r-project.org'); IRkernel::installspec(user = FALSE)"

# BiocManager
RUN R -e "if (!requireNamespace('BiocManager', quietly = TRUE))" \
    R -e "install.packages('BiocManager')" 

# Install various packages
RUN R -e "BiocManager::install('tidyverse')" 
RUN R -e "install.packages(c('openai', 'enrichR', 'pachwork'))" 
RUN R -e "remotes::install_github('Winnie09/GPTCelltype')" 
RUN R -e "remotes::install_github('immunogenomics/presto')"





RUN mkdir 0_notes 
RUN R -e "write.csv(installed.packages(), file = '/0_notes/maiolino_doc_v3_installed_packages.csv')"

ENV SHELL=/bin/bash
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.allow_origin='*'", "--ServerApp.token=''"]