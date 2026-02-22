module bin_to_bcd #(
    parameter  BIN_DIGITS = 13,
    // num of bcd digits = bin_dits x 0.30103, so we need to round up to the nearest integer
    // (BIN_DIGITS * 302 / 1000) is a safe integer-only approximation of log10(2)
    localparam BCD_DIGITS = (BIN_DIGITS * 302 / 1000) + 1
) (
    input  logic                        clk,
    input  logic                        arst_n,

    input  logic                        start,
    input  logic [BIN_DIGITS -1:0]      bin_in,

    output logic [BCD_DIGITS -1:0][3:0] bcd_out,
    output logic                        done,
    output logic                        rdy
);

    localparam BIN_WIDTH = $clog2(BIN_DIGITS);
    
    typedef enum { 
        IDLE,
        CALC,
        DONE
    } state_t;

    state_t                      CS;
    state_t                      NS;

    logic [BIN_WIDTH  -1:0]      n_reg;
    logic [BIN_WIDTH  -1:0]      n_next;

    logic [BCD_DIGITS -1:0][3:0] bcd_reg;
    logic [BCD_DIGITS -1:0][3:0] bcd_next;
    logic [BCD_DIGITS -1:0][3:0] bcd_tmp;

    logic [BIN_DIGITS -1:0]      bin_reg;
    logic [BIN_DIGITS -1:0]      bin_next;

    always_ff @( posedge clk or negedge arst_n )
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
                    bcd_next = 'd0;
                    bin_next = bin_in;
                end
            end
            CALC: begin
                // 1. Shift the Binary Register
                bin_next    = {bin_reg[BIN_DIGITS -2:0], 1'b0};   
                // 2. Shift from Binary into BCD Digit 0
                // Use bcd_tmp (the version that had +3 added if needed)
                bcd_next[0] = {bcd_tmp[0][2:0], bin_reg[BIN_DIGITS -1]};
                // 3. Shift carries between BCD Digits
                for (int i=1; i<BCD_DIGITS; i++)
                    bcd_next[i] = {bcd_tmp[i][2:0], bcd_tmp[i-1][3]};

                n_next = n_reg - 1;
                if (n_next == 0)
                    NS = DONE;
            end
            default: NS = IDLE; 
        endcase
    end

    generate
        for (genvar i=0; i<BCD_DIGITS; i++)
        begin
            assign bcd_tmp[i] = (bcd_reg[i] > 4) ? bcd_reg[i] + 3 : bcd_reg[i];
        end
    endgenerate

    assign bcd_out = bcd_reg;
    assign done    = (CS == DONE);
    assign rdy     = (CS == IDLE);

endmodule