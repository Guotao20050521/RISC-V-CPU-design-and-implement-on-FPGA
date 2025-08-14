`timescale 1ns/1ns
module top_tb;

  // Parameters
  parameter CLK_PERIOD = 5;

  //Ports
  reg CLK;
  reg RESETn;
  wire [2:0] LED;

  top  top_inst (
    .clk(CLK),
    .rst(RESETn),
    .leds(LED)
  );

  always #CLK_PERIOD CLK = ~CLK;
  initial begin 
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);
  end
  initial begin
    CLK <= 1;
    RESETn <= 0;
    //repeat (100) @(posedge CLK);
		#200 RESETn <= 1;
		repeat (1000) @(posedge CLK);
		$finish;
  end
  /*检查固件hex文件是否正常加载*/
  initial begin
    #500; // 等待500ns确保内存初始化完成
    $display("First instruction: 0x%h", top_inst.memory[0]);
  end
  /*always @(posedge CLK) begin
    if (top_inst.mem_valid && top_inst.mem_ready) begin
        $display("MemAccess: addr=0x%h, data=0x%h", top_inst.mem_addr, top_inst.mem_rdata);
    end
end*/
endmodule