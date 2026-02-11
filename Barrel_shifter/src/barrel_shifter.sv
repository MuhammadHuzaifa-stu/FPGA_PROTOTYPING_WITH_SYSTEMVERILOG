module barrel_shifter #(
    parameter  WIDTH       = 8,
    localparam SHAMT_WIDTH = $clog2(WIDTH)
) (
    input  logic [WIDTH      -1:0] a_in,
    input  logic [SHAMT_WIDTH-1:0] shamt,
    input  logic                   dir, // 0 for left shift, 1 for right shift

    output logic [WIDTH      -1:0] a_out
);
    
    logic [WIDTH-1:0] stage [SHAMT_WIDTH:0];
    logic [WIDTH-1:0] a_in_rev;
    logic [WIDTH-1:0] a_out_rev;

    generate
        // Reverse the input for left shift
        for (genvar i = 0; i < WIDTH; i++) 
        begin : input_reversal_blk
            assign a_in_rev[i] = a_in[WIDTH - 1 - i];
        end
    endgenerate
    
    always_comb 
    begin : input_sel_blk
        if (dir == 0) 
        begin
            // Reverse the input for left shift
            stage[0] = a_in_rev;
        end 
        else 
        begin
            // No reversal for right shift
            stage[0] = a_in; 
        end
    end

    // Generate the stages of the barrel shifter
    generate
        for (genvar i = 0; i < SHAMT_WIDTH; i++) 
        begin : shifter_stage_blk
            assign stage[i+1] = (shamt[i]) ? {stage[i][(1 << i) - 1 : 0], stage[i][WIDTH - 1 : ( 1 << i )]} : stage[i];
        end
    endgenerate

    generate
        // Reverse the output for left shift
        for (genvar i = 0; i < WIDTH; i++) 
        begin : output_reversal_blk
            assign a_out_rev[i] = stage[SHAMT_WIDTH][WIDTH - 1 - i];
        end
    
    endgenerate
    
    always_comb 
    begin : output_sel_blk
        if (dir == 0)
        begin
            // Output the reversed result for left shift
            a_out = a_out_rev; 
        end 
        else
        begin
            // Output the direct result for right shift
            a_out = stage[SHAMT_WIDTH]; 
        end
    end

endmodule