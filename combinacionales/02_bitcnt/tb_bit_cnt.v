// Testbench para verificar el funcionamiento del módulo bit_cnt.
// El testbench genera todos los valores posibles de la entrada
// y observa la respuesta del circuito.

`timescale 1ns / 1ps

module tb_bit_cnt();
    reg [4:0] x;
    wire [2:0] y;
    integer i;                  // Variable utilizada para recorrer los valores de prueba

    // Instancia del circuito que vamos a probar (UUT = Unit Under Test)
    bit_cnt uut(
        .entrada(x),
        .salida(y)
    );

    // Bloque de pruebas.
    // Todo lo que está dentro de "initial" se ejecuta una sola vez,
    // comenzando al inicio de la simulación.
    initial begin

        // Genera el archivo que contiene las formas de onda de la simulación.
        $dumpfile("tb_bit_cnt.vcd");

        // Indica qué señales se deben guardar en el archivo VCD.
        // El "0" indica que también se incluyen las señales de los
        // módulos instanciados dentro de tb_bit_cnt.
        $dumpvars(0, tb_bit_cnt);

        // Muestra en la consola los valores de entrada y salida.
        // Se ejecuta nuevamente cada vez que cambia alguna de las señales.
        $monitor("entrada => %b\t salida => %b (%d)", x, y, y);
        // Probamos los 32 valores posibles de la entrada de 5 bits.
        for (i = 0; i < 2**5; i = i + 1) begin
            // Aplicamos un nuevo valor a la entrada del circuito.
            x = i;
            // Esperamos 10 ns antes de aplicar el siguiente valor.
            #10;
        end
        // Finaliza la simulación.
        $finish;
    end
endmodule