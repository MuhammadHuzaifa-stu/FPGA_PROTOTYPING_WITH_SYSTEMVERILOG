module PWM #(
    parameter  PWM_FREQ   = 1_000,         // 1kHz
    parameter  CLK_FREQ   = 200_000_000,   // 200MHz
    localparam CNT_THRESH = CLK_FREQ / PWM_FREQ,
    localparam CNT_WIDTH  = $clog2(CNT_THRESH)
) (
    input  logic        clk,
    input  logic        arst_n,
    input  logic [3:0]  duty_cycle, // 0 to 15
    
    output logic        pwm_en
);

    logic [CNT_WIDTH-1:0] cnt;
    logic [CNT_WIDTH-1:0] threshold;

    // Linearly map 4-bit (0-15) to the counter range
    // Threshold = (CNT_THRESH * duty_cycle) / 16
    assign threshold = (CNT_THRESH * duty_cycle) >> 4;
    // High for the first 'threshold' clocks of the period
    assign pwm_en = (cnt < threshold);

    always_ff @(posedge clk or negedge arst_n) 
    begin
        if (!arst_n) 
            cnt <= 0;
        else if (cnt >= CNT_THRESH - 1) 
            cnt <= 0;
        else 
            cnt <= cnt + 1;
    end

endmodule