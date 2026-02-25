module tb_fwft ();
    
    parameter  DATA_WIDTH = 16;
    parameter  ADDR_WIDTH = 2;
    localparam OUT_WIDTH  = DATA_WIDTH >> 1;

    logic                   clk;
    logic                   arst_n;
    
    // Write Interface
    logic                   wr_en;
    logic [DATA_WIDTH-1:0]  wr_data;
    logic                   full;
    
    // Read Interface
    logic                   rd_en;
    logic [OUT_WIDTH-1:0]   rd_data;
    logic                   empty;

    fwft #(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    ) u_dut (
        .clk     ( clk     ),
        .arst_n  ( arst_n  ),
        .wr      ( wr_en   ),
        .wr_data ( wr_data ),
        .full    ( full    ),
        .rd      ( rd_en   ),
        .rd_data ( rd_data ),
        .empty   ( empty   )
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial
    begin
        arst_n  <= 'd0;
        wr_en   <= 'd0;
        wr_data <= 'd0;
        rd_en   <= 'd0;

        #1;
        arst_n  <= 'd1;

        // Write some data
        repeat (10) begin
            @(posedge clk);
            wr_en   <= 1;
            wr_data <= $random;
        end

        @(posedge clk);
        wr_en <= 0;

        // Read the data back
        repeat (10) begin
            @(posedge clk);
            rd_en   <= 1;
        end

        @(posedge clk);
        rd_en <= 0;

        #100;
        $finish;
    end

endmodule