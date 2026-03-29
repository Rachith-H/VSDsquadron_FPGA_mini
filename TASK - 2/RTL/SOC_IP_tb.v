`timescale 1ns/1ps
`define BENCH
module SOC_IP_tb;
    reg  RESET;
    wire [4:0] LEDS;
    reg  RXD;
    wire TXD;

    SOC uut (
        .RESET(RESET),
        .LEDS(LEDS),
        .RXD(RXD),
        .TXD(TXD)
    );

    // GPIO activity monitor
    always @(posedge uut.clk) begin
        if(uut.GPIO_sel & uut.mem_wstrb)
            $display("T=%0t | GPIO WRITE: 0x%h", $time, uut.mem_wdata);
        if(uut.GPIO_sel & uut.mem_rstrb)
            $display("T=%0t | GPIO READ : 0x%h", $time, uut.GPIO_rdata);
    end

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, SOC_IP_tb);
        RXD   = 1;
        RESET = 1;   // assert reset first
        #50;
        RESET = 0;   // release reset → design boots
        #10000;     // run long enough for CPU to execute
        $finish;
    end
endmodule

