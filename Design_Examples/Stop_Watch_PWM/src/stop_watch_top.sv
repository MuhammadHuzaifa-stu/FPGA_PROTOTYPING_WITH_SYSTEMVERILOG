module stop_watch_top (
    input  logic       sys_clk_p, 
    input  logic       sys_clk_n,

    input  logic       sys_rstn,
    
    input  logic       cnt_en,
    input  logic       clr,
    input  logic [3:0] duty_cycle,
    
    output logic [7:0] seg_sel,
    output logic [7:0] seg_led1,
    output logic [7:0] seg_led2
);

    localparam CLK_FREQ   = 200_000_000;         // 200MHz
    localparam PWM_FREQ   = 1_000;               // 1kHz
    localparam CNT_THOLD  = CLK_FREQ / PWM_FREQ; // 1kHz
    localparam SEG_WIDTH  = $clog2(CNT_THOLD);

    logic                 clk;
    logic [3:0]           sec_0;
    logic [2:0]           sec_1;
    logic [3:0]           min_0;
    logic [2:0]           min_1;
    logic [3:0]           hr_0;
    logic                 hr_1;

    logic [3:0]           sev_seg_dec_in;
    logic                 special_in;

    logic [SEG_WIDTH-1:0] cnt_seg;
    logic                 tick_seg;
    logic [2:0]           seg_sel_cnt;
    
    logic [7:0]           seg_led;
    logic [7:0]           seg_sel_int;

    logic [SEG_WIDTH-1:0] threshold;
    logic                 pwm_en;

    assign seg_led1 = seg_led;
    assign seg_led2 = seg_led;
    assign seg_sel  = seg_sel_int & {8{pwm_en}};

    // Linearly map 4-bit (0-15) to the counter range
    // Threshold = (CNT_THRESH * duty_cycle) / 16
    assign threshold = (CNT_THOLD * duty_cycle) >> 4;
    // High for the first 'threshold' clocks of the period
    assign pwm_en    = (cnt_seg < threshold);

    IBUFDS # ( 
        .DIFF_TERM   ("FALSE"  ),        
        .IBUF_LOW_PWR("TRUE"   ),      
        .IOSTANDARD  ("DEFAULT")      
    ) IBUFDS_inst ( 
        .O (clk      ),  
        .I (sys_clk_p),   
        .IB(sys_clk_n)  
    ); 

    stop_watch u_stop_watch (
        .clk    ( clk      ),
        .arst_n ( sys_rstn ),
        .cnt_en ( cnt_en   ),
        .clr    ( clr      ),
        .sec_0  ( sec_0    ),
        .sec_1  ( sec_1    ),
        .min_0  ( min_0    ),
        .min_1  ( min_1    ),
        .hr_0   ( hr_0     ),
        .hr_1   ( hr_1     )
    );

    sev_seg_dec u_sev_seg_dec_sec_0 (
        .in      ( sev_seg_dec_in   ),
        .special ( special_in       ),
        .seg_out ( seg_led          )
    );

    always_ff @( posedge clk or negedge sys_rstn ) 
    begin : seg_tick_blk
        if (!sys_rstn)
        begin
            cnt_seg  <= 'd0;
            tick_seg <= 'd0;
        end
        else if (cnt_seg == CNT_THOLD - 1)
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
            'd0 : begin
                sev_seg_dec_in = sec_0;
                special_in     = 'd0;
                seg_sel_int    = 8'b0000_0001;
            end
            'd1 : begin
                sev_seg_dec_in = {1'b0, sec_1};
                special_in     = 'd0;
                seg_sel_int    = 8'b0000_0010;
            end
            'd2 : begin
                sev_seg_dec_in = 'd0;
                special_in     = 'd1;
                seg_sel_int    = 8'b0000_0100;
            end
            'd3 : begin
                sev_seg_dec_in = min_0;
                special_in     = 'd0;
                seg_sel_int    = 8'b0000_1000;
            end
            'd4 : begin
                sev_seg_dec_in = {1'b0, min_1};
                special_in     = 'd0;
                seg_sel_int    = 8'b0001_0000;
            end
            'd5 : begin
                sev_seg_dec_in = 'd0;
                special_in     = 'd1;
                seg_sel_int    = 8'b0010_0000;
            end
            'd6 : begin
                sev_seg_dec_in = hr_0;
                special_in     = 'd0;
                seg_sel_int    = 8'b0100_0000;
            end
            default : begin
                sev_seg_dec_in = {3'd0, hr_1};
                special_in     = 'd0;
                seg_sel_int    = 8'b1000_0000;
            end 
        endcase
    end
    
endmodule