module sev_seg_dec (
    input  logic [3:0] in,
    output logic [7:0] seg_out
);

    always_comb 
    begin : sev_seg_dec_blk
        case (in)
            4'h0   : seg_out = 8'b1_0111111;
            4'h1   : seg_out = 8'b1_0000110;
            4'h2   : seg_out = 8'b1_1011011;
            4'h3   : seg_out = 8'b1_1001111;
            4'h4   : seg_out = 8'b1_1100110;
            4'h5   : seg_out = 8'b1_1101101;
            4'h6   : seg_out = 8'b1_1111101;
            4'h7   : seg_out = 8'b1_0000111;
            4'h8   : seg_out = 8'b1_1111111;
            4'h9   : seg_out = 8'b1_1101111;
            4'ha   : seg_out = 8'b1_1110111;
            4'hb   : seg_out = 8'b1_1111100;
            4'hc   : seg_out = 8'b1_0111001;
            4'hd   : seg_out = 8'b1_1011110;
            4'he   : seg_out = 8'b1_1111001;
            default: seg_out = 8'b1_1110001; // F
        endcase
    end

endmodule