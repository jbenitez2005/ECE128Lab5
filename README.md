# Multi-Digit Seven-Segment Display Driver – ECE 128 Lab 5

## Overview
This project implements a **4-digit seven-segment display driver** on the **Basys3 FPGA**.  
It converts a 12-bit binary input into four BCD digits using the **double-dabble algorithm**, then displays them using **time-division multiplexing**.

---
## How to Simulate
1. Open Vivado → Create Project → Add `multiseg_driver.v` and `tb_multiseg_driver.v`.  
2. Set `tb_multiseg_driver` as Top Module under Simulation Sources.  
3. Run Behavioral Simulation.  
4. Observe:
   - `seg_anode` cycling through `1110 → 1101 → 1011 → 0111`.  
   - `seg_cathode` patterns changing according to `bcd_in`.

---

## How to Program FPGA
1. Connect Basys3 via USB.  
2. Assign pins using `constraints.xdc (need all the switches, 7segement display, and anodes...).  
3. Run **Synthesis → Implementation → Generate Bitstream**.  
4. Open Hardware Manager → Program Device.  
5. Use switches SW0–SW15 to control displayed digits.

---
