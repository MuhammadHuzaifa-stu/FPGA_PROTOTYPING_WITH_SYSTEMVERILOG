module tb_bcd_to_bin ();
    
    parameter  BCD_DIGITS = 4;
    localparam BIN_DIGITS = $clog2(10**BCD_DIGITS);

    logic                        clk;
    logic                        arst_n;
    logic                        start;
    logic [BCD_DIGITS-1:0][3:0]  bcd_in;
    logic [BIN_DIGITS-1:0]       bin_out;
    logic                        done;
    logic                        rdy;

    bcd_to_bin #(
        .BCD_DIGITS(BCD_DIGITS)
    ) u_dut (
        .clk    ( clk     ),
        .arst_n ( arst_n  ),
        .start  ( start   ),
        .bcd_in ( bcd_in  ),
        .bin_out( bin_out ),
        .done   ( done    ),
        .rdy    ( rdy     )
    );

    initial 
    begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    initial 
    begin
        arst_n <= 'd0;
        start  <= 'd0;
        bcd_in <= 'd0;

        #1;
        arst_n <= 'd1;

        @(posedge clk);
        // CASE-I
        bcd_in[0] <= 'd4; //1234
        bcd_in[1] <= 'd3; //1234
        bcd_in[2] <= 'd2; //1234
        bcd_in[3] <= 'd1; //1234
        start     <= 'd1;
        @(posedge clk);
        start     <= 'd0;
        
        wait (done);
        for (int i = BCD_DIGITS-1; i >= 0; i--)
            $display("BCD Digit %0d: %0d", i, bcd_in[i]);

        $display("Output: %d", bin_out);

        @(posedge clk);
        // CASE-II
        bcd_in <= 13'd0;
        start  <= 'd1;
        @(posedge clk);
        start  <= 'd0;
        
        wait (done);
        for (int i = BCD_DIGITS-1; i >= 0; i--)
            $display("BCD Digit %0d: %0d", i, bcd_in[i]);

        $display("Output: %d", bin_out);

        @(posedge clk);
        // CASE-III
        bcd_in[0] <= 'd1; //8191 
        bcd_in[1] <= 'd9; //8191 
        bcd_in[2] <= 'd1; //8191 
        bcd_in[3] <= 'd8; //8191 
        start     <= 'd1;
        @(posedge clk);
        start     <= 'd0;

        wait (done);
        for (int i = BCD_DIGITS-1; i >= 0; i--)
            $display("BCD Digit %0d: %0d", i, bcd_in[i]);

        $display("Output: %d", bin_out);

        repeat(5) @(posedge clk);
        $finish;
    end

endmodule