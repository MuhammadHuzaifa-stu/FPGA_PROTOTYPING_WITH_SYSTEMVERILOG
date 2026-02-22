module fibonacci #(
    parameter  IN_WIDTH  = 5,
    localparam OUT_WIDTH = (1 << IN_WIDTH) - 1
) (
    input  logic                 clk,
    input  logic                 arst_n,

    input  logic                 start,
    input  logic [IN_WIDTH -1:0] n,

    output logic [OUT_WIDTH-1:0] fib_out,
    output logic                 done,
    output logic                 rdy    
);
    
    typedef enum { 
        IDLE,
        CALC,
        DONE
    } state_t;

    state_t               CS;
    state_t               NS;

    logic [OUT_WIDTH-1:0] t0_reg;
    logic [OUT_WIDTH-1:0] t0_next;
    logic [OUT_WIDTH-1:0] t1_reg;
    logic [OUT_WIDTH-1:0] t1_next;

    logic [IN_WIDTH -1:0] n_reg;
    logic [IN_WIDTH -1:0] n_next;

    always_ff @( posedge clk or negedge arst_n ) 
    begin : state_update_blk
        if (!arst_n) 
        begin
            CS     <= IDLE;
            t0_reg <= 0;
            t1_reg <= 0;
            n_reg  <= 0;
        end 
        else 
        begin
            CS     <= NS;
            t0_reg <= t0_next;
            t1_reg <= t1_next;
            n_reg  <= n_next;
        end
    end

    always_comb
    begin: next_state_blk
        NS      = CS;
        t0_next = t0_reg;
        t1_next = t1_reg;
        n_next  = n_reg;

        case (CS)
            IDLE: begin
                if (start) 
                begin
                    NS      = CALC;
                    t0_next = 0;
                    t1_next = 1;
                    n_next  = n;
                end
            end

            CALC: begin
                if (n_reg == 0) 
                begin
                    t1_next = 'd0;
                    NS      = DONE;
                end
                else if (n_reg == 1)
                begin
                    NS      = DONE;
                end
                else
                begin
                    t1_next = t0_reg + t1_reg;
                    t0_next = t1_reg;
                    n_next  = n_reg - 1;
                end
            end

            DONE: begin
                NS = IDLE;
            end

            default: NS = IDLE;
        endcase
    end

    assign rdy     = (CS == IDLE);
    assign done    = (CS == DONE);
    assign fib_out = t1_reg;

endmodule