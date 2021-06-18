# largely based on rocker r-base image and MosaicForecast image

FROM ubuntu:18.04

# Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
		ed \
		less \
		locales \
		vim-tiny \
		wget \
		ca-certificates \
		apt-transport-https \
		gsfonts \
		gnupg2 \
		bzip2 \
		gcc \
		git \
		libncurses-dev \
		make \
		time \
		unzip \
		vim \
		zlib1g-dev \
		liblz4-tool \
		libxt6 \
		libxml2-dev \
        samtools \
        openjdk-8-jdk \
        tar \
        libboost-iostreams-dev \
        libboost-program-options-dev \
        libboost-thread-dev \
        libbz2-dev \
		libssl-dev \
        libhts-dev \
	&& rm -rf /var/lib/apt/lists/*


RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3.6.7 \
    && conda config --add channels bioconda \
    # && conda install pysam==0.15.2 -y \
    # && conda install numpy==1.16.1 -y \
    # && conda install pandas -y \
    # && conda install pyfaidx==0.5.3 -y \
    # && conda install pysamstats==1.1.2 -y \
    # && conda install regex -y \
    # && conda install scipy==1.2.1 -y \
    && conda update conda \
    # && conda install bedtools==2.25.0 \
    # && conda install vcftools \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes

RUN conda install -y -c conda-forge r-base=4.0.3 

ENV PATH /opt/conda/bin:$PATH
ENV TAR /bin/tar
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN R -e 'install.packages("BiocManager")'
RUN R -e 'BiocManager::install("GenomeInfoDb")'
RUN R -e 'BiocManager::install("GenomicFeatures")'
RUN R -e 'BiocManager::install("VariantAnnotation")'
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_version("RSQLite",version="2.2.4",updgrade=TRUE)'
RUN R -e 'BiocManager::install("BSgenome.Hsapiens.UCSC.hg19", update=FALSE)'
RUN R -e 'BiocManager::install("BSgenome.Hsapiens.UCSC.hg38", update=FALSE)'
RUN R -e 'BiocManager::install("BSgenome.Mmusculus.UCSC.mm10", update=FALSE)'
RUN R -e 'install.packages("optparse")'
RUN R -e 'install.packages("devtools")'
RUN R -e 'install.packages("tidyverse")'
# RUN R -e 'library(RSQLite); user_lib <- Sys.getenv("R_LIBS_USER"); message("user_lib= ", user_lib); devtools::install_github("ChristofferFlensburg/superFreq", force=FALSE,updgrade =  FALSE, lib=user_lib)'
RUN R -e 'remotes::install_github("ChristofferFlensburg/superFreq", upgrade=FALSE)'

# set path:
ENV PATH=/usr/local/bin/samtools/:$PATH

# download other tools
# WORKDIR /usr/local/bin
# COPY downloads_docker.sh .
# RUN . downloads_docker.sh

# 7. wrapper
COPY . /usr/