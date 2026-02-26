module stack_ctrl #(
    parameter ADDR_WIDTH = 4
)(
    input  logic                   clk,
    input  logic                   arst_n,
    
    // Write Interface
    input  logic                   push,
    output logic [ADDR_WIDTH-1:0]  wr_addr,
    output logic                   full,
    
    // Read Interface
    input  logic                   pop,
    output logic [ADDR_WIDTH-1:0]  rd_addr,
    output logic                   empty
);

    logic [ADDR_WIDTH:0] wr_ptr;
    logic [ADDR_WIDTH:0] wr_ptr_next;

    logic [ADDR_WIDTH:0] pop_ptr;
    logic [ADDR_WIDTH:0] push_ptr;

    always_ff @( posedge clk or negedge arst_n ) 
    begin
        if (!arst_n)
        begin
            wr_ptr <= 'd0;
        end
        else
        begin
            wr_ptr <= wr_ptr_next;
        end
    end

    always_comb 
    begin
        wr_ptr_next = wr_ptr;
        pop_ptr     = wr_ptr - 'd1;
        push_ptr    = wr_ptr + 'd1;

        case ({push, pop})
            2'b01 :begin //read
                if (!empty)
                    wr_ptr_next = pop_ptr;
            end 
            2'b10 :begin //write
                if (!full)
                    wr_ptr_next = push_ptr;
            end 
            default: ; // 2'b11: do nothing, 2'b00: null operation
        endcase
    end

    assign wr_addr = wr_ptr;
    assign rd_addr = pop_ptr;
    assign full    = wr_ptr == 1<<ADDR_WIDTH;
    assign empty   = wr_ptr == 'd0;

endmodule