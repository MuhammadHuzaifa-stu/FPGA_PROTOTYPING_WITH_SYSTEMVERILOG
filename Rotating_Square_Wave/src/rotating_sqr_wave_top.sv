module rotating_sqr_wave_top (
    input  logic       sys_clk_p, 
    input  logic       sys_clk_n,

    input  logic       sys_rstn,
    
    input  logic       en,
    input  logic       rot, // 0: counter-clockwise, 1: clockwise
    
    output logic [7:0] seg_sel,
    output logic [7:0] seg_led1,
    output logic [7:0] seg_led2
);

    localparam CLK_FREQ  = 200_000_000; // 200MHz

    // Multiplexing
    localparam SEG_FREQ  = 5;           // 5Hz
    localparam SEG_THOLD = CLK_FREQ / SEG_FREQ;
    localparam SEG_WIDTH = $clog2(SEG_THOLD);

    // Pattern
    localparam NUM_SEG   = 8;
    localparam SEG_CNT_W = $clog2(NUM_SEG);

    // PATTERN
    //                             gfe_dcba
    localparam TOP_SQUARE    = 8'b0110_0011;
    localparam BOTTOM_SQUARE = 8'b0101_1100;

    logic                 clk;

    logic [SEG_WIDTH-1:0] cnt_seg;
    logic                 tick_seg;

    logic [3:0]           seg_sel_cnt;    
    logic [7:0]           seg_led;

    logic [7:0]           seg_sel_int;

    assign seg_led1 = seg_led;
    assign seg_led2 = seg_led;
    assign seg_sel  = seg_sel_int;

    IBUFDS # ( 
        .DIFF_TERM   ("FALSE"  ),        
        .IBUF_LOW_PWR("TRUE"   ),      
        .IOSTANDARD  ("DEFAULT")      
    ) IBUFDS_inst ( 
        .O (clk      ),  
        .I (sys_clk_p),   
        .IB(sys_clk_n)  
    ); 

    always_ff @( posedge clk or negedge sys_rstn ) 
    begin : seg_tick5Hz_blk
        if (!sys_rstn)
        begin
            cnt_seg  <= 'd0;
            tick_seg <= 'd0;
        end
        else if (en)
        begin
            if (cnt_seg == SEG_THOLD - 1)
            begin
                tick_seg <= 'd1;
                cnt_seg  <= 'd0;
            end
            else
            begin
                cnt_seg  <= cnt_seg + 1;
                tick_seg <= 'd0;
            end            
        end
        else
        begin
            tick_seg <= 'd0;
        end
    end

    always_ff @( posedge clk or negedge sys_rstn ) 
    begin : seg_sel_cnt_blk
        if (!sys_rstn)
        begin
            seg_sel_cnt <= 'd0;
        end
        else if (tick_seg)
        begin
            seg_sel_cnt <= seg_sel_cnt + 1;
        end
    end

    always_comb 
    begin
        case (seg_sel_cnt)
            'd0: begin
                seg_sel_int = (!rot) ? 8'b0000_0001 : 8'b1000_0000;
                seg_led     = TOP_SQUARE;
            end
            'd1: begin
                seg_sel_int = (!rot) ? 8'b0000_0010 : 8'b0100_0000;
                seg_led     = TOP_SQUARE;
            end
            'd2: begin
                seg_sel_int = (!rot) ? 8'b0000_0100 : 8'b0010_0000;
                seg_led     = TOP_SQUARE;
            end
            'd3: begin
                seg_sel_int = (!rot) ? 8'b0000_1000 : 8'b0001_0000;
                seg_led     = TOP_SQUARE;
            end
            'd4: begin
                seg_sel_int = (!rot) ? 8'b0001_0000 : 8'b0000_1000;
                seg_led     = TOP_SQUARE;
            end
            'd5: begin
                seg_sel_int = (!rot) ? 8'b0010_0000 : 8'b0000_0100;
                seg_led     = TOP_SQUARE;
            end
            'd6: begin
                seg_sel_int = (!rot) ? 8'b0100_0000 : 8'b0000_0010;
                seg_led     = TOP_SQUARE;
            end
            'd7: begin
                seg_sel_int = (!rot) ? 8'b1000_0000 : 8'b0000_0001;
                seg_led     = TOP_SQUARE;
            end
            'd8: begin
                seg_sel_int = (!rot) ? 8'b1000_0000 : 8'b0000_0001;
                seg_led     = BOTTOM_SQUARE;
            end
            'd9: begin
                seg_sel_int = (!rot) ? 8'b0100_0000 : 8'b0000_0010;
                seg_led     = BOTTOM_SQUARE;
            end
            'd10: begin
                seg_sel_int = (!rot) ? 8'b0010_0000 : 8'b0000_0100;
                seg_led     = BOTTOM_SQUARE;
            end
            'd11: begin
                seg_sel_int = (!rot) ? 8'b0001_0000 : 8'b0000_1000;
                seg_led     = BOTTOM_SQUARE;
            end
            'd12: begin
                seg_sel_int = (!rot) ? 8'b0000_1000 : 8'b0001_0000;
                seg_led     = BOTTOM_SQUARE;
            end
            'd13: begin
                seg_sel_int = (!rot) ? 8'b0000_0100 : 8'b0010_0000;
                seg_led     = BOTTOM_SQUARE;
            end
            'd14: begin
                seg_sel_int = (!rot) ? 8'b0000_0010 : 8'b0100_0000;
                seg_led     = BOTTOM_SQUARE;
            end
            default: begin
                seg_sel_int = (!rot) ? 8'b0000_0001 : 8'b1000_0000;
                seg_led     = BOTTOM_SQUARE;
            end
        endcase
    end
    
endmodule