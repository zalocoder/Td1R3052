// Testbench para verificar el funcionamiento del módulo bit_cnt.
// El testbench genera todos los valores posibles de la entrada
// y observa la respuesta del circuito.

`timescale 1ns / 1ps

module tb_bit_cnt2();
    localparam N = 4;
    localparam M = $clog2(N+1);

    reg [N-1:0]     x;
    wire [M-1:0]    y;
    integer i;                  

    // Instancia del circuito que vamos a probar (UUT = Unit Under Test)
    bit_cnt2 #(.N(N))    //Genero bit_cnt de 8 bits
    uut(
        .entrada(x),
        .salida(y)
    );

    initial begin
        $dumpfile("tb_bit_cnt2.vcd");
        $dumpvars(0, tb_bit_cnt2);
        $monitor("entrada => %b\t salida => %b (%d)", x, y, y);
        for (i = 0; i < (2**N); i = i + 1) begin
            x = i;
            #10;
        end
        $finish;
    end
endmodule