`timescale 1ns/1ps

module tb ();
    
    logic       clk;
    logic       arst_n;
    logic       cnt_en;
    logic       clr;
    logic [3:0] sec_0;
    logic [2:0] sec_1;
    logic [3:0] min_0;
    logic [2:0] min_1;
    logic [3:0] hr_0;
    logic       hr_1;

    stop_watch dut (
        .clk    ( clk    ),
        .arst_n ( arst_n ),
        .cnt_en ( cnt_en ),
        .clr    ( clr    ),
        .sec_0  ( sec_0  ),
        .sec_1  ( sec_1  ),
        .min_0  ( min_0  ),
        .min_1  ( min_1  ),
        .hr_0   ( hr_0   ),
        .hr_1   ( hr_1   )
    );

    initial
    begin
        clk = 1'b0;
        forever #5000 clk = ~clk; // 1kHz clock
    end

    initial begin
        arst_n = 1'b0;
        cnt_en = 1'b0;
        clr    = 1'b0;
        
        #1;
        arst_n = 1'b1;
        
        @(posedge clk);
        cnt_en = 1'b1; // start counting

        repeat(10000000) @(posedge clk); // run for a while
        $finish;
    end

endmodule