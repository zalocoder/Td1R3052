`timescale 1ns/1ps

// Testbench autoverificable para la FIFO corregida con cabeza precargada.
// La FIFO debe permitir lectura y escritura simultaneas.
//
// Contrato:
// - r_data muestra la cabeza cuando empty=0; si empty=1, r_data=0.
// - El consumidor captura el dato ANTES de actualizar los punteros.
// - Despues del flanco, r_data muestra la nueva cabeza.
// - En lleno se rechaza wr aunque rd=1. En vacio se rechaza rd.
//
// Icarus Verilog:
//   iverilog -g2012 -s tb_fifo -o tb_fifo.out fifo.v tb_fifo.v
//   vvp tb_fifo.out
//   gtkwave fifo.vcd
//
// Las tareas generan entradas en negedge para evitar carreras con el DUT.
// Los #1 de comprobacion son exclusivos de simulacion.

module tb_fifo;
    parameter B = 8;
    parameter W = 2;
    parameter RANDOM_CYCLES = 10;
    parameter DUMP_WAVES = 1;
    parameter VERBOSE = 0;

    localparam DEPTH = 2**W;
    localparam CLK_PERIOD = 10;  // ns

    reg clk;
    reg rst;
    reg rd;
    reg wr;
    reg [B-1:0] w_data;
    wire empty;
    wire full;
    wire [B-1:0] r_data;

    fifo #(.B(B), .W(W)) dut (
        .clk(clk),
        .rst(rst),
        .rd(rd),
        .wr(wr),
        .w_data(w_data),
        .empty(empty),
        .full(full),
        .r_data(r_data)
    );

    // Cola de referencia: la cabeza siempre es modelo[0].
    // Se desplaza al leer, para no reproducir los punteros del DUT.
    reg [B-1:0] modelo [0:DEPTH-1];
    integer ocupacion;
    integer ciclos;
    integer lecturas;
    integer escrituras;
    integer lecturas_bloqueadas;
    integer escrituras_bloqueadas;
    integer semilla;
    integer i;
    integer vuelta;
    reg rd_aleatorio;
    reg wr_aleatorio;
    reg [B-1:0] dato_aleatorio;

    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        if (DUMP_WAVES) begin
            $dumpfile("fifo.vcd");
            $dumpvars(0, tb_fifo);
        end
    end

    // Comprueba banderas y cabeza, incluyendo valores X/Z inesperados.
    task automatic verificar_estado;
        begin
            if (empty !== (ocupacion == 0)) begin
                $display("ERROR t=%0t ciclo=%0d: empty=%b, ocupacion=%0d",
                         $time, ciclos, empty, ocupacion);
                $fatal(1, "Bandera empty incorrecta");
            end
            if (full !== (ocupacion == DEPTH)) begin
                $display("ERROR t=%0t ciclo=%0d: full=%b, ocupacion=%0d",
                         $time, ciclos, full, ocupacion);
                $fatal(1, "Bandera full incorrecta");
            end
            if (ocupacion == 0) begin
                if (r_data !== {B{1'b0}})
                    $fatal(1, "t=%0t: FIFO vacia con r_data=%h", $time, r_data);
            end else if (r_data !== modelo[0]) begin
                $display("ERROR t=%0t ciclo=%0d: r_data=%h, esperado=%h",
                         $time, ciclos, r_data, modelo[0]);
                $fatal(1, "Cabeza incorrecta o datos fuera de orden");
            end
        end
    endtask

    // Realiza un ciclo y actualiza la referencia con las aceptaciones
    // determinadas por la OCUPACION PREVIA, independientemente del DUT.
    task automatic ciclo(
        input pedir_rd,
        input pedir_wr,
        input [B-1:0] dato
    );
        reg aceptar_rd;
        reg aceptar_wr;
        integer j;
        begin
            @(negedge clk);
            rd = pedir_rd;
            wr = pedir_wr;
            w_data = dato;

            @(posedge clk);
            // Antes de NBA: este es el dato que captura el consumidor.
            verificar_estado;
            aceptar_rd = pedir_rd && (ocupacion > 0);
            aceptar_wr = pedir_wr && (ocupacion < DEPTH);

            if (VERBOSE)
                $display("t=%0t rd=%b wr=%b rd_ok=%b wr_ok=%b entrada=%h cabeza=%h n=%0d",
                         $time, rd, wr, aceptar_rd, aceptar_wr,
                         w_data, r_data, ocupacion);

            if (pedir_rd && !aceptar_rd)
                lecturas_bloqueadas = lecturas_bloqueadas + 1;
            if (pedir_wr && !aceptar_wr)
                escrituras_bloqueadas = escrituras_bloqueadas + 1;

            if (aceptar_rd) begin
                for (j = 0; j < ocupacion-1; j = j+1)
                    modelo[j] = modelo[j+1];
                ocupacion = ocupacion - 1;
                lecturas = lecturas + 1;
            end
            if (aceptar_wr) begin
                modelo[ocupacion] = dato;
                ocupacion = ocupacion + 1;
                escrituras = escrituras + 1;
            end
            ciclos = ciclos + 1;

            // Despues de NBA: comprobar NUEVA cabeza y NUEVAS banderas.
            #1;
            verificar_estado;
        end
    endtask

    // El reset se activa entre flancos. Los pedidos quedan activos
    // durante reset para comprobar que no alteren el estado de la FIFO.
    task automatic aplicar_reset;
        begin
            @(negedge clk);
            rd = 1'b1;
            wr = 1'b1;
            w_data = {B{1'b1}};
            #(CLK_PERIOD/4);
            rst = 1'b1;
            ocupacion = 0;
            #1;
            verificar_estado;  // todavia no ocurrio el siguiente posedge
            repeat (2) begin
                @(posedge clk);
                #1;
                verificar_estado;
            end
            @(negedge clk);
            rd = 1'b0;
            wr = 1'b0;
            rst = 1'b0;
        end
    endtask

    initial begin
        if (B < 1 || W < 1 || RANDOM_CYCLES < 0)
            $fatal(1, "Parametros invalidos");
        rst = 1'b0;
        rd = 1'b0;
        wr = 1'b0;
        w_data = {B{1'b0}};
        ocupacion = 0;
        ciclos = 0;
        lecturas = 0;
        escrituras = 0;
        lecturas_bloqueadas = 0;
        escrituras_bloqueadas = 0;
        semilla = 32'h13579BDF;

        $display("1. Reset asincronico y lectura en vacio");
        aplicar_reset;
        ciclo(1, 0, 0);
        ciclo(0, 0, 0);

        $display("2. Primera escritura y lectura inmediata");
        ciclo(0, 1, 8'hA1);
        ciclo(1, 0, 0);

        $display("3. Reemplazo simultaneo del unico dato (bypass)");
        ciclo(0, 1, 8'hA1);
        ciclo(1, 1, 8'hB2);
        ciclo(1, 1, 8'hC3);
        ciclo(1, 0, 0);

        $display("4. Llenado, escritura bloqueada y lectura estando llena");
        for (i = 0; i < DEPTH; i = i+1)
            ciclo(0, 1, i);  // incluye cero como dato valido
        ciclo(0, 1, 8'hEE);
        ciclo(1, 1, 8'hFF); // llena: se acepta SOLO la lectura
        for (i = 0; i < DEPTH-1; i = i+1)
            ciclo(1, 0, 0);
        ciclo(1, 0, 0);

        $display("5. Pedidos simultaneos en vacio");
        ciclo(1, 1, 8'h55); // se acepta SOLO la escritura
        ciclo(1, 0, 0);

        $display("6. Lecturas/escrituras juntas y varias vueltas de punteros");
        ciclo(0, 1, 8'h10);
        for (i = 0; i < 3*DEPTH; i = i+1)
            ciclo(1, 1, i+1);
        ciclo(1, 0, 0);
        for (vuelta = 0; vuelta < 3; vuelta = vuelta+1) begin
            for (i = 0; i < DEPTH; i = i+1)
                ciclo(0, 1, vuelta*DEPTH+i);
            for (i = 0; i < DEPTH; i = i+1)
                ciclo(1, 0, 0);
        end

        $display("7. Reset con datos pendientes");
        ciclo(0, 1, 8'h71);
        ciclo(0, 1, 8'h72);
        aplicar_reset;
        ciclo(0, 1, 8'h83);
        ciclo(1, 0, 0);

        $display("8. Secuencia pseudoaleatoria reproducible");
        for (i = 0; i < RANDOM_CYCLES; i = i+1) begin
            rd_aleatorio = $random(semilla);
            wr_aleatorio = $random(semilla);
            dato_aleatorio = $random(semilla);
            ciclo(rd_aleatorio, wr_aleatorio, dato_aleatorio);
        end

        // Vaciar todo lo que quede y comprobar la salida en reposo.
        while (ocupacion > 0)
            ciclo(1, 0, 0);
        ciclo(0, 0, 0);

        $display("PASS: FIFO B=%0d W=%0d, %0d ciclos verificados.", B, W, ciclos);
        $display("Aceptadas: %0d lecturas, %0d escrituras.", lecturas, escrituras);
        $display("Bloqueadas: %0d lecturas, %0d escrituras.",
                 lecturas_bloqueadas, escrituras_bloqueadas);
        $finish;
    end

    // Proteccion para que un error del testbench no deje la simulacion abierta.
    initial begin
        repeat (RANDOM_CYCLES + 20*DEPTH + 1000) @(posedge clk);
        $fatal(1, "Timeout de simulacion");
    end
endmodule
