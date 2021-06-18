#!/usr/bin/env Rscript


#first install superFreq if running first time
#load devtools that allows installation from github (may need to install devtools first with install.packages("devtools"))
library(devtools)

#there are sometimes conflicts between the github install and bioconductor in different version
#so safer to manually install bioconductor dependencies.
# if (!requireNamespace("BiocManager", quietly = TRUE))
#     install.packages("BiocManager")
# BiocManager::install()
# BiocManager::install("GenomeInfoDb")
# BiocManager::install("GenomicFeatures")
# BiocManager::install("VariantAnnotation")

# #then install superFreq
# install_github('ChristofferFlensburg/superFreq')
library("optparse")

library(superFreq)

## Inputs should be
##  - metadata

## Usage: Rscript --vanilla main_superFreq <inputs>

option_list = list(
    make_option("--sample", type="character",default=NULL,help="sample name",metavar="character"),
    make_option("--meta", type="character", default=NULL, help ="metadata file", metavar="character"),
    make_option("--normal_dir", type="character", default=NULL, help="reference normal directory", metavar="character"),
    make_option("--output_dir", type="character",default="./",help="directory where results will be saved",metavar="character"),
    make_option("--plot_dir", type="character",default="./",help="directory where plots will be saved",metavar="character"),
    make_option("--regions",type="character",default=NULL, help="link capture regions, it can also be all exons in the genome instead", metavar="character"),
    make_option("--reference",type="character",default=NULL,help="reference genome",metavar="character"),
    make_option("--cpus",type="numeric", default=1, help="cpus to use",metavar="numeric"),
    make_option("--mode", type="character", default="RNA", help="RNA or exome",metavar="character"),
    make_option("--genome", type="character", default="hg19", help="hg19 or hg38", metavar="character")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)
participant= opt$sample
genome = opt$genome
normalDirectory = opt$normal_dir
Rdirectory = opt$output_dir
plotDirectory = opt$plot_dir
captureRegionsFile = opt$regions
reference = opt$reference
cpus=opt$cpus
mode = opt$mode

metaDataFile = opt$meta


## If meta file is not provided then we can create our own metafile from the inputs given

data = superFreq(metaDataFile = metaDataFile, normalDirectory=normalDirectory,
                Rdirectory=Rdirectory, plotDirectory= plotDirectory, reference=reference,
                genome=genome, cpus=cpus, mode=mode)

