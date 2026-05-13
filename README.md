# Single-Cycle RISC-V Processor

## Overview

A hardware implementation of a **RISC-V (RV32I)** processor designed in Verilog HDL. This project targets the **Digilent Basys3 (Xilinx Artix-7)** FPGA board, featuring a 7-segment display. 
The "Single-Cycle" architecture means that the entire lifecycle of an instruction - from finding it in memory to performing the math and saving the result - happens in one single clock cycle. This project serves as a physical demonstration of how software commands are translated into electrical signals and logic gate operations.

## Key Features

- **Instruction set**: Supports full RV32I instruction set (R, I, S, B, U, J types).
- **Hardware Implementation**: Optimized for FGPA sysnthsis using Vivado.
- **Visual Output** Shows the output on the 7-segment diplay in Hexadecimal Encoding.
- **Verification**: Working verified with unit testbenches.
