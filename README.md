# I2C Master Controller using Verilog

## Overview

This project implements an FSM-based I2C Master Controller in Verilog using Xilinx Vivado.

## Features

* START Condition Generation
* STOP Condition Generation
* 7-bit Slave Address Transmission
* Read/Write Bit Support
* Data Byte Transmission
* Clock Divider for I2C Clock Generation
* Tri-State SDA Line Control
* ACK Detection and Error Monitoring
* Behavioral Simulation and Verification

## FSM States

* IDLE
* START_ST
* SEND_ADDR_RW
* ACK1
* SEND_DATA
* ACK2
* STOP_ST

## Tools Used

* Verilog HDL
* Xilinx Vivado 2018.2
* Vivado Simulator

## Simulation Flow

IDLE → START → ADDRESS → ACK → DATA → ACK → STOP → IDLE

## Project Files

### Source Files

* i2c_master.v
* i2c_master_v2.v

### Testbench Files

* i2c_master_tb.v
* i2c_master_v2_tb.v

## Future Improvements

* Read Operation Support
* Multi-byte Data Transfer
* Multiple Slave Support
* Configurable Clock Frequency

## Results

- Successfully implemented FSM-based I2C Master Controller.
- Verified START, Address Transmission, ACK Detection,
  Data Transfer, and STOP conditions.
- Simulated and verified using Xilinx Vivado 2018.2.

## Author

Jayavarshini 

Electronics and Communication Engineering

Chennai Institute of Technology
