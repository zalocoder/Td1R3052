module contador 
#(parameter N   = 4,
  parameter UP  = 0) (
    input wire clk,
    input wire rst,
    input wire load,
    input wire en,
    input wire[N-1:0] d,
    output reg[N-1:0] q
);
    always @(posedge clk) begin
        if (rst) begin
            q <= {N{1'b0}};
        end else if (load) begin
            q <= d;
        end else if (en) begin
            if (UP)
                q <= q + 1'b1;
            else
                q <= q - 1'b1;
        end
    end
endmodule