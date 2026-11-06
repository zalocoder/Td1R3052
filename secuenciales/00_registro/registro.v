
module registro 
#(parameter N = 2)(
    input  wire clk,
    input  wire rst,
    input  wire  en,
    input  wire [N-1:0] d,
    output reg [N-1:0] q
);
    always @(posedge clk) begin
        if(rst) begin
            q <= {N{1'b0}};
        end else if(en) begin
            q <= d;
        end
    end
endmodule
