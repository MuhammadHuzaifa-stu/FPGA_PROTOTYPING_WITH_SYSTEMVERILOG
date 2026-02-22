module tb_fib ();
    
    localparam IN_WIDTH  = 5;
    localparam OUT_WIDTH = (1 << IN_WIDTH) - 1;

    logic                 clk;
    logic                 arst_n;
    logic                 start;

    logic [IN_WIDTH -1:0] n;
    logic [OUT_WIDTH-1:0] fib_out;

    logic                 done;
    logic                 rdy;

    fibonacci #(
        .IN_WIDTH(IN_WIDTH)
    ) u_dut (
        .clk    (clk    ),
        .arst_n (arst_n ),
        .start  (start  ),
        .n      (n      ),
        .fib_out(fib_out),
        .done   (done   ),
        .rdy    (rdy    )
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
        n      <= 'd0;

        @(posedge clk);
        arst_n <= 'd1;
        @(posedge clk);

        n     <= 'd10;
        start <= 'd1; // Start the calculation

        @(posedge clk);
        start <= 'd0; // Deassert start

        wait(done); // Wait until the calculation is done

        $display("Fibonacci of %0d is %0d", n, fib_out);
        
        repeat(5) @(posedge clk);
        $finish; // End simulation
    end

endmodule