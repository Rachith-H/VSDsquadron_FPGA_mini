module GPIO_reg_IP_tb;

reg clk,rst;
reg IP_sel,wen;
reg [31:0] IP_wdata;
wire [31:0] IP_rdata;

GPIO_reg_IP gpio_ip (clk,IP_wdata,IP_sel,rst,IP_rdata,wen);

always #5 clk = ~clk;
initial begin 
$dumpfile("waves.vcd");
$dumpvars(1,GPIO_reg_IP_tb);

clk = 0;
IP_sel = 0;
IP_wdata = 32'd0;
rst = 1; #2;
rst = 0; #4;
rst = 1;

IP_sel = 1;
IP_wdata = 32'd44;
wen = 1; #10;
wen = 0; #10;

IP_sel = 0;
IP_wdata = 32'd88;
wen = 1; #10;
wen = 0; #10;
#5 $finish;

end
endmodule



