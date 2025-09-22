# arys-HDL-Fault-Detection-FSM-Vikas-V
## Candidate Details
- **Name:** Vikas V
- **Assignment:** Arys Garage – HDL Fault Detection FSM (Electronics Option)
- **Date:**22 September 2025

## Project Scope
This project implements a **Fault Detection Finite State Machine (FSM)** for monitoring 
battery cell voltages, current, and temperature. The FSM transitions through the states:
**Normal → Warning → Fault → Shutdown**, with debounce, persistence, fault priority,
and masking features.

## Files
- `design.sv` – HDL implementation of FSM
- `testbench.sv` – SystemVerilog testbench with stimulus and waveforms
- `tb_fault_fsm.vcd` – Simulation waveform output
- `FSM_diagram.png` – FSM diagram
