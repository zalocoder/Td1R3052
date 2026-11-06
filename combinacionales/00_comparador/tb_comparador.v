`timescale 1ns / 100ps

module tb_comparador;
    reg [1:0] a;
    reg [1:0] b;
    wire a_igual_b;

    // Variable para recorrer todos los casos
    integer i;

    // Instancia del circuito a ensayar
    comparador uut (
        .a(a),
        .b(b),
        .eq(a_igual_b)
    );

    // Bloque inicial para aplicar los estímulos
    initial begin
        // Archivo para guardar la simulación
        $dumpfile("tb_comparador.vcd");
        $dumpvars(0, tb_comparador);
        // Mostrar los valores por consola
        $monitor("a=%b b=%b => a_igual_b=%b", a, b, a_igual_b);

        // Aplicar todos los valores posibles
        for (i = 0; i < 16; i = i + 1) begin
            // Asignar los 4 bits de i a las dos entradas
            {a, b} = i;
            // Esperar 10 ns
            #10;
        end
        $finish;
    end
endmodule