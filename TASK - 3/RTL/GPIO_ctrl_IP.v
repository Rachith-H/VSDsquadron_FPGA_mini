`timescale 1ns/1ps
module GPIO_ctrl_IP(clk,IP_wdata,decode,IP_sel,rst,IP_rdata,wen,IP_ext_in);

input [1:0] decode;
input clk,rst;
input IP_sel,wen;
input [31:0] IP_wdata, IP_ext_in;
output reg [31:0] IP_rdata;

reg [31:0] GPIO_data;
reg [31:0] GPIO_dir;
reg [31:0] GPIO_read;

always@(*) begin
	GPIO_read = (GPIO_data & GPIO_dir) | (~GPIO_dir & IP_ext_in);
	case(decode)
	2'b00 : IP_rdata = GPIO_data;
	2'b01 : IP_rdata = GPIO_dir;
	2'b10 : IP_rdata = GPIO_read;
	default : IP_rdata = 0;
	endcase
end

always@(posedge clk) begin
	if(!rst) begin
		GPIO_data <= 0;
		GPIO_dir <= 0;
	end
	else begin
		if(IP_sel && wen) begin
			case(decode)
			2'b00 : GPIO_data <= IP_wdata;
			2'b01 : GPIO_dir <= IP_wdata;
			default : begin
				GPIO_data <= GPIO_data;
				GPIO_dir <= GPIO_dir;
			end
			endcase
		end
		else begin
			GPIO_data <= GPIO_data;
			GPIO_dir <= GPIO_dir;
		end
	end
end
endmodule 
