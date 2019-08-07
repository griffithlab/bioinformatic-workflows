#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "Paired Fastq to filtered HLA Reads"
requirements:
    - class: SubworkflowFeatureRequirement
    - class: MultipleInputFeatureRequirement
    - class: StepInputExpressionRequirement

inputs:
  fastq:
    type: File
    doc: fastq file for which to filter to HLA candidate reads (must only pass 1 fastq at a time if paired)
  reference:
    type: File
    doc: Reference to use to screen for DNA/RNA HLA reads, This should come from optitypes repo @https://github.com/FRED-2/OptiType/tree/master/data

outputs:
  CandidateHLAFastq:
    type: File
    outputSource: filterScreen/fastqFile

steps:
  fastaHLADNAIndex:
    run: ../tools/bwa_index.cwl
    in:
      reference: reference
    out: [ referenceIndex ]
    doc: index the HLA DNA fasta from optitype
  alignScreeen:
    run: ../tools/bwa_mem.cwl
    in:
      reference: fastaHLADNAIndex/referenceIndex
      fastq: [ fastq ]
    out: [ sam_alignment ]
    doc: screen the fastq for HLA reads with a bwa mem alignment
  filterScreen:
    run: ../tools/samtools_fastq.cwl
    in:
      sam_file: alignScreeen/sam_alignment
      filter_flag:
        valueFrom: "-F 4"
    out: [ fastqFile ]
    doc: Keep only the aligned reads
