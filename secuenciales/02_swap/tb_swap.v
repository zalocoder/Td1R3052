
`timescale 1ns/1ps

module tb_swap;

    parameter N = 4;

    reg clk;
    reg rst;
    reg en;

    wire [N-1:0] q1;
    wire [N-1:0] q2;

    // Instancia del modulo
    swap #(.N(N)) uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .q1(q1),
        .q2(q2)
    );

    // Clock: periodo 10 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Verificacion
    task verificar;
        input [N-1:0] esperado_q1;
        input [N-1:0] esperado_q2;
        begin
            #1;
            if ((q1 !== esperado_q1) ||
                (q2 !== esperado_q2)) begin

                $display("ERROR:");
                $display("q1 esperado=%b, obtenido=%b",
                         esperado_q1, q1);
                $display("q2 esperado=%b, obtenido=%b",
                         esperado_q2, q2);
                $finish;

            end else begin
                $display("OK: q1=%b q2=%b", q1, q2);
            end
        end
    endtask

    initial begin

        $dumpfile("tb_swap.vcd");
        $dumpvars(0, tb_swap);

        // Valores iniciales
        rst = 1;
        en  = 0;

        // 1. Reset
        @(posedge clk);
        verificar(4'b0000, 4'b1111);

        // 2. Primer intercambio
        @(negedge clk);
        rst = 0;
        en  = 1;

        @(posedge clk);
        verificar(4'b1111, 4'b0000);

        // 3. Segundo intercambio
        @(posedge clk);
        verificar(4'b0000, 4'b1111);

        // 4. Deshabilitar
        @(negedge clk);
        en = 0;

        @(posedge clk);
        verificar(4'b0000, 4'b1111);

        // 5. Volver a habilitar
        @(negedge clk);
        en = 1;

        @(posedge clk);
        verificar(4'b1111, 4'b0000);

        // 6. Otro intercambio
        @(posedge clk);
        verificar(4'b0000, 4'b1111);

        $display("--------------------------------");
        $display("TODAS LAS PRUEBAS FINALIZARON OK");
        $display("--------------------------------");

        $finish;
    end

endmodule