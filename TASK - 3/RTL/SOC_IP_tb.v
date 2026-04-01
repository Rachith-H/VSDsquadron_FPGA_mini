`timescale 1ns/1ps
`define BENCH
module SOC_IP_tb;
    reg  RESET;
    wire [4:0] LEDS;
    reg  RXD;
    wire TXD;
    reg [31:0] ext_pins;
    SOC uut (
        .RESET(RESET),
        .LEDS(LEDS),
        .RXD(RXD),
        .TXD(TXD),
        .GPIO_ext_pins(ext_pins)
    );

   

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, SOC_IP_tb);
        ext_pins = 32'h12340000;
        RXD   = 1;
        RESET = 1;   // assert reset first
        #50;
        RESET = 0;   // release reset → design boots
        #10000;     // run long enough for CPU to execute
        $finish;
    end
endmodule

