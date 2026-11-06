
`timescale 1ns/1ps

module tb_genreset;
    parameter N = 4;
    reg     clk;
    reg     rst_in;
    wire    rst;

    // Instancia del registro
    genreset #(.N(N)) uut (
        .clk(clk),
        .rst_in(rst_in),
        .rst_out(rst));

    // Clock: periodo 10 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Verificacion
   
    initial begin

        $dumpfile("tb_genreset.vcd");
        $dumpvars(0, tb_genreset);
        $monitor("rst_in: %b rst_out: %b", rst_in, rst);
        rst_in = 1; 
        #7;
        rst_in = 0;
        #100;
        rst_in = 1; 
        #7;
        rst_in = 0;
        #300;
        $finish;
    end

endmodule