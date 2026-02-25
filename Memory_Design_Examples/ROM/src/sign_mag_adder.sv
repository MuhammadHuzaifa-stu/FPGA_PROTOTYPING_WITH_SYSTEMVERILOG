module sign_mag_adder #(
    parameter DATA_WIDTH = 8
) (
    input  logic [DATA_WIDTH-1:0] a_in,
    input  logic [DATA_WIDTH-1:0] b_in,
    output logic [DATA_WIDTH-1:0] adder_out
);
    
    logic [DATA_WIDTH-2:0] a_mag;
    logic [DATA_WIDTH-2:0] b_mag;
    logic [DATA_WIDTH-2:0] max;
    logic [DATA_WIDTH-2:0] min;
    logic [DATA_WIDTH-2:0] mag_sum;

    logic                  sign_a;
    logic                  sign_b;
    logic                  sign_sum;

    always_comb 
    begin
        a_mag  = a_in[DATA_WIDTH-2:0];
        b_mag  = b_in[DATA_WIDTH-2:0];
        sign_a = a_in[DATA_WIDTH-1];
        sign_b = b_in[DATA_WIDTH-1];

        if (a_mag > b_mag)
        begin
            max = a_mag;
            min = b_mag;
            sign_sum = sign_a;
        end
        else
        begin
            max = b_mag;
            min = a_mag;
            sign_sum = sign_b;
        end

        if (sign_a == sign_b)
        begin
            mag_sum = max + min;
        end
        else
        begin
            mag_sum = max - min;
        end
    
        adder_out = {sign_sum, mag_sum};
    end

endmodule