`timescale 1ns / 1ps

module tb_tres_unos();
    reg [7:0] entradas;
    wire salida;
    integer i;

tres_unos uut(
    .x(entradas),
    .y(salida)
);

initial begin
    
    $dumpfile("tb_tres_unos.vcd");
    $dumpvars(0, tb_tres_unos);

    for(i=0; i<256; i = i + 1) begin
        entradas = i;
        #5; //Espera 5 unidades de tiempo (5ns)
    end


    $finish;
end

endmodule