module anillo 
#(  parameter LEN = 4) (   
    input clk,
    input rst,
    input en,
    output reg[LEN-1:0] q);

    always @(posedge clk ) begin
        if (rst) begin
            q <= {{(LEN- 1){1'b0}},{1'b1}};
        end else if (en) begin
            q <= {q[LEN- 2:0],q[LEN-1]};
        end
    end 
endmodule
