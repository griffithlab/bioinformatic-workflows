#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "Convert a single sample FASTQ (r1, r2, i1, i2) with UMIs to a consensus bam"

inputs:
  reference:
    type: File
    doc: Reference fasta to use for merging in picard::MergeBamAlignment
  FastqToBam_input:
    type: File[]
    doc: Array of fastq files for which to convert to bam with UMI (i.e. R1, R2, I1, I2), used in fgbio::FastqToBam
  FastqToBam_read_structures:
    type: string[]
    doc: The read structure within the reads specifying where the UMI, template, etc. is, used in fgbio::FastqToBam
  FastqToBam_sample:
    type: string?
    default: 'SampleA'
    doc: Sample name to add to the bam file, used in fgbio::FastqToBam
  FastqToBam_library:
    type: string?
    default: 'LibraryA'
    doc: Library name to add to the bam file, used in fgbio::FastqToBam
  FastqToBam_sequencing_center:
    type: string?
    default: 'SequencingCenterA'
    doc: Sequencing center to add to the bam file, used in fgbio::FastqToBam
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
    type: string[]?
    default: ['3', '1', '1']
    doc: minimum number of reads supporting a consensus base/read, given as a trio for final consensus, first single-strand consensus, other single-strand consensus in fgbio::FilterConsensusReads
  FilterConsensus_min_base_quality:
    type: string?
    default: '30'
    doc: bases below this value are masked, (annotated as N), in fgbio::FilterConsensusReads
  FilterConsensus_max_base_error_rate:
    type: string[]?
    default: ['.1', '.1', '.1']
    doc: maximum error rate for a single consensus base, given as a trio for final consensus, first single-strand consensus, other single-strand consensus in fgbio::FilterConsensusReads
  FilterConsensus_max_read_error_rate:
    type: string[]?
    default: ['.025', '.025', '.025']
    doc: maximum read error rate, given as a trio for final consensus, first single-strand consensus, other single-strand consensus in fgbio::FilterConsensusReads

outputs:
  rawAlignedBamFile:
    type: File
    outputSource: createConsensus/rawAlignedBamFile
  mrkDupMetrics:
    type: File
    outputSource: createConsensus/mrkDupMetrics
  mrkDupUMIMetrics:
    type: File
    outputSource: createConsensus/mrkDupUMIMetrics
  consensusBamFile:
    type: File
    outputSource: createConsensus/consensusBamFile
  consensusBamRejects:
    type: File
    outputSource: createConsensus/consensusBamRejects
  consensusFilteredBamFile:
    type: File
    outputSource: createConsensus/consensusFilteredBamFile

steps:
  createUMIunmappedBam:
    run: ../tools/fgbio_FastqToBam.cwl
    in:
      input: FastqToBam_input
      read_structures: FastqToBam_read_structures
      sample: FastqToBam_sample
      library: FastqToBam_library
      sequencing_center: FastqToBam_sequencing_center
    out: [ UMIunmappedBam ]
  createConsensus:
    run: ../sub_workflows/composeConsensus.cwl
    in:
      bam: createUMIunmappedBam/UMIunmappedBam
      reference: reference
      GroupReadsByUMI_strategy: GroupReadsByUMI_strategy
      GroupReadsByUMI_edits: GroupReadsByUMI_edits
      GroupReadsByUMI_min_map_q: GroupReadsByUMI_min_map_q
      CallMolecularConsensus_min_reads: CallMolecularConsensus_min_reads
      FilterConsensus_min_reads: FilterConsensus_min_reads
      FilterConsensus_min_base_quality: FilterConsensus_min_base_quality
      FilterConsensus_max_base_error_rate: FilterConsensus_max_base_error_rate
      FilterConsensus_max_read_error_rate: FilterConsensus_max_read_error_rate
    out: [rawAlignedBamFile, mrkDupMetrics, mrkDupUMIMetrics, consensusBamFile, consensusBamRejects, consensusFilteredBamFile]
