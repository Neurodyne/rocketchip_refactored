# rocketchip_refactored

This contains a refactored Rocket Chip build flow, which supports the latest Chisel3, FIRRTL and Plugin versions.
This also removes cumbersome and unnecessary dependencies on RISC-V toolchain, outdated FIRRTL, Chisel and Verilator versions.

We assume that a person, who really wants to use the Rocketchip is capable to build dependencies from scratch and thus remove all bundled dependencies to simplify the Chisel design work flow

# Installation

## Before you begin
Install all build dependencies, SBT and Verilator
``` bash
sudo apt install verilator
```
### 1. Remove cached versions of Berkeley IPs
``` bash
> cd ~/.ivy2
> rm -rf ./cache/edu.berkeley.cs
> rm -rf ./local/edu.berkeley.cs
```
### 2. Build the latest versions of FIRRTL and Chisel3
``` bash
> git clone https://github.com/freechipsproject/firrtl
> cd firrtl
> sbt publishLocal

FIRRTL also requires a fat build, which includes all dependencies, including Scala.

> sbt assembly
> cp utils/bin/firrtl.jar ~/.ivy2/local/edu.berkeley.cs/firrtl_2.12/1.2-SNAPSHOT/jars

> git clone https://github.com/freechipsproject/chisel3
> cd chisel3
> sbt publishLocal
```
### 3. Clone this project and build, simulate and synthesize Rocketchip
``` bash
> git clone https://github.com/Neurodyne/rocketchip_refactored
> cd rocketchip_refactored
> sbt
```
The last command launches Scala SBT shell. This may take a while. The commands below are typed in the SBT shell
``` bash
> sbt:rocketchip > compile
> sbt:rocketchip > runMain freechips.rocketchip.system.Generator ./out freechips.rocketchip.system TestHarness freechips.rocketchip.system TinyConfig
```
The last command builds the smallest possible version of Rocketchip and outputs data into ./out directory.
This output contains a FIRRTL output, memory map and lots of stuff, which will be used next to generate Verilog, launch a simulation or perform synthesis.

## Simple User Mode
This flow allows you to work with multiple representations of the Rocketchip: Chisel, FIRRTL, Verilog, FPGA/ASIC synthesis and Verilator simulations.
To view all options, simply do:
``` bash
> cd rocketchip_refactored/
> make 
```
The last command will output the following:
``` shell
**** Rocketchip build flow ****
make fir - compile Chisel sources and generate FIRRTL output
make vlog - compile FIRRTL and generate Verilog
make vsim - run Verilog simulation with Verilator
make vdbg - run Verilog debug simulation with Verilator
```

If you want to extend functionality of this project, open your Issue !
