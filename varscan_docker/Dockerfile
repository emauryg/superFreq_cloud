## Dockerfile for varscan by Eduardo Maury <eduardo_maury@hms.harvard.edu>
# ## based on alexcoppe https://github.com/alexcoppe/bio-dockers/blob/master/varscan/Dockerfile

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
	&& rm -rf /var/lib/apt/lists/*

ENV version 2.4.2
ADD https://github.com/dkoboldt/varscan/raw/master/VarScan.v${version}.jar /opt

RUN cd /opt/ && mv /opt/VarScan.v${version}.jar /opt/VarScan.jar

# set path:
ENV PATH=/usr/local/bin/samtools/:$PATH
