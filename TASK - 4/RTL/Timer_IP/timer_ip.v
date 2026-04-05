`timescale 1ns/1ps
module timer_ip (clk,rstn,timer_rdata,timer_wdata,decode,timer_sel,wen,ext_LED,timeout_LED);

input clk,rstn,timer_sel,wen;
input [31:0] timer_wdata;
input [1:0] decode;
output reg [31:0] timer_rdata;
output [31:0] ext_LED;
output reg timeout_LED;

reg [31:0] ctrl;
reg [31:0] value;
reg [31:0] load;
reg [31:0] status;
reg [7:0] prescale;

assign ext_LED = value;

always@(*) begin
	case(decode)
		2'b00 : timer_rdata = ctrl;
		2'b01 : timer_rdata = load;
		2'b10 : timer_rdata = value;
		2'b11 : timer_rdata = status;
		default : timer_rdata = 0;
	endcase
end

always@(posedge clk) begin
	if(!rstn) begin
		ctrl <= 0;
		value <= 0;
		load <= 0;
		status <= 0;
		prescale <= 0;
		timeout_LED <= 0;
	end
	
	else if(timer_sel && wen) begin
		case(decode)
			2'b00 : begin
				ctrl <= timer_wdata;
				prescale <= timer_wdata[15:8];
			end
			2'b01 : begin
				load <= timer_wdata;
				value <= timer_wdata;
			end
			2'b11 : status <= (!timer_wdata[0]) ? status : {status[31:1],1'b0} ;
		endcase
	end
	
	else if(ctrl[0] && value==0) begin
		value <= (ctrl[1]) ? load : 0 ;
		timeout_LED <= ~timeout_LED;
		status <= 32'h00000001;
		prescale <= (ctrl[2]) ? ctrl[15:8] : prescale ;
		ctrl <= (ctrl[1]) ? ctrl : {ctrl[31:1],1'b0} ;
	end
	
	else begin
		if(ctrl[0] && !ctrl[2]) begin
			value <= value-1;
		end
		if (ctrl[0] && ctrl[2]) begin
			prescale <= (prescale==0) ? ctrl[15:8] : prescale-1;
			value <= (prescale==0) ? value-1 : value ;
		end
	end
end
endmodule
