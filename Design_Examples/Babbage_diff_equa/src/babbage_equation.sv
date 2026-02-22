module babbage_equation #(
    parameter  IN_WIDTH  = 5,
    localparam OUT_WIDTH = 2*IN_WIDTH + 2
) (
    input  logic                 clk,
    input  logic                 arst_n,

    input  logic                 start,
    input  logic [IN_WIDTH -1:0] n,

    output logic [OUT_WIDTH-1:0] f_out,
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

    logic [OUT_WIDTH-1:0] g_reg;
    logic [OUT_WIDTH-1:0] g_next;
    logic [OUT_WIDTH-1:0] f_reg;
    logic [OUT_WIDTH-1:0] f_next;

    logic [IN_WIDTH -1:0] n_reg;
    logic [IN_WIDTH -1:0] n_next;

    always_ff @( posedge clk or negedge arst_n ) 
    begin : state_update_blk
        if (!arst_n) 
        begin
            CS    <= IDLE;
            g_reg <= 0;
            f_reg <= 0;
            n_reg <= 0;
        end 
        else 
        begin
            CS     <= NS;
            g_reg  <= g_next;
            f_reg  <= f_next;
            n_reg  <= n_next;
        end
    end

    always_comb
    begin: next_state_blk
        NS      = CS;
        g_next  = g_reg;
        f_next  = f_reg;
        n_next  = n_reg;

        case (CS)
            IDLE: begin
                if (start) 
                begin
                    NS      = CALC;
                    g_next  = 'd5;
                    f_next  = 'd5;
                    n_next  = n;
                    if (n == 'd0)
                        NS = DONE;
                end
            end

            CALC: begin
                f_next = f_reg + g_reg;
                g_next = g_reg + 'd4;
                n_next = n_reg - 1;

                if (n_reg == 1)
                    NS = DONE;
            end

            DONE: begin
                NS = IDLE;
            end

            default: NS = IDLE;
        endcase
    end

    assign rdy     = (CS == IDLE);
    assign done    = (CS == DONE);
    assign f_out   = f_reg;

endmodule