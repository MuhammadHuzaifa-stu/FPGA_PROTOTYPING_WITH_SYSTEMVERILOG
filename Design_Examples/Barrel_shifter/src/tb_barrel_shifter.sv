`timescale 1ns/1ps

module tb_barrel_shifter ();
    
    localparam NUM_TESTS   = 20;
    localparam WIDTH       = 16;
    localparam SHAMT_WIDTH = $clog2(WIDTH);

    logic [WIDTH      -1:0] a_in;
    logic [SHAMT_WIDTH-1:0] shamt;
    logic                   dir;

    logic [WIDTH      -1:0] a_out;
    logic [WIDTH      -1:0] expected_out;

    barrel_shifter # (
        .WIDTH(WIDTH)
    ) u_dut (
        .a_in (a_in ),
        .shamt(shamt),
        .dir  (dir  ),
        .a_out(a_out)
    );

    initial 
    begin
        a_in  = 'd0;
        shamt = 'd0;
        dir   = 'd0;
        #10;

        for (int i = 0; i < NUM_TESTS; i++) 
        begin
            a_in  = $urandom_range(0, 2**WIDTH       - 1);
            shamt = $urandom_range(0, 2**SHAMT_WIDTH - 1);
            dir   = $urandom_range(0, 1);
            
            #5;
            $display(">>> Self Checking...");
            if (dir == 0) 
            begin : left_rotate_logic
                // For Left Rotate:
                // If shamt is 0, we must handle it carefully to avoid a shift by WIDTH
                if (shamt == 0) 
                    expected_out = a_in;
                else 
                    expected_out = (a_in << shamt) | (a_in >> (WIDTH - shamt));
            end 
            else 
            begin : right_rotate_logic
                // For Right Rotate:
                if (shamt == 0) 
                    expected_out = a_in;
                else 
                    expected_out = (a_in >> shamt) | (a_in << (WIDTH - shamt));
            end

            if (a_out !== expected_out)
            begin
                $error("Test Failed for a_in=%0h, shamt=%0d, dir=%0d: Expected a_out=%0h, Got a_out=%0h", 
                        a_in, shamt, dir, expected_out, a_out);
            end 
            else
            begin
                $display("Test Passed for a_in=%0h, shamt=%0d, dir=%0d: a_out=%0h", 
                         a_in, shamt, dir, a_out);
            end
            #5;
        end

        #10;
        $finish;
    end

endmodule