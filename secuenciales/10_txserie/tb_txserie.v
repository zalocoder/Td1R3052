`timescale 1ns/1ps

module tb_txserie;
    localparam CLK_PERIOD = 20;
    localparam FCLK_HZ = 50000000;
    localparam BAUDRATE = 9600;

    reg[7:0] data;
    reg clk, rst, start;
    wire ready, sout;
    

    txserie #(.FCLK_HZ(FCLK_HZ), .BAUDRATE(BAUDRATE))
    uut (   .clk(clk),
            .rst(rst),
            .start(start),
            .data(data),
            .sout(sout),
            .ready(ready));

    task enviar_serie; 
        input integer val;
        begin
            data = val;
            @(posedge clk);
            #CLK_PERIOD;
            start = 1;
            #CLK_PERIOD;
            start = 0;
            @(posedge ready);
            #CLK_PERIOD;
        end
    endtask

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        $dumpfile("tb_txserie.vcd");
        $dumpvars(0,tb_txserie);
        rst = 1;
        start = 0;
        #(CLK_PERIOD*2);
        rst = 0;
        
        enviar_serie(8'h55);
        enviar_serie(8'h00);
        enviar_serie(8'hAA);
        enviar_serie(8'hFF);
        enviar_serie(8'h5A);
        #(CLK_PERIOD*100);
        $finish;
    end

endmodule