// Problema
//Diseñe un módulo combinacional en verilog y
//archivo de prueba (testbench) que cuente la
//cantidad de unos de la entrada y quede en salida.

module bit_cnt (
    input [4:0] entrada,    // Vector de entrada de 5 bits
    output [2:0] salida     // Conteo de bits en '1' (0-5)
);

// Implementar la lógica aquí
assign salida = entrada[0] +
                entrada[1] +
                entrada[2] +
                entrada[3] + 
                entrada[4]; 
endmodule