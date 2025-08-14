#!/bin/bash

# 编译汇编启动文件
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -ffreestanding -c -o start.o start.S

# 编译C程序
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -ffreestanding -Os -c -o main.o main.c

# 链接
riscv64-unknown-elf-ld -m elf32lriscv -T linker.ld -o firmware.elf start.o main.o
#riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostartfiles -o firmware.elf main.c
# 生成内存初始化文件
riscv64-unknown-elf-objcopy -O verilog firmware.elf firmware.hex

# 精简HEX文件格式
sed -i 's/@........//g' firmware.hex
