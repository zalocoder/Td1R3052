
`timescale 1ns/1ps

module tb_rise_detector;
    parameter CLK_PERIOD = 10;
    reg     clk;
    reg     rst;
    reg     d;
    wire    q;

    // Instancia del registro
    rise_detector uut (
        .clk(clk),
        .rst(rst),
        .din(d),
        .dout(q));
    
    // Clock: periodo 10 ns
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    task genera_entrada;
        input dval; 
        input integer espera;
        begin
            @(posedge clk);
            d = dval;
            #(CLK_PERIOD*espera);
        end
    endtask

    // Verificacion
    initial begin

        $dumpfile("tb_rise_detector.vcd");
        $dumpvars(0, tb_rise_detector);
        $monitor("Tiempo=%08t ns | rst=%b | d=%b | q=%b", $time, rst, d, q);
        rst = 1; d = 1; 
        #(CLK_PERIOD*2);
        rst = 0; 
        genera_entrada(1,10);
        genera_entrada(0,10);
        genera_entrada(1,10);
        genera_entrada(0,10);
        genera_entrada(1,1);
        genera_entrada(0,1);
        genera_entrada(1,10);
        genera_entrada(0, 2);
        genera_entrada(1, 1);
        genera_entrada(0, 1);
        genera_entrada(1, 1);
        genera_entrada(0, 3);
        #20;
        $display("--- Fin de Pruebas ---");
        $finish;
    end
endmodule