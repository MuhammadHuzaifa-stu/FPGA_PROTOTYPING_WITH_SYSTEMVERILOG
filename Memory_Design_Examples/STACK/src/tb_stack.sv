module tb_stack ();
    
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 4;

    logic                   clk;
    logic                   arst_n;
    
    // Write Interface
    logic                   push;
    logic [DATA_WIDTH-1:0]  wr_data;
    logic                   full;
    
    // Read Interface
    logic                   pop;
    logic [DATA_WIDTH-1:0]  rd_data;
    logic                   empty;

    stack #(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    ) u_dut (
        .clk     ( clk     ),
        .arst_n  ( arst_n  ),
        .push    ( push    ),
        .wr_data ( wr_data ),
        .full    ( full    ),
        .pop     ( pop     ),
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
        push    <= 'd0;
        wr_data <= 'd0;
        pop     <= 'd0;

        #1;
        arst_n  <= 'd1;

        // Write some data
        repeat (18) begin
            @(posedge clk);
            push    <= 1;
            wr_data <= $random;
        end

        @(posedge clk);
        push <= 0;

        // Read the data back
        repeat (18) begin
            @(posedge clk);
            pop   <= 1;
        end

        @(posedge clk);
        pop <= 0;

        #100;
        $finish;
    end

endmodule