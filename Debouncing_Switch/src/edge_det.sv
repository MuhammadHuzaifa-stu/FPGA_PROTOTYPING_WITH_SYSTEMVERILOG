module edge_det (
    input  logic clk,
    input  logic arst_n,

    input  logic lvl,
    output logic tick
);
    
    logic lvl_d;

    assign tick = !lvl_d & lvl;

    always_ff @( posedge clk or negedge arst_n ) 
    begin : lvl_d_blk
        if (!arst_n)
            lvl_d <= 'd0;
        else
            lvl_d <= lvl;
    end

endmodule