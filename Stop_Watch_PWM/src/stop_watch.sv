module stop_watch # (
) (
    input  logic       clk,
    input  logic       arst_n,

    input  logic       cnt_en,
    input  logic       clr,
    
    output logic [3:0] sec_0,
    output logic [2:0] sec_1,
    output logic [3:0] min_0,
    output logic [2:0] min_1,
    output logic [3:0] hr_0,
    output logic       hr_1
);

    localparam SEC_TIMER = 200_000_000;
    localparam CNT_WIDTH = $clog2(SEC_TIMER);

    logic [CNT_WIDTH-1 : 0] cnt;
    logic                   tick;

    // tick
    assign tick = (cnt == SEC_TIMER - 1) && cnt_en;

    // counter
    always_ff @( posedge clk or negedge arst_n ) 
    begin : counter_blk
        if (!arst_n)
        begin
            cnt <= '0;
        end
        else if (clr || (cnt_en && (cnt == SEC_TIMER - 1)))
        begin
            cnt <= '0;
        end
        else if (cnt_en)
        begin
            cnt <= cnt + 1;
        end
    end

    // stop watch
    always_ff @( posedge clk or negedge arst_n )
    begin
        if (!arst_n)
        begin
            sec_0 <= '0;
            sec_1 <= '0;
            min_0 <= '0;
            min_1 <= '0;
            hr_0  <= '0;
            hr_1  <= '0;
        end
        else if (clr)
        begin
            sec_0 <= '0;
            sec_1 <= '0;
            min_0 <= '0;
            min_1 <= '0;
            hr_0  <= '0;
            hr_1  <= '0;
        end
        else if (tick)
        begin
            if (sec_0 == 'd9)
            begin
                sec_0 <= '0;

                if (sec_1 == 'd5)
                begin
                    sec_1 <= '0;

                    if (min_0 == 'd9)
                    begin
                        min_0 <= '0;

                        if (min_1 == 'd5)
                        begin
                            min_1 <= '0;
                            
                            if (hr_0 == 'd9)
                            begin
                                hr_0 <= '0;
                                hr_1 <= hr_1 + 1;
                            end
                            else if (hr_1 == 'd1 && hr_0 == 'd2)  // 12:59:59
                            begin
                                hr_0 <= '0;
                                hr_1 <= '0;
                            end
                            else
                            begin
                                hr_0 <= hr_0 + 1;
                            end
                        end
                        else
                        begin
                            min_1 <= min_1 + 1;
                        end
                    end
                    else
                    begin
                        min_0 <= min_0 + 1;
                    end
                end
                else
                begin
                    sec_1 <= sec_1 + 1;
                end
            end
            else
            begin
                sec_0 <= sec_0 + 1;
            end
        end
    end
    
endmodule