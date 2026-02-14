module square_wave #(
    localparam WIDTH = 4
)(
    input  logic             clk, 
    input  logic             arst_n,

    input  logic [WIDTH-1:0] m, // logic 1 interval
    input  logic [WIDTH-1:0] n, // logic 0 interval
    input  logic             gen,

    output logic             square_wave_out
);
    
    localparam OFFSET    = 32;
    localparam CNT_WIDTH = $clog2(OFFSET) + WIDTH;
    
    logic [CNT_WIDTH-1:0] cnt;
    logic [CNT_WIDTH-1:0] n_thold;
    logic [CNT_WIDTH-1:0] m_thold;

    assign n_thold = n << $clog2(OFFSET);
    assign m_thold = m << $clog2(OFFSET);

    always_ff @(posedge clk or negedge arst_n) 
    begin
        if (!arst_n) 
        begin
            cnt             <= 0;
            square_wave_out <= 0;
        end 
        else if (gen) 
        begin
            if ((m_thold == 0) && (n_thold == 0))
            begin
                square_wave_out <= 0;
                cnt             <= 0;
            end
            else if (square_wave_out == 0) 
            begin
                if (cnt >= n_thold - 1) 
                begin
                    square_wave_out <= 1;
                    cnt             <= 0;
                end 
                else 
                begin
                    cnt <= cnt + 1;
                end
            end 
            else 
            begin
                if (cnt >= m_thold - 1) 
                begin
                    square_wave_out <= 0;
                    cnt             <= 0;
                end 
                else 
                begin
                    cnt <= cnt + 1;
                end
            end
        end
        else
        begin
            cnt             <= 0;
            square_wave_out <= 0;            
        end
    end

endmodule