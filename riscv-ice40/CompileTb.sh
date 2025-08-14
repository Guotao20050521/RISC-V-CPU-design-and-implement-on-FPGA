iverilog -o sim rtl/*.v tb.v
vvp -l sim.log sim
gtkwave top_tb.vcd
