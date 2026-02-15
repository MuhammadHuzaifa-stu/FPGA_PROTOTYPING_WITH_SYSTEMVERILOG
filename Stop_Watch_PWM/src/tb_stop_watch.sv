`timescale 1ns/1ps

module tb ();
    
    logic       sys_clk_p;
    logic       sys_clk_n;
    logic       sys_rstn;
    logic       cnt_en;
    logic       clr;
    logic [3:0] duty_cycle;
    logic [7:0] seg_sel;
    logic [7:0] seg_led1;
    logic [7:0] seg_led2;

    stop_watch_top u_dut (
        .sys_clk_p ( sys_clk_p    ),
        .sys_clk_n ( sys_clk_n    ),
        .sys_rstn  ( sys_rstn     ),
        .cnt_en    ( cnt_en       ),
        .clr       ( clr          ),
        .duty_cycle( duty_cycle   ),
        .seg_sel   ( seg_sel      ),
        .seg_led1  ( seg_led1     ),
        .seg_led2  ( seg_led2     )
    );

    initial
    begin
        sys_clk_p = 1'b0;
        sys_clk_n = 1'b1;
        forever
        begin
            #2.5; 
            sys_clk_p = ~sys_clk_p; // 200MHz clock
            sys_clk_n = ~sys_clk_n; // 200MHz clock
        end 
    end

    initial 
    begin
        sys_rstn   = 1'b0;
        cnt_en     = 1'b0;
        clr        = 1'b0;
        duty_cycle = 1'b0;
        
        #1;
        sys_rstn = 1'b1;
        
        @(posedge u_dut.clk);
        cnt_en     = 1'b1; // start counting
        duty_cycle = 'd4;

        repeat(10000000) @(posedge u_dut.clk); // run for a while
        $finish;
    end

endmodule