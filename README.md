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