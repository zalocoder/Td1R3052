module rom_crc (
        input wire clk,
        input wire [7:0] addr,
        output reg [7:0] data
);
    reg[7:0] memoria_rom [0:255];

    // Este initial carga el contenido de la memoria ROM
    initial begin
        $readmemh("crc8_table.hex",memoria_rom);    
    end

    // Genero la memoria ROM
    always @(posedge clk) begin
        data <= memoria_rom[addr];
    end
endmodule
