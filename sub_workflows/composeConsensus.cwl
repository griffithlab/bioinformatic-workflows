#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "bam to fastq conversion workflow"
requirements:
    - class: SubworkflowFeatureRequirement

inputs:
  bwaIndex:
    type: File
    secondaryFiles: [ .amb, .ann, .bwt, .pac, .sa ]
    doc: BWA reference index for which to align reads
  bam:
    type: File
    doc: Unaligned bam file for which to align
  reference:
    type: File
    secondaryFiles: [ ^.dict ]
    doc: Reference fasta to use for merging in picard::MergeBamAlignment, should be associated with a picard sequence dictionary
#  FastqToBam_input:
#    type: File[]
#    doc: Array of fastq files for which to convert to bam with UMI (i.e. R1, R2, I1, I2), used in fgbio::FastqToBam
#  FastqToBam_read_structures:
#    type: string
#    doc: The read structure within the reads specifying where the UMI, template, etc. is, used in fgbio::FastqToBam
#  FastqToBam_sample:
#    type: string?
#    default: 'SampleA'
#    doc: Sample name to add to the bam file, used in fgbio::FastqToBam
#  FastqToBam_library:
#    type: string?
#    default: 'LibraryA'
#    doc: Library name to add to the bam file, used in fgbio::FastqToBam
#  FastqToBam_sequencing_center:
#    type: string?
#    default: 'SequencingCenterA'
#    doc: Sequencing center to add to the bam file, used in fgbio::FastqToBam
  GroupReadsByUMI_strategy:
    type: string?
    default: 'adjacency'
    doc: The strategy for grouping UMI in fgbio::GroupReadsByUMI
  GroupReadsByUMI_edits:
    type: string?
    default: '1'
    doc: The number of errors permited in a UMI for grouping in fgbio::GroupReadsByUMI
  GroupReadsByUMI_min_map_q:
    type: string?
    default: '30'
    doc: The minimum mapping quality of a read when evaluating forr grouping in fgbio::GroupReadsByUMI
  CallMolecularConsensus_min_reads:
    type: string?
    default: '1'
    doc: The minimum number of reads for a consensus to be produced in fgbio::CallMolecularConsensus
  FilterConsensus_min_reads:
    type: string?
    default: '3 1 1'
    doc: minimum number of reads supporting a consensus base/read, given as a trio for final consensus, first single-strand consensus, other single-strand consensus in fgbio::FilterConsensusReads
  FilterConsensus_min_base_quality:
    type: string?
    default: '30'
    doc: bases below this value are masked, (annotated as N), in fgbio::FilterConsensusReads
  FilterConsensus_max_base_error_rate:
    type: string?
    default: '.1 .1 .1'
    doc: maximum error rate for a single consensus base, given as a trio for final consensus, first single-strand consensus, other single-strand consensus in fgbio::FilterConsensusReads
  FilterConsensus_max_read_error_rate:
    type: string?
    default: '.025 .025 .025'
    doc: maximum read error rate, given as a trio for final consensus, first single-strand consensus, other single-strand consensus in fgbio::FilterConsensusReads

outputs:
  test:
    type: File
    outputSource: filterConsensus/filteredConsensusBam

steps:
#  fastaIndex:
#    run: ../tools/fastaIndex.cwl
#    in:
#      reference: reference
#    out: [ referenceIndex ]
#  fastaDict:
#    run: ../tools/fastaDict.cwl
#    in:
#      reference: reference
#    out: [ referenceIndex ]
#  bwaIndex:
#    run: ../tools/bwaIndex.cwl
#    in:
#      reference: reference
#    out: [ bwaIndex ]
#  createUMIunmappedBam:
#    run: ../tools/fgbio_FastqToBam.cwl
#    in:
#      input: FastqToBam_input
#      read_structures: FastqToBam_read_structures
#      sample: FastqToBam_sample
#      library: FastqToBam_library
#      sequencing_center: FastqToBam_sequencing_center
#    out: [ UMIunmappedBam ]
  alignUMIBAM:
    run: unalignedBam2dnaAlignment.cwl
    in:
      bwaIndex: bwaIndex
      bam: bam
      reference: reference
    out: [ mergedBam ]
  umiMarkDuplicates:
    run: ../tools/picard_UmiAwareMarkDuplicatesWithMateCigar.cwl
    in:
      input: alignUMIBAM/mergedBam
      assume_sort_order:
        valueFrom: "coordinate"
      remove_sequencing_duplicates:
        valueFrom: "false"
    out: [ umiAwareMrkDup ]
  groupUMIReads:
    run: ../tools/fgbio_GroupReadsByUmi.cwl
    in:
      input: umiMarkDuplicates/umiAwareMrkDup
      strategy: GroupReadsByUMI_strategy
      edits: GroupReadsByUMI_edits
    out: [ groupedByUmi ]
  constructConsensus:
    run: ../tools/fgbio_CallMolecularConsensusReads.cwl
    in:
      input: groupUMIReads/groupedByUmi
      min_reads: CallMolecularConsensus_min_reads
    out: [ consensusBam ]
  alignConsensusBam:
    run: unalignedBam2dnaAlignment.cwl
    in:
      bwaIndex: bwaIndex
      bam: constructConsensus/consensusBam
      reference: reference
    out: [ mergedBam ]
  filterConsensus:
    run: ../tools/fgbio_FilterConsensusReads.cwl
    in:
      input: alignConsensusBam/mergedBam
      ref: reference
      min_reads: FilterConsensus_min_reads
      max_base_error_rate: FilterConsensus_max_base_error_rate
      max_read_error_rate: FilterConsensus_max_read_error_rate
      min_base_quality: FilterConsensus_min_base_quality
    out: [ filteredConsensusBam ]
