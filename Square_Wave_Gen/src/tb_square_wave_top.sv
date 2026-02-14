`timescale 1ns/1ps

module tb_square_wave_top ();
    
    localparam WIDTH = 4;

    logic             sys_clk_p; 
    logic             sys_clk_n;
    logic             sys_rstn;
    logic             m_en; 
    logic             n_en;
    logic [WIDTH-1:0] m; // logic 1 interval
    logic [WIDTH-1:0] n; // logic 0 interval
    logic             gen;
    logic             square_wave_out;

    square_wave_top u_dut (
        .sys_clk_p      ( sys_clk_p       ), 
        .sys_clk_n      ( sys_clk_n       ),
        .sys_rstn       ( sys_rstn        ),
        .m_en           ( m_en            ),
        .n_en           ( n_en            ),
        .m              ( m               ),
        .n              ( n               ),
        .gen            ( gen             ),
        .square_wave_out( square_wave_out )
    );

    initial 
    begin

        sys_clk_p = 0;
        sys_clk_n = 1;
        forever 
        begin
            #2.5; 
            sys_clk_p = ~sys_clk_p; // 200MHz clock
            sys_clk_n = ~sys_clk_n; // 200MHz clock
        end

    end

    initial 
    begin
        sys_rstn = 0;
        m_en     = 0;
        n_en     = 0;
        m        = 0;
        n        = 0;
        #1;
        sys_rstn = 1;
        repeat(4) #5;
        m_en = 1;
        m    = 2;
        #5;
        m_en = 0;
        n_en = 1;
        n    = 2;
        #5;
        n_en = 0;
        gen  = 1;
        repeat(1024) #5;
        $finish;
    end

endmodule