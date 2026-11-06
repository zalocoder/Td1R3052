`timescale 1ns / 1ps

module tb_fulladder();

    reg a, b, ci;
    wire s, co;
    integer i;

    fulladder uut(
        .a(a),
        .b(b),
        .ci(ci),
        .s(s),
        .co(co)
    );

    initial 
    begin
        $dumpfile("tb_fulladder.vcd");
        $dumpvars(0,tb_fulladder);
        $monitor("a: %b\t b: %b\t ci: %b\t s => %b\t co => %b", a, b, ci, s, co);

        for(i=0; i<2**3; i=i+1)
        begin
            {ci,b,a} = i;
            #10;
        end
    end
endmodule