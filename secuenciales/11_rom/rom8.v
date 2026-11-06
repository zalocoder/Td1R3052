// Este modulo genera dos memorias ROM, una sincrónica (data_sync) y 
// otra asincrónica (data_async) que podemos utilizar para generar
// el producto sin signo de dos números de 4 bits entre sí.
module rom8(
        input wire  clk,
        input wire  [7:0] addr,
        output reg  [7:0] data_sync,
        output wire [7:0] data_async
);
    reg[7:0] memoria_rom [0:255];
    integer i, j;

    // Este initial carga el contenido de la memoria ROM
    // es de los pocos casos que un initial genera contenido 
    // sintetizable (en realidad en tiempo de síntesis se genera el contenido de la ROM). 
    initial begin
        for (i=0; i<16; i=i+1)
            for(j=0; j<16; j=j+1) begin
                memoria_rom[i*16+j] = i*j;
            end       
    end

    // Genero la memoria ROM sincrónica
    always @(posedge clk) begin
        data_sync <= memoria_rom[addr];
    end

    //Genero la memoria ROM asincrónica.
    assign data_async = memoria_rom[addr];

endmodule
