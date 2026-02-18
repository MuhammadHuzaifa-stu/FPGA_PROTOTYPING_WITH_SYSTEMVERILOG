module tb_db_sw_top ();
    
    parameter CLK_FREQ = 200_000_000;

    logic       sys_clk_p;
    logic       sys_clk_n;
    logic       sys_rstn;
    logic [1:0] button;
    logic [3:0] seg_sel;
    logic [7:0] seg_led;

    db_sw_top #(
        .CLK_FREQ(CLK_FREQ)
    ) u_dut (
        .sys_clk_p ( sys_clk_p ),
        .sys_clk_n ( sys_clk_n ),
        .sys_rstn  ( sys_rstn  ),
        .button    ( button    ),
        .seg_sel   ( seg_sel   ),
        .seg_led   ( seg_led   )
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
        sys_rstn <= 'd0;
        button   <= '1;
        #1;
        sys_rstn <= 'd1;
        
        @(posedge u_dut.clk);
        button = 2'b01; // start counting

        repeat(100000000) @(posedge u_dut.clk); // run for a while
        $finish;
    end

endmodule