# supFreq in the Cloud

## Description 

This repository contains the tools to deploy the superFreq R pipeline in the cloud. 

Briefly, superFreq is a tool by Flanserburg et al. {https://github.com/ChristofferFlensburg/superFreq} that allows for the identification of somatic copynumber alterations (sCNA) in RNA, whole genome, and exome sequencing data. 

Since we wanted to scale up the application of this tool to thousands of samples for RNA sequencing we decided to create docker containers and WDL files that would allow for efficient deployment in cloud environments. 

For our use case we deployed our pipeline on Terra through Google Cloud Platform, but it could be generalizable as long as your cloud system is able to use docker and read WDL files through Cromwell. 


## Workflow

The main files you need besides the genome reference files are
* Aligned bam files with their indices for your cohort
* Choose 2-10 samples from your cohort (stored in a different bucket location than the rest of your sample labeled as "path/to/directory/ReferenceNormals/bams/)". 

See the the `sample_wdl_inputs` folder for example of input files taken by each of the WDL files described here. 

Steps:

1. Varscan
Run the varscan wdl (`varscan_eam.wdl`) on each bam file in the cohort, which generates a very raw set of variants for each sample. See `sample_wdl_inputs/varscan_inputs.json` for sample inputs. Optional commands are left blank. The suggested memory and cpu requirements seemed to work well for most samples tested in practice, but feel free to optimize to reduce cost. 

2. superFreq
Run the superFreq wdl (`superfreq.wdl`) on each bam file in the cohort. 

The default mode to run superFreq is RNA mode, but you can change the `mode` input to "exome" or "genome" depending in your needs. Similarly, you can adjust the reference genome build using the `rule` input ("hg19","hg38"). 

Another useful parameter is the `minimal` parameter, which you can set to "true" or "false", which indicates whether you just want as the output just the segment file with your potential sCNA or if you want the full output of superFreq which includes diagnostic plots, as well as all the output described here {https://github.com/ChristofferFlensburg/superFreq}. 

For memory and cpu requiremements I noticed that following the recommendations of Flensburg et al works relatively well for most sample but some optimization can be done depending on your use case:

* RNA-Seq: 2-4 cpus ( ~10GB memory per cpu typically enough)
* exome: 4-6 cpus (~15GB memory per cpu typically enough)
* genome: 10-20 cpus ( ~20GB memory per cpu typically enough)

One of the most expensive steps is the localization of the reference normal samples, which you can choose to be from either 2-10 samples, but for RNA sequence we recommend 10 to make sure we remove as much technical artifact as possible. 


### TODO:
- We are currently setting up a link to a public Terra workspace where all these scripts will be deposited and easily run with their API. 
