module multiplicador 
#(parameter N=8) (
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire[N-1:0] a,
    input  wire[N-1:0] b,
    output wire[N-1:0] p,
    output wire ready
);
    wire en, done;

    datapath_multiplicador #(.N(N)) 
    dp (    .clk(clk),
            .rst(rst),
            .load(start), 
            .en(en),
            .a(a),
            .b(b),
            .p(p),
            .done(done));

    unidad_de_control uc 
    (       .clk(clk),
            .rst(rst),
            .start(start),
            .done(done),
            .en(en),
            .ready(ready));
endmodule