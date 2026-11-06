module fulladder(
    input wire a,
    input wire b,
    input wire ci,
    output wire s,
    output wire co
);

    assign co = (a&b) | (a&ci) | (b&ci);
    assign s = a ^ b ^ ci;

endmodule