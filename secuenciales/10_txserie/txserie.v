module txserie #(
    parameter FCLK_HZ=50000000,
    parameter BAUDRATE=9600)(
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire[7:0]    data,
    output wire         sout,
    output wire         ready
);

    wire en, brate, done;

    datapath_txserie #(.FCLK_HZ(FCLK_HZ), .BAUDRATE(BAUDRATE))
    dp (
        .clk(clk),
        .rst(rst),
        .load(start), 
        .en(en),
        .din(data),
        .brate_tic(brate),
        .sout(sout),
        .done(done));

    unidad_de_control fsm(    
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .brate_tic(brate),
        .en(en),
        .ready(ready));
endmodule
