module square_wave_top  #(
    localparam WIDTH = 4
)(
    input  logic             sys_clk_p, 
    input  logic             sys_clk_n,
    input  logic             sys_rstn,

    input  logic             m_en,
    input  logic             n_en,
    input  logic [WIDTH-1:0] m_n, // logic 1_0 interval
    
    input  logic             gen,

    output logic             square_wave_out
);

    logic             clk;
    logic [WIDTH-1:0] m_reg;   // logic 1 interval
    logic [WIDTH-1:0] n_reg;   // logic 0 interval
    logic             gen_d;

    IBUFDS # ( 
        .DIFF_TERM   ("FALSE"  ),        
        .IBUF_LOW_PWR("TRUE"   ),      
        .IOSTANDARD  ("DEFAULT")      
    ) IBUFDS_inst ( 
        .O (clk      ),  
        .I (sys_clk_p),   
        .IB(sys_clk_n)  
    ); 

    square_wave u_square_wave (
        .clk             ( clk             ),
        .arst_n          ( sys_rstn        ),
        .m               ( m_reg           ),
        .n               ( n_reg           ),
        .gen             ( gen_d           ),
        .square_wave_out ( square_wave_out )
    );

    always_ff @( posedge clk or negedge sys_rstn ) 
    begin : input_reg_blk
        if (!sys_rstn)
        begin
            m_reg <= 0;
            n_reg <= 0;
            gen_d <= 0;
        end
        else
        begin
            gen_d <= gen;

            if (m_en)
            begin
                m_reg <= m_n;
            end
            if (n_en)
            begin
                n_reg <= m_n;
            end
        end    
    end
    
endmodule