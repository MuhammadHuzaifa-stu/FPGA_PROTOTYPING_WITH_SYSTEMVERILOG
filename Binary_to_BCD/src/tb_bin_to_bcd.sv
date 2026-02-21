module tb_bin_to_bcd ();
    
    parameter  BIN_DIGITS = 13;
    // num of bcd digits = bin_dits x 0.30103, so we need to round up to the nearest integer
    // (BIN_DIGITS * 302 / 1000) is a safe integer-only approximation of log10(2)
    localparam BCD_DIGITS = (BIN_DIGITS * 302 / 1000) + 1;

    logic                        clk;
    logic                        arst_n;
    logic                        start;
    logic [BIN_DIGITS-1:0]       bin_in;
    logic [BCD_DIGITS-1:0][3:0]  bcd_out;
    logic                        done;
    logic                        rdy;

    bin_to_bcd #(
        .BIN_DIGITS(BIN_DIGITS)
    ) u_dut (
        .clk    ( clk     ),
        .arst_n ( arst_n  ),
        .start  ( start   ),
        .bin_in ( bin_in  ),
        .bcd_out( bcd_out ),
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
        bin_in <= 'd0;

        #1;
        arst_n <= 'd1;

        @(posedge clk);
        // CASE-I
        bin_in <= 13'b0_0100_1101_0010; //1234
        start  <= 'd1;
        @(posedge clk);
        start <= 'd0;
        
        wait (done);
        $display("Input: %d", bin_in);
        for (int i = BCD_DIGITS-1; i >= 0; i--)
            $display("BCD Digit %0d: %0d", i, bcd_out[i]);

        @(posedge clk);
        // CASE-II
        bin_in <= 13'd0;
        start  <= 'd1;
        @(posedge clk);
        start <= 'd0;
        
        wait (done);
        $display("Input: %d", bin_in);
        for (int i = BCD_DIGITS-1; i >= 0; i--)
            $display("BCD Digit %0d: %0d", i, bcd_out[i]);

        @(posedge clk);
        // CASE-III
        bin_in <= 13'b1_1111_1111_1111; //8191 
        start  <= 'd1;
        @(posedge clk);
        start <= 'd0;

        wait (done);
        $display("Input: %d", bin_in);
        for (int i = BCD_DIGITS-1; i >= 0; i--)
            $display("BCD Digit %0d: %0d", i, bcd_out[i]);

        repeat(5) @(posedge clk);
        $finish;
    end

endmodule