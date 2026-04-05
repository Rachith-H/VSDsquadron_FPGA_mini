module timer_ip_tb;

reg clk,rst,timer_sel,wen;
reg [31:0] timer_wdata;
reg [1:0] decode;
wire [31:0] timer_rdata;
wire [31:0] ext_LED;
wire timeout_LED;

timer_ip uut(clk,rst,timer_rdata,timer_wdata,decode,timer_sel,wen,ext_LED,timeout_LED);

always #5 clk = ~clk;

initial begin 
	$dumpfile("sim.vcd");
	$dumpvars(0,timer_ip_tb);
	
	//initialize registers
	clk = 0;
	decode = 0;
	wen = 0;
	timer_wdata = 0;
	timer_sel = 0;
	
	rst = 0 ; #6;
	rst = 1;
	
	
	//enable one shot mode
	decode = 2'b01;
	timer_wdata = 32'h00000004;
	timer_sel = 1;
	wen = 1; #10;
	
	decode = 2'b11;
	timer_wdata = 32'h00000001; #10;
	timer_sel = 1;
	wen = 1;#10;
	
	decode = 2'b00;
	timer_wdata = 32'h00000001; #10;
	timer_sel = 1;
	wen = 1;#10
	timer_sel = 0;
	wen = 0; 
	#100;
	
	
	//enable auto reload mode
	decode = 2'b01;
	timer_wdata = 32'h00000004;
	timer_sel = 1;
	wen = 1; #10;
	
	decode = 2'b11;
	timer_wdata = 32'h00000001; #10;
	timer_sel = 1;
	wen = 1;#10;
	
	decode = 2'b00;
	timer_wdata = 32'h00000003; #10;
	timer_sel = 1;
	wen = 1;#10
	timer_sel = 0;
	wen = 0;
	#150; 
	
	
	//enable prescale division
	decode = 2'b01;
	timer_wdata = 32'h00000004;
	timer_sel = 1;
	wen = 1; #10;
	
	decode = 2'b11;
	timer_wdata = 32'h00000001; #10;
	timer_sel = 1;
	wen = 1;#10;
	
	
	decode = 2'b00;
	timer_wdata = 32'h0000207; #10;
	timer_sel = 1;
	wen = 1;#10
	timer_sel = 0;
	wen = 0;
	#180; $finish;
	
	
	
end
endmodule

