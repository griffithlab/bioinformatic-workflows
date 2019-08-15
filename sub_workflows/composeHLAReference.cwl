#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "create reference file using correct HLA alleles from optitype"
requirements:
    - class: SubworkflowFeatureRequirement

inputs:
  hlaAlleles:
    type: File
    doc: optitype HLA predictions
  imgtAlleleList:
    type: File
    doc: mapping between HLA names and IMGT ids available at: ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/Allelelist.3370.txt
  reference:
    type: File
    doc: reference file containing all chromosomes (but no decoys)

outputs:
  hlaReference:
    type: File
    outputSource:
    doc: fasta file with the correct HLA sequence instead of decoys

steps:
  optitype2imgtID:
    run: ../tools/R_optitype2imgt.cwl
    in:
      optitypeCall: hlaAlleles
      imgtAlleleList: imgtAlleleList
    out: [ hlaIMGTID ]
  createHLAFasta:
    run: ../tools/perl_dbfetch_fetchData.cwl
    in:
      imgtIDHLA: optitype2imgtID/hlaIMGTID
    out: [ hlaReference ]
  createHLAReference:
    run: ../tools/ubuntu_cat.cwl
    in:
      HLARef: createHLAFasta/hlaReference
      speciesRef: reference
    out: [ hlaReference ]
