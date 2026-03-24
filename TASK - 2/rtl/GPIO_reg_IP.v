module GPIO_reg_IP(clk,IP_wdata,IP_sel,rst,IP_rdata,wen);

input clk,rst;
input IP_sel,wen;
input [31:0] IP_wdata;
output [31:0] IP_rdata;

reg [31:0] GPIO_reg;

assign IP_rdata = GPIO_reg ;
always@(posedge clk ) begin
	if(!rst) 
		GPIO_reg <= {32{1'b0}};
	else if (IP_sel) begin
		if(wen)
			GPIO_reg <= IP_wdata;
	end
	
end
endmodule 
