
`timescale 1ns/1ps

module tb_fsm_ejemplo;
    parameter CLK_PERIOD = 10;
    reg     clk;
    reg     rst;
    reg     start;
    reg     done;
    wire    busy;
    wire    ready;

    // Instancia del registro
    fsm_ejemplo uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .busy(busy),
        .ready(ready));

    // Clock: periodo 10 ns
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    task genera_ciclo_fsm;
        input integer espera;
        begin
            @(negedge clk);
            start = 1'b1;
            done  = 1'b0;
            #(CLK_PERIOD);
            start = 1'b0;
            #(CLK_PERIOD*espera);
            done = 1'b1;
            #(CLK_PERIOD);
            done = 1'b0;
        end
    endtask

    // Verificacion
    initial begin

        $dumpfile("tb_fsm_ejemplo.vcd");
        $dumpvars(0, tb_fsm_ejemplo);
       
        rst = 1; start = 0; done = 0; 
        #(CLK_PERIOD*2);
        rst = 0; 
        genera_ciclo_fsm(20);
        #2
        genera_ciclo_fsm(3);
        #20
        $display("--- Fin de Pruebas ---");
        $finish;
    end
endmodule