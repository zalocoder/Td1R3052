module capicua (
    input wire [7:0] x,
    output wire y);

    wire [3:0] pares;
    assign pares[0] = (x[7]==x[0])? 1'b1 : 1'b0;
    assign pares[1] = (x[6]==x[1])? 1'b1 : 1'b0;
    assign pares[2] = (x[5]==x[2])? 1'b1 : 1'b0;
    assign pares[3] = (x[4]==x[3])? 1'b1 : 1'b0;
    assign y = pares[0]&pares[1]&pares[2]&pares[3];
endmodule
