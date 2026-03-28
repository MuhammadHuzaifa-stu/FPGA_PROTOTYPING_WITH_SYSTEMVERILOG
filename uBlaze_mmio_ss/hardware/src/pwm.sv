module pwm #(
    parameter R          = 10, // resolution of PWM
    parameter DATA_WIDTH = 32
) (
    input  logic                  clk,
    input  logic                  arst_n,

    input  logic [R-1:0]          duty_cycle,
    input  logic [DATA_WIDTH-1:0] dvsr,
    output logic                  pwm_out
);

/*
    For more details Refer to the chapter-14 of the book "FPGA Prototyping by SystemVerilog Examples".
    14.2.2 onwards        
*/

    logic [R-1:0]          d_reg;
    logic [R-1:0]          d_next;
    logic [R  :0]          d_ext; // to achieve 0-100% duty cycle range

    logic                  pwm_reg;
    logic                  pwm_next;

    logic [DATA_WIDTH-1:0] q_reg;
    logic [DATA_WIDTH-1:0] q_next;

    logic                  tick; // indicates the end of one PWM cycle

    always_ff @(posedge clk or negedge arst_n) 
    begin
        if (!arst_n) 
        begin
            d_reg   <= 'd0;
            q_reg   <= 'd0;
            pwm_reg <= 1'b0;
        end 
        else 
        begin
            d_reg   <= d_next;
            q_reg   <= q_next;
            pwm_reg <= pwm_next;
        end
    end

    // prescale counter
    assign q_next   = (q_reg == dvsr) ? 'd0 : q_reg + 'd1;
    assign tick     = q_reg == 'd0;
    // duty cycle counter
    assign d_next   = tick ? d_reg + 'd1 : d_reg;
    assign d_ext    = {1'b0, d_reg};

    assign pwm_next = d_ext < duty_cycle;
    assign pwm_out  = pwm_reg;
    
endmodule