`timescale 1ns/1ps

module tb ();

    logic       sys_clk_p; 
    logic       sys_clk_n;
    logic       sys_rstn;
    logic       en;
    logic       rot;
    logic [7:0] seg_sel;
    logic [7:0] seg_led1;
    logic [7:0] seg_led2;

    rotating_sqr_wave_top u_dut (
        .sys_clk_p ( sys_clk_p ), 
        .sys_clk_n ( sys_clk_n ),
        .sys_rstn  ( sys_rstn  ),
        .en        ( en        ),
        .rot       ( rot       ),
        .seg_sel   ( seg_sel   ),
        .seg_led1  ( seg_led1  ),
        .seg_led2  ( seg_led2  )
    );

    initial
    begin
        sys_clk_p = 1'b0;
        sys_clk_n = 1'b1;
        forever
        begin
            #2.5 
            sys_clk_p = ~sys_clk_p; // 200MHz clock
            sys_clk_n = ~sys_clk_n; // 200MHz clock
        end 
    end

    initial 
    begin
        sys_rstn = 1'b0;
        en       = 1'b0;
        rot      = 1'b0;
        
        #1;
        sys_rstn = 1'b1;
        
        @(posedge u_dut.clk);
        en = 1'b1; // start counting

        repeat(100000000) @(posedge u_dut.clk); // run for a while
        $finish;
    end

endmodule