`timescale 1ns / 1ps

module tb_capicua();
    reg [7:0] entradas;
    wire salida;
    integer i;

capicua uut(
    .x(entradas),
    .y(salida)
);

initial begin
    
    $dumpfile("tb_capicua.vcd");
    $dumpvars(0, tb_capicua);

    for(i=0; i<256; i = i + 1) begin
        entradas = i;
        #5; //Espera 5 unidades de tiempo (5ns)
    end


    $finish;
end

endmodule