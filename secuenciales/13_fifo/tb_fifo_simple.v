`timescale 1ns/1ps

// FIFO corregida: cabeza precargada y operaciones simultaneas.
// r_data muestra la cabeza actual. rd la retira en posedge.
// Simular seleccionando tb_fifo_simple como modulo superior.
module tb_fifo_simple;
    localparam B = 8;
    localparam W = 2;             // Cuatro posiciones
    localparam CLK_PERIOD = 10;

    reg clk = 0;
    reg rst = 1;
    reg rd = 0, wr = 0;
    reg [B-1:0] w_data = 0;
    wire [B-1:0] r_data;
    wire empty, full;

    fifo #(.B(B), .W(W)) uut (
        .clk(clk), .rst(rst), .rd(rd), .wr(wr),
        .w_data(w_data), .r_data(r_data),
        .empty(empty), .full(full)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    // Cada llamada prepara entradas en negedge.
    // La operacion se acepta en el siguiente posedge.
    task ciclo;
        input leer, escribir;
        input [B-1:0] dato;
        begin
            @(negedge clk);
            rd = leer;
            wr = escribir;
            w_data = dato;
        end
    endtask

    initial begin
        $dumpfile("tb_fifo_simple.vcd");
        $dumpvars(0, tb_fifo_simple);

        repeat (2) @(negedge clk);
        rst = 0;

        // Escribir 11 y 22. La cabeza queda en 11.
        ciclo(0, 1, 8'h11);
        ciclo(0, 1, 8'h22);
        ciclo(0, 0, 8'h00);
        ciclo(0, 0, 8'h00);

        // Retirar 11 y escribir 33: quedan 22 y 33.
        ciclo(1, 1, 8'h33);
        ciclo(0, 0, 8'h00);
        ciclo(0, 0, 8'h00);

        // Lecturas consecutivas: retirar 22 y luego 33.
        ciclo(1, 0, 8'h00);
        ciclo(1, 0, 8'h00);
        ciclo(0, 0, 8'h00);       // empty=1, r_data=00
        ciclo(0, 0, 8'h00);

        // Llenar las cuatro posiciones: full pasa a uno.
        ciclo(0, 1, 8'hA1);
        ciclo(0, 1, 8'hB2);
        ciclo(0, 1, 8'hC3);
        ciclo(0, 1, 8'hD4);
        ciclo(0, 1, 8'hFF);       // Escritura rechazada: llena
        ciclo(0, 0, 8'h00);

        // Reset entre flancos, con datos pendientes.
        #2 rst = 1;
        #(2*CLK_PERIOD);
        rst = 0;
        #(2*CLK_PERIOD);
        $finish;
    end
endmodule
