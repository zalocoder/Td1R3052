
module mux2to1 
#(parameter N = 4)(
    input  wire [N-1:0] x1,
    input  wire [N-1:0] x2,
    input  wire s,
    output wire [N-1:0] y
);
    assign y = (s)?x2:x1;
endmodule

