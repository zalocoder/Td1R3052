
`timescale 1ns/1ps

module tb_anillo;

    parameter LEN = 4;

    reg clk;
    reg rst;
    reg en;

    wire [LEN-1:0] q;

    // Instancia del registro de anillo
    anillo #(.LEN(LEN)) uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .q(q)
    );

    // Clock: periodo 10 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Verificacion
    task verificar;
        input [LEN-1:0] esperado;
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

    initial begin

        $dumpfile("tb_anillo.vcd");
        $dumpvars(0, tb_anillo);

        rst = 1;
        en  = 0;

        // 1. Reset
        @(posedge clk);
        verificar(4'b0001);

        // 2. Primer desplazamiento
        @(negedge clk);
        rst = 0;
        en  = 1;

        @(posedge clk);
        verificar(4'b0010);

        // 3. Segundo desplazamiento
        @(posedge clk);
        verificar(4'b0100);

        // 4. Tercer desplazamiento
        @(posedge clk);
        verificar(4'b1000);

        // 5. Cuarto desplazamiento
        @(posedge clk);
        verificar(4'b0001);

        // 6. Deshabilitacion: conservar el estado
        @(negedge clk);
        en = 0;

        @(posedge clk);
        verificar(4'b0001);

        // 7. Volver a habilitar
        @(negedge clk);
        en = 1;

        @(posedge clk);
        verificar(4'b0010);

        // 8. Reset durante el funcionamiento
        @(negedge clk);
        rst = 1;

        @(posedge clk);
        verificar(4'b0001);

        // 9. Continuar despues del reset
        @(negedge clk);
        rst = 0;

        @(posedge clk);
        verificar(4'b0010);

        $display("--------------------------------");
        $display("TODAS LAS PRUEBAS FINALIZARON OK");
        $display("--------------------------------");

        $finish;
    end

endmodule