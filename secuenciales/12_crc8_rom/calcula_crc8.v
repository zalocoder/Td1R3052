module calcula_crc8(
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire [7:0] data,
    output reg  [7:0] crc
);

    reg  [7:0] addr;
    wire [7:0] rom_data;
    reg  [1:0] estado;

    localparam IDLE = 2'd0;
    localparam WAIT = 2'd1;
    localparam SAVE = 2'd2;

    // Instancio la ROM de CRC
    rom_crc romcrc (
        .clk  (clk),
        .addr (addr),
        .data (rom_data)
    );

    always @(posedge clk) begin
        if (rst) begin
            crc    <= 8'h00;
            addr   <= 8'h00;
            estado <= IDLE;
        end else begin
            case (estado)
                IDLE: begin
                    if (en) begin
                        addr   <= data ^ crc;
                        estado <= WAIT;
                    end
                end
                WAIT: begin
                    estado <= SAVE;
                end
                SAVE: begin
                    crc    <= rom_data;
                    estado <= IDLE;
                end
                default: estado <= IDLE;
            endcase
        end
    end
endmodule