`timescale 1ns / 1ps

module tb_sumador();

    reg [2:0] a, b;
    wire[2:0] s;
    wire co;
    reg ci;
    integer i;

    sumador uut(
        .a(a),
        .b(b),
        .ci(ci),
        .s(s),
        .co(co)
    );

    initial 
    begin
        $dumpfile("tb_sumador.vcd");
        $dumpvars(0,tb_sumador);
        $monitor("a: %b\t b: %b\t ci: %b\t s => %b\t co => %b", a, b, ci, s, co);

        for(i=0; i<2**7; i=i+1)
        begin
            {ci,b,a} = i;
            #10;
        end
    end
endmodule