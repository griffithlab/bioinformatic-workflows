#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerImageId: humanlongevity/hla:0.0.0
  - class: ResourceRequirement
    ramMin: 20000
    coresMin: 8

baseCommand: [ "kallisto", "quant" ]
