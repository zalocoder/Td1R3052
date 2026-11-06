`timescale 1ns/1ps

module tb_registro;

    parameter N = 4;

    reg clk;
    reg rst;
    reg en;
    reg [N-1:0] d;

    wire [N-1:0] q;

    // Instancia del registro
    registro #(.N(N)) uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d),
        .q(q)
    );

    // Generacion del clock: periodo 10 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Verificacion del resultado
    task verificar;
        input [N-1:0] esperado;
        begin
            #1;
            if (q !== esperado) begin
                $display("ERROR: esperado=%b, obtenido=%b", esperado, q);
                $finish;
            end else begin
                $display("OK: q=%b", q);
            end
        end
    endtask

    // Secuencia de pruebas
    initial begin

        $dumpfile("tb_registro.vcd");
        $dumpvars(0, tb_registro);

        rst = 1;
        en  = 1;
        d   = 4'b1010;

        // 1. Reset
        @(posedge clk);
        verificar(4'b0000);

        // 2. Carga
        @(negedge clk);
        rst = 0;
        en  = 1;
        d   = 4'b1010;

        @(posedge clk);
        verificar(4'b1010);

        // 3. Retencion
        @(negedge clk);
        en = 0;
        d  = 4'b0101;

        @(posedge clk);
        verificar(4'b1010);

        // 4. Nueva carga
        @(negedge clk);
        en = 1;
        d  = 4'b1100;

        @(posedge clk);
        verificar(4'b1100);

        // 5. Reset con habilitacion activa
        @(negedge clk);
        rst = 1;
        en  = 1;
        d   = 4'b1111;

        @(posedge clk);
        verificar(4'b0000);

        // 6. Carga posterior al reset
        @(negedge clk);
        rst = 0;
        en  = 1;
        d   = 4'b0110;

        @(posedge clk);
        verificar(4'b0110);

        $display("--------------------------------");
        $display("TODAS LAS PRUEBAS FINALIZARON OK");
        $display("--------------------------------");

        $finish;
    end

endmodule