module sev_seg_dec (
    input  logic [3:0] in,
    input  logic       special, // special mode for displaying specific patterns (e.g., for "12-59-59")
    output logic [7:0] seg_out
);
    logic [7:0] seg_int;

    assign seg_out = special ? 8'b0_1000000 : seg_int;

    always_comb 
    begin : sev_seg_dec_blk
        case (in)
            4'h0   : seg_int = 8'b0_0111111;
            4'h1   : seg_int = 8'b0_0000110;
            4'h2   : seg_int = 8'b0_1011011;
            4'h3   : seg_int = 8'b0_1001111;
            4'h4   : seg_int = 8'b0_1100110;
            4'h5   : seg_int = 8'b0_1101101;
            4'h6   : seg_int = 8'b0_1111101;
            4'h7   : seg_int = 8'b0_0000111;
            4'h8   : seg_int = 8'b0_1111111;
            4'h9   : seg_int = 8'b0_1101111;
            default: seg_int = 8'b0_0000000; // all segments off for invalid input
        endcase
    end

endmodule