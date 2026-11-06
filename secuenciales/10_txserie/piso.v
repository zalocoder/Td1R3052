module piso #(
    parameter N=8, 
    parameter RST_VAL=1'b1
    )(
        input wire clk,
        input wire rst,
        input wire load,
        input wire en,
        input wire si,
        input wire [N-1:0] d,
        output reg [N-1:0] q
    );

    always @(posedge clk) begin
        if (rst) 
            q <= {N{RST_VAL}};
        else if (load) 
            q <= d;
        else if (en)
            q <= {si,q[N-1:1]};
    end
endmodule
