#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "compose a consensus sequence from a UMI tagged bam file"
requirements:
    - class: SubworkflowFeatureRequirement

inputs:
  bam:
    type: File
    doc: Unaligned bam file for which to align
  reference:
    type: File
    doc: Reference fasta to use for merging in picard::MergeBamAlignment
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
    outputSource: alignUMIBAM/MergedAlignedBam
  mrkDupMetrics:
    type: File
    outputSource: umiMarkDuplicates/mrkDupMetrics
  mrkDupUMIMetrics:
    type: File
    outputSource: umiMarkDuplicates/umiMrkDupMetrics
  consensusBamFile:
    type: File
    outputSource: alignConsensusBam/MergedAlignedBam
  consensusBamRejects:
    type: File
    outputSource: constructConsensus/consensusRejectsBam
  consensusFilteredBamFile:
    type: File
    outputSource: indexFilteredConsensusBam/bam_index

steps:
  fastaIndex:
    run: ../tools/samtools_faidx.cwl
    in:
      reference: reference
    out: [ referenceIndex ]
  createReferenceDict:
    run: ../tools/picard_CreateSequenceDictionary.cwl
    in:
      reference: reference
    out: [ referenceDict ]
  bwaIndex:
    run: ../tools/bwa_index.cwl
    in:
      reference: reference
    out: [ referenceIndex ]
  alignUMIBAM:
    run: unalignedBam2dnaAlignment.cwl
    in:
      bwaIndex: bwaIndex/referenceIndex
      bam: bam
      reference: createReferenceDict/referenceDict
    out: [ MergedAlignedBam ]
  umiMarkDuplicates:
    run: ../tools/picard_UmiAwareMarkDuplicatesWithMateCigar.cwl
    in:
      input: alignUMIBAM/MergedAlignedBam
      assume_sort_order:
        valueFrom: "coordinate"
      remove_sequencing_duplicates:
        valueFrom: "false"
    out: [ umiAwareMrkDupBam, umiMrkDupMetrics, mrkDupMetrics ]
  groupUMIReads:
    run: ../tools/fgbio_GroupReadsByUmi.cwl
    in:
      input: umiMarkDuplicates/umiAwareMrkDupBam
      strategy: GroupReadsByUMI_strategy
      edits: GroupReadsByUMI_edits
    out: [ groupedByUmi ]
  constructConsensus:
    run: ../tools/fgbio_CallMolecularConsensusReads.cwl
    in:
      input: groupUMIReads/groupedByUmi
      min_reads: CallMolecularConsensus_min_reads
    out: [ consensusBam, consensusRejectsBam ]
  alignConsensusBam:
    run: unalignedBam2dnaAlignment.cwl
    in:
      bwaIndex: bwaIndex/referenceIndex
      bam: constructConsensus/consensusBam
      reference: createReferenceDict/referenceDict
    out: [ MergedAlignedBam ]
  filterConsensus:
    run: ../tools/fgbio_FilterConsensusReads.cwl
    in:
      input: alignConsensusBam/MergedAlignedBam
      ref: fastaIndex/referenceIndex
      min_reads: FilterConsensus_min_reads
      max_base_error_rate: FilterConsensus_max_base_error_rate
      max_read_error_rate: FilterConsensus_max_read_error_rate
      min_base_quality: FilterConsensus_min_base_quality
    out: [ filteredConsensusBam ]
  indexFilteredConsensusBam:
    run: ../tools/bam_index.cwl
    in:
      bam_file: filterConsensus/filteredConsensusBam
    out: [ bam_index ]
