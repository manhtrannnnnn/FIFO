# FIFO Design and Implementation

## Overview

This project focuses on the **design and implementation** of **FIFO (First-In-First-Out)** buffers, which are critical components in digital systems for managing data flow between processes or modules. The project consists of two types of FIFO designs:

1. **Synchronous FIFO**: Operates within a single clock domain.
2. **Asynchronous FIFO**: Handles communication between two different clock domains.

Both FIFO designs have been implemented in Verilog and verified through simulation. The project leverages **Icarus Verilog** for simulation and **GTKWave** for waveform analysis, ensuring correctness and functionality.

---

## Project Structure

```plaintext
FIFO-Design/
├── synchronous_fifo/       # RTL design files for Synchronous FIFO
│   ├── rtl/                # RTL design files
│   ├── verification/       # Testbenches and Makefile for simulation
├── asynchronous_fifo/      # RTL design files for Asynchronous FIFO
│   ├── rtl/                # RTL design files
│   ├── verification/       # Testbenches and Makefile for simulation
├── README.md               # Project documentation

```

## Synchronous FIFO
- **Clock Domain**: Write and read operations share the same clock.
- **Key Features**: Simple pointer management with `full` and `empty` status flags.
- **Usage**: Suitable for systems where all operations occur within a single clock domain.

## Asynchronous FIFO
- **Clock Domain**: Write and read operations occur in separate, asynchronous clock domains.
- **Key Features**: 
  - Pointer synchronization using Gray code and 2-flop synchronizers.
  - Reliable communication between different clock domains.
- **Usage**: Ideal for bridging modules with independent clocking schemes.

---

## How to Run Simulations

### Prerequisites
To run the simulations, ensure the following tools are installed:
- [Icarus Verilog](http://iverilog.icarus.com/) for compiling and simulating Verilog designs.
- [GTKWave](http://gtkwave.sourceforge.net/) for waveform analysis.

### Steps to Simulate

1. **Navigate to the desired FIFO verification directory**:
   - For **Synchronous FIFO**:
     ```bash
     cd synchronous fifo/verification
     ```
   - For **Asynchronous FIFO**:
     ```bash
     cd asynchronous fifo/verification
     ```

2. **Run the simulation**:
   ```bash
   make run
