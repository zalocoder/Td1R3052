
module swap
#(parameter N = 4) (
    input  wire         clk,
    input  wire         rst,
    input  wire         en,
    output reg  [N-1:0] q1,
    output reg  [N-1:0] q2
);

    always @(posedge clk) begin
        if (rst) begin
            q1 <= {N{1'b0}};
            q2 <= {N{1'b1}};
        end else if (en) begin
            q1 <= q2;
            q2 <= q1;
        end
    end

endmodule
