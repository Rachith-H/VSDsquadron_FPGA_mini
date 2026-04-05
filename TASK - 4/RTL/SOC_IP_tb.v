`timescale 1ns/1ps
`define BENCH
module SOC_IP_tb;
    reg  RESET;
    wire [4:0] LEDS;
    reg  RXD;
    wire TXD;
    wire [31:0] timer_LED;
    wire timeout ;
    
    SOC uut (
        .RESET(RESET),
        .LEDS(LEDS),
        .RXD(RXD),
        .TXD(TXD),
	.timer_LED(timer_LED),
	.timeout(timeout)
    );
    
    
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, SOC_IP_tb);
        RXD   = 1;
        RESET = 1;   // assert reset first
        #10;
        RESET = 0;   // release reset → design boots
        #10000;     // run long enough for CPU to execute
        $finish;
    end
endmodule

