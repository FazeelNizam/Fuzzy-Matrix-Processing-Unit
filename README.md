# Fuzzy Matrix Operation Unit (FMU)

> **A specialized FPGA-based processor designed to accelerate Fuzzy Logic matrix computations.**

![VHDL](https://img.shields.io/badge/Language-VHDL-blue)
![Platform](https://img.shields.io/badge/Platform-Nexys%20A7--100T-orange)
![Tool](https://img.shields.io/badge/Tool-Xilinx%20Vivado-green)

## 📖 Overview

Welcome to the **Fuzzy Matrix Operation Unit (FMU)** project!

In the world of Artificial Intelligence and control systems, "Fuzzy Logic" allows us to reason with approximate values (like "warm" or "fast") rather than strict binary true/false. However, standard CPUs often struggle to process these operations efficiently when dealing with large matrices.

This project implements a custom hardware accelerator (co-processor) specifically designed to handle **Fuzzy Matrix Arithmetic**. By offloading these heavy calculations to dedicated hardware on an FPGA, we achieve higher efficiency compared to general-purpose processors.

## 🚀 Key Features

* **Specialized ISA:** A custom RISC-style instruction set architecture optimized for matrix manipulation.
* **Hardware Acceleration:** Dedicated units for Fuzzy Addition, Subtraction, and Multiplication.
* **Harvard Architecture:** Separate memory paths for instructions (ROM) and data (RAM) to prevent bottlenecks.
* **Fixed-Point Precision:** Uses **Q0.8 fixed-point format** (0.0 to 1.0 range) to represent fuzzy degrees of truth efficiently without the overhead of floating-point hardware.
* **Scalable Design:** Capable of handling configurable matrix sizes (up to 32x32 in current config).

## 🧮 How It Works

Unlike standard linear algebra, this processor implements **Fuzzy Arithmetic**:

1.  **Fuzzy Addition:** `A + B = max(A, B)`
2.  **Fuzzy Multiplication:** `A × B = min(A, B)`
3.  **Fuzzy Subtraction:**
    ```
    A - B = A  (if A > B)
          = 0  (if A <= B)
    ```

## 🛠️ Hardware Architecture

The design targets the **Nexys A7-100T FPGA** (XC7A100T-1CSG324C).

### Core Components
* **Control Unit (CU):** The brain of the operation. It fetches instructions, decodes opcodes (like `FADD`, `FMUL`, `LDMX`), and manages state transitions.
* **Inference Unit:** Performs the actual fuzzy logic comparisons (Max/Min logic).
* **Memory Architecture:**
    * **RAM:** Stores input matrices and results.
    * **ROM:** Stores the program instructions.
    * **Register Bank:** Holds metadata (Matrix Rows/Cols, Base Addresses).

### RTL Diagram
*Below is the Register Transfer Level (RTL) schematic of the FMU top module:*

![RTL Schematic](https://github.com/FazeelNizam/Fuzzy-Matrix-Processing-Unit/blob/main/sim%20runs%20ss/RTL.png)

## 📊 Performance & Utilization

We prioritized efficiency in this design. Here is how it performs on the Nexys A7 board:

* **BRAM Usage:** ~44% (Heavy reliance on block RAM for matrix storage).
* **Power Consumption:** ~0.132 W (Total On-Chip Power).
* **Latency:** Optimized to execute matrix operations in ~20 clock cycles per element (best case).

### Resource Utilization Graph
![Utilization Graph](https://github.com/FazeelNizam/Fuzzy-Matrix-Processing-Unit/blob/main/sim%20runs%20ss/utilization.png)

### Power Consumption
![Power Report](https://github.com/FazeelNizam/Fuzzy-Matrix-Processing-Unit/blob/main/sim%20runs%20ss/power.png)

## 📂 Repository Structure

Here is a quick tour of the VHDL files in this repo:

```text
├── src/
│   ├── FMU.vhd                  # Top-level module
│   ├── control_unit.vhd         # FSM handling instruction cycles
│   ├── inference_unit.vhd       # ALU for Fuzzy Logic (Min/Max/Sub)
│   ├── instruction_register.vhd # Fetches and holds current opcodes
│   ├── ram_top.vhd              # Data Memory wrapper
│   ├── rom_top.vhd              # Program Memory wrapper
│   ├── reg_a_top.vhd            # Accumulator Register
│   └── registry_bank_top.vhd    # Temp registers for metadata
├── sim/
│   ├── tb_FMU.vhd               # Testbench for the full processor
│   └── tb_control_unit.vhd      # Unit test for the Control Unit
└── docs/
    └── EEX7436_Design_Report.pdf
