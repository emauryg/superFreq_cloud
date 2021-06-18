version 1.0

# maintained by Eduardo Maury <eduardo_maury@hms.harvard.edu>
## Run varscan on a sample

#############################
## Workflow spec
#############################

workflow super_freq {
    input {
        String sample_name
        File input_bam
        File input_bam_index
        File fasta_ref
        File fasta_ref_idx
        
        String varscan_docker = "emauryg/varscan:0.0.1"
        Int additional_disk_size = 20
        Int machine_gb = 60

    }

    Float input_size = size(input_bam, "GB")

    call run_varscan {
        input:
            bam_in = input_bam,
            bam_idx = input_bam_index,
            prefix = sample_name,
            ref = fasta_ref,
            ref_idx = fasta_ref_idx,
            docker = varscan_docker,
            disk_size = ceil(input_size*3) + additional_disk_size,
            machine_mem_gb = machine_gb
    }

    output {
        File varscan_out = run_varscan.out_table
    }
}


task run_varscan {
    input {
        File bam_in
        File bam_idx
        String prefix
        File ref
        File ref_idx

        # Runtime parameters
        Int machine_mem_gb
        Int disk_size
        String docker
        Int preemptible_attempts=3
        Int command_mem = machine_mem_gb - 1
    }

    command <<<
        set -euo pipefail
        samtools mpileup -d 10000 -q 1 -Q 15 -A -f ~{ref} ~{bam_in} | \
        java -Xmx~{command_mem}G -jar /opt/VarScan.jar mpileup2cns --variants --strand-filter 0 \
        --p-value 0.01 --min-var-freq 0.01 --output-vcf > ~{prefix}.varscan.vcf
    >>>

    runtime {
        docker: docker
        disks: "local-disk " + disk_size + " HDD"
        memory: machine_mem_gb + "GB"
    }

    output {
        File out_table = prefix + ".varscan.vcf"
    }

}