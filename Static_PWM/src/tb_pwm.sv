module tb_pwm ();

    parameter  PWM_FREQ   = 1_000;         // 1kHz
    parameter  CLK_FREQ   = 200_000_000;   // 200MHz
    localparam CNT_THRESH = CLK_FREQ / PWM_FREQ;
    localparam CNT_WIDTH  = $clog2(CNT_THRESH);

    logic        clk;
    logic        arst_n;
    logic [3:0]  duty_cycle; // 0 to 15
    logic        pwm_en;

    PWM # (
        .PWM_FREQ(PWM_FREQ),
        .CLK_FREQ(CLK_FREQ)
    ) u_dut (
        .clk       (clk       ),
        .arst_n    (arst_n    ),
        .duty_cycle(duty_cycle),
        .pwm_en    (pwm_en    )
    );

    initial 
    begin
        clk = 0;
        forever begin
            #2.5 clk = ~clk; // 200MHz clock
        end    
    end

    initial 
    begin
        arst_n     = 0;
        duty_cycle = 0;
        #1;
        arst_n = 1;
        @(posedge clk);
        while (1) 
        begin
            repeat(400_000) @(posedge clk); // Wait for 400k clock cycles (2ms at 200MHz)        
            if (duty_cycle == 15)
            begin
                @(posedge clk);
                break;                
            end
            else
            begin
                @(posedge clk);
                duty_cycle = duty_cycle + 1;                
            end
        end

        $finish;
    end

endmodule