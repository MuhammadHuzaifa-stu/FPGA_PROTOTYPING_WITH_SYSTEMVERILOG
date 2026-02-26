module fifo_ctrl #(
    parameter ADDR_WIDTH = 4
)(
    input  logic                   clk,
    input  logic                   arst_n,
    
    // Write Interface
    input  logic                   wr_en,
    output logic [ADDR_WIDTH-1:0]  wr_addr,
    output logic                   full,
    output logic                   almost_full,
    
    // Read Interface
    input  logic                   rd_en,
    output logic [ADDR_WIDTH-1:0]  rd_addr,
    output logic                   empty,
    output logic                   almost_empty,

    output logic [ADDR_WIDTH  :0]  w_count
);

    localparam DEPTH  = 1 << ADDR_WIDTH;
    localparam AE_LVL = DEPTH / 4;      // Almost Empty Level 25%
    localparam AF_LVL = DEPTH - AE_LVL; // Almost Full Level 75%

    logic [ADDR_WIDTH-1:0] wr_ptr;
    logic [ADDR_WIDTH-1:0] wr_ptr_next;
    logic [ADDR_WIDTH-1:0] wr_ptr_succ;
    
    logic [ADDR_WIDTH-1:0] rd_ptr;
    logic [ADDR_WIDTH-1:0] rd_ptr_next;
    logic [ADDR_WIDTH-1:0] rd_ptr_succ;

    logic [ADDR_WIDTH  :0] counter;
    logic [ADDR_WIDTH  :0] counter_next;

    always_ff @( posedge clk or negedge arst_n ) 
    begin
        if (!arst_n)
        begin
            wr_ptr      <= 'd0;
            rd_ptr      <= 'd0;
            counter     <= 'd0;
        end
        else
        begin
            wr_ptr      <= wr_ptr_next;
            rd_ptr      <= rd_ptr_next;
            counter     <= counter_next;
        end
    end

    always_comb 
    begin
        wr_ptr_succ  = wr_ptr + 'd1;
        rd_ptr_succ  = rd_ptr + 'd1;

        counter_next = counter;
        wr_ptr_next  = wr_ptr;
        rd_ptr_next  = rd_ptr;
        case ({wr_en, rd_en})
            2'b01 :begin //read
                if (!empty)
                begin
                    rd_ptr_next   = rd_ptr_succ;
                    counter_next  = counter - 'd1;
                end
            end 
            2'b10 :begin //write
                if (!full)
                begin
                    wr_ptr_next  = wr_ptr_succ;
                    counter_next = counter + 'd1;
                end
            end 
            2'b11 :begin //write and read
                wr_ptr_next = wr_ptr_succ;
                rd_ptr_next = rd_ptr_succ;
            end 
            default: ; // 2'b00 null operation
        endcase
    end

    assign wr_addr      = wr_ptr;
    assign rd_addr      = rd_ptr;
    assign full         = counter == DEPTH;
    assign empty        = counter == 'd0;
    assign almost_full  = counter >= AF_LVL;
    assign almost_empty = counter <= AE_LVL;
    assign w_count      = counter;

endmodule