version development

# maintained by Eduardo Maury <eduardo_maury@hms.harvard.edu>


#############################
## Workflow spec
#############################
workflow superfreq {
    input {
        Boolean minimal
        String sample_name
        File input_bam
        File input_bam_index
        File input_vcf
        String output_dir
        String plotting_dir
        String genome_rule = "hg19"
        String mode = "RNA"
        File fasta_ref
        File fasta_ref_idx

        
        # Runtime parameters
        String super_docker = "emauryg/superfreq_eam:0.0.1"
        Int additional_disk_size = 20
        Int machine_gb = 40
        Int cpus = 4

    }

    Float input_size = size(input_bam, "GB")

    if (minimal){
        call run_superFreq_minimal {
            input:
                participant = sample_name,
                bam_in = input_bam,
                bam_idx = input_bam_index,
                vcf_in = input_vcf,
                ref = fasta_ref,
                ref_idx = fasta_ref_idx,
                norm_bams = normal_bams,
                norms_bams_idx = normal_bams_index,
                out_dir = output_dir,
                plot_dir = plotting_dir,
                genome = genome_rule,
                run_mode = mode,
                docker = super_docker,
                disk_size = ceil(input_size*10) + additional_disk_size,
                machine_mem_gb = machine_gb,
                cpus = cpus
        }
    }

    if (!minimal){
        call run_superFreq {
            input:
                participant = sample_name,
                bam_in = input_bam,
                bam_idx = input_bam_index,
                vcf_in = input_vcf,
                ref = fasta_ref,
                ref_idx = fasta_ref_idx,
                norm_bams = normal_bams,
                norms_bams_idx = normal_bams_index,
                out_dir = output_dir,
                plot_dir = plotting_dir,
                genome = genome_rule,
                run_mode = mode,
                docker = super_docker,
                disk_size = ceil(input_size*10) + additional_disk_size,
                machine_mem_gb = machine_gb,
                cpus = cpus
        }

    }

    output {
        Array[File]? superFreq_segments = run_superFreq_minimal.segments_tsv
        File? final_metadata = run_superFreq_minimal.met_file
        Directory? superFreq_out = run_superFreq.output_files
        Directory? superFreq_plots = run_superFreq.plotting_files
        File? final_metadata_full = run_superFreq.met_file
    }


}


#########################
## TASKS
#########################



task run_superFreq {
    input {
        String participant
        File bam_in
        File bam_idx
        File vcf_in
        File ref
        File ref_idx
        String genome
        String run_mode
        String plot_dir
        String out_dir
        Int cpus
        Array[File] norm_bams
        Array[File] norms_bams_idx

        # Runtime parameters
        Int machine_mem_gb
        Int disk_size
        String docker
        Int preemptible_attempts=3
        Int command_mem = machine_mem_gb -1
    }

    command <<<
        set -euo pipefail
        echo -e "BAM\tVCF\tINDIVIDUAL\tNAME\tTIMEPOINT\tNORMAL" >> metadata.tsv
        echo -e "~{bam_in}\t~{vcf_in}\t~{participant}\t~{participant}\tnonDiagnosis\tNO" >> metadata.tsv
        cat metadata.tsv
        mkdir -p ReferenceNormals/bam
        mv ~{sep=' ' norm_bams} ReferenceNormals/bam/
        mv ~{sep=' ' norms_bams_idx} ReferenceNormals/bam/
        mkdir -p ~{out_dir}
        mkdir -p ~{plot_dir}
        Rscript --vanilla /usr/main_superFreq.R --sample ~{participant} \
            --meta metadata.tsv \
            --normal_dir ReferenceNormals \
            --output_dir ~{out_dir} \
            --plot_dir ~{plot_dir} \
            --reference ~{ref} \
            --cpus ~{cpus} \
            --mode ~{run_mode} \
            --genome ~{genome}
    >>>

    runtime {
        docker: docker
        disks: "local-disk " + disk_size + " HDD"
        memory: machine_mem_gb + "GB"
        cpu: cpus
    }

    ## TODO: retain only useful outputs. 

    output {
        Directory output_files = "${out_dir}"
        Directory plotting_files = "${plot_dir}"
        File met_file = "metadata.tsv"
    }
}


task run_superFreq_minimal {
    input {
        String participant
        File bam_in
        File bam_idx
        File vcf_in
        File ref
        File ref_idx
        String genome
        String run_mode
        String plot_dir
        String out_dir
        Int cpus
        Array[File] norm_bams
        Array[File] norms_bams_idx

        # Runtime parameters
        Int machine_mem_gb
        Int disk_size
        String docker
        Int preemptible_attempts=3
        Int command_mem = machine_mem_gb -1
    }

    command <<<
        set -euo pipefail
        echo -e "BAM\tVCF\tINDIVIDUAL\tNAME\tTIMEPOINT\tNORMAL" >> metadata.tsv
        echo -e "~{bam_in}\t~{vcf_in}\t~{participant}\t~{participant}\tnonDiagnosis\tNO" >> metadata.tsv
        cat metadata.tsv
        mkdir -p ReferenceNormals/bam
        mv ~{sep=' ' norm_bams} ReferenceNormals/bam/
        mv ~{sep=' ' norms_bams_idx} ReferenceNormals/bam/
        mkdir -p ~{out_dir}
        mkdir -p ~{plot_dir}
        Rscript --vanilla /usr/main_superFreq.R --sample ~{participant} \
            --meta metadata.tsv \
            --normal_dir ReferenceNormals \
            --output_dir ~{out_dir} \
            --plot_dir ~{plot_dir} \
            --reference ~{ref} \
            --cpus ~{cpus} \
            --mode ~{run_mode} \
            --genome ~{genome}
    >>>

    runtime {
        docker: docker
        disks: "local-disk " + disk_size + " HDD"
        memory: machine_mem_gb + "GB"
        cpu: cpus
    }


    output {
        Array[File] segments_tsv = glob("${plot_dir}/${participant}/data/CNAsegments_*.tsv")
        File met_file = "metadata.tsv"
    }
}