module fifo #(
    parameter B = 8,    // Ancho de palabra
    parameter W = 2     // Bits de direccionamiento
)(
    input wire clk,
    input wire rst,     // Reset asincrónico
    input wire rd,
    input wire wr,
    input wire [B-1:0] w_data,
    output wire empty,
    output wire full,
    output wire [B-1:0] r_data
);

    reg [B-1:0] fifo_mem [0:(2**W)-1];
    reg [B-1:0] read_data;

    reg [W:0] cnt_read;
    reg [W:0] cnt_write;

    wire rd_ok, wr_ok;
    wire [W:0] cnt_read_next;

    // Banderas del estado actual
    assign empty = (cnt_read == cnt_write);

    assign full =
        (cnt_read[W] != cnt_write[W]) &&
        (cnt_read[W-1:0] == cnt_write[W-1:0]);

    // La salida muestra la cabeza precargada
    assign r_data = empty ? {B{1'b0}} : read_data;

    // Operaciones aceptadas
    assign rd_ok = rd & ~empty & ~rst;
    assign wr_ok = wr & ~full  & ~rst;

    // Puntero de lectura posterior al flanco
    assign cnt_read_next = rd_ok ?
                           (cnt_read + 1'b1) :
                           cnt_read;

    // Punteros con reset asincrónico
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_read  <= {(W+1){1'b0}};
            cnt_write <= {(W+1){1'b0}};
        end else begin
            cnt_read <= cnt_read_next;

            if (wr_ok)
                cnt_write <= cnt_write + 1'b1;
        end
    end

    // Memoria y precarga sincrónica de la cabeza
    always @(posedge clk) begin
        if (wr_ok)
            fifo_mem[cnt_write[W-1:0]] <= w_data;

        // Bypass: la próxima cabeza se escribe ahora
        if (wr_ok &&
            (cnt_write[W-1:0] == cnt_read_next[W-1:0]))
            read_data <= w_data;
        else
            read_data <= fifo_mem[cnt_read_next[W-1:0]];
    end
endmodule