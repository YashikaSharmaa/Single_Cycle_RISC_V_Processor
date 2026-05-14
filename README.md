# Single-Cycle RISC-V Processor

A fully functional single-cycle RISC-V (RC32I) processor implemented in Verilog, targeting Xilinx Artix-7 Basys3 FGPA board.

## Table of Contents

- [Overview](#overview)
- [Architechture](#architechture)

## Overview

A hardware implementation of a **RISC-V (RV32I)** processor designed in Verilog HDL. This project targets the **Digilent Basys3 (Xilinx Artix-7)** FPGA board, featuring a 7-segment display. 

The "Single-Cycle" architecture means that the every instruction - Fetch, Decode, Execute, Memory Access and Write-back - is performed within one clock cycle. 

## Architechture

![RISC-V Architechture](images/RISCV_blockDiagram.jpeg)

## Instruction Set

### R-type (Register Type, opcode 0110011)
Arithmatic and Logic Operation

| Instruction | Operation |
|-------------|-----------|
| `add`  | rd = rs1 + rs2 |
| `sub`  | rd = rs1 − rs2 |
| `and`  | rd = rs1 & rs2 |
| `or`   | rd = rs1 \| rs2 |
| `xor`  | rd = rs1 ^ rs2 |
| `sll`  | rd = rs1 << rs2[4:0] |
| `srl`  | rd = rs1 >> rs2[4:0] (logical) |
| `sra`  | rd = rs1 >> rs2[4:0] (arithmetic) |
| `slt`  | rd = (rs1 < rs2) signed ? 1 : 0 |
| `sltu` | rd = (rs1 < rs2) unsigned ? 1 : 0 |

### I-type (Immediate type, opcode 0010011)
Immediate Arithmatic and Logic Operation

| Instruction | Operation |
|-------------|-----------|
| `addi`  | rd = rs1 + imm |
| `andi`  | rd = rs1 & imm |
| `ori`   | rd = rs1 \| imm |
| `xori`  | rd = rs1 ^ imm |
| `slti`  | rd = (rs1 < imm) signed ? 1 : 0 |
| `slli`  | rd = rs1 << shamt |
| `srli`  | rd = rs1 >> shamt (logical) |
| `srai`  | rd = rs1 >> shamt (arithmetic) |

### Load / Store

| Instruction | Operation |
|-------------|-----------|
| `lw` | rd = mem[rs1 + imm] (32-bit word) |
| `sw` | mem[rs1 + imm] = rs2 |

### Branch (opcode `1100011`)
 
| Instruction | Condition |
|-------------|-----------|
| `beq`  | branch if rs1 == rs2 |
| `bne`  | branch if rs1 != rs2 |
| `blt`  | branch if rs1 < rs2 (signed) |
| `bge`  | branch if rs1 >= rs2 (signed) |

### Jumps and Upper Immediates
 
| Instruction | Operation |
|-------------|-----------|
| `jal`   | rd = PC+4; PC = PC + J-imm |
| `jalr`  | rd = PC+4; PC = (rs1 + I-imm) & ~1 |
| `lui`   | rd = imm << 12 |
| `auipc` | rd = PC + (imm << 12) |

---

## File structure

```
Single_Cycle_RISV_V_Processor/
+-- Constraint_Files
+-- Source_Files
+-- TestBenches
+-- VCDFiles
+-- images
+-- README.md
``` 
