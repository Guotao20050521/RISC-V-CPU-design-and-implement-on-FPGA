#!/bin/bash

# 使用Yosys综合
yosys -p "
    read_verilog rtl/picorv32.v;
    read_verilog rtl/simple_ram.v;
    read_verilog rtl/top.v;
    synth_ice40 -top top -json top.json
"

# 使用nextpnr布局布线
nextpnr-ice40 \
    --up5k --package sg48 \
    --json top.json \
    --pcf constraint.pcf \
    --asc top.asc

# 生成比特流
icepack top.asc top.bin
