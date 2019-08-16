#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "hla typing workflow"
requirements:
  - class: SubworkflowFeatureRequirement

inputs:
  bam:
    type: File
    doc: Bam file to make HLA predictions from
  hla_reference:
    type: File
    doc: HLA reference to use for pre-filtering reads
  imgtAlleleList:
    type: File
    doc: 'mapping between HLA names and IMGT ids available at: ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/Allelelist.3370.txt'
  reference:
    type: File
    doc: reference file containing all chromosomes, for competitive alignment (but no decoys)

outputs:
  optitype_graph_out:
    type: File
    outputSource: optitype/optitype_graph
  optitype_prediction_out:
    type: File
    outputSource: optitype/optitype_prediction
  alignment:
    type: File
    outputSource: alignHLAReads/MergedAlignedBam
  referenceIndex:
    type: File
    outputSource: bwaIndex/referenceIndex

steps:
  bam2fastq:
    run: ../sub_workflows/bam2fastq.cwl
    in:
      bam: bam
    out: [fastq1, fastq2]
  optitypePreFilterR1:
    run: ../sub_workflows/optitypePreFilter.cwl
    in:
      fastq: bam2fastq/fastq1
      reference: hla_reference
    out: [ CandidateHLAFastq ]
  optitypePreFilterR2:
    run: ../sub_workflows/optitypePreFilter.cwl
    in:
      fastq: bam2fastq/fastq2
      reference: hla_reference
    out: [ CandidateHLAFastq ]
  optitype:
    run: ../tools/optitype.cwl
    in:
      fastq1: optitypePreFilterR1/CandidateHLAFastq
      fastq2: optitypePreFilterR2/CandidateHLAFastq
    out: [ optitype_prediction, optitype_graph ]
  HLACandidateReadFilter:
    run: ../sub_workflows/readnameFilter.cwl
    in:
      bam: bam
      fastq1: optitypePreFilterR1/CandidateHLAFastq
      fastq2: optitypePreFilterR2/CandidateHLAFastq
    out: [ readnameFilteredBam ]
  composeHLAReference:
    run: ../sub_workflows/composeHLAReference.cwl
    in:
      hlaAlleles: optitype/optitype_prediction
      imgtAlleleList: imgtAlleleList
      reference: reference
    out: [ hlaReference ]
  bwaIndex:
    run: ../tools/bwa_index.cwl
    in:
      reference: composeHLAReference/hlaReference
    out: [ referenceIndex ]
  alignHLAReads:
    run: ../sub_workflows/unalignedBam2dnaAlignment_v2.cwl
    in:
      bwaIndex: bwaIndex/referenceIndex
      bam: HLACandidateReadFilter/readnameFilteredBam
    out: [ MergedAlignedBam ]
