module comparador
(   input wire [1:0] a,
    input wire [1:0] b,
    output wire eq
);

    assign eq = (a == b)? 1'b1 : 1'b0;

endmodule