`timescale 1ns/1ps
module GPIO_ctrl_IP_tb;

reg [1:0] decode;
reg clk,rst;
reg IP_sel,wen;
reg [31:0] IP_wdata, IP_ext_in;
wire [31:0] IP_rdata;

GPIO_ctrl_IP uut(clk,IP_wdata,decode,IP_sel,rst,IP_rdata,wen,IP_ext_in);

always #5 clk = ~clk;
initial begin 

$dumpfile("run.vcd");
$dumpvars(0,GPIO_ctrl_IP_tb);

clk = 0;
IP_sel = 0;
IP_ext_in = 32'hcccc1234;
decode = 2'b01;
rst = 0;#8;
rst = 1;

IP_sel = 1;
wen = 1;
IP_wdata = 32'h0000ffff;
#20 decode = 2'b00;
IP_wdata = 32'h5555aaaa;
# 20 wen = 0;
decode = 2'b10;
#40 $finish;
end

endmodule 
