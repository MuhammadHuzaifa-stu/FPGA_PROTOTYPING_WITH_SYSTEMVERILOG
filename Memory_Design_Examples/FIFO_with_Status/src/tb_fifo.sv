module tb_fifo ();
    
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 4;

    logic                   clk;
    logic                   arst_n;
    
    // Write Interface
    logic                   wr_en;
    logic [DATA_WIDTH-1:0]  wr_data;
    logic                   full;
    logic                   almost_full;
    
    // Read Interface
    logic                   rd_en;
    logic [DATA_WIDTH-1:0]  rd_data;
    logic                   empty;
    logic                   almost_empty;

    logic [ADDR_WIDTH  :0]  w_count;

    fifo #(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    ) u_dut (
        .clk         ( clk          ),
        .arst_n      ( arst_n       ),
        .wr          ( wr_en        ),
        .wr_data     ( wr_data      ),
        .full        ( full         ),
        .almost_full ( almost_full  ),
        .rd          ( rd_en        ),
        .rd_data     ( rd_data      ),
        .empty       ( empty        ),
        .almost_empty( almost_empty ),
        .w_count     ( w_count      )
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
        repeat (18) begin
            @(posedge clk);
            wr_en   <= 1;
            wr_data <= $random;
        end

        @(posedge clk);
        wr_en <= 0;

        // Read the data back
        repeat (18) begin
            @(posedge clk);
            rd_en   <= 1;
        end

        @(posedge clk);
        rd_en <= 0;

        #100;
        $finish;
    end

endmodule