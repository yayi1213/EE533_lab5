# EE533 Lab 5: 3-Stage Pipeline Processor with RAM

## Overview
This project implements a 3-stage pipeline processor in Verilog with instruction memory (IMEM), data memory (DMEM), and a register file. The processor fetches instructions, decodes operands, and executes memory/write-back operations in a pipelined fashion.

## Architecture

### Pipeline Stages
1. **Fetch (IF)**: Fetch instruction from instruction memory using program counter
2. **Decode (ID)**: Decode instruction and read operands from register file
3. **Memory/Write-Back (MEM/WB)**: Access data memory and write results back to register file

### Key Components
- **Program Counter (PC)**: 9-bit counter that increments each cycle
- **Instruction Memory (IMEM)**: 512-entry × 32-bit memory storing instructions
- **Data Memory (DMEM)**: 256-entry × 64-bit memory for data storage and retrieval
- **Register File**: 64 × 64-bit registers for operand storage

## File Descriptions

| File | Purpose |
|------|---------|
| [pipeline_with_ram.v](pipeline_with_ram.v) | Main processor module implementing the 3-stage pipeline |
| [pipeline_with_ram_tb.v](pipeline_with_ram_tb.v) | Testbench for simulating and monitoring processor execution |
| [imem.v](imem.v) | Instruction memory (ROM), 512 × 32-bit |
| [dmem.v](dmem.v) | Data memory (RAM), 256 × 64-bit |
| [Reg_File.v](Reg_File.v) | Register file with 64 × 64-bit registers |
| [im.txt](im.txt) | Initial instruction memory contents (32-bit hex values) |
| [dm.txt](dm.txt) | Initial data memory contents (64-bit hex values) |

## Instruction Format

Instruction is 32 bits wide with the following encoding:

| Bits | Field | Description |
|------|-------|-------------|
| [31] | WMemEn | Write Memory Enable |
| [30] | WRegEn | Write Register Enable |
| [29:27] | Reg1Addr | Read Register 1 Address (0-7) |
| [26:24] | Reg2Addr | Read Register 2 Address (0-7) |
| [23:21] | WRegAddr | Write Register Address (0-7) |
| [20:0] | Reserved | Unused |

## Pipeline Registers

- **IF_ID_Instr**: Stores instruction fetched in IF stage
- **ID_MEM_R1/R2**: Store operand data and control signals from ID stage
- **MEM_WB_Data**: Stores memory read data and write-back control signals

## How to Run

### Pre-requisites
- Verilog simulator (e.g., Vivado, ModelSim, Icarus Verilog)

### Simulation Steps
1. Compile all Verilog files
2. Run testbench `pipeline_with_ram_tb.v`
3. Observe pipeline execution with cycle-by-cycle register and memory values

### Example Command (Icarus Verilog)
```bash
iverilog -o sim.vvp *.v
vvp sim.vvp
```

## Memory Initialization

- **im.txt**: Contains initial instruction memory values
- **dm.txt**: Contains initial data memory values
- Both files are loaded at simulation start by the respective memory modules

## Sample Test Program
The default im.txt contains a simple test program:
- Instruction 0: Read register operations with write enable
- Instructions 1-5: Sequential memory operations for testing pipeline behavior