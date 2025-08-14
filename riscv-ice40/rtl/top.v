module top(
    input clk,
    input rst,
    output[2:0] leds
);
    wire cpu_resetn = rst;
	wire mem_valid;
	wire mem_instr;
	reg mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	reg  [31:0] mem_rdata;

    picorv32 #(
        .ENABLE_MUL(0),       // 禁用乘法器
        .ENABLE_DIV(0),       // 禁用除法器
        .COMPRESSED_ISA(0)    // 禁用C扩展
    ) inst (
		.clk         (clk        ),
		.resetn      (cpu_resetn ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  )
	);

    reg [31:0] memory [0:255];
	integer i;
    /*初始化memory*/
    initial begin
		for (i = 0; i < 256; i = i + 1) begin
			memory[i] = 32'h00000000;
		end
        $readmemh("firmware.hex", memory);
    end
    /*initial begin
		memory[0] = 32'h 3fc00093; //       li      x1,1020
		memory[1] = 32'h 0000a023; //       sw      x0,0(x1)
		memory[2] = 32'h 0000a103; // loop: lw      x2,0(x1)
		memory[3] = 32'h 00110113; //       addi    x2,x2,1
		memory[4] = 32'h 0020a023; //       sw      x2,0(x1)
		memory[5] = 32'h ff5ff06f; //       j       <loop>
	end*/

    always @(posedge clk) begin
		mem_ready <= 0;
		if (mem_valid && !mem_ready) begin
			if (mem_addr < 1024) begin
				mem_ready <= 1;
				case(mem_addr[1: 0])
				  2'b00: mem_rdata <= memory[mem_addr >> 2];
				  2'b01: mem_rdata <= {memory[mem_addr >> 2][7:0], memory[mem_addr >> 2][31:8]};
				  2'b10: mem_rdata <= {memory[mem_addr >> 2][15:0], memory[mem_addr >> 2][31:16]};
				  2'b11: mem_rdata <= {memory[mem_addr >> 2][23:0], memory[mem_addr >> 2][31:24]};
				endcase
				//mem_rdata <= memory[mem_addr >> 2];
				if (mem_wstrb[0]) memory[mem_addr >> 2][ 7: 0] <= mem_wdata[ 7: 0];
				if (mem_wstrb[1]) memory[mem_addr >> 2][15: 8] <= mem_wdata[15: 8];
				if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
				if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
			end
		end
	end
	/*reg [31:0] current_mem_addr;
    
    always @(posedge clk) begin
        if (mem_valid && !mem_ready) begin
            // 锁存当前地址
            current_mem_addr <= mem_addr;
        end
        
        // 默认情况下，mem_ready为0
        mem_ready <= 0;
        
        // 当mem_valid为高时，表示处理器正在请求内存访问
        if (mem_valid) begin
            // 检查地址是否在有效范围内
            if (current_mem_addr < 1024) begin
                // 设置mem_ready为高，表示内存已准备好
                mem_ready <= 1;
                
                // 根据地址的低2位选择正确的字节组合
                case (current_mem_addr[1:0])
                    2'b00: mem_rdata <= memory[current_mem_addr >> 2];
                    2'b01: mem_rdata <= {memory[current_mem_addr >> 2][7:0], memory[current_mem_addr >> 2][31:8]};
                    2'b10: mem_rdata <= {memory[current_mem_addr >> 2][15:0], memory[current_mem_addr >> 2][31:16]};
                    2'b11: mem_rdata <= {memory[current_mem_addr >> 2][23:0], memory[current_mem_addr >> 2][31:24]};
                endcase
                
                // 处理写操作
                if (|mem_wstrb) begin  // 如果有任何写使能位被设置
                    if (mem_wstrb[0]) memory[current_mem_addr >> 2][ 7: 0] <= mem_wdata[ 7: 0];
                    if (mem_wstrb[1]) memory[current_mem_addr >> 2][15: 8] <= mem_wdata[15: 8];
                    if (mem_wstrb[2]) memory[current_mem_addr >> 2][23:16] <= mem_wdata[23:16];
                    if (mem_wstrb[3]) memory[current_mem_addr >> 2][31:24] <= mem_wdata[31:24];
                end
            end
        end
    end*/
    assign leds = mem_addr[2:0];  //LED显示低3位地址
endmodule