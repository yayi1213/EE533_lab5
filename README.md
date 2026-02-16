# EE533 Lab 5: Pipeline Architecture

A Verilog implementation of a CPU pipeline without RAM, featuring instruction memory, data memory, and register file components.

## Project Structure

### Core Modules

- **pipeline_no_ram.v** - Main pipeline processor module implementing the core execution pipeline
- **Reg_File.v** - Register file implementation for CPU registers
- **imem.v** - Instruction memory (ROM) for storing and retrieving instructions
- **dmem.v** - Data memory (RAM) for load/store operations

### Testbenches
- **tb_latest.v** - Additional testbench implementation

## Getting Started

### Prerequisites

- Verilog compiler (e.g., Icarus Verilog, ModelSim, or similar)
- Simulation environment

### Running Simulations

To simulate the pipeline:

```bash
# Using Icarus Verilog (example)
iverilog -o sim pipeline_no_ram.v Reg_File.v imem.v dmem.v pipeline_no_ram_tb.v
vvp sim
```

## Architecture Overview

This project implements a pipelined CPU architecture with the following components:

- **Instruction Memory**: Stores instruction code
- **Register File**: Manages CPU registers
- **Data Memory**: Handles data storage and retrieval
- **Pipeline Logic**: Implements instruction fetch, decode, execute, and write-back stages

## File Descriptions

| File | Purpose |
|------|---------|
| pipeline_no_ram.v | Main pipeline core |
| Reg_File.v | Register file  |
| imem.v | Instruction ROM |
| dmem.v | Data RAM |
| tb_latest.v | Test harness |

## Notes

- This implementation does not use external RAM modules
- All memory structures are implemented internally
- Testbenches verify correct pipeline operation and data flow

## Author

EE533 Lab 5
