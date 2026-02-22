module db_sw_top #(
    parameter CLK_FREQ = 200_000_000
) (
    input  logic       sys_clk_p,
    input  logic       sys_clk_n,
    input  logic       sys_rstn,

    input  logic [1:0] button,
    output logic [3:0] seg_sel,
    output logic [7:0] seg_led
);

    localparam SEG_FREQ  = CLK_FREQ / 1000;
    localparam SEG_WIDTH = $clog2(SEG_FREQ);

    logic clk;
    logic btn; 
    logic clr;
    logic db; 
    logic db_d; 
    logic tick;

    logic [7:0]           lvl_cnt;
    logic [7:0]           db_cnt;
    logic [SEG_WIDTH-1:0] cnt_seg;
    logic                 tick_seg;
    logic [1:0]           seg_sel_cnt;
    logic [3:0]           sev_seg_dec_in;

    assign btn = !button[1];
    assign clr = !button[0];

    IBUFDS # ( 
        .DIFF_TERM   ("FALSE"  ),        
        .IBUF_LOW_PWR("TRUE"   ),      
        .IOSTANDARD  ("DEFAULT")      
    ) IBUFDS_inst ( 
        .O (clk      ),  
        .I (sys_clk_p),   
        .IB(sys_clk_n)  
    );

    edge_det u_edge_det (
        .clk   ( clk      ),
        .arst_n( sys_rstn ),
        .lvl   ( btn      ),
        .tick  ( tick     )
    );

    db_sw #(
        .CLK_FREQ(CLK_FREQ)
    ) u_db_sw (
        .clk   ( clk      ),
        .arst_n( sys_rstn ),
        .sw    ( btn      ),
        .db    ( db       )
    );

    sev_seg_dec u_sev_seg_dec (
        .in     ( sev_seg_dec_in ),
        .seg_out( seg_led        )
    );

    always_ff @( posedge clk or negedge sys_rstn ) 
    begin : lvl_counter_blk
        if (!sys_rstn)
            lvl_cnt <= 'd0;
        else if (tick)
            lvl_cnt <= lvl_cnt + 'd1;
        else if (clr)
            lvl_cnt <= 'd0;
    end

    always_ff @( posedge clk or negedge sys_rstn ) 
    begin : db_counter_blk
        if (!sys_rstn)
            db_cnt <= 'd0;
        else if (db & !db_d)
            db_cnt <= db_cnt + 'd1;
        else if (clr)
            db_cnt <= 'd0;
    end

    always_ff @( posedge clk or negedge sys_rstn ) 
    begin : seg_tick_blk
        if (!sys_rstn)
        begin
            cnt_seg  <= 'd0;
            tick_seg <= 'd0;
        end
        else if (cnt_seg == SEG_FREQ - 1)
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
            seg_sel_cnt <= 'd0;
        else if (tick_seg)
            seg_sel_cnt <= seg_sel_cnt + 1;
    end

    always_ff @( posedge clk or negedge sys_rstn ) 
    begin : delay_blk
        if (!sys_rstn)
            db_d <= 'd0;
        else
            db_d <= db;
    end

    always_comb 
    begin
        case (seg_sel_cnt)
            'd0 : begin
                sev_seg_dec_in = lvl_cnt[7:4];
                seg_sel        = 4'b0001;
            end
            'd1 : begin
                sev_seg_dec_in = lvl_cnt[3:0];
                seg_sel        = 4'b0010;
            end
            'd2 : begin
                sev_seg_dec_in = db_cnt[7:4];
                seg_sel        = 4'b0100;
            end
            default : begin
                sev_seg_dec_in = db_cnt[3:0];
                seg_sel        = 4'b1000;
            end 
        endcase
    end

endmodule