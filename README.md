# Single-Cycle RISC-V Processor

A fully functional single-cycle RISC-V (RC32I) processor implemented in Verilog, targeting Xilinx Artix-7 Basys3 FGPA board.

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)

## Overview

A hardware implementation of a **RISC-V (RV32I)** processor designed in Verilog HDL. This project targets the **Digilent Basys3 (Xilinx Artix-7)** FPGA board, featuring a 7-segment display. 

The "Single-Cycle" architecture means that the every instruction - Fetch, Decode, Execute, Memory Access and Write-back - is performed within one clock cycle. 

## Key Features

- **Instruction set**: Supports full RV32I instruction set (R, I, S, B, U, J types).
- **Hardware Implementation**: Optimized for FGPA sysnthsis using Vivado.
- **Visual Output** Shows the output on the 7-segment diplay in Hexadecimal Encoding.
- **Verification**: Working verified with unit testbenches.

## Architechture

![RISC-V Architechture](images/RISCV_blockDiagram.jpeg)

