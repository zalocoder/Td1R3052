module datapath_multiplicador 
#(parameter N = 8)(
    input  wire clk,
    input  wire rst,
    input  wire load, 
    input  wire en,
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] p,
    output wire done
);
    wire [N-1:0] q_a, q_b, d_b;
    wire enb;

    assign done = (q_a) ? 1'b0 : 1'b1;
    assign rstb = load | rst ;
    assign d_b  = (load) ? b : (q_b + b);
    assign p    = q_b;

    contador #(.N(N)) cnt_a (
        .clk(clk),
        .rst(rst),
        .load(load),
        .en(en),
        .d(a),
        .q(q_a));

    registro #(.N(N)) reg_b(
        .clk(clk),
        .rst(rstb),
        .en(en),
        .d(d_b),
        .q(q_b));

endmodule;