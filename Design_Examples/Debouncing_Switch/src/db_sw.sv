module db_sw #(
    parameter CLK_FREQ = 200_000_000 // period: 5ns
) (
    input  logic clk,
    input  logic arst_n,

    input  logic sw,
    output logic db
);
    
    localparam FREQ_10MS = 100; // period; 10ms
    localparam N         = $clog2(CLK_FREQ / FREQ_10MS);
    // --> equation: 2^N x 5ns = 10ms <--

    typedef enum { 
        ZERO, WAIT1_1, WAIT1_2,
        ONE , WAIT0_1, WAIT0_2
    } state_t;

    logic [N-1:0] ms_cnt;
    logic         ms_tick;

    state_t       CS;
    state_t       NS;

    assign ms_tick = (ms_cnt == 'd0);
    assign db      = (CS == ONE) | (CS == WAIT0_1) | (CS == WAIT0_2); // output

    always_ff @( posedge clk or negedge arst_n ) 
    begin : ms_tick_counter_blk
        if (!arst_n)
        begin
            ms_cnt <= 'd0;
        end
        else
        begin
            ms_cnt <= ms_cnt + 'd1;
        end
    end

    always_ff @( posedge clk or negedge arst_n ) 
    begin : state_blk
        if (!arst_n)
        begin
            CS <= ZERO;
        end
        else
        begin
            CS <= NS;
        end
    end

    always_comb 
    begin : ns_blk

        NS = CS;
        case (CS)
            ZERO : begin
                if (sw)
                    NS = WAIT1_1;
            end
            WAIT1_1 : begin
                if (!sw)
                    NS = ZERO;
                else
                    if (ms_tick)
                        NS = WAIT1_2;
            end
            WAIT1_2 : begin
                if (!sw)
                    NS = ZERO;
                else
                    if (ms_tick)
                        NS = ONE; 
            end
            ONE : begin
                if (!sw)
                    NS = WAIT0_1;
            end
            WAIT0_1 : begin
                if (sw)
                    NS = ONE;
                else
                    if (ms_tick)
                        NS = WAIT0_2;
            end
            WAIT0_2 : begin
                if (sw)
                    NS = ONE;
                else
                    if (ms_tick)
                        NS = ZERO;
            end
            default : NS = ZERO;
        endcase
    end

endmodule