# RISC-V-CPU-design-and-implement-on-FPGA
RISC-V CPU设计与FPGA实现
基于开源软核**picorv32**设计RISC-V处理器，支持**RV32I指令集**。
完成从C语言固件编写到FPGA部署的全流程开发，驱动外设实现交互功能。
成功烧录至**Lattice**的ice40up5k开发板上，能实时观察状态。

项目主要文件功能：

|文件（夹）名|功能|
|:--:|:--:|
|firmware|固件启动代码、链接脚本、源文件等|
|build_fpga.sh|从综合到生成比特流文件的自动化脚本|
|constraint.pcf|引脚约束文件|
|top_tb.v|rtl/top.v的testbench|
|top_tb.vcd|波形文件|
|rtl|软核源码和顶层设计|
