`timescale 1ns/1ps

module tb_calcula_crc8;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg en = 1'b0;
    reg [7:0] data = 8'h00;
    wire [7:0] crc;
    integer errores = 0;
    integer i;
    reg [7:0] esperado;

    always #5 clk = ~clk;

    calcula_crc8 dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .data(data),
        .crc(crc)
    );

    function [7:0] crc8_byte;
        input [7:0] crc_anterior;
        input [7:0] dato;
        reg [7:0] c;
        integer j;
        begin
            c = crc_anterior ^ dato;
            for (j = 0; j < 8; j = j + 1)
                if (c[0]) c = (c >> 1) ^ 8'h8C;
                else      c = c >> 1;
            crc8_byte = c;
        end
    endfunction

    task enviar_byte;
        input [7:0] dato;
        begin
            @(negedge clk);
            data = dato;
            en = 1'b1;
            esperado = crc8_byte(esperado, dato);
            @(negedge clk);
            en = 1'b0;
            // WAIT y SAVE: el resultado se actualiza en el tercer flanco.
            repeat (2) @(negedge clk);
            if (crc !== esperado) begin
                $display("ERROR dato=%02h esperado=%02h obtenido=%02h", dato, esperado, crc);
                errores = errores + 1;
            end else begin
                $display("OK dato=%02h CRC=%02h", dato, crc);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_calcula_crc8.vcd");
        $dumpvars(0, tb_calcula_crc8);
        esperado = 8'h00;
        repeat (2) @(negedge clk);
        rst = 1'b0;

        // Vector de referencia CRC-8/MAXIM: ASCII "123456789" -> A1
        for (i = 8'h31; i <= 8'h39; i = i + 1)
            enviar_byte(i[7:0]);

        if (crc !== 8'hA1) begin
            $display("ERROR vector 123456789: esperado A1, obtenido %02h", crc);
            errores = errores + 1;
        end

        // Reinicio y secuencia adicional
        @(negedge clk);
        rst = 1'b1;
        esperado = 8'h00;
        @(negedge clk);
        rst = 1'b0;
        enviar_byte(8'h00);
        enviar_byte(8'hA5);
        enviar_byte(8'hFF);
        enviar_byte(8'h3C);

        if (errores == 0) $display("TEST OK: todas las comprobaciones pasaron.");
        else $display("TEST FALLIDO: %0d errores.", errores);
        $finish;
    end
endmodule
