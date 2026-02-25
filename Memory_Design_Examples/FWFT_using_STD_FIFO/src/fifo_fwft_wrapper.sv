module fifo_fwft_wrapper #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4
)(
    input  logic                  clk,
    input  logic                  arst_n,

    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] dout,
    output logic                  empty,

    input  logic                  wr_en,
    input  logic [DATA_WIDTH-1:0] din,
    output logic                  full
);

    logic                  std_rd_en;
    logic [DATA_WIDTH-1:0] std_dout;
    logic                  std_empty;
    logic                  out_valid;
                
    assign dout = std_dout;

    fifo #(
        .DATA_WIDTH( DATA_WIDTH ),
        .ADDR_WIDTH( ADDR_WIDTH )
    ) standard_fifo_inst (
        .clk     ( clk       ),
        .arst_n  ( arst_n    ),
        .wr      ( wr_en     ),
        .wr_data ( din       ),
        .full    ( full      ),
        .rd      ( std_rd_en ),
        .rd_data ( std_dout  ),
        .empty   ( std_empty )
    );

    // We are "Empty" to the user only if our output register is invalid
    assign empty = !out_valid;
    
    // The trick: Read the internal FIFO if it has data AND 
    // (our output is empty OR the user is reading right now)
    assign std_rd_en = !std_empty && (!out_valid || rd_en);

    always_ff @(posedge clk or negedge arst_n) 
    begin
        if (!arst_n) 
        begin
            out_valid <= 1'b0;
        end 
        else 
        begin
            if (std_rd_en) 
            begin
                out_valid <= 1'b1; 
            end 
            else if (rd_en) 
            begin
                out_valid <= 1'b0;
            end
        end
    end

endmodule