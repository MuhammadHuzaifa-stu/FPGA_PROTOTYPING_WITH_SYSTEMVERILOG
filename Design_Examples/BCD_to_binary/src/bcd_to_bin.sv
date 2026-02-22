module bcd_to_bin #(
    parameter  BCD_DIGITS = 4,
    localparam BIN_DIGITS = $clog2(10**BCD_DIGITS)
) (
    input  logic                        clk,
    input  logic                        arst_n,

    input  logic                        start,
    input  logic [BCD_DIGITS -1:0][3:0] bcd_in,

    output logic [BIN_DIGITS -1:0]      bin_out,
    output logic                        done,
    output logic                        rdy
);

    localparam BIN_WIDTH = $clog2(BIN_DIGITS+1);
    
    typedef enum { 
        IDLE, CALC, DONE
    } state_t;

    state_t                      CS, NS;

    logic [BIN_WIDTH  -1:0]      n_reg; 
    logic [BIN_WIDTH  -1:0]      n_next;

    logic [BCD_DIGITS -1:0][3:0] bcd_reg; 
    logic [BCD_DIGITS -1:0][3:0] bcd_next;

    logic [BIN_DIGITS -1:0]      bin_reg; 
    logic [BIN_DIGITS -1:0]      bin_next;

    always_ff @(posedge clk or negedge arst_n) 
    begin: state_blk
        if (!arst_n) 
        begin
            CS      <= IDLE;
            n_reg   <= 'd0;
            bcd_reg <= 'd0;
            bin_reg <= 'd0;
        end 
        else 
        begin
            CS      <= NS;
            n_reg   <= n_next;
            bcd_reg <= bcd_next;
            bin_reg <= bin_next;
        end
    end

    always_comb 
    begin : ns_blk
        NS       = CS;
        n_next   = n_reg;
        bcd_next = bcd_reg;
        bin_next = bin_reg;

        case (CS)
            IDLE: begin
                if (start) 
                begin
                    NS       = CALC;
                    n_next   = BIN_DIGITS;
                    bcd_next = bcd_in;
                    bin_next = 'd0;
                end
            end

            CALC: begin
                // 1. Shift the LSB of BCD into the Binary Register (Right Shift)
                bin_next = {bcd_reg[0][0], bin_reg[BIN_DIGITS-1:1]};

                // 2. Perform Shift-then-Adjust for BCD nibbles
                for (int i = 0; i < BCD_DIGITS; i++) 
                begin
                    logic [3:0] shifted_nibble;
                    
                    // Shift: Bring down the LSB from the nibble to the left
                    if (i == BCD_DIGITS - 1)
                        shifted_nibble = {1'b0, bcd_reg[i][3:1]};
                    else
                        shifted_nibble = {bcd_reg[i+1][0], bcd_reg[i][3:1]};

                    // Adjust: If the shifted result is 8 or higher, subtract 3
                    if (shifted_nibble > 7)
                        bcd_next[i] = shifted_nibble - 3;
                    else
                        bcd_next[i] = shifted_nibble;
                end

                n_next = n_reg - 1;
                if (n_next == 0) 
                    NS = DONE;
            end

            default: NS = IDLE; 
        endcase
    end

    assign bin_out = bin_reg;
    assign done    = (CS == DONE);
    assign rdy     = (CS == IDLE);

endmodule