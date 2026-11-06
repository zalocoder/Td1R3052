module sumador(
  input wire [2:0] a,
  input wire [2:0] b,
  input wire ci,
  output wire [2:0] s,
  output wire co  
);
    wire [2:0] c;
    assign co = c[2];
    fulladder bit0 (.a(a[0]), .b(b[0]), .ci(ci),   .s(s[0]), .co(c[0]));
    fulladder bit1 (.a(a[1]), .b(b[1]), .ci(c[0]), .s(s[1]), .co(c[1]));
    fulladder bit2 (.a(a[2]), .b(b[2]), .ci(c[1]), .s(s[2]), .co(c[2]));
endmodule