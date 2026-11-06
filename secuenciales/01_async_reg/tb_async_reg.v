
`timescale 1ns/1ps

module tb_async_reg;

    parameter N = 4;

    reg clk;
    reg rst;
    reg en;
    reg [N-1:0] d;

    wire [N-1:0] q;

    // Instancia del registro
    async_reg #(.N(N)) uut (
        .clk(clk),
        .async_rst(rst),
        .en(en),
        .d(d),
        .q(q)
    );

    // Clock: periodo 10 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Verificacion
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

    initial begin

        $dumpfile("tb_async_reg.vcd");
        $dumpvars(0, tb_async_reg);

        rst = 1;
        en  = 1;
        d   = 4'b1010;

        // 1. Reset inicial
        #2;
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

        // 5. Reset asincronico
        // Se activa entre flancos de reloj
        @(negedge clk);
        #2;
        rst = 1;

        // Verificar sin esperar al proximo flanco
        #1;
        if (q !== 4'b0000) begin
            $display("ERROR: reset asincronico no funciono");
            $finish;
        end else begin
            $display("OK: reset asincronico inmediato");
        end

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