module datapath_txserie #(
    parameter FCLK_HZ  = 50000000,
    parameter BAUDRATE = 9600)(
    input  wire clk,
    input  wire rst,
    input  wire load, 
    input  wire en,
    input  wire [7:0] din,
    output wire brate_tic,
    output wire sout,
    output wire done
);
    parameter N_BRATE = $clog2(FCLK_HZ/BAUDRATE+1);
    parameter [N_BRATE-1:0] BRATE = FCLK_HZ/BAUDRATE-1;
    wire load_cnt_brate;
    wire [N_BRATE-1:0] brate;
    wire [3:0] nbits;
    wire [8:0] qpiso;

    assign done = (!nbits)?1'b1:1'b0;
    assign load_cnt_brate = load | brate_tic;
    assign brate_tic = (!brate)?1'b1:1'b0;
    assign sout = qpiso[0];

    contador #(
        .N(N_BRATE),
        .UP(1'b0)
        ) cnt_brate (   
        .clk(clk),
        .rst(rst),
        .load(load_cnt_brate),
        .en(1'b1),
        .d(BRATE),
        .q(brate));

    contador #(
        .N(4),
        .UP(1'b0))
        cnt_bits (
        .clk(clk),
        .rst(rst),
        .load(load),
        .en(en),
        .d(4'd9),
        .q(nbits));

    piso #(
        .N(9), 
        .RST_VAL(1'b1)
    ) registro (
        .clk(clk),
        .rst(rst),
        .load(load),
        .en(en),
        .si(1'b1),
        .d({din,1'b0}),
        .q(qpiso));
endmodule;