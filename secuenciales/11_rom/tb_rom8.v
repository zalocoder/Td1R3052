`timescale 1ns/1ps

module tb_rom8;
    parameter   CLK_PERIOD = 10;
    reg         clk;
    reg [7:0]   addr;
    wire[7:0]   data_sync, data_async;
    integer     i = 0, j = 0;

    rom8 uut(   .clk(clk),
                .addr(addr),
                .data_sync(data_sync),
                .data_async(data_async));

    assign addr = {i[3:0],j[3:0]};

    always begin
        clk = 0;
        #(CLK_PERIOD/2);
        clk = 1;
        #(CLK_PERIOD/2);
    end

    initial begin
        $dumpfile("tb_rom8.vcd");
        $dumpvars(0, tb_rom8);
        #CLK_PERIOD;
        for(i=15; i>=0; i=i-1)
            for(j=0; j<16; j=j+1) begin
                @(posedge clk);
                #1; //Simulo TCQ
            end
        $finish;
    end
endmodule
